// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {Errors} from "@utils/Errors.sol";
import {ValidatorUtils} from "@utils/ValidatorUtils.sol";

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
    using EnumerableSet for EnumerableSet.Bytes32Set;

    bytes private constant EMPTY_BYTES = "";

    /// Events.
    event ValidatorSetUpdated(
        bytes indexed _old,
        bytes indexed _new,
        DataTypes.ValidatorSetAction _action
    );

    /**
     * @notice Gets a validator from the set.
     * @param  _set       Set storage                      The set to get the validator from.
     * @param  _pubKey    bytes                            The public key of the validator to get.
     * @return _validator Validator                        The validator to get
     */
    function get(DataTypes.ValidatorSet storage _set, bytes memory _pubKey)
        internal
        view
        returns (DataTypes.Validator memory _validator)
    {
        return _set.map[ValidatorUtils.hash(_pubKey)];
    }

    /**
     * @notice Adds a validator to the set.
     * @param  _set       Set storage                      The set to add the validator to.
     * @param  _validator Validator                        The validator to add.
     */
    function add(
        DataTypes.ValidatorSet storage _set,
        DataTypes.Validator memory _validator
    ) internal {
        bytes32 _key = ValidatorUtils.hash(_validator.pubKey);
        if (_set.keys.contains(_key)) revert Errors.ValidatorAlreadyExists();

        bool success = _set.keys.add(_key);
        if (!success) revert Errors.FailedToAddValidator();
        _set.map[_key] = _validator;

        emit ValidatorSetUpdated(
            EMPTY_BYTES, _validator.pubKey, DataTypes.ValidatorSetAction.Add
        );
    }

    /**
     * @notice Removes a validator from the set.
     * @param  _set       Set storage                      The set to remove the validator from.
     * @param  _validator Validator                        The validator to remove.
     */
    function remove(
        DataTypes.ValidatorSet storage _set,
        DataTypes.Validator memory _validator
    ) internal {
        bytes32 _key = ValidatorUtils.hash(_validator.pubKey);
        if (!_set.keys.contains(_key)) revert Errors.ValidatorDoesNotExist();

        bool success = _set.keys.remove(_key);
        if (!success) revert Errors.FailedToRemoveValidator();
        delete _set.map[_key];

        emit ValidatorSetUpdated(
            _validator.pubKey, EMPTY_BYTES, DataTypes.ValidatorSetAction.Remove
        );
    }

    /**
     * @notice Replaces a validator in the set.
     * @param  _set           Set storage                        The set to replace the validator in.
     * @param  _oldValidator  Validator                          The validator to replace.
     * @param  _newValidator  Validator                          The new validator.
     */
    function replace(
        DataTypes.ValidatorSet storage _set,
        DataTypes.Validator memory _oldValidator,
        DataTypes.Validator memory _newValidator
    ) internal {
        bytes32 _oldKey = ValidatorUtils.hash(_oldValidator.pubKey);
        bytes32 _newKey = ValidatorUtils.hash(_newValidator.pubKey);

        if (!_set.keys.contains(_oldKey)) revert Errors.ValidatorDoesNotExist();
        if (_set.keys.contains(_newKey)) revert Errors.ValidatorAlreadyExists();

        bool success = _set.keys.remove(_oldKey);
        if (!success) revert Errors.FailedToRemoveValidator();
        delete _set.map[_oldKey];

        success = _set.keys.add(_newKey);
        if (!success) revert Errors.FailedToAddValidator();
        _set.map[_newKey] = _newValidator;

        emit ValidatorSetUpdated(
            _oldValidator.pubKey,
            _newValidator.pubKey,
            DataTypes.ValidatorSetAction.Replace
        );
    }

    /**
     * @notice Returns all the validators in the set.
     * @param  _set        Set storage                The set to get the validators from.
     * @return _validators Validator[]                The validators in the set.
     */
    function validators(DataTypes.ValidatorSet storage _set)
        internal
        view
        returns (DataTypes.Validator[] memory _validators)
    {
        bytes32[] memory _keys = _set.keys.values();
        _validators = new DataTypes.Validator[](_keys.length);
        for (uint256 i = 0; i < _keys.length; i++) {
            _validators[i] = _set.map[_keys[i]];
        }
    }

    /**
     * @notice Checks if a validator is apart of the set.
     * @param  _set         Set storage                    The set to check.
     * @param  _pubKey      bytes                          The public key of the validator to check.
     * @return _isValidator bool                           Whether the validator is in the set.
     */
    function isValidator(
        DataTypes.ValidatorSet storage _set,
        bytes memory _pubKey
    ) internal view returns (bool _isValidator) {
        bytes32 _key = ValidatorUtils.hash(_pubKey);
        return _set.keys.contains(_key);
    }
}
