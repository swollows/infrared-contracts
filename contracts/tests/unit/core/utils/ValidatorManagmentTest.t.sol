// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

pragma solidity 0.8.22;

//
import "@utils/DataTypes.sol";
import "@utils/ValidatorManagment.sol";

import "../../mocks/MockERC20.sol";

// internal
import "../Infrared/Helper.sol";

contract ValidatorManagmentTest is Helper {
    function testDelegate() public {
        // Setup
        address validator = address(0x123); // Example validator address
        uint256 amount = 1000; // Example delegation amount

        StdCheats.deal(address(bgt), address(this), amount, false);

        // Act

        bool success = ValidatorManagment._delegate(
            validator, amount, address(mockStaking)
        );

        // Assert
        assertTrue(success, "Delegation should succeed");
        uint256 delegatedAmount =
            mockStaking.getDelegatedAmount(validator, address(this));
        assertEq(
            delegatedAmount,
            amount,
            "Delegated amount does not match expected amount"
        );
    }

    function testDelegateFailures() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        ValidatorManagment._delegate(address(0), 1000, address(mockStaking));

        vm.expectRevert(Errors.ZeroAmount.selector);
        ValidatorManagment._delegate(address(0x123), 0, address(mockStaking));
    }

    // function testUndelegate() public {
    //     // Setup
    //     address validator = address(0x123); // Example validator address
    //     uint256 amount = 1000; // Example undelegation amount

    //     StdCheats.deal(address(bgt), address(stakingHandler), amount, false);

    //     bool success =
    //         stakingHandler.delegate(validator, amount, address(stakingHandler));

    //     // Act
    //     bool success2 = stakingHandler.undelegate(
    //         validator, amount, address(stakingHandler)
    //     );

    //     // Assert
    //     assertTrue(success, "Undelegation should succeed");
    //     uint256 delegatedAmount =
    //         address(mockStaking).getDelegatedAmount(validator, address(stakingHandler));
    //     assertEq(
    //         delegatedAmount,
    //         0,
    //         "Delegated amount does not match expected amount"
    //     );

    //     assertTrue(success2, "Undelegation should succeed");
    //     uint256 undelegatedAmount =
    //         address(mockStaking).undelegatedAmounts(validator);
    //     assertEq(
    //         undelegatedAmount,
    //         amount,
    //         "Undelegated amount does not match expected amount"
    //     );
    // }

    function testUndelegateFailures() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        ValidatorManagment._undelegate(address(0), 1000, address(mockStaking));

        vm.expectRevert(Errors.ZeroAmount.selector);
        ValidatorManagment._undelegate(address(0x123), 0, address(mockStaking));
    }

    function testUndelegate() public {
        // Setup
        uint256 amount = 1000; // Example undelegation amount

        // first delegate
        StdCheats.deal(address(bgt), address(this), amount, false);
        ValidatorManagment._delegate(validator, amount, address(mockStaking));

        // Act
        bool success = ValidatorManagment._undelegate(
            validator, amount, address(mockStaking)
        );

        // Assert
        assertTrue(success, "Undelegation should succeed");
        uint256 delegatedAmount =
            mockStaking.getDelegatedAmount(validator, address(this));
        assertEq(
            delegatedAmount,
            0,
            "Delegated amount does not match expected amount"
        );
    }

    // function testBeginRedelegate() public {
    //     // Setup
    //     address fromValidator = address(0x123); // Example from validator address
    //     address toValidator = address(0x456); // Example to validator address
    //     uint256 amount = 1000; // Example redelegation amount

    //     // Act
    //     bool success = stakingHandler.beginRedelegate(
    //         fromValidator, toValidator, amount, address(stakingHandler)
    //     );

    //     // Assert
    //     assertTrue(success, "Redelegation should succeed");
    //     uint256 redelegatedAmount = address(mockStaking).redelegatedAmounts(toValidator);
    // }

    function testBeginRedelegateFailures() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        ValidatorManagment._beginRedelegate(
            address(0), address(0x456), 1000, address(mockStaking)
        );

        vm.expectRevert(Errors.ZeroAddress.selector);
        ValidatorManagment._beginRedelegate(
            address(0x123), address(0), 1000, address(mockStaking)
        );

        vm.expectRevert(Errors.ZeroAmount.selector);
        ValidatorManagment._beginRedelegate(
            address(0x123), address(0x456), 0, address(mockStaking)
        );
    }

    function testCancelUnbondingDelegation() public {
        // Setup
        address validator = address(0x123); // Example validator address
        uint256 amount = 1000; // Example amount for unbonding cancellation
        int64 creationHeight = 12345; // Example creation height

        // Act
        bool success = ValidatorManagment._cancelUnbondingDelegation(
            validator, amount, creationHeight, address(mockStaking)
        );

        // Assert
        assertTrue(
            success, "Cancellation of unbonding delegation should succeed"
        );
        uint256 canceledAmount = mockStaking.canceledUnbondingAmounts(validator);
        assertEq(
            canceledAmount,
            amount,
            "Canceled unbonding amount does not match expected amount"
        );
    }

    function testCancelUnbondingDelegationFailures() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        ValidatorManagment._cancelUnbondingDelegation(
            address(0), 1000, 12345, address(mockStaking)
        );

        vm.expectRevert(Errors.ZeroAmount.selector);
        ValidatorManagment._cancelUnbondingDelegation(
            address(0x123), 0, 12345, address(mockStaking)
        );
    }
}
