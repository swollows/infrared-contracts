// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External Dependencies.
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";

// Internal Dependencies.
import {ValidatorSet} from "@utils/ValidatorSet.sol";
import {Errors} from "@utils/Errors.sol";
import {IUpgradableStakingHandler} from
    "@interfaces/IUpgradableStakingHandler.sol";

/**
 * @title InfraredValidators
 * @dev A abstract contract for managing the set of infrared validators and interacting with the staking handler.
 *
 * The `_delegate`, `_undelegate`, `_beginRedelegate`, and `_cancelUnbondingDelegation` functions are wrappers for the staking handler functions.
 * The `infraredValidators` function returns the set of infrared validators.
 * The `isInfraredValidator` function checks if a validator is an infrared validator.
 */
abstract contract InfraredValidators {
    using ValidatorSet for EnumerableSet.AddressSet;

    // Upgradable contracts.
    IUpgradableStakingHandler public immutable UPGRADABLE_STAKING_HANDLER;

    // The set of infrared validators.
    EnumerableSet.AddressSet internal _infraredValidators;

    /**
     * @notice constructor for the InfraredValidators contract.
     * @param _stakingHandler address The address of the staking handler.
     */
    constructor(address _stakingHandler) {
        if (_stakingHandler == address(0)) {
            revert Errors.ZeroAddress();
        }

        UPGRADABLE_STAKING_HANDLER = IUpgradableStakingHandler(_stakingHandler);
    }

    /*//////////////////////////////////////////////////////////////
                               READS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Gets the set of infrared validators.
     * @return _validators address[] memory The set of infrared validators.
     */
    function infraredValidators()
        public
        view
        virtual
        returns (address[] memory _validators)
    {
        return _infraredValidators.validators();
    }

    /**
     * @notice Checks if a validator is an infrared validator.
     * @param _validator    address  The validator to check.
     * @return _isValidator bool     Whether the validator is an infrared validator.
     */
    function isInfraredValidator(address _validator)
        public
        view
        returns (bool)
    {
        return _infraredValidators.isValidator(_validator);
    }

    /*//////////////////////////////////////////////////////////////
                        STAKING WRITES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Delegate `_amt` of tokens to `_validator`.
     * @param _validator address The validator to delegate to.
     * @param _amt       uint256 The amount of tokens to delegate.
     * @return _success  bool    Whether the addition was successful.
     */
    function _delegate(address _validator, uint256 _amt)
        internal
        virtual
        returns (bool _success)
    {
        if (!isInfraredValidator(_validator)) {
            revert Errors.InvalidValidator();
        }

        (bool success, bytes memory data) = address(UPGRADABLE_STAKING_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_STAKING_HANDLER.delegate.selector,
                _validator,
                _amt,
                address(UPGRADABLE_STAKING_HANDLER)
            )
        );

        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        return abi.decode(data, (bool));
    }

    /**
     * @notice Undelegate `_amt` of tokens from `_validator`.
     * @param _validator address The validator to undelegate from.
     * @param _amt       uint256 The amount of tokens to undelegate.
     * @return _success  bool    Whether the removal was successful.
     */
    function _undelegate(address _validator, uint256 _amt)
        internal
        virtual
        returns (bool _success)
    {
        if (!isInfraredValidator(_validator)) {
            revert Errors.InvalidValidator();
        }

        (bool success, bytes memory data) = address(UPGRADABLE_STAKING_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_STAKING_HANDLER.undelegate.selector,
                _validator,
                _amt,
                address(UPGRADABLE_STAKING_HANDLER)
            )
        );

        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        return abi.decode(data, (bool));
    }

    /**
     * @notice Begin redelegation of `_amt` of tokens from `_from` to `_to`.
     * @param  _from      address The validator to redelegate from.
     * @param  _to        address The validator to redelegate to.
     * @param  _amt       uint256 The amount of tokens to redelegate.
     * @return _success   bool    Whether the redelegation was successful.
     */
    function _beginRedelegate(address _from, address _to, uint256 _amt)
        internal
        virtual
        returns (bool _success)
    {
        if (!isInfraredValidator(_from) || !isInfraredValidator(_to)) {
            revert Errors.InvalidValidator();
        }

        (bool success, bytes memory data) = address(UPGRADABLE_STAKING_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_STAKING_HANDLER.beginRedelegate.selector,
                _from,
                _to,
                _amt,
                address(UPGRADABLE_STAKING_HANDLER)
            )
        );

        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        return abi.decode(data, (bool));
    }

    /**
     * @notice Cancels an unbonding delegation.
     * @param _validator     address The validator to cancel the unbonding delegation from.
     * @param _amt           uint256 The amount of tokens to cancel the unbonding delegation for.
     * @param _creationHeight int64   The height at which the unbonding delegation was created.
     */
    function _cancelUnbondingDelegation(
        address _validator,
        uint256 _amt,
        int64 _creationHeight
    ) internal virtual returns (bool _success) {
        if (!isInfraredValidator(_validator)) {
            revert Errors.InvalidValidator();
        }

        (bool success, bytes memory data) = address(UPGRADABLE_STAKING_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_STAKING_HANDLER.cancelUnbondingDelegation.selector,
                _validator,
                _amt,
                _creationHeight,
                address(UPGRADABLE_STAKING_HANDLER)
            )
        );

        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        return abi.decode(data, (bool));
    }
}
