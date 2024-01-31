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
            address(infrared.ibgt()), address(ibgt), "Incorrect IBGT address"
        );

        assertEq(
            address(infrared.stakingPrecompile()),
            address(mockStaking),
            "Incorrect Staking Module address"
        );
        assertEq(
            address(infrared.distributionPrecompile()),
            address(mockDistribution),
            "Incorrect Distribution Precompile address"
        );
        assertEq(
            address(infrared.erc20BankPrecompile()),
            address(mockErc20Bank),
            "Incorrect ERC20 Bank Module address"
        );
        assertEq(
            address(infrared.wbera()),
            address(mockWbera),
            "Incorrect Wbera address"
        );
        assertEq(
            address(infrared.rewardsPrecompile()),
            address(mockRewardsPrecompile),
            "Incorrect Rewards Precompile address"
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
        infrared.registerVault(address(mockAsset), rewardTokens, poolAddress);

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

    function testUpdateWhiteListedRewardTokens() public {
        vm.expectEmit();
        emit Infrared.WhiteListedRewardTokensUpdated(
            address(this), address(12345), false, true
        );
        // Update the whitelist
        infrared.updateWhiteListedRewardTokens(address(12345), true);

        // Check that the whitelist was updated
        assertTrue(
            infrared.whitelistedRewardTokens(address(12345)),
            "Wbera should be whitelisted"
        );
    }

    function testUpdateRewardsDuration() public {
        vm.expectEmit();
        emit Infrared.RewardsDurationUpdated(
            address(this), infrared.rewardsDuration(), 123
        );
        // Update the rewards duration
        infrared.updateRewardsDuration(123);

        // Check that the rewards duration was updated
        assertEq(
            infrared.rewardsDuration(), 123, "Rewards duration not updated"
        );
    }
}
