// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {EnumerableSet} from '@openzeppelin/utils/structs/EnumerableSet.sol';
import {DataTypes} from '@utils/DataTypes.sol';
import {Errors} from '@utils/Errors.sol';

library ValidatorSet {
    // Add the library methods
    using EnumerableSet for EnumerableSet.AddressSet;

    // Events.
    event ValidatorSetUpdated(address indexed _old, address _new, DataTypes.ValidatorSetAction _action);

    /**
     * @notice Replace a validator in the validators set.
     *       @param  _set      EnumerableSet.AddressSet  Storage Validators set.
     *       @param  _current  address                   Current validator to be replaced.
     *       @param  _new      address                   New validator to replace the current one.
     */
    function replaceValidator(EnumerableSet.AddressSet storage _set, address _current, address _new) internal {
        // Check that _current is an element of _set.
        if (!_set.contains(_current)) {
            revert Errors.ValidatorDoesNotExist(_current);
        }
        // Check that _new is not an element of _set.
        if (_set.contains(_new)) {
            revert Errors.ValidatorAlreadyExists(_new);
        }

        // Replace _current with _new.
        require(_set.remove(_current), 'ValidatorSet: failed to remove');
        require(_set.add(_new), 'ValidatorSet: failed to add');

        emit ValidatorSetUpdated(_current, _new, DataTypes.ValidatorSetAction.Replace);
    }

    /**
     * @notice Add a validator to the validators set.
     *       @param  _set  EnumerableSet.AddressSet  Storage Validators set.
     *       @param  _new  address                   New validator to be added.
     */
    function addValidator(EnumerableSet.AddressSet storage _set, address _new) internal {
        // Check that the validator is not already in the set.
        if (_set.contains(_new)) {
            revert Errors.ValidatorAlreadyExists(_new);
        }

        // Add the validator to the set.
        require(_set.add(_new), 'ValidatorSet: failed to add');

        emit ValidatorSetUpdated(address(0), _new, DataTypes.ValidatorSetAction.Add);
    }

    /**
     * @notice Remove a validator from the validators set.
     *       @param  _set      EnumerableSet.AddressSet  Storage Validators set.
     *       @param  _current  address                   Validator to be removed.
     */
    function removeValidator(EnumerableSet.AddressSet storage _set, address _current) internal {
        // Check that the validator is in the set.
        if (!_set.contains(_current)) {
            revert Errors.ValidatorDoesNotExist(_current);
        }

        // Remove the validator from the set.
        require(_set.remove(_current), 'ValidatorSet: failed to remove');

        emit ValidatorSetUpdated(_current, address(0), DataTypes.ValidatorSetAction.Remove);
    }

    /**
     * @notice Returns the addresses of all the validators in the set.
     * @param  _set         EnumerableSet.AddressSet  Storage Validators set.
     * @return _validators  address[] memory          Returns all the validators in the set.
     */
    function validators(EnumerableSet.AddressSet storage _set) external view returns (address[] memory _validators) {
        return _set.values();
    }

    /**
     * @notice Returns the number of validators in the set.
     * @param  _set        EnumerableSet.AddressSet Storage Validators set.
     * @param  _validator  address                  The validator to check.
     * @return _is         bool                     Returns true if the validator is in the set.
     */
    function isElementOfSet(EnumerableSet.AddressSet storage _set, address _validator) public view returns (bool _is) {
        return _set.contains(_validator);
    }
}
