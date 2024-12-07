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

import {IInfraredBERA} from "src/interfaces/IInfraredBERA.sol";
import {IInfraredBERAFeeReceivor} from
    "src/interfaces/IInfraredBERAFeeReceivor.sol";
import {IInfrared} from "src/interfaces/IInfrared.sol";
import {InfraredBERAConstants} from "./InfraredBERAConstants.sol";

/// @title InfraredBERAFeeReceivor
/// @author bungabear69420
/// @notice Fee receivor receives coinbase priority fees + MEV credited to contract on EL upon block validation
/// @dev CL validators should set fee_recipient to the address of this contract
contract InfraredBERAFeeReceivor is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    IInfraredBERAFeeReceivor
{
    /// @inheritdoc IInfraredBERAFeeReceivor
    address public InfraredBERA;

    IInfrared public infrared;

    /// @inheritdoc IInfraredBERAFeeReceivor
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

        InfraredBERA = ibera;
        infrared = IInfrared(_infrared);
    }

    /// @inheritdoc IInfraredBERAFeeReceivor
    function distribution()
        public
        view
        returns (uint256 amount, uint256 fees)
    {
        amount = (address(this).balance - shareholderFees);
        uint16 feeShareholders = IInfraredBERA(InfraredBERA).feeShareholders();

        // take protocol fees
        if (feeShareholders > 0) {
            fees = amount / uint256(feeShareholders);
            amount -= fees;
        }
    }

    /// @inheritdoc IInfraredBERAFeeReceivor
    function sweep() external returns (uint256 amount, uint256 fees) {
        (amount, fees) = distribution();
        // do nothing if InfraredBERA deposit would revert
        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT
            + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        if (amount < min) return (0, 0);

        // add to protocol fees and sweep amount back to ibera to deposit
        if (fees > 0) shareholderFees += fees;
        if (amount > 0) IInfraredBERA(InfraredBERA).sweep{value: amount}();
        emit Sweep(InfraredBERA, amount, fees);
    }

    /// @inheritdoc IInfraredBERAFeeReceivor
    function collect() external returns (uint256 sharesMinted) {
        if (msg.sender != InfraredBERA) revert Unauthorized();
        if (shareholderFees == 0) return 0;
        uint256 shf = shareholderFees;
        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT
            + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        if (shf == 0 || shf < min) {
            revert InvalidAmount();
        }

        uint256 amount = shf - 1; // gas savings on sweep
        shareholderFees -= amount;
        if (amount > 0) {
            (, sharesMinted) = IInfraredBERA(InfraredBERA).mint{value: amount}(
                address(infrared)
            );
        }
        emit Collect(address(infrared), amount, sharesMinted);
    }

    receive() external payable {}

    function implementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
