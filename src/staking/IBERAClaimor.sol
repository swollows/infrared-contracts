// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Initializable} from
    "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {
    ERC1967Utils,
    UUPSUpgradeable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {IIBERAClaimor} from "@interfaces/IIBERAClaimor.sol";

/// @title IBERAClaimor
/// @author bungabear69420
/// @notice Claimor to claim BERA withdrawn from CL for Infrared liquid staking token
/// @dev Separate contract so withdrawor process has trusted contract to forward funds to so no issue with naked bera transfer and receive function
contract IBERAClaimor is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    IIBERAClaimor
{
    /// @inheritdoc IIBERAClaimor
    mapping(address => uint256) public claims;

    /// @dev Constructor disabled for upgradeable contracts
    constructor() {
        _disableInitializers();
    }

    /// @notice Initializer function (replaces constructor)
    /// @param admin Address of the initial admin
    function initialize(address admin) external initializer {
        __Ownable_init(admin);
        __UUPSUpgradeable_init();
    }

    /// @inheritdoc IIBERAClaimor
    function queue(address receiver) external payable {
        uint256 claim = claims[receiver];
        claim += msg.value;
        claims[receiver] = claim;
        emit Queue(receiver, msg.value, claim);
    }

    /// @inheritdoc IIBERAClaimor
    function sweep(address receiver) external {
        uint256 amount = claims[receiver];
        delete claims[receiver];
        if (amount > 0) SafeTransferLib.safeTransferETH(receiver, amount);
        emit Sweep(receiver, amount, 0);
    }

    /// @notice Authorization function for UUPS upgrades
    /// @dev Restrict to only the contract owner
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    function implementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
