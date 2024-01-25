// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";

contract InfraredTest is Helper {
    /*//////////////////////////////////////////////////////////////
               END TO END TESTS, FULL LIFE CYCLE
    //////////////////////////////////////////////////////////////*/
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

        // Step 3: Simulating Rewards for harvestVault
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(1000 ether, "abgt"); // 100 bgt
        mockRewardsPrecompile.setMockRewards(rewards);

        // Simulate Infrared harvesting and distributing rewards to the vault
        vm.prank(keeper);
        infrared.harvestVault(pool);

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
        // For Validator 1
        Cosmos.Coin[] memory rewardsValidator1 = new Cosmos.Coin[](2);
        rewardsValidator1[0] = Cosmos.Coin(50 * 1e18, "abgt"); // 50 bgt
        rewardsValidator1[1] = Cosmos.Coin(100 * 1e18, "abera"); // 100 abera
        mockDistribution.setMockRewards(rewardsValidator1);

        // Harvesting Rewards from Validators
        vm.prank(keeper);
        infrared.harvestValidator(validator);

        // For Validator 2
        Cosmos.Coin[] memory rewardsValidator2 = new Cosmos.Coin[](2);
        rewardsValidator2[0] = Cosmos.Coin(75 * 1e18, "abgt"); // 75 bgt
        rewardsValidator2[1] = Cosmos.Coin(50 * 1e18, "abera"); // Additional 50 abera
        mockDistribution.setMockRewards(rewardsValidator2);

        vm.prank(keeper);
        infrared.harvestValidator(validator2);

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
}
