// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ValidatorSet} from '@utils/ValidatorSet.sol';
import {EnumerableSet} from '@openzeppelin/utils/structs/EnumerableSet.sol';
import {Errors} from '@utils/Errors.sol';
import {IStakingModule} from '@polaris/Staking.sol';

// InfraredValidators is an abstract contract, that abstracts the logic for
// dealing with the staking precompile.
abstract contract InfraredValidators {
    using ValidatorSet for EnumerableSet.AddressSet;

    // External Contracts.
    address public immutable STAKING_PRECOMPILE_ADDRESS;

    // The set of infrared validators.
    EnumerableSet.AddressSet internal _infraredValidatorsSet;

    /*//////////////////////////////////////////////////////////////
                        CONSTRUCTOR/INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    constructor(address _stakingPrecompileAddress) {
        if (_stakingPrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        STAKING_PRECOMPILE_ADDRESS = _stakingPrecompileAddress;
    }

    /*//////////////////////////////////////////////////////////////
                        VIEW METHODS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the addresses of all the validators in the set.
     * @return _validators address[] memory Returns all the validators in the
     * set.
     */
    function infraredValidators() external view virtual returns (address[] memory _validators) {
        return _infraredValidatorsSet.validators();
    }

    /**
     * @notice Returns the number of validators in the set.
     * @param  _validator   address The validator to check.
     * @return _is          bool    Returns true if the validator is in the set.
     */
    function isInfraredValidator(address _validator) public view virtual returns (bool _is) {
        return _infraredValidatorsSet.isElementOfSet(_validator);
    }

    /*//////////////////////////////////////////////////////////////
                    Staking Precompile Write METHODS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Delegates bond tokens to a validator.
     * @param _validator  address  The validator to delegate to.
     * @param _amount     uint256  The amount of tokens to delegate.
     * @return _success   bool     Returns true if the delegation was
     * successful.
     */
    function _delegate(address _validator, uint256 _amount) internal virtual returns (bool _success) {
        // Check that the validator is in the set.
        if (!isInfraredValidator(_validator)) {
            revert Errors.ValidatorDoesNotExist(_validator);
        }

        // Delegate to tha validator.
        return IStakingModule(STAKING_PRECOMPILE_ADDRESS).delegate(_validator, _amount);
    }

    /**
     * @notice Undelegates unbond tokens from a validator.
     * @param _validator  address  The validator to undelegate from.
     * @param _amount     uint256  The amount of tokens to undelegate.
     * @return _success   bool     Returns true if the undelegation was
     * successful.
     */
    function _undelegate(address _validator, uint256 _amount) internal virtual returns (bool _success) {
        // Check that the validator is in the set.
        if (!isInfraredValidator(_validator)) {
            revert Errors.ValidatorDoesNotExist(_validator);
        }

        // Undelegate from the validator.
        return IStakingModule(STAKING_PRECOMPILE_ADDRESS).undelegate(_validator, _amount);
    }

    /**
     * @notice Redelegates unbond tokens from a validator to another validator.
     * @param _from   address  The validator to undelegate from.
     * @param _to     address  The validator to delegate to.
     * @param _amount uint256  The amount of tokens to undelegate.
     * @return _success   bool     Returns true if the redelegation was
     * successful.
     */
    function _beginRedelegate(address _from, address _to, uint256 _amount) internal virtual returns (bool _success) {
        // Only care about if the `_to` validator is in the set.
        if (!isInfraredValidator(_to)) {
            revert Errors.ValidatorDoesNotExist(_to);
        }

        // Redelegate from the validator.
        return IStakingModule(STAKING_PRECOMPILE_ADDRESS).beginRedelegate(_from, _to, _amount);
    }

    /**
     * @notice Cancels an unbonding delegation and delegates the tokens back to
     * the validator.
     * @param _validator       address  The validator to delegate to.
     * @param _amount          uint256  The amount of tokens to delegate.
     * @param _creationHeight  int64    The height at which the unbonding
     * delegation was created.
     * @return _success        bool     Returns true if the delegation was
     * successful.
     */
    function _cancelUnbondingDelegation(
        address _validator,
        uint256 _amount,
        int64 _creationHeight
    ) internal virtual returns (bool _success) {
        // Check that the validator is in the set.
        if (!isInfraredValidator(_validator)) {
            revert Errors.ValidatorDoesNotExist(_validator);
        }

        // Cancel the unbonding delegation.
        return
            IStakingModule(STAKING_PRECOMPILE_ADDRESS).cancelUnbondingDelegation(_validator, _amount, _creationHeight);
    }
}
