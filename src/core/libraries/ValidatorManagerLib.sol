// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IBerachainBGT} from "@interfaces/IBerachainBGT.sol";
import {Errors} from "@utils/Errors.sol";
import {ValidatorTypes} from "./ValidatorTypes.sol";
import {IInfraredDistributor} from "@interfaces/IInfraredDistributor.sol";
import {EnumerableSet} from
    "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library ValidatorManagerLib {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    struct ValidatorStorage {
        EnumerableSet.Bytes32Set validatorIds; // Set of validator IDs
        mapping(bytes32 => bytes) validatorPubkeys; // Maps validator ID to public key
        address distributor; // Address of the distributor contract
        address bgt;
    }

    // Public function to check if a validator exists, accessible to any external contract or account
    function isValidator(ValidatorStorage storage $, bytes memory pubkey)
        public
        view
        returns (bool)
    {
        return $.validatorIds.contains(keccak256(pubkey));
    }

    /// @notice Gets the validator ID for associated CL pubkey
    /// @param pubkey The CL pubkey of validator
    function _getValidatorId(bytes memory pubkey)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(pubkey);
    }

    function addValidators(
        ValidatorStorage storage $,
        ValidatorTypes.Validator[] memory _validators
    ) internal {
        for (uint256 i = 0; i < _validators.length; i++) {
            ValidatorTypes.Validator memory v = _validators[i];
            bytes32 id = _getValidatorId(v.pubkey);
            if ($.validatorIds.contains(id)) {
                revert Errors.InvalidValidator();
            }
            $.validatorIds.add(id);
            $.validatorPubkeys[id] = v.pubkey;

            // add pubkey to those elligible for iBGT rewards
            IInfraredDistributor($.distributor).add(v.pubkey, v.addr);
        }
    }

    function removeValidators(
        ValidatorStorage storage $,
        bytes[] memory _pubkeys
    ) internal {
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            bytes memory pubkey = _pubkeys[i];
            bytes32 id = keccak256(pubkey);
            if (!$.validatorIds.contains(id)) {
                revert Errors.InvalidValidator();
            }
            $.validatorIds.remove(id);
            delete $.validatorPubkeys[id];

            // remove pubkey from those elligible for iBGT rewards
            IInfraredDistributor($.distributor).remove(pubkey);
        }
    }

    function replaceValidator(
        ValidatorStorage storage $,
        bytes calldata _current,
        bytes calldata _new
    ) internal {
        bytes32 id = keccak256(_current);
        if (!$.validatorIds.contains(id)) {
            revert Errors.InvalidValidator();
        }
        address _addr = _getValidatorAddress($, _current);

        // remove current from set
        $.validatorIds.remove(id);
        delete $.validatorPubkeys[id];
        IInfraredDistributor($.distributor).remove(_current);

        // add new to set
        id = _getValidatorId(_new);
        if ($.validatorIds.contains(id)) {
            revert Errors.InvalidValidator();
        }
        $.validatorIds.add(id);
        $.validatorPubkeys[id] = _new;

        IInfraredDistributor($.distributor).add(_new, _addr);
    }

    function queueBoosts(
        ValidatorStorage storage $,
        bytes[] memory _pubkeys,
        uint128[] memory _amts
    ) internal {
        if (_pubkeys.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            if (!$.validatorIds.contains(keccak256(_pubkeys[i]))) {
                revert Errors.InvalidValidator();
            }
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            IBerachainBGT($.bgt).queueBoost(_pubkeys[i], _amts[i]);
        }
    }

    function cancelBoosts(
        ValidatorStorage storage $,
        bytes[] memory _pubkeys,
        uint128[] memory _amts
    ) internal {
        if (_pubkeys.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            IBerachainBGT($.bgt).cancelBoost(_pubkeys[i], _amts[i]);
        }
    }

    function activateBoosts(ValidatorStorage storage $, bytes[] memory _pubkeys)
        internal
    {
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            if (!$.validatorIds.contains(keccak256(_pubkeys[i]))) {
                revert Errors.InvalidValidator();
            }
            IBerachainBGT($.bgt).activateBoost(address(this), _pubkeys[i]);
        }
    }

    function infraredValidators(ValidatorStorage storage $)
        public
        view
        returns (ValidatorTypes.Validator[] memory validators)
    {
        bytes32[] memory ids = $.validatorIds.values();
        uint256 len = ids.length;
        validators = new ValidatorTypes.Validator[](len);

        for (uint256 i = 0; i < len; i++) {
            bytes memory pubkey = $.validatorPubkeys[ids[i]];
            validators[i] = ValidatorTypes.Validator({
                pubkey: pubkey,
                addr: _getValidatorAddress($, pubkey),
                commission: _getValidatorCommission($, pubkey)
            });
        }
    }

    // Public function to return the number of validators
    function numInfraredValidators(ValidatorStorage storage $)
        public
        view
        returns (uint256)
    {
        return $.validatorIds.length();
    }

    // Helper function to retrieve validator address from distributor
    function _getValidatorAddress(
        ValidatorStorage storage $,
        bytes memory pubkey
    ) internal view returns (address) {
        return IInfraredDistributor($.distributor).validators(pubkey);
    }

    // Helper function to retrieve validator commission from distributor
    function _getValidatorCommission(
        ValidatorStorage storage $,
        bytes memory pubkey
    ) internal view returns (uint256) {
        return IBerachainBGT($.bgt).commissions(pubkey);
    }
}
