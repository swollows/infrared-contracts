// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@forge-std/console2.sol";

import "./Helper.sol";
import {Errors} from "@utils/Errors.sol";

import {DataTypes} from "@utils/DataTypes.sol";

contract ValidatorManagment is Helper {
/*//////////////////////////////////////////////////////////////
               Validator Set Management Tests
    //////////////////////////////////////////////////////////////*/

/* TODO: FIX
    function testAddValidators() public {
        // Set up a new mock validator
        DataTypes.Validator[] memory newValidators =
            new DataTypes.Validator[](1);
        newValidators[0] = DataTypes.Validator({
            pubKey: bytes("validator_pub_key"),
            coinbase: address(msg.sender)
        });

        bytes[] memory pubKeys = new bytes[](1);
        pubKeys[0] = newValidators[0].pubKey;

        vm.prank(governance);
        // Add the new validator
        vm.expectEmit(true, true, true, true);
        emit IInfrared.ValidatorsAdded(governance, pubKeys);
        infrared.addValidators(newValidators);

        // Assert that the validator was added
        assertEq(
            infrared.isInfraredValidator(newValidators[0].pubKey),
            true,
            "Validator not added correctly"
        );
    }

    function testFailAddValidatorWithZeroPubKey() public {
        // Set up a new mock validator with zero-length public key
        DataTypes.Validator[] memory newValidators =
            new DataTypes.Validator[](1);
        newValidators[0] =
            DataTypes.Validator({pubKey: "", coinbase: address(msg.sender)});

        vm.startPrank(governance);
        // Expect a revert due to zero-length public key
        vm.expectRevert(Errors.ZeroBytes.selector);
        // Attempt to add the new validators
        try infrared.addValidators(newValidators) {
            revert("Zero-length public key should revert");
        } catch {
            revert();
        }
    }

    function testFailAddValidatorUnauthorized() public {
        // Set up a new mock validator
        DataTypes.Validator[] memory newValidators =
            new DataTypes.Validator[](1);
        newValidators[0] = DataTypes.Validator({
            pubKey: "someValidPubKey", // This needs to be a valid public key in bytes format
            coinbase: address(msg.sender)
        });

        // Simulate the call from an unauthorized address
        vm.prank(address(2));

        // Attempt to add the new validator
        infrared.addValidators(newValidators);

        // Expect a revert due to unauthorized access
        vm.expectRevert();
    }

    function testRemoveValidators() public {
        // Set up a new mock validator
        DataTypes.Validator[] memory newValidators =
            new DataTypes.Validator[](2);
        newValidators[0] = DataTypes.Validator({
            pubKey: "someValidPubKey", // A valid public key in bytes format
            coinbase: address(msg.sender)
        });
        newValidators[1] = DataTypes.Validator({
            pubKey: "someOtherValidPubKey2", // Another valid public key in bytes format
            coinbase: address(msg.sender)
        });

        vm.startPrank(governance);
        // Add the new validator
        infrared.addValidators(newValidators);

        // Assert that the validator was added
        assertTrue(
            infrared.isInfraredValidator(newValidators[0].pubKey),
            "Validator not added correctly"
        );

        DataTypes.Validator[] memory validatorsToRemove =
            new DataTypes.Validator[](1);
        validatorsToRemove[0] = newValidators[0];

        bytes[] memory pubKeysToRemove = new bytes[](1);
        pubKeysToRemove[0] = validatorsToRemove[0].pubKey;

        // Prepare for the removal event
        vm.expectEmit(true, true, false, true);
        emit IInfrared.ValidatorsRemoved(governance, pubKeysToRemove);

        // Remove the validator
        infrared.removeValidators(validatorsToRemove);

        // Assert that the validator was removed
        assertFalse(
            infrared.isInfraredValidator(newValidators[0].pubKey),
            "Validator not removed correctly"
        );
        vm.stopPrank();
    }

    function testFailRemoveValidatorUnauthorized() public {
        // Create a new validator struct with sample data
        // Convert the Validator struct to bytes to simulate adding and removing
        DataTypes.Validator[] memory newValidators =
            new DataTypes.Validator[](1);
        newValidators[0] = DataTypes.Validator({
            pubKey: "somePublicKey", // Assuming this is a valid public key in bytes
            coinbase: address(msg.sender)
        });

        vm.startPrank(governance);
        // Add the new validator
        infrared.addValidators(newValidators);
        vm.stopPrank();

        // Assert that the validator was added successfully
        assertTrue(
            infrared.isInfraredValidator(newValidators[0].pubKey),
            "Validator not added correctly"
        );

        // Attempt to remove the validator as an unauthorized user
        vm.prank(address(2)); // Simulate call from an unauthorized address
        vm.expectRevert("Unauthorized"); // Use the specific revert reason or error selector expected for unauthorized access
        infrared.removeValidators(newValidators);
    }

    function testReplaceValidator() public {
        // Set up a new mock validator
        DataTypes.Validator[] memory newValidators =
            new DataTypes.Validator[](1);
        newValidators[0] = DataTypes.Validator({
            pubKey: "someValidPubKey777", // Original validator's public key
            coinbase: address(msg.sender)
        });

        // Add the new validator
        vm.startPrank(governance);
        infrared.addValidators(newValidators);

        // Assert that the validator was added
        assertTrue(
            infrared.isInfraredValidator(newValidators[0].pubKey),
            "Validator not added correctly"
        );

        // Prepare for validator replacement
        DataTypes.Validator[] memory replacementValidator =
            new DataTypes.Validator[](1);
        replacementValidator[0] = DataTypes.Validator({
            pubKey: "someValidPubKey45454", // New validator's public key
            coinbase: address(msg.sender)
        });

        // Emitting event for replacing validator
        vm.expectEmit(true, true, false, true);
        emit IInfrared.ValidatorReplaced(
            governance, newValidators[0].pubKey, replacementValidator[0].pubKey
        );

        // Replace the original validator with the new one
        infrared.replaceValidator(newValidators[0], replacementValidator[0]);

        // Stop impersonating the governance address
        vm.stopPrank();

        // Assert that the original validator was replaced
        assertFalse(
            infrared.isInfraredValidator(newValidators[0].pubKey),
            "Original validator was not removed correctly"
        );
        assertTrue(
            infrared.isInfraredValidator(replacementValidator[0].pubKey),
            "New validator was not added correctly"
        );
    }

    function testFailReplaceValidatorWithInvalidPubKey() public {
        // Set up a new mock validator with valid details
        DataTypes.Validator[] memory originalValidator;
        originalValidator[0] = DataTypes.Validator({
            pubKey: "someValidPubKey777", // Assuming this is a valid public key in bytes format
            coinbase: address(msg.sender)
        });

        // Attempt to add the original validator
        vm.prank(governance);
        infrared.addValidators(originalValidator);

        // Assert that the original validator was added
        assertTrue(
            infrared.isInfraredValidator(originalValidator[0].pubKey),
            "Original validator not added correctly"
        );

        // Prepare an invalid new validator with zero-length public key
        DataTypes.Validator[1] memory invalidNewValidator;
        invalidNewValidator[0] = DataTypes.Validator({
            pubKey: "", // Zero-length public key
            coinbase: address(msg.sender)
        });

        // Attempt to replace the original validator with the invalid new validator
        vm.prank(governance);
        vm.expectRevert(Errors.ZeroBytes.selector); // Assuming you have a specific error for this
        infrared.replaceValidator(originalValidator[0], invalidNewValidator[0]);
    }

    function testFailReplaceValidatorUnauthorized() public {
        // Assuming we have a function to convert addresses to bytes for demonstration
        bytes memory pubKey777 = abi.encodePacked(address(777));
        bytes memory pubKey888 = abi.encodePacked(address(888));

        // Set up a new mock validator with valid details
        DataTypes.Validator[] memory originalValidator;
        originalValidator[0] = DataTypes.Validator({
            pubKey: pubKey777,
            coinbase: address(msg.sender)
        });

        // Add the original validator with governance privileges
        vm.prank(governance);
        infrared.addValidators(originalValidator);

        // Assert that the original validator was added
        assertTrue(
            infrared.isInfraredValidator(originalValidator[0].pubKey),
            "Original validator not added correctly"
        );

        // Attempt to replace the validator without authorization
        vm.prank(address(2)); // Simulating a call from an unauthorized address

        // Prepare the call to replace the validator and expect it to revert due to unauthorized access

        vm.expectRevert(); // Use your contract's specific revert reason or error selector for unauthorized actions
        // Attempt to replace the original validator with a new public key, simulated to fail due to lack of permissions
        infrared.replaceValidator(
            originalValidator[0],
            DataTypes.Validator({
                pubKey: pubKey888,
                coinbase: address(msg.sender)
            })
        );
    }
    */

/*//////////////////////////////////////////////////////////////
                                FUZZING
    //////////////////////////////////////////////////////////////*/

/* TODO: FIX
    function testValidatorManagementFuzz(uint8 numActions, uint256 seed)
        public
    {
        // This will represent the current set of validators
        DataTypes.Validator[] memory currentValidators =
            new DataTypes.Validator[](0);

        for (uint256 i = 0; i < numActions; i++) {
            // Randomly decide the action to take: add, remove, or replace
            uint256 action = uint256(keccak256(abi.encode(seed, i))) % 3;

            if (action == 0) {
                // Add validators
                // Define a random number of validators to add
                uint8 numToAdd =
                    uint8(uint256(keccak256(abi.encode(seed, i))) % 5) + 1; // Add 1-5 validators
                DataTypes.Validator[] memory validatorsToAdd =
                    new DataTypes.Validator[](numToAdd);
                for (uint8 j = 0; j < numToAdd; j++) {
                    validatorsToAdd[j] = DataTypes.Validator({
                        pubKey: abi.encodePacked(
                            uint256(keccak256(abi.encode(seed, i, j)))
                        ),
                        coinbase: address(msg.sender)
                    });
                }
                vm.prank(governance);
                infrared.addValidators(validatorsToAdd);
                currentValidators =
                    combineValidatorArrays(currentValidators, validatorsToAdd);
            } else if (action == 1 && currentValidators.length > 0) {
                // Remove validators
                // Randomly select one of the current validators to remove
                uint256 indexToRemove = uint256(keccak256(abi.encode(seed, i)))
                    % currentValidators.length;
                DataTypes.Validator[] memory validatorsToRemove =
                    new DataTypes.Validator[](1);
                validatorsToRemove[0] = currentValidators[indexToRemove];
                vm.prank(governance);
                infrared.removeValidators(validatorsToRemove);
                currentValidators =
                    removeValidatorAtIndex(currentValidators, indexToRemove);
            } else if (action == 2 && currentValidators.length > 0) {
                // Replace a validator
                // Randomly select one of the current validators to replace
                uint256 indexToReplace = uint256(keccak256(abi.encode(seed, i)))
                    % currentValidators.length;
                DataTypes.Validator memory newValidator = DataTypes.Validator({
                    pubKey: abi.encodePacked(
                        uint256(keccak256(abi.encode(seed, i, "replace")))
                    ),
                    coinbase: address(msg.sender)
                });
                vm.prank(governance);
                infrared.replaceValidator(
                    currentValidators[indexToReplace], newValidator
                );
                currentValidators[indexToReplace] = newValidator; // Replace in the array
            }
        }
    }

    // Helper function to combine two arrays of Validator structs
    function combineValidatorArrays(
        DataTypes.Validator[] memory array1,
        DataTypes.Validator[] memory array2
    ) internal pure returns (DataTypes.Validator[] memory) {
        DataTypes.Validator[] memory combined =
            new DataTypes.Validator[](array1.length + array2.length);
        for (uint256 i = 0; i < array1.length; i++) {
            combined[i] = array1[i];
        }
        for (uint256 j = 0; j < array2.length; j++) {
            combined[array1.length + j] = array2[j];
        }
        return combined;
    }

    // Helper function to remove an element from an array of Validator structs by index
    function removeValidatorAtIndex(
        DataTypes.Validator[] memory array,
        uint256 index
    ) internal pure returns (DataTypes.Validator[] memory) {
        require(index < array.length, "Index out of bounds");
        DataTypes.Validator[] memory newArray =
            new DataTypes.Validator[](array.length - 1);
        for (uint256 i = 0; i < index; i++) {
            newArray[i] = array[i];
        }
        for (uint256 j = index + 1; j < array.length; j++) {
            newArray[j - 1] = array[j];
        }
        return newArray;
    }
    */
}
