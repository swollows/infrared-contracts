// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// external
import "@forge-std/Test.sol";
import "@forge-std/Vm.sol";

// berachain precompile mock contracts
import "../mocks/MockStakingModule.sol";

// internal
import "@core/upgradable/UpgradableStakingHandler.sol";

contract UpgradableStakingHandlerTest is Test {
    UpgradableStakingHandler stakingHandler;
    MockStakingModule mockStaking;

    function setUp() public {
        // Initialize the UpgradableStakingHandler and MockStakingModule
        stakingHandler = new UpgradableStakingHandler();
        mockStaking = new MockStakingModule();

        stakingHandler.initialize(address(mockStaking));
    }

    function testDelegate() public {
        // Setup
        address validator = address(0x123); // Example validator address
        uint256 amount = 1000; // Example delegation amount

        // Act
        bool success =
            stakingHandler.delegate(validator, amount, address(stakingHandler));

        // Assert
        assertTrue(success, "Delegation should succeed");
        uint256 delegatedAmount = mockStaking.delegatedAmounts(validator);
        assertEq(
            delegatedAmount,
            amount,
            "Delegated amount does not match expected amount"
        );
    }

    function testDelegateFailures() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        stakingHandler.delegate(address(0), 1000, address(stakingHandler));

        vm.expectRevert(Errors.ZeroAmount.selector);
        stakingHandler.delegate(address(0x123), 0, address(stakingHandler));
    }

    function testUndelegate() public {
        // Setup
        address validator = address(0x123); // Example validator address
        uint256 amount = 1000; // Example undelegation amount

        // Act
        bool success = stakingHandler.undelegate(
            validator, amount, address(stakingHandler)
        );

        // Assert
        assertTrue(success, "Undelegation should succeed");
        uint256 undelegatedAmount = mockStaking.undelegatedAmounts(validator);
        assertEq(
            undelegatedAmount,
            amount,
            "Undelegated amount does not match expected amount"
        );
    }

    function testUndelegateFailures() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        stakingHandler.undelegate(address(0), 1000, address(stakingHandler));

        vm.expectRevert(Errors.ZeroAmount.selector);
        stakingHandler.undelegate(address(0x123), 0, address(stakingHandler));
    }

    function testBeginRedelegate() public {
        // Setup
        address fromValidator = address(0x123); // Example from validator address
        address toValidator = address(0x456); // Example to validator address
        uint256 amount = 1000; // Example redelegation amount

        // Act
        bool success = stakingHandler.beginRedelegate(
            fromValidator, toValidator, amount, address(stakingHandler)
        );

        // Assert
        assertTrue(success, "Redelegation should succeed");
        uint256 redelegatedAmount = mockStaking.redelegatedAmounts(toValidator);
        assertEq(
            redelegatedAmount,
            amount,
            "Redelegated amount does not match expected amount"
        );
    }

    function testBeginRedelegateFailures() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        stakingHandler.beginRedelegate(
            address(0), address(0x456), 1000, address(stakingHandler)
        );

        vm.expectRevert(Errors.ZeroAddress.selector);
        stakingHandler.beginRedelegate(
            address(0x123), address(0), 1000, address(stakingHandler)
        );

        vm.expectRevert(Errors.ZeroAmount.selector);
        stakingHandler.beginRedelegate(
            address(0x123), address(0x456), 0, address(stakingHandler)
        );
    }

    function testCancelUnbondingDelegation() public {
        // Setup
        address validator = address(0x123); // Example validator address
        uint256 amount = 1000; // Example amount for unbonding cancellation
        int64 creationHeight = 12345; // Example creation height

        // Act
        bool success = stakingHandler.cancelUnbondingDelegation(
            validator, amount, creationHeight, address(stakingHandler)
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
        stakingHandler.cancelUnbondingDelegation(
            address(0), 1000, 12345, address(stakingHandler)
        );

        vm.expectRevert(Errors.ZeroAmount.selector);
        stakingHandler.cancelUnbondingDelegation(
            address(0x123), 0, 12345, address(stakingHandler)
        );
    }
}
