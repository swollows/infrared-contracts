// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

//external

import {Helper, Infrared, Errors, IAccessControl} from "./Helper.sol";

contract InfraredInitializationTest is Helper {
    /*//////////////////////////////////////////////////////////////
                Initialization and Setup Tests
    //////////////////////////////////////////////////////////////*/
    function testInitializationParameters() public {
        assertEq(
            address(infrared.UPGRADABLE_REWARDS_HANDLER()),
            address(rewardsHandlerProxy),
            "Incorrect Rewards Handler address"
        );
        assertTrue(
            infrared.hasRole(infrared.DEFAULT_ADMIN_ROLE(), admin),
            "Incorrect Admin address"
        );
        assertEq(
            address(infrared.ibgt()), address(ibgt), "Incorrect IBGT address"
        );
    }

    function testRoleAssignments() public {
        assertTrue(
            infrared.hasRole(infrared.DEFAULT_ADMIN_ROLE(), admin),
            "Admin should have DEFAULT_ADMIN_ROLE"
        );
        assertTrue(
            infrared.hasRole(infrared.KEEPER_ROLE(), keeper),
            "Keeper should have KEEPER_ROLE"
        );
        assertTrue(
            infrared.hasRole(infrared.GOVERNANCE_ROLE(), governance),
            "Governance should have GOVERNANCE_ROLE"
        );
    }

    function testFailRoleAssignmentsUnauthorizedAccess() public {
        // Trying to access a role with an unauthorized address
        address unauthorizedUser = address(3);

        // Expecting a revert when unauthorizedUser tries to access a role-specific function
        vm.prank(unauthorizedUser);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.DEFAULT_ADMIN_ROLE()
            )
        );
        infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            rewardTokens,
            poolAddress
        );

        vm.prank(unauthorizedUser);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.KEEPER_ROLE()
            )
        );
        infrared.updateIbgt(address(123));
    }
}
