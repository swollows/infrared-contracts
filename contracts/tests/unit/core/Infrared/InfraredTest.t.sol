// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";

contract InfraredTest is Helper {
/*//////////////////////////////////////////////////////////////
               END TO END TESTS, FULL LIFE CYCLE
    //////////////////////////////////////////////////////////////*/

/* TODO: fix
    function testEndToEndFlow() public {
        // Step 1: Vault Registration
        (address deployedInfraredVault, address pool) = setupMockVault();
        // stakingAsset is the staking token for the vault
        InfraredVault vault = InfraredVault(deployedInfraredVault);
        vault.stakingToken();

        // Step 2: User Interaction - Staking Tokens
        address user = address(10);
        uint256 stakeAmount = 1000 ether;
        MockERC20(stakingAsset).mint(user, stakeAmount);
        vm.startPrank(user);
        MockERC20(stakingAsset).approve(deployedInfraredVault, stakeAmount);
        vault.stake(stakeAmount);
        vm.stopPrank();

        // Simulate Infrared harvesting and distributing rewards to the vault
        vm.prank(keeper);
        // infrared.harvestVault(pool);

        // Step 4: Passage of Time for Rewards Distribution
        vm.warp(block.timestamp + 30 days); // Simulating 30 days for reward distribution

        // Step 5: Claiming Rewards
        vm.startPrank(user);
        vault.getReward();
        uint256 rewardBalance = ibgt.balanceOf(user);
        vm.stopPrank();
        assertTrue(rewardBalance > 0, "User should have rewards");

        // Step 6: Users Withdraw Tokens
        vm.startPrank(user);
        vault.withdraw(stakeAmount);
        uint256 finalBalance = MockERC20(stakingAsset).balanceOf(user);
        vm.stopPrank();
        assertTrue(
            finalBalance == stakeAmount,
            "User should have withdrawn all staked tokens"
        );

        // Step 7: Assertions
        // Ensure the vault's state is correct
        assertEq(
            vault.totalSupply(),
            0,
            "Vault total supply should be zero after withdrawal"
        );
        assertEq(
            vault.balanceOf(user),
            0,
            "User balance in vault should be zero after withdrawal"
        );
    }

    // TODO: fix
    function testEndToEndHarvestValidator() public {
        // Staking by User in IBGT Vault
        address user = address(10);
        uint256 stakeAmount = 1000 * 1e18;
        ibgt.mint(user, stakeAmount);
        vm.startPrank(user);
        ibgt.approve(address(ibgtVault), stakeAmount);
        ibgtVault.stake(stakeAmount);
        vm.stopPrank();

        // Simulate Rewards from Validators
        // TODO: For Validator 1 with token rewards

        // Harvesting Rewards from Validators
        vm.prank(keeper);
        // TODO: infrared.harvestValidator(validator);

        // TODO: For Validator 2 with token rewards

        vm.prank(keeper);
        // TODO: fix infrared.harvestValidator(validator2);

        // Time Skip for Reward Distribution
        vm.warp(block.timestamp + 30 days); // Simulate passage of time for reward distribution

        // Claiming Rewards and Checking Balances
        vm.startPrank(user);
        ibgtVault.getReward();
        uint256 rewardBalanceBGT = ibgt.balanceOf(user);
        uint256 rewardBalanceBERA = mockWbera.balanceOf(user);
        vm.stopPrank();
        assertTrue(rewardBalanceBGT > 0, "User should have BGT rewards");
        assertTrue(rewardBalanceBERA > 0, "User should have BERA rewards");

        // Withdrawal by User
        vm.startPrank(user);
        ibgtVault.withdraw(stakeAmount);
        uint256 finalBalance = ibgt.balanceOf(user);
        vm.stopPrank();
        // Final balance expected is the sum of initially staked amount and rewards received
        uint256 expectedFinalBalance = stakeAmount + rewardBalanceBGT;
        assertEq(
            finalBalance,
            expectedFinalBalance,
            "User final balance should be sum of staked amount and BGT rewards"
        );

        // Final Assertions
        assertEq(
            ibgtVault.totalSupply(),
            0,
            "IBGT Vault total supply should be zero after withdrawals"
        );
        assertEq(
            ibgtVault.balanceOf(user),
            0,
            "User balance in IBGT Vault should be zero after withdrawal"
        );
    }

    ?*/
}
