// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {Errors} from "@utils/Errors.sol";

/**
 * @title ValidatorSet
 * @dev A library for managing a set of validators.
 *
 * This library provides functions for adding, removing, and replacing validators in a set.
 * The functions are marked as `internal`, meaning they are only intended to be called from the contract that defines the set.
 * This allows the contract to define its own events for when the set is updated.
 *
 * The `add` function adds a validator to the set.
 * The `remove` function removes a validator from the set.
 * The `replace` function replaces a validator in the set.
 * The `validators` function returns all the validators in the set.
 * The `isValidator` function checks if a validator is in the set.
 */
library ValidatorSet {
    using EnumerableSet for EnumerableSet.AddressSet;

    /// Events.
    event ValidatorSetUpdated(
        address indexed _old,
        address indexed _new,
        DataTypes.ValidatorSetAction _action
    );

    /**
     * @notice Adds a validator to the set.
     * @param  _set       EnumerableSet.AddressSet storage The set to add the validator to.
     * @param  _validator address                          The validator to add.
     */
    function add(EnumerableSet.AddressSet storage _set, address _validator)
        internal
    {
        if (_set.contains(_validator)) {
            revert Errors.ValidatorAlreadyExists();
        }

        bool success = _set.add(_validator);
        if (!success) {
            revert Errors.FailedToAddValidator();
        }

        emit ValidatorSetUpdated(
            address(0), _validator, DataTypes.ValidatorSetAction.Add
        );
    }

    /**
     * @notice Removes a validator from the set.
     * @param  _set       EnumerableSet.AddressSet storage The set to remove the validator from.
     * @param  _validator address                          The validator to remove.
     */
    function remove(EnumerableSet.AddressSet storage _set, address _validator)
        internal
    {
        if (!_set.contains(_validator)) {
            revert Errors.ValidatorDoesNotExist();
        }

        bool success = _set.remove(_validator);
        if (!success) {
            revert Errors.FailedToRemoveValidator();
        }

        emit ValidatorSetUpdated(
            _validator, address(0), DataTypes.ValidatorSetAction.Remove
        );
    }

    /**
     * @notice Replaces a validator in the set.
     * @param  _set           EnumerableSet.AddressSet storage The set to replace the validator in.
     * @param  _oldValidator  address                          The validator to replace.
     * @param  _newValidator  address                          The new validator.
     */
    function replace(
        EnumerableSet.AddressSet storage _set,
        address _oldValidator,
        address _newValidator
    ) internal {
        if (!_set.contains(_oldValidator)) {
            revert Errors.ValidatorDoesNotExist();
        }

        if (_set.contains(_newValidator)) {
            revert Errors.ValidatorAlreadyExists();
        }

        bool success = _set.remove(_oldValidator);
        if (!success) {
            revert Errors.FailedToRemoveValidator();
        }

        success = _set.add(_newValidator);
        if (!success) {
            revert Errors.FailedToAddValidator();
        }

        emit ValidatorSetUpdated(
            _oldValidator, _newValidator, DataTypes.ValidatorSetAction.Replace
        );
    }

    /**
     * @notice Returns all the validators in the set.
     * @param  _set        EnumerableSet.AddressSet storage The set to get the validators from.
     * @return _validators address[]                  The validators in the set.
     */
    function validators(EnumerableSet.AddressSet storage _set)
        internal
        view
        returns (address[] memory _validators)
    {
        return _set.values();
    }

    /**
     * @notice Checks if a validator is apart of the set.
     * @param  _set       EnumerableSet.AddressSet storage The set to check.
     * @param  _validator address                          The validator to check.
     * @return _isValidator bool                           Whether the validator is in the set.
     */
    function isValidator(
        EnumerableSet.AddressSet storage _set,
        address _validator
    ) internal view returns (bool _isValidator) {
        return _set.contains(_validator);
    }
}
