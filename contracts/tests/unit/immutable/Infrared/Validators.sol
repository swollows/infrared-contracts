// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";
import "@forge-std/console2.sol";

contract ValidatorManagment is Helper {
    /*//////////////////////////////////////////////////////////////
               Validator Set Management Tests
    //////////////////////////////////////////////////////////////*/
    function testAddValidators() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(777);
        vm.prank(governance);
        // Add the new validators
        infrared.addValidators(newValidators);

        // Assert that the validators were added
        assertEq(
            infrared.isInfraredValidator(address(777)),
            true,
            "Validators not added correctly"
        );
    }

    function testFailAddValidatorWithZeroAddress() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(0);
        vm.prank(governance);
        // Attempt to add the new validators
        infrared.addValidators(newValidators);

        // Expect a revert due to zero address
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailAddValidatorUnauthorized() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(777);
        // Attempt to add the new validators
        vm.prank(address(2)); // Simulate call from unauthorized address
        infrared.addValidators(newValidators);

        // Expect a revert due to unauthorized access
        vm.expectRevert();
    }

    function testRemoveValidators() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(777);
        vm.startPrank(governance);
        // Add the new validators
        infrared.addValidators(newValidators);

        // Assert that the validators were added
        assertEq(
            infrared.isInfraredValidator(address(777)),
            true,
            "Validators not added correctly"
        );

        // Remove the validators
        infrared.removeValidators(newValidators);

        // Assert that the validators were removed
        assertEq(
            infrared.isInfraredValidator(address(777)),
            false,
            "Validators not removed correctly"
        );
    }

    function testFailRemoveValidatorUnauthorized() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(777);
        vm.prank(governance);
        // Add the new validators
        infrared.addValidators(newValidators);

        // Assert that the validators were added
        assertEq(
            infrared.isInfraredValidator(address(777)),
            true,
            "Validators not added correctly"
        );

        // Remove the validators
        vm.prank(address(2)); // Simulate call from unauthorized address
        infrared.removeValidators(newValidators);

        // Expect a revert due to unauthorized access
        vm.expectRevert();
    }

    function testReplaceValidator() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(777);
        vm.startPrank(governance);
        // Add the new validators
        infrared.addValidators(newValidators);

        // Assert that the validators were added
        assertEq(
            infrared.isInfraredValidator(address(777)),
            true,
            "Validators not added correctly"
        );

        // Remove the validators
        infrared.replaceValidator(newValidators[0], address(45454));

        // Assert that the validators were replaced
        assertEq(
            infrared.isInfraredValidator(address(777)),
            false,
            "Validators not removed correctly"
        );
        assertEq(
            infrared.isInfraredValidator(address(45454)),
            true,
            "Validators not added correctly"
        );
    }

    function testFailReplaceValidatorWithZeroAddress() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(777);
        vm.prank(governance);
        // Add the new validators
        infrared.addValidators(newValidators);

        // Assert that the validators were added
        assertEq(
            infrared.isInfraredValidator(address(777)),
            true,
            "Validators not added correctly"
        );

        // Remove the validators
        infrared.replaceValidator(newValidators[0], address(0));

        // Expect a revert due to zero address
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailReplaceValidatorUnauthorized() public {
        // Set up a new mock validator set
        address[] memory newValidators = new address[](1);
        newValidators[0] = address(777);
        vm.prank(governance);
        // Add the new validators
        infrared.addValidators(newValidators);

        // Assert that the validators were added
        assertEq(
            infrared.isInfraredValidator(address(777)),
            true,
            "Validators not added correctly"
        );

        // Remove the validators
        vm.prank(address(2)); // Simulate call from unauthorized address
        infrared.replaceValidator(newValidators[0], address(888));

        // Expect a revert due to unauthorized access
        vm.expectRevert();
    }

    /*//////////////////////////////////////////////////////////////
                                FUZZING
    //////////////////////////////////////////////////////////////*/

    function testValidatorManagementFuzz(uint8 numActions, uint256 seed)
        public
    {
        // This will represent the current set of validators
        address[] memory currentValidators = new address[](0);

        for (uint256 i = 0; i < numActions; i++) {
            // Randomly decide the action to take: add, remove, or replace
            uint256 action = uint256(keccak256(abi.encode(seed, i))) % 3;

            if (action == 0) {
                // Add validators
                // Define a random number of validators to add
                uint8 numToAdd =
                    uint8(uint256(keccak256(abi.encode(seed, i))) % 5) + 1; // Add 1-5 validators
                address[] memory validatorsToAdd = new address[](numToAdd);
                for (uint8 j = 0; j < numToAdd; j++) {
                    address newValidator = address(
                        uint160(uint256(keccak256(abi.encode(seed, i, j))))
                    );
                    vm.assume(newValidator != address(0));
                    validatorsToAdd[j] = newValidator;
                }
                vm.prank(governance);
                infrared.addValidators(validatorsToAdd);
                currentValidators =
                    combineArrays(currentValidators, validatorsToAdd);
                for (uint8 j = 0; j < numToAdd - 1; j++) {
                    assertTrue(
                        infrared.isInfraredValidator(validatorsToAdd[j]),
                        "Validator should be added"
                    );
                }
            } else if (action == 1 && currentValidators.length > 0) {
                // Remove validators
                // Randomly select one of the current validators to remove
                uint256 indexToRemove = uint256(keccak256(abi.encode(seed, i)))
                    % currentValidators.length;
                address validatorToRemove = currentValidators[indexToRemove];
                address[] memory validatorsToRemove = new address[](1);
                validatorsToRemove[0] = validatorToRemove;
                vm.prank(governance);
                infrared.removeValidators(validatorsToRemove);
                currentValidators =
                    removeElementAtIndex(currentValidators, indexToRemove);
                assertTrue(
                    !infrared.isInfraredValidator(validatorsToRemove[0]),
                    "Validator should be removed"
                );
            } else if (action == 2 && currentValidators.length > 0) {
                // Replace a validator
                // Randomly select one of the current validators to replace
                uint256 indexToReplace = uint256(keccak256(abi.encode(seed, i)))
                    % currentValidators.length;
                address validatorToReplace = currentValidators[indexToReplace];
                address newValidator = address(
                    uint160(uint256(keccak256(abi.encode(seed, i, "replace"))))
                );
                vm.assume(
                    newValidator != address(0)
                        && newValidator != validatorToReplace
                );
                vm.startPrank(governance);
                infrared.replaceValidator(validatorToReplace, newValidator);
                vm.stopPrank();
                currentValidators[indexToReplace] = newValidator; // Replace in the array
                assertTrue(
                    !infrared.isInfraredValidator(validatorToReplace),
                    "Validator should be removed"
                );
                assertTrue(
                    infrared.isInfraredValidator(newValidator),
                    "Validator should be added"
                );
            }
        }
    }

    // Helper function to combine two arrays of addresses
    function combineArrays(address[] memory array1, address[] memory array2)
        internal
        pure
        returns (address[] memory)
    {
        address[] memory combined = new address[](array1.length + array2.length);
        for (uint256 i = 0; i < array1.length; i++) {
            combined[i] = array1[i];
        }
        for (uint256 j = 0; j < array2.length; j++) {
            combined[array1.length + j] = array2[j];
        }
        return combined;
    }

    // Helper function to remove an element from an array of addresses by index
    function removeElementAtIndex(address[] memory array, uint256 index)
        internal
        pure
        returns (address[] memory)
    {
        require(index < array.length, "Index out of bounds");
        address[] memory newArray = new address[](array.length - 1);
        for (uint256 i = 0; i < index; i++) {
            newArray[i] = array[i];
        }
        for (uint256 j = index + 1; j < array.length; j++) {
            newArray[j - 1] = array[j];
        }
        return newArray;
    }
}
