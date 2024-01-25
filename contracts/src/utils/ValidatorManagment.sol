// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// Internal Dependencies.
import {Errors} from "@utils/Errors.sol";
import {IStakingModule} from "@polaris/Staking.sol";

/**
 * @title InfraredValidators
 * @dev A abstract contract for managing the set of infrared validators and interacting with the staking handler.
 *
 * The `_delegate`, `_undelegate`, `_beginRedelegate`, and `_cancelUnbondingDelegation` functions are wrappers for the staking handler functions.
 */
library ValidatorManagment {
    /*//////////////////////////////////////////////////////////////
                        STAKING WRITES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Delegate `_amt` of tokens to `_validator`.
     * @param _validator address The validator to delegate to.
     * @param _amt       uint256 The amount of tokens to delegate.
     * @return _success  bool    Whether the addition was successful.
     */
    function _delegate(
        address _validator,
        uint256 _amt,
        address _stakingPrecompile
    ) public returns (bool) {
        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }
        return IStakingModule(_stakingPrecompile).delegate(_validator, _amt);
    }

    /**
     * @notice Undelegate `_amt` of tokens from `_validator`.
     * @param _validator address The validator to undelegate from.
     * @param _amt       uint256 The amount of tokens to undelegate.
     * @return _success  bool    Whether the removal was successful.
     */
    function _undelegate(
        address _validator,
        uint256 _amt,
        address _stakingPrecompile
    ) public returns (bool) {
        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }
        return IStakingModule(_stakingPrecompile).undelegate(_validator, _amt);
    }

    /**
     * @notice Begin redelegation of `_amt` of tokens from `_from` to `_to`.
     * @param  _from      address The validator to redelegate from.
     * @param  _to        address The validator to redelegate to.
     * @param  _amt       uint256 The amount of tokens to redelegate.
     * @return _success   bool    Whether the redelegation was successful.
     */
    function _beginRedelegate(
        address _from,
        address _to,
        uint256 _amt,
        address _stakingPrecompile
    ) public returns (bool) {
        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }
        if (_from == address(0) || _to == address(0)) {
            revert Errors.ZeroAddress();
        }
        return
            IStakingModule(_stakingPrecompile).beginRedelegate(_from, _to, _amt);
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
        int64 _creationHeight,
        address _stakingPrecompile
    ) public returns (bool) {
        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }
        return IStakingModule(_stakingPrecompile).cancelUnbondingDelegation(
            _validator, _amt, _creationHeight
        );
    }
}
