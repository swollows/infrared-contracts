// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";
import {DataTypes} from "@utils/DataTypes.sol";

contract DelegationTest is Helper {
    /*//////////////////////////////////////////////////////////////
               Delegation Function Tests
    //////////////////////////////////////////////////////////////*/

    function testDelegate() public {
        // Simulate accrued BGT rewards to the Infrared contract
        deal(address(bgt), address(infrared), 100);

        // Create a validator struct array and initialize it with the test validator's data
        DataTypes.Validator[] memory validatorStruct =
            new DataTypes.Validator[](1);
        validatorStruct[0] = DataTypes.Validator({
            coinbase: address(infrared), // Using the Infrared contract address as a placeholder
            pubKey: bytes("validatorPubKey") // Mock public key for the validator
        });

        bytes memory signature = bytes("signature"); // Mock signature for testing
        bytes memory validatorPubKey = validatorStruct[0].pubKey; // Extract the validator's public key

        // Add the validator with the governance privileges
        vm.startPrank(governance);
        infrared.addValidators(validatorStruct);

        // Expect the `Delegated` event to be emitted upon successful delegation
        vm.expectEmit(true, true, true, true);
        emit IInfrared.Delegated(governance, validatorPubKey, 100);

        // Perform the delegation action
        infrared.delegate(validatorPubKey, 100, signature);
        vm.stopPrank();

        // Check the total stake for the validator to verify that delegation was successful
        uint256 amount = depositor.getValidatorTotalStake(validatorPubKey);
        assertEq(
            amount,
            100,
            "The delegated amount does not match the expected value."
        );
    }

    function testFailDelegateWithInvalidPubKey() public {
        // Set up a mock public key and signature
        bytes memory invalidPubKey = ""; // Represents an invalid public key, analogous to the zero address check
        bytes memory signature = bytes("signature");

        vm.prank(governance);
        vm.expectRevert(Errors.InvalidValidator.selector); // Assuming there's an error for invalid public key lengths
        try infrared.delegate(invalidPubKey, 100, signature) {
            revert("Invalid public key should revert");
        } catch {
            revert();
        }
    }

    function testFailDelegateWithZeroAmount() public {
        // Simulate accrued BGT rewards to the Infrared contract
        deal(address(bgt), address(infrared), 100);

        // Mock valid public key and signature
        bytes memory validatorPubKey = abi.encodePacked(address(this));
        bytes memory signature = bytes("signature");

        // Create a validator struct array and initialize it with the test validator's data
        DataTypes.Validator[] memory validatorStruct =
            new DataTypes.Validator[](1);
        validatorStruct[0] = DataTypes.Validator({
            coinbase: address(infrared), // Using the Infrared contract address as a placeholder
            pubKey: validatorPubKey // Mock public key for the validator
        });

        // Add the validator with the governance privileges
        vm.startPrank(governance);
        infrared.addValidators(validatorStruct);

        vm.expectRevert(Errors.ZeroAmount.selector);
        try infrared.delegate(validatorPubKey, 0, signature) {
            revert("Zero amount should revert");
        } catch {
            revert();
        }
        vm.stopPrank();
    }

    function testFailDelegateUnauthorized() public {
        // Mock valid public key and signature
        bytes memory validatorPubKey = abi.encodePacked(address(this));
        bytes memory signature = bytes("signature");

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infrared.GOVERNANCE_ROLE()
            )
        );
        infrared.delegate(validatorPubKey, 100, signature);
    }

    function testBeginRedelegate() public {
        // Simulate accrued BGT rewards
        deal(address(bgt), address(infrared), 100);

        // Create public keys and signature for validators
        bytes memory fromPubKey = abi.encodePacked(address(444)); // Mock public key for validator1
        bytes memory toPubKey = abi.encodePacked(address(555)); // Mock public key for validator2
        bytes memory signature = bytes("signature"); // Mock signature, might not be necessary depending on your delegator logic

        // Initialize validators
        DataTypes.Validator[] memory validators = new DataTypes.Validator[](2);
        validators[0] =
            DataTypes.Validator({pubKey: fromPubKey, coinbase: address(0)}); // Assume coinbase is not used here
        validators[1] =
            DataTypes.Validator({pubKey: toPubKey, coinbase: address(0)});

        // Add validators with governance privileges
        vm.startPrank(governance);
        infrared.addValidators(validators);
        // Delegate to the first validator to set up for redelegation
        infrared.delegate(fromPubKey, 100, signature);
        vm.stopPrank();

        // Expect the `Redelegated` event to be emitted upon successful redelegation
        vm.startPrank(governance);
        vm.expectEmit();
        emit IInfrared.Redelegated(governance, fromPubKey, toPubKey, 100);
        // Perform the redelegation action
        infrared.redelegate(fromPubKey, toPubKey, 100);
        vm.stopPrank();

        // Check the delegated amounts
        // Assuming mockStaking.getDelegatedAmount now accepts a public key in bytes format
        uint256 fromAmount = depositor.getValidatorTotalStake(fromPubKey);
        uint256 toAmount = depositor.getValidatorTotalStake(toPubKey);

        // Assert that the amount was redelegated from the first validator to the second
        assertEq(
            fromAmount,
            0,
            "Amount not correctly redelegated from the first validator"
        );
        assertEq(
            toAmount,
            100,
            "Amount not correctly redelegated to the second validator"
        );
    }

    function testFailBeginRedelegateWithInvalidFromPubKey() public {
        bytes memory invalidFromPubKey = ""; // Represents an invalid public key
        bytes memory toPubKey = bytes("toValidatorPubKey"); // Mock public key for validator2
        uint64 amount = 100;

        vm.prank(governance);
        infrared.redelegate(invalidFromPubKey, toPubKey, amount);
        vm.expectRevert(Errors.InvalidValidator.selector); // Assuming there's an error for invalid public key lengths
    }

    function testFailBeginRedelegateWithInvalidToPubKey() public {
        bytes memory fromPubKey = abi.encodePacked(address(444)); // Mock public key for validator1
        bytes memory invalidToPubKey = ""; // Represents an invalid public key
        uint64 amount = 100;

        vm.prank(governance);
        infrared.redelegate(fromPubKey, invalidToPubKey, amount);
        vm.expectRevert(Errors.InvalidValidator.selector); // Similar assumption as above
    }

    function testFailBeginRedelegateWithZeroAmount() public {
        bytes memory fromPubKey = abi.encodePacked(address(444)); // Mock public key for validator1
        bytes memory toPubKey = abi.encodePacked(address(555)); // Mock public key for validator1
        uint64 zeroAmount = 0;

        vm.prank(governance);
        infrared.redelegate(fromPubKey, toPubKey, zeroAmount);
        vm.expectRevert(Errors.ZeroAmount.selector);
    }

    function testFailBeginRedelegateUnauthorized() public {
        bytes memory fromPubKey = abi.encodePacked(address(444)); // Mock public key for validator1
        bytes memory toPubKey = abi.encodePacked(address(555)); // Mock public key for validator1
        uint64 amount = 100;

        infrared.redelegate(fromPubKey, toPubKey, amount);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infrared.GOVERNANCE_ROLE()
            )
        ); // Use your contract's specific revert reason or error selector
    }

    /* TODO: fix
    

    function testUndelegate() public {
        // simulate accured bgt rewards
        StdCheats.deal(address(bgt), address(infrared), 100, false);

        vm.startPrank(governance);
        infrared.delegate(validator, 100);
        vm.expectEmit();
        emit IInfrared.Undelegated(governance, address(validator), 100);
        infrared.undelegate(validator, 100);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 amount =
            mockStaking.getDelegatedAmount(validator, address(infrared));
        assertEq(amount, 0);
    }

    function testFailUndelegateWithZeroAddress() public {
        vm.prank(governance);
        infrared.undelegate(address(0), 100);
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailUndelegateWithZeroAmount() public {
        vm.prank(governance);
        infrared.undelegate(validator, 0);
        vm.expectRevert(Errors.ZeroAmount.selector);
    }

    function testFailUndelegateUnauthorized() public {
        infrared.undelegate(validator, 100);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infrared.GOVERNANCE_ROLE()
            )
        );
    }

    */
}
