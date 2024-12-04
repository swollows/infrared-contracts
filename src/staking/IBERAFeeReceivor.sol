// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {Initializable} from
    "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {
    ERC1967Utils,
    UUPSUpgradeable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IIBERA} from "@interfaces/IIBERA.sol";
import {IIBERAFeeReceivor} from "@interfaces/IIBERAFeeReceivor.sol";
import {IInfrared} from "@interfaces/IInfrared.sol";
import {IBERAConstants} from "./IBERAConstants.sol";

/// @title IBERAFeeReceivor
/// @author bungabear69420
/// @notice Fee receivor receives coinbase priority fees + MEV credited to contract on EL upon block validation
/// @dev CL validators should set fee_recipient to the address of this contract
contract IBERAFeeReceivor is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    IIBERAFeeReceivor
{
    /// @inheritdoc IIBERAFeeReceivor
    address public IBERA;

    IInfrared public infrared;

    /// @inheritdoc IIBERAFeeReceivor
    uint256 public shareholderFees;

    /// @dev Constructor disabled for upgradeable contracts
    constructor() {
        _disableInitializers();
    }

    /// @notice Ensure that only the governor or the contract itself can authorize upgrades
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    /// @notice Initializer function (replaces constructor)
    /// @param admin Address of the initial admin
    function initialize(address admin, address ibera, address _infrared)
        external
        initializer
    {
        if (
            admin == address(0) || ibera == address(0)
                || _infrared == address(0)
        ) revert ZeroAddress();
        __Ownable_init(admin);
        __UUPSUpgradeable_init();

        IBERA = ibera;
        infrared = IInfrared(_infrared);
    }

    /// @inheritdoc IIBERAFeeReceivor
    function distribution()
        public
        view
        returns (uint256 amount, uint256 fees)
    {
        amount = (address(this).balance - shareholderFees);
        uint16 feeShareholders = IIBERA(IBERA).feeShareholders();

        // take protocol fees
        if (feeShareholders > 0) {
            fees = amount / uint256(feeShareholders);
            amount -= fees;
        }
    }

    /// @inheritdoc IIBERAFeeReceivor
    function sweep() external returns (uint256 amount, uint256 fees) {
        (amount, fees) = distribution();
        // do nothing if IBERA deposit would revert
        uint256 min =
            IBERAConstants.MINIMUM_DEPOSIT + IBERAConstants.MINIMUM_DEPOSIT_FEE;
        if (amount < min) return (0, 0);

        // add to protocol fees and sweep amount back to ibera to deposit
        if (fees > 0) shareholderFees += fees;
        if (amount > 0) IIBERA(IBERA).sweep{value: amount}();
        emit Sweep(IBERA, amount, fees);
    }

    /// @inheritdoc IIBERAFeeReceivor
    function collect() external returns (uint256 sharesMinted) {
        if (msg.sender != IBERA) revert Unauthorized();
        if (shareholderFees == 0) return 0;
        uint256 shf = shareholderFees;
        uint256 min =
            IBERAConstants.MINIMUM_DEPOSIT + IBERAConstants.MINIMUM_DEPOSIT_FEE;
        if (shf == 0 || shf < min) {
            revert InvalidAmount();
        }

        uint256 amount = shf - 1; // gas savings on sweep
        shareholderFees -= amount;
        if (amount > 0) {
            (, sharesMinted) =
                IIBERA(IBERA).mint{value: amount}(address(infrared));
        }
        emit Collect(address(infrared), amount, sharesMinted);
    }

    receive() external payable {}

    function implementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
