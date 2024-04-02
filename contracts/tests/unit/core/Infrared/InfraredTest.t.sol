// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";

contract InfraredTest is Helper {
    /*//////////////////////////////////////////////////////////////
               END TO END TESTS, FULL LIFE CYCLE
    //////////////////////////////////////////////////////////////*/

    function testEndToEndFlow() public {
        MockERC20 mockAsset = new MockERC20("MockAsset", "MCK", 18);
        rewardsFactory.createRewardsVault(address(mockAsset));

        address[] memory rewardTokens = new address[](1);
        rewardTokens[0] = address(ibgt);

        // Step 1: Vault Registration
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));
        InfraredVault vault = InfraredVault(
            address(infrared.registerVault(address(mockAsset), rewardTokens))
        );

        // Step 2: User Interaction - Staking Tokens
        address user = address(10);
        uint256 stakeAmount = 1000 ether;
        mockAsset.mint(user, stakeAmount);
        vm.startPrank(user);
        mockAsset.approve(address(vault), stakeAmount);
        vault.stake(stakeAmount);
        vm.stopPrank();

        // Step 3: Reward Accrual via Rewards Factory (Simulate Reward Increase)
        // Assuming rewardsFactory and infrared contracts have been set up to interact correctly
        rewardsFactory.increaseRewardsForVault(address(mockAsset), 100 ether);

        // Step 4: Passage of Time for Rewards Distribution
        vm.warp(block.timestamp + 10 days); // Simulating 10 days for reward accrual

        // Step 5: Harvest Vault - Distributing Rewards
        vm.startPrank(keeper);
        uint256 vaultBalanceBefore = ibgt.balanceOf(address(vault));
        vm.expectEmit();
        emit IInfrared.VaultHarvested(
            keeper, address(mockAsset), address(vault), 99999999999999964000
        );
        infrared.harvestVault(address(mockAsset));
        vm.stopPrank();

        uint256 vaultBalanceAfter = ibgt.balanceOf(address(vault));
        assertTrue(
            vaultBalanceAfter > vaultBalanceBefore,
            "Vault should have more IBGT after harvest"
        );

        // Step 6: Claiming Rewards
        vm.startPrank(user);
        vm.warp(block.timestamp + 10 days); //
        vault.getReward();
        vm.stopPrank();
        uint256 rewardBalance = ibgt.balanceOf(user);
        assertTrue(rewardBalance > 0, "User should have rewards");

        // Step 7: Users Withdraw Tokens
        vm.startPrank(user);
        vault.withdraw(stakeAmount);
        uint256 finalBalance = mockAsset.balanceOf(user);
        vm.stopPrank();
        assertEq(
            finalBalance,
            stakeAmount,
            "User should have withdrawn all staked tokens"
        );

        // Step 8: Assertions
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
    /* TODO: fix
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
