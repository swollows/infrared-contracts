// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./Helper.sol";
import "@forge-std/console2.sol";
import "@core/Infrared.sol";
import "@interfaces/IInfrared.sol";

contract InfraredRewardsTest is Helper {
    /*//////////////////////////////////////////////////////////////
                Vault Rewards test
    //////////////////////////////////////////////////////////////*/

    function testHarvestVault() public {
        rewardsFactory.increaseRewardsForVault(stakingAsset, 100 ether);
        address user = address(123);
        stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

        vm.warp(10 days);
        uint256 vaultBalanceBefore = ibgt.balanceOf(address(infraredVault));
        vm.expectEmit();
        emit IInfrared.VaultHarvested(
            address(this),
            stakingAsset,
            address(infraredVault),
            1099999999999999958400
        );
        infrared.harvestVault(stakingAsset);

        uint256 vaultBalanceAfter = ibgt.balanceOf(address(infraredVault));
        assertEq(vaultBalanceAfter, vaultBalanceBefore + 1099999999999999958400); // adjust for rounding error
        // assert that bgt balance and IBGT balance are equal
        assertEq(ibgt.totalSupply(), bgt.balanceOf(address(infrared)));
    }

    function testHarvestVaultWithProtocolFees() public {
        rewardsFactory.increaseRewardsForVault(stakingAsset, 100 ether);
        address user = address(123);
        stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

        // TODO: include voting fees distribution
        vm.startPrank(governance);
        infrared.updateFee(IInfrared.FeeType.HarvestVaultFeeRate, 3e5);
        infrared.updateFee(IInfrared.FeeType.HarvestVaultProtocolRate, 1e6);
        infrared.updateIredMintRate(2e6); // 2x
        vm.stopPrank();

        vm.warp(10 days);
        vm.startPrank(keeper);
        uint256 vaultBalanceBefore = ibgt.balanceOf(address(infraredVault));
        uint256 vaultIredBalanceBefore = ired.balanceOf(address(infraredVault));
        uint256 protocolFeeAmountBefore =
            infrared.protocolFeeAmounts(address(ibgt));
        uint256 protocolFeeAmountIredBefore =
            infrared.protocolFeeAmounts(address(ired));

        uint256 amt = 1099999999999999958400;
        uint256 protocolFees = (amt * 3e5) / 1e6;
        uint256 bgtAmt = amt - protocolFees;

        uint256 iredAmt = 2 * amt;

        vm.expectEmit();
        emit IInfrared.VaultHarvested(
            keeper, stakingAsset, address(infraredVault), amt
        );
        emit IInfrared.IBGTSupplied(address(infraredVault), bgtAmt, iredAmt);
        infrared.harvestVault(stakingAsset);
        vm.stopPrank();

        uint256 vaultBalanceAfter = ibgt.balanceOf(address(infraredVault));
        assertEq(vaultBalanceAfter, vaultBalanceBefore + bgtAmt); // adjust for rounding error
        // assert that bgt balance and IBGT balance are equal
        assertEq(ibgt.totalSupply(), bgt.balanceOf(address(infrared)));
        assertEq(
            infrared.protocolFeeAmounts(address(ibgt)),
            protocolFeeAmountBefore + protocolFees
        );

        uint256 vaultIredBalanceAfter = ired.balanceOf(address(infraredVault));
        assertEq(vaultIredBalanceAfter, vaultIredBalanceBefore + iredAmt);
        assertEq(
            infrared.protocolFeeAmounts(address(ired)),
            protocolFeeAmountIredBefore
        );
    }

    function testFailHarvestVaultInvalidPool() public {
        rewardsFactory.increaseRewardsForVault(stakingAsset, 100 ether);
        address user = address(123);
        stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

        vm.warp(10 days);
        infrared.harvestVault(address(123));
        vm.expectRevert(Errors.VaultNotSupported.selector);
    }

    function testHarvestVaultPremissionless() public {
        rewardsFactory.increaseRewardsForVault(stakingAsset, 100 ether);
        address user = address(123);
        stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

        vm.warp(1 days);
        vm.startPrank(address(1234));
        infrared.harvestVault(stakingAsset);

        vm.warp(1 days);
        vm.startPrank(address(12345));
        infrared.harvestVault(stakingAsset);

        vm.warp(1 days);
        vm.startPrank(address(123456));
    }

    function testGetRewardsCallbackIntoHarvestVault() public {
        rewardsFactory.increaseRewardsForVault(stakingAsset, 100 ether);
        address user = address(123);
        stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

        vm.warp(10 hours);
        uint256 vaultBalanceBefore = ibgt.balanceOf(address(infraredVault));
        infrared.harvestVault(stakingAsset);

        uint256 vaultBalanceAfter = ibgt.balanceOf(address(infraredVault));
        // assert that bgt balance and IBGT balance are equal
        assertEq(ibgt.totalSupply(), bgt.balanceOf(address(infrared)));

        vm.warp(1 days);
        // get user rewards
        (,,, uint256 rewardRateBefore,,) =
            infraredVault.rewardData(address(ibgt));
        vm.startPrank(user);
        infraredVault.getReward();
        vm.stopPrank();
        (,,, uint256 rewardRateAfter,,) =
            infraredVault.rewardData(address(ibgt));
        assertGt(rewardRateAfter, rewardRateBefore);
        assertGt(ibgt.totalSupply(), vaultBalanceAfter); // totalSupply > last harvestVault
    }

    /*//////////////////////////////////////////////////////////////
                Validator Rewards test
    //////////////////////////////////////////////////////////////*/

    /* TODO: fix
    function testAddingNewRewardToken() public {
        deal(address(ired), address(infrared), 100 ether);
        vm.startPrank(keeper);
        address[] memory rewardTokens = new address[](1);
        rewardTokens[0] = address(ired);

        address vault = address(infrared.ibgtVault());
        vm.expectEmit();
        emit IInfrared.RewardSupplied(vault, address(ired), 100 ether);
        infrared.harvestTokenRewards(rewardTokens);
        vm.stopPrank();

        address user = address(123);
        stakeInVault(vault, address(ibgt), user, 100 ether);

        vm.warp(10 days);

        uint256 vaultBalanceAfter = ired.balanceOf(vault);
        assertTrue(vaultBalanceAfter == 100 ether);
    }

    function testHarvestValidator() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abera"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        DataTypes.Token[] memory rewardTokens = new DataTypes.Token[](1);
        rewardTokens[0] =
            DataTypes.Token({tokenAddress: address(mockWbera), amount: 100});

        // Test for event ValidatorHarvested
        vm.prank(keeper);
        vm.expectEmit();
        emit IInfrared.ValidatorHarvested(keeper, validator, rewardTokens, 0);
        infrared.harvestValidator(validator);
        vm.stopPrank();

        // Test for event RewardSupplied
        vm.prank(keeper);
        vm.expectEmit();
        emit IInfrared.RewardSupplied(
            address(ibgtVault), address(mockWbera), 100
        );
        infrared.harvestValidator(validator);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 balance = mockWbera.balanceOf(address(ibgtVault));
        assertEq(balance, 200);
    }

    function testFailHarvestValidatorInvalidPool() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        vm.prank(keeper);
        infrared.harvestValidator(address(123));
        vm.expectRevert(
            abi.encodeWithSelector(Errors.InvalidValidator.selector)
        );
        vm.stopPrank();
    }

    function testFailHarvestValidatorUnauthorized() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        (address vault, address pool) = setupMockVault();

        try infrared.harvestValidator(validator) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Infrared: Unauthorized");
        }
    }

    function testHarvestMultipleRewardTokens() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        rewards[1] = Cosmos.Coin(100, "abera"); // 100 abera
        mockDistribution.setMockRewards(rewards);

        uint256 prevEthBalance = mockWbera.balanceOf(address(ibgtVault));

        vm.startPrank(keeper);
        infrared.harvestValidator(validator);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 balance = mockWbera.balanceOf(address(ibgtVault));
        assertEq(balance, 100);
        assertEq(mockWbera.balanceOf(address(ibgtVault)) - prevEthBalance, 100); // check that native balance was increased by abera amount
    }

    function testHarvestValidatorWithWhitelistedTokens() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abera"); // Whitelisted token
        rewards[1] = Cosmos.Coin(100, "nonWhitelistedToken"); // Non-whitelisted token
        address nonWhitelistedToken =
            address(new MockERC20("Other", "Other", 18));
        mockErc20Bank.setErc20AddressForCoinDenom(
            "nonWhitelistedToken", nonWhitelistedToken
        );

        mockDistribution.setMockRewards(rewards);

        vm.prank(keeper);
        vm.expectEmit(true, true, true, true);
        emit IInfrared.RewardTokenNotSupported(nonWhitelistedToken);
        infrared.harvestValidator(validator);
        vm.stopPrank();

        // Check that the vault has the correct balance for the whitelisted token
        uint256 balance = mockWbera.balanceOf(address(ibgtVault));
        assertEq(balance, 100, "Incorrect balance for whitelisted token");
    }

    function testRecoverERC20() public {
        // deploy a random token
        MockERC20 randomToken = new MockERC20("Random Token", "RND", 18);

        // deal and send in random token to vault
        uint256 amountTotal = 200 ether;
        deal(address(randomToken), address(infrared), amountTotal);
        // Test for event ERC20Recovered
        vm.prank(governance);
        vm.expectEmit();
        emit IInfrared.Recovered(governance, address(randomToken), amountTotal);
        infrared.recoverERC20(governance, address(randomToken), amountTotal);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 balance = randomToken.balanceOf(governance);
        assertEq(balance, amountTotal);

        // check that the vault has the correct balance
        balance = randomToken.balanceOf(address(infrared));
        assertEq(balance, 0);
    }
    */
}
