// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";

contract DelegationTest is Helper {
    /*//////////////////////////////////////////////////////////////
               Delegation Function Tests
    //////////////////////////////////////////////////////////////*/
    function testDelegate() public {
        // simulate accured bgt rewards
        StdCheats.deal(address(bgt), address(infrared), 100, false);

        vm.prank(governance);
        infrared.delegate(validator, 100);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 amount =
            mockStaking.getDelegatedAmount(validator, address(infrared));
        assertEq(amount, 100);
    }

    function testFailDelegateWithZeroAddress() public {
        vm.prank(governance);
        infrared.delegate(address(0), 100);
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailDelegateWithZeroAmount() public {
        vm.prank(governance);
        infrared.delegate(validator, 0);
        vm.expectRevert(Errors.ZeroAmount.selector);
    }

    function testFailDelegateUnauthorized() public {
        infrared.delegate(validator, 100);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infrared.GOVERNANCE_ROLE()
            )
        );
    }

    function testUndelegate() public {
        // simulate accured bgt rewards
        StdCheats.deal(address(bgt), address(infrared), 100, false);

        vm.startPrank(governance);
        infrared.delegate(validator, 100);
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

    function testBeginRedelegate() public {
        // simulate accured bgt rewards
        StdCheats.deal(address(bgt), address(infrared), 100, false);

        vm.startPrank(governance);
        infrared.delegate(validator, 100);
        infrared.beginRedelegate(validator, validator2, 100);
        vm.stopPrank();

        // checks are arbitrary, Test already passed if no revert
        uint256 amount =
            mockStaking.getDelegatedAmount(validator, address(infrared));
        assertEq(amount, 0);
        amount = mockStaking.getDelegatedAmount(validator2, address(infrared));
        assertEq(amount, 100);
    }

    function testFailBeginRedelegateWithZeroFromAddress() public {
        vm.prank(governance);
        infrared.beginRedelegate(address(0), validator2, 100);
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailBeginRedelegateWithZeroToAddress() public {
        vm.prank(governance);
        infrared.beginRedelegate(validator, address(0), 100);
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailBeginRedelegateWithZeroAmount() public {
        vm.prank(governance);
        infrared.beginRedelegate(validator, validator2, 0);
        vm.expectRevert(Errors.ZeroAmount.selector);
    }

    function testFailBeginRedelegateUnauthorized() public {
        infrared.beginRedelegate(validator, validator2, 100);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infrared.GOVERNANCE_ROLE()
            )
        );
    }

    function testCancelUnbondingDelegation() public {
        // simulate accured bgt rewards
        StdCheats.deal(address(bgt), address(infrared), 100, false);

        vm.startPrank(governance);
        infrared.cancelUnbondingDelegation(validator, 100, 100);
        vm.stopPrank();
    }

    function testFailCancelUnbondingDelegationWithZeroAddress() public {
        vm.prank(governance);
        infrared.cancelUnbondingDelegation(address(0), 100, 100);
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailCancelUnbondingDelegationWithZeroAmount() public {
        vm.prank(governance);
        infrared.cancelUnbondingDelegation(validator, 0, 100);
        vm.expectRevert(Errors.ZeroAmount.selector); // this test just always passes.
    }

    function testFailCancelUnbondingDelegationUnauthorized() public {
        infrared.cancelUnbondingDelegation(validator, 100, 100);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infrared.GOVERNANCE_ROLE()
            )
        );
    }
}
