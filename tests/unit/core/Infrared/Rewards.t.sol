// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./Helper.sol";
import "@forge-std/console2.sol";
import "@core/Infrared.sol";
import "@interfaces/IInfrared.sol";
import "@interfaces/IMultiRewards.sol";
import {IRewardVault as IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IRewardVault.sol";

contract InfraredRewardsTest is Helper {
    /*//////////////////////////////////////////////////////////////
                Vault Rewards test
    //////////////////////////////////////////////////////////////*/

    function testharvestVaultSuccess() public {
        address[] memory rewardTokens = new address[](2);
        rewardTokens[0] = address(ibgt);
        rewardTokens[1] = address(ired);

        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));
        // InfraredVault vault = InfraredVault(
        //     address(infrared.registerVault(address(wbera), rewardTokens))
        // );
        InfraredVault vault = infraredVault;

        vm.startPrank(infraredGovernance);
        infrared.updateWhiteListedRewardTokens(address(wbera), true);
        vm.stopPrank();

        address user = address(10);
        vm.deal(address(user), 1000 ether);
        uint256 stakeAmount = 1000 ether;
        vm.startPrank(user);
        wbera.deposit{value: stakeAmount}();
        wbera.approve(address(vault), stakeAmount);
        vault.stake(stakeAmount);
        vm.stopPrank();

        address vaultWbera = factory.getVault(address(wbera));

        vm.startPrank(address(blockRewardController));
        bgt.mint(address(distributor), 100 ether);
        vm.stopPrank();

        vm.startPrank(address(distributor));
        bgt.approve(address(vaultWbera), 100 ether);
        IBerachainRewardsVault(vaultWbera).notifyRewardAmount(
            abi.encodePacked(bytes32("v0"), bytes16("")), 100 ether
        );
        vm.stopPrank();

        vm.warp(block.timestamp + 10 days);

        uint256 vaultBalanceBefore = ibgt.balanceOf(address(vault));

        vm.startPrank(address(vault));
        vault.rewardsVault().setOperator(address(infrared));
        vm.startPrank(keeper);
        vm.expectEmit();
        emit IInfrared.VaultHarvested(
            keeper, address(wbera), address(vault), 99999999999999999000
        );
        infrared.harvestVault(address(wbera));
        vm.stopPrank();

        uint256 vaultBalanceAfter = ibgt.balanceOf(address(vault));
        assertTrue(
            vaultBalanceAfter > vaultBalanceBefore,
            "Vault should have more IBGT after harvest"
        );
    }

    function testharvestVaultNotWhitelistedToken() public {
        MockERC20 mockAsset = new MockERC20("MockAsset", "MCK", 18);
        vm.expectRevert(abi.encodeWithSignature("VaultNotSupported()"));
        infrared.harvestVault(address(mockAsset));
    }

    function testrecoverERC20Success() public {
        uint256 recoverAmount = 10 ether;
        MockERC20 mockAsset = new MockERC20("MockAsset", "MCK", 18);
        mockAsset.mint(address(infrared), recoverAmount);

        address user = address(10);
        uint256 userBalanceBefore = mockAsset.balanceOf(user);

        vm.startPrank(address(infraredGovernance));
        vm.expectEmit();
        emit IInfrared.Recovered(
            infraredGovernance, address(mockAsset), recoverAmount
        );
        infrared.recoverERC20(user, address(mockAsset), recoverAmount);
        vm.stopPrank();

        uint256 userBalanceAfter = mockAsset.balanceOf(user);
        assertTrue(
            userBalanceAfter == userBalanceBefore + recoverAmount,
            "User should have more mockAsset after recovery"
        );
    }

    function testrecoverERC20ZeroAddressRecipient() public {
        MockERC20 mockAsset = new MockERC20("MockAsset", "MCK", 18);

        vm.startPrank(address(infraredGovernance));
        vm.expectRevert(abi.encodeWithSignature("ZeroAddress()"));
        infrared.recoverERC20(address(0), address(mockAsset), 10 ether);
        vm.stopPrank();
    }

    function testrecoverERC20ZeroAddressToken() public {
        address user = address(10);

        vm.startPrank(address(infraredGovernance));
        vm.expectRevert(abi.encodeWithSignature("ZeroAddress()"));
        infrared.recoverERC20(user, address(0), 10 ether);
        vm.stopPrank();
    }

    function testrecoverERC20ZeroAmount() public {
        MockERC20 mockAsset = new MockERC20("MockAsset", "MCK", 18);
        address user = address(10);

        vm.startPrank(address(infraredGovernance));
        vm.expectRevert(abi.encodeWithSignature("ZeroAmount()"));
        infrared.recoverERC20(user, address(mockAsset), 0);
        vm.stopPrank();
    }

    function testrecoverERC20NotGovernor() public {
        MockERC20 mockAsset = new MockERC20("MockAsset", "MCK", 18);
        address user = address(10);

        vm.startPrank(address(user));
        vm.expectRevert(
            abi.encodeWithSignature(
                "AccessControlUnauthorizedAccount(address,bytes32)",
                user,
                infrared.GOVERNANCE_ROLE()
            )
        );
        infrared.recoverERC20(user, address(mockAsset), 10 ether);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                Incentives test
    //////////////////////////////////////////////////////////////*/

    event RewardStored(address indexed rewardsToken, uint256 rewardsDuration);
    event RewardAdded(address indexed rewardsToken, uint256 reward);

    function testAddRewardSuccess() public {
        // Setup new reward token
        MockERC20 newRewardToken = new MockERC20("NewReward", "NRT", 18);
        uint256 rewardsDuration = 7 days;

        vm.startPrank(infraredGovernance);
        // Whitelist the new reward token first
        infrared.updateWhiteListedRewardTokens(address(newRewardToken), true);

        // The event is emitted from the vault contract
        vm.expectEmit();
        emit IMultiRewards.RewardStored(
            address(newRewardToken), rewardsDuration
        );
        infrared.addReward(
            address(wbera), address(newRewardToken), rewardsDuration
        );
        vm.stopPrank();

        // Verify reward was added by checking reward duration
        (, uint256 duration,,,,) =
            infraredVault.rewardData(address(newRewardToken));
        assertEq(duration, rewardsDuration, "Reward duration should match");
    }

    function testAddRewardFailsWithNonWhitelistedReward() public {
        vm.expectRevert(abi.encodeWithSignature("RewardTokenNotWhitelisted()"));
        infrared.addReward(address(wbera), address(ired), 7 days);
    }

    function testAddRewardFailsWithZeroDuration() public {
        vm.expectRevert(abi.encodeWithSignature("ZeroAmount()"));
        infrared.addReward(address(wbera), address(ired), 0);
    }

    function testAddRewardFailsWithNoVault() public {
        infrared.updateWhiteListedRewardTokens(address(ired), true);
        vm.expectRevert(abi.encodeWithSignature("NoRewardsVault()"));
        infrared.addReward(address(1), address(ired), 7 days);
    }

    function testAddRewardFailsWithNotAuthorized() public {
        vm.startPrank(address(1));
        vm.expectRevert(
            abi.encodeWithSignature(
                "AccessControlUnauthorizedAccount(address,bytes32)",
                address(1),
                infrared.GOVERNANCE_ROLE()
            )
        );
        infrared.addReward(address(wbera), address(ired), 7 days);
    }

    function testAddIncentivesSuccess() public {
        uint256 rewardAmount = 100 ether;
        MockERC20 newRewardToken = new MockERC20("NewReward", "NRT", 18);

        vm.startPrank(infraredGovernance);
        infrared.updateWhiteListedRewardTokens(address(newRewardToken), true);
        infrared.addReward(address(wbera), address(newRewardToken), 7 days);
        vm.stopPrank();

        // Deal tokens to admin (test contract)
        deal(address(newRewardToken), address(this), rewardAmount);

        // Approve the Infrared contract to spend tokens
        newRewardToken.approve(address(infrared), rewardAmount);

        // Expect the event from the vault
        vm.expectEmit(true, true, true, true, address(infraredVault));
        emit RewardAdded(address(newRewardToken), rewardAmount);

        // Call addIncentives
        infrared.addIncentives(
            address(wbera), address(newRewardToken), rewardAmount
        );

        // Verify rewards were added
        (,,, uint256 rewardRate,,) =
            infraredVault.rewardData(address(newRewardToken));
        assertTrue(rewardRate > 0, "Reward rate should be set");
    }

    function testAddIncentivesFailsWithZeroAmount() public {
        MockERC20 newRewardToken = new MockERC20("NewReward", "NRT", 18);

        vm.startPrank(infraredGovernance);
        infrared.updateWhiteListedRewardTokens(address(newRewardToken), true);
        infrared.addReward(address(wbera), address(newRewardToken), 7 days);
        vm.stopPrank();

        vm.expectRevert(abi.encodeWithSignature("ZeroAmount()"));
        infrared.addIncentives(address(wbera), address(newRewardToken), 0);
    }

    function testAddIncentivesFailsWithInvalidVault() public {
        vm.expectRevert(abi.encodeWithSignature("NoRewardsVault()"));
        infrared.addIncentives(address(1), address(ibgt), 100 ether);
    }

    function testAddIncentivesFailsWithNonWhitelistedReward() public {
        MockERC20 newRewardToken = new MockERC20("NewReward", "NRT", 18);

        vm.expectRevert(abi.encodeWithSignature("RewardTokenNotWhitelisted()"));
        infrared.addIncentives(
            address(wbera), address(newRewardToken), 100 ether
        );
    }

    // function testHarvestVault() public {
    //      NOTE added in Infrared.t.sol
    //     // factory.increaseRewardsForVault(stakingAsset, 100 ether);
    //     address user = address(123);
    //     stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

    //     vm.warp(10 days);
    //     uint256 vaultBalanceBefore = ibgt.balanceOf(address(infraredVault));
    //     vm.expectEmit();
    //     emit IInfrared.VaultHarvested(
    //         address(this),
    //         stakingAsset,
    //         address(infraredVault),
    //         1099999999999999958400
    //     );
    //     infrared.harvestVault(stakingAsset);

    //     uint256 vaultBalanceAfter = ibgt.balanceOf(address(infraredVault));
    //     assertEq(vaultBalanceAfter, vaultBalanceBefore + 1099999999999999958400); // adjust for rounding error
    //     // assert that bgt balance and IBGT balance are equal
    //     assertEq(ibgt.totalSupply(), bgt.balanceOf(address(infrared)));
    // }

    // function testHarvestVaultWithProtocolFees() public {
    //     NOTE added in Infrared.t.sol
    //     // factory.increaseRewardsForVault(stakingAsset, 100 ether);
    //     address user = address(123);
    //     stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

    //     // TODO: include voting fees distribution
    //     vm.startPrank(infraredGovernance);
    //     infrared.updateFee(IInfrared.FeeType.HarvestVaultFeeRate, 3e5);
    //     infrared.updateFee(IInfrared.FeeType.HarvestVaultProtocolRate, 1e6);
    //     infrared.updateIredMintRate(2e6); // 2x
    //     vm.stopPrank();

    //     vm.warp(10 days);
    //     vm.startPrank(keeper);
    //     uint256 vaultBalanceBefore = ibgt.balanceOf(address(infraredVault));
    //     uint256 vaultIredBalanceBefore = ired.balanceOf(address(infraredVault));
    //     uint256 protocolFeeAmountBefore =
    //         infrared.protocolFeeAmounts(address(ibgt));
    //     uint256 protocolFeeAmountIredBefore =
    //         infrared.protocolFeeAmounts(address(ired));

    //     uint256 amt = 1099999999999999958400;
    //     uint256 protocolFees = (amt * 3e5) / 1e6;
    //     uint256 bgtAmt = amt - protocolFees;

    //     uint256 iredAmt = 2 * amt;

    //     vm.expectEmit();
    //     emit IInfrared.VaultHarvested(
    //         keeper, stakingAsset, address(infraredVault), amt
    //     );
    //     emit IInfrared.IBGTSupplied(address(infraredVault), bgtAmt, iredAmt);
    //     infrared.harvestVault(stakingAsset);
    //     vm.stopPrank();

    //     uint256 vaultBalanceAfter = ibgt.balanceOf(address(infraredVault));
    //     assertEq(vaultBalanceAfter, vaultBalanceBefore + bgtAmt); // adjust for rounding error
    //     // assert that bgt balance and IBGT balance are equal
    //     assertEq(ibgt.totalSupply(), bgt.balanceOf(address(infrared)));
    //     assertEq(
    //         infrared.protocolFeeAmounts(address(ibgt)),
    //         protocolFeeAmountBefore + protocolFees
    //     );

    //     uint256 vaultIredBalanceAfter = ired.balanceOf(address(infraredVault));
    //     assertEq(vaultIredBalanceAfter, vaultIredBalanceBefore + iredAmt);
    //     assertEq(
    //         infrared.protocolFeeAmounts(address(ired)),
    //         protocolFeeAmountIredBefore
    //     );
    // }

    /*
    function testFailHarvestVaultInvalidPool() public {
        // factory.increaseRewardsForVault(stakingAsset, 100 ether);
        address user = address(123);
        stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

        vm.warp(10 days);
        infrared.harvestVault(address(123));
        vm.expectRevert(Errors.VaultNotSupported.selector);
    }

    function testHarvestVaultPremissionless() public {
        // factory.increaseRewardsForVault(stakingAsset, 100 ether);
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
    */

    // function testGetRewardsCallbackIntoHarvestVault() public {
    // NOTE added in Infrared.t.sol
    // // factory.increaseRewardsForVault(stakingAsset, 100 ether);
    // address user = address(123);
    // stakeInVault(address(infraredVault), stakingAsset, user, 100 ether);

    // vm.warp(10 hours);
    // uint256 vaultBalanceBefore = ibgt.balanceOf(address(infraredVault));
    // infrared.harvestVault(stakingAsset);

    // uint256 vaultBalanceAfter = ibgt.balanceOf(address(infraredVault));
    // // assert that bgt balance and IBGT balance are equal
    // assertEq(ibgt.totalSupply(), bgt.balanceOf(address(infrared)));

    // vm.warp(1 days);
    // // get user rewards
    // (,,, uint256 rewardRateBefore,,) =
    //     infraredVault.rewardData(address(ibgt));
    // vm.startPrank(user);
    // infraredVault.getReward();
    // vm.stopPrank();
    // (,,, uint256 rewardRateAfter,,) =
    //     infraredVault.rewardData(address(ibgt));
    // assertGt(rewardRateAfter, rewardRateBefore);
    // assertGt(ibgt.totalSupply(), vaultBalanceAfter); // totalSupply > last harvestVault
    // }

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
