// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External dependencies.
import {UUPSUpgradeable} from
    "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from
    "@openzeppelin-upgradeable/access/OwnableUpgradeable.sol";
import {IStakingModule} from "@polaris/Staking.sol";

// Internal dependencies.
import {Errors} from "@utils/Errors.sol";

/**
 * @title UpgradableStakingHandler
 * @dev A contract that preforms staking operations on the berachain network.
 * @dev Built to be called as delegatecall from other contracts.
 * @dev This contract is upgradable.
 */
contract UpgradableStakingHandler is UUPSUpgradeable, OwnableUpgradeable {
    // Berachain Precompiled Contracts.
    IStakingModule public STAKING_PRECOMPILE;

    /**
     * @notice Initialize the contract.
     * @param _stakingPrecompileAddress address The address of the staking precompile.
     */
    function initialize(address _stakingPrecompileAddress)
        external
        initializer
    {
        if (_stakingPrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        STAKING_PRECOMPILE = IStakingModule(_stakingPrecompileAddress);

        __Ownable_init(msg.sender);
    }

    /**
     * @notice Authorize an upgrade to `_newImplementation`.
     * @dev TODO: Please implement this function.
     */
    function _authorizeUpgrade(address) internal override onlyOwner {}

    /**
     * @notice Delegate `_amt` of tokens to `_validator`.
     * @param _validator address The validator to delegate to.
     * @param _amt       uint256 The amount of tokens to delegate.
     * @return _success  bool    Whether the delegation was successful.
     */
    function delegate(address _validator, uint256 _amt, address _storageAddress)
        external
        returns (bool _success)
    {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }

        return UpgradableStakingHandler(_storageAddress).STAKING_PRECOMPILE()
            .delegate(_validator, _amt);
    }

    /**
     * @notice Undelegate `_amt` of tokens from `_validator`.
     * @param _validator address The validator to undelegate from.
     * @param _amt       uint256 The amount of tokens to undelegate.
     * @return _success  bool    Whether the undelegation was successful.
     */
    function undelegate(
        address _validator,
        uint256 _amt,
        address _storageAddress
    ) external returns (bool _success) {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }

        return UpgradableStakingHandler(_storageAddress).STAKING_PRECOMPILE()
            .undelegate(_validator, _amt);
    }

    /**
     * @notice Begin redelegation of `_amt` of tokens from `_from` to `_to`.
     * @param _from address The validator to redelegate from.
     * @param _to   address The validator to redelegate to.
     * @param _amt  uint256 The amount of tokens to redelegate.
     * @return _success  bool    Whether the redelegation was successful.
     */
    function beginRedelegate(
        address _from,
        address _to,
        uint256 _amt,
        address _storageAddress
    ) external returns (bool _success) {
        if (_from == address(0) || _to == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }

        return UpgradableStakingHandler(_storageAddress).STAKING_PRECOMPILE()
            .beginRedelegate(_from, _to, _amt);
    }

    /**
     * @notice Cancel redelegation of `_amt` of tokens from `_from` to `_to` at `_creationHeight`.
     * @param _validator      address The validator to redelegate from.
     * @param _amt            uint256 The amount of tokens to redelegate.
     * @param _creationHeight int64   The height at which the redelegation was created.
     */
    function cancelUnbondingDelegation(
        address _validator,
        uint256 _amt,
        int64 _creationHeight,
        address _storageAddress
    ) external returns (bool _success) {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }

        return UpgradableStakingHandler(_storageAddress).STAKING_PRECOMPILE()
            .cancelUnbondingDelegation(_validator, _amt, _creationHeight);
    }
}
