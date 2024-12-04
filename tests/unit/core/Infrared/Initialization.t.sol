// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

//external

import "./Helper.sol";
import {IMultiRewards} from "src/interfaces/IMultiRewards.sol";

contract InfraredInitializationTest is Helper {
    /*//////////////////////////////////////////////////////////////
                Initialization and Setup Tests
    //////////////////////////////////////////////////////////////*/

    function testInitializationParameters() public view {
        assertEq(
            address(infrared.ibgt()), address(ibgt), "Incorrect IBGT address"
        );

        assertEq(
            address(infrared.rewardsFactory()),
            address(factory),
            "Incorrect Bera Chain Rewards Factory address"
        );
        // assertEq(     // TODO: wait until the distribution contract is implemented
        //     address(infrared.distributionPrecompile()),
        //     address(distribution),
        //     "Incorrect Distribution Precompile address"
        // );
        assertEq(
            address(infrared.wbera()), address(wbera), "Incorrect Wbera address"
        );

        assertTrue(
            infrared.hasRole(infrared.DEFAULT_ADMIN_ROLE(), admin),
            "Incorrect Admin address"
        );
        assertEq(
            infrared.rewardsDuration(), 1 days, "Incorrect rewards duration"
        );
    }

    function testRoleAssignments() public view {
        assertTrue(
            infrared.hasRole(infrared.DEFAULT_ADMIN_ROLE(), admin),
            "Admin should have DEFAULT_ADMIN_ROLE"
        );
        assertTrue(
            infrared.hasRole(infrared.KEEPER_ROLE(), keeper),
            "Keeper should have KEEPER_ROLE"
        );
        assertTrue(
            infrared.hasRole(infrared.GOVERNANCE_ROLE(), infraredGovernance),
            "Governance should have GOVERNANCE_ROLE"
        );
    }

    function testFailRoleAssignmentsUnauthorizedAccess() public {
        // Trying to access a role with an unauthorized address
        address unauthorizedUser = address(3);

        // Expecting a revert when unauthorizedUser tries to access a role-specific function
        vm.startPrank(unauthorizedUser);
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.KEEPER_ROLE()
            )
        );
        infrared.registerVault(address(stakingAsset));

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.KEEPER_ROLE()
            )
        );
        // infrared.harvestValidator(address(1));

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.GOVERNANCE_ROLE()
            )
        );
        infrared.updateWhiteListedRewardTokens(address(12345), true);

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.GOVERNANCE_ROLE()
            )
        );
        infrared.updateRewardsDuration(2 days);

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.GOVERNANCE_ROLE()
            )
        );
        infrared.pauseVault(address(infraredVault));

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                unauthorizedUser,
                infrared.GOVERNANCE_ROLE()
            )
        );
        infrared.recoverERC20(address(12345), address(this), 100);
    }

    function testUpdateWhiteListedRewardTokens() public {
        vm.expectEmit();
        emit IInfrared.WhiteListedRewardTokensUpdated(
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
        emit IInfrared.RewardsDurationUpdated(
            address(this), infrared.rewardsDuration(), 123
        );
        // Update the rewards duration
        infrared.updateRewardsDuration(123);

        // Check that the rewards duration was updated
        assertEq(
            infrared.rewardsDuration(), 123, "Rewards duration not updated"
        );
    }

    function testUpdateRewardsDurationForVault() public {
        // Set up initial conditions
        address stakingToken = address(wbera);
        address rewardsToken = address(ibgt);
        uint256 newRewardsDuration = 2 days;

        // Update the rewards duration for the vault
        vm.expectEmit(true, true, true, true, address(infraredVault));
        emit IMultiRewards.RewardsDurationUpdated(
            rewardsToken, newRewardsDuration
        );
        infrared.updateRewardsDurationForVault(
            stakingToken, rewardsToken, newRewardsDuration
        );

        // Verify that the rewards duration was updated
        (, uint256 updatedRewardsDuration,,,,,) =
            infraredVault.rewardData(rewardsToken);
        assertEq(
            updatedRewardsDuration,
            newRewardsDuration,
            "Rewards duration not updated correctly"
        );

        // Test unauthorized access
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(666),
                infrared.GOVERNANCE_ROLE()
            )
        );
        vm.prank(address(666));
        infrared.updateRewardsDurationForVault(stakingToken, rewardsToken, 0);

        // Test for zero rewards duration
        vm.expectRevert(Errors.ZeroAmount.selector);
        infrared.updateRewardsDurationForVault(stakingToken, rewardsToken, 0);

        // Test for unsupported vault
        address unsupportedStakingToken = address(0x123);
        vm.expectRevert(Errors.VaultNotSupported.selector);
        infrared.updateRewardsDurationForVault(
            unsupportedStakingToken, rewardsToken, newRewardsDuration
        );

        // Test for non-whitelisted reward token
        address nonWhitelistedToken = address(0x456);
        vm.expectRevert(Errors.RewardTokenNotWhitelisted.selector);
        infrared.updateRewardsDurationForVault(
            stakingToken, nonWhitelistedToken, newRewardsDuration
        );
    }
}
