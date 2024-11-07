// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import "forge-std/Test.sol";

import {InfraredVault, Errors, MultiRewards} from "@core/InfraredVault.sol";
import {IMultiRewards} from "@interfaces/IMultiRewards.sol";

import {IBGT} from "@core/IBGT.sol";

import {IInfrared} from "@interfaces/IInfrared.sol";

import "@mocks/MockERC20.sol";
import "@mocks/MockInfrared.sol";
import "@berachain/pol/rewards/RewardVaultFactory.sol";
import {IRewardVault as IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IRewardVault.sol";
import "@mocks/MockBerachainRewardsVaultFactory.sol";
import "@berachain/../test/mock/pol/MockRewardVault.sol";

import {stdStorage, StdStorage} from "forge-std/Test.sol";

import {Helper} from "./Infrared/Helper.sol";

contract InfraredVaultTest is Helper {
    // WBERA public stakingToken;
    // MockERC20 public rewardsToken;
    IBGT public rewardsToken;

    // MockERC20 public bgt;
    MockERC20 public stakingToken;
    MockBerachainRewardsVaultFactory public rewardsFactory;
    // MockRewardVault public rewardsVault;

    // MockERC20 public rewardsToken;
    // address[] rewardTokens;

    // address constant admin = address(1);
    address constant pool = address(3);
    address constant user = address(4);
    address constant user2 = address(5);

    IBerachainRewardsVault public rewardsVault;

    function setUp() public override {
        super.setUp();

        rewardsVault = infraredVault.rewardsVault();

        rewardsToken = ibgt;
        admin = address(1);
        // stakingToken = wbera;
        // rewardsToken = address(ibgt);
    }

    /*//////////////////////////////////////////////////////////////
                        Constructor
    //////////////////////////////////////////////////////////////*/

    // function testSuccessfulDeployment() public {
    //     NOTE: done in InfraredTest.t.sol or Helper.t.sol
    //     infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

    //     // Act: Deploy the contract with valid parameters
    //     // vm.startPrankprank(infrared);

    //     // Assert: Check if the contract is deployed successfully
    //     assertTrue(
    //         address(infraredVault) != address(0),
    //         "Contract should be successfully deployed"
    //     );

    //     assertEq(infraredVault.rewardTokens(0), rewardTokens[0]);

    //     (address _distributor, uint256 _duration,,,,) =
    //         infraredVault.rewardData(rewardTokens[0]);
    //     // assertEq(_distributor, infrared);
    //     // assertEq(_duration, 1 days);

    //     // check immutables set
    //     // assertEq(infraredVault.infrared(), infrared);
    //     // assertEq(infraredVault.stakingToken(), stakingAsset);

    //     // // check withdraw address set on rewards, distribution modules to infrared
    //     // assertEq(infraredVault.rewardsVault().operator(address(infraredVault)), infrared);
    // }

    // function testSuccessfulDeploymentCreatesRewardsVault() public {
    //     NOTE done in InfraredTest.t.sol or Helper.t.sol
    //     assertEq(factory.getVault(address(rewardsToken)), address(0));

    //     // Act: Deploy the contract with valid parameters
    //     // vm.startPrank(address(infrared));

    //     // Assert: Check if the contract is deployed successfully
    //     assertTrue(
    //         address(infraredVault) != address(0),
    //         "Contract should be successfully deployed"
    //     );

    //     assertEq(infraredVault.rewardTokens(0), rewardTokens[0]);

    //     (address _distributor, uint256 _duration,,,,) =
    //         infraredVault.rewardData(rewardTokens[0]);
    //     assertEq(_distributor, address(infrared));
    //     assertEq(_duration, 1 days);

    //     // check immutables set
    //     assertEq(infraredVault.infrared(), address(infrared));

    //     // check rewards infraredVault created
    //     address _rv = factory.getVault(address(rewardsToken));
    //     assertTrue(_rv != address(0), "Rewards infraredVault should have been created");
    //     assertEq(address(infraredVault.rewardsVault()), _rv);
    //     // assertEq(infraredVault.stakingToken(), address(stakingToken));

    //     // // check withdraw address set on rewards, distribution modules to infrared
    //     assertEq(IRewardVault(_rv).operator(address(infraredVault)), address(infrared));
    // }

    function testRevertWithZeroAddressesInConstructor() public {
        // Test each parameter with zero address
        address[] memory testAddresses = new address[](8);
        testAddresses[0] = address(0); // Zero admin address
        testAddresses[1] = address(wbera);
        testAddresses[2] = address(2); // Infrared address
        testAddresses[3] = address(3); // Pool address
        testAddresses[4] = address(factory);
        testAddresses[5] = address(factory);
        testAddresses[6] = address(4); // Zero admin address
        testAddresses[7] = address(5); // Zero admin address

        for (uint256 i = 0; i < testAddresses.length; i++) {
            address[] memory constructorParams = new address[](8);
            for (uint256 j = 0; j < constructorParams.length; j++) {
                constructorParams[j] = (i == j) ? address(0) : testAddresses[j];
            }
            // Act & Assert
            vm.expectRevert(Errors.ZeroAddress.selector);
            new InfraredVault(
                constructorParams[0], // Staking Token
                rewardTokens,
                1 days
            );
        }
    }

    /*//////////////////////////////////////////////////////////////
                        harvest
    //////////////////////////////////////////////////////////////*/

    event Harvest(address _sender, address _pool, uint256 _bgtAmount);

    // function testSuccessfulGetRewardByOperator() public {
    //     // NOTE  MOVED TO InfraredTest.t.sol
    //     // deal some reward tokens to the rewardsVault
    //     ibgt.mint(address(rewardsVault), 5000 ether);
    //     ired.mint(address(rewardsVault), 5000 ether);

    //     uint256 bgtBalanceBefore = ibgt.balanceOf(address(infrared));

    //     uint256 amt = 100 ether;
    //     // rewardsFactory.increaseRewardsForVault(address(stakingToken), amt);

    //     // TODO:  implement staking of staking token into InfraredVault\
    //     // deal(address(wbera), user, 1000 ether);
    //     vm.deal(user, 1000 ether);
    //     vm.startPrank(user);
    //     wbera.deposit{value: 1000 ether}();
    //     // vm.startPrank(user);
    //     wbera.approve(address(infraredVault), 1000 ether);
    //     infraredVault.stake(1000 ether);
    //     vm.stopPrank();

    //     vm.startPrank(address(infrared));
    //     // vm.expectEmit();
    //     // emit MockBerachainRewardsVault.RewardsClaimedByOperator(
    //     //     infrared, address(infraredVault), 99999999999999964000
    //     // );

    //     skip(10 days);
    //     uint256 rewardsBalance = rewardsVault.balanceOf(address(infraredVault));
    //     console.log("rewardsBalance", rewardsBalance);
    //     rewardsVault.getReward(address(infraredVault), address(infrared));
    //     vm.stopPrank();

    //     uint256 bgtBalanceAfter = ibgt.balanceOf(address(infrared));
    //     assertTrue(bgtBalanceAfter > bgtBalanceBefore); //  adjust for rounding percision
    // }

    // function testRevertNotInfraredForHarvest() public {
    //     vm.expectRevert(
    //         abi.encodeWithSelector(Errors.Unauthorized.selector, address(this))
    //     );
    //     infraredVault.harvest();
    // }

    /*//////////////////////////////////////////////////////////////
                        addReward
    //////////////////////////////////////////////////////////////*/

    event RewardStored(address rewardsToken, uint256 rewardsDuration);

    // function testSuccessfulRewardAddition() public {
    //     uint256 rewardsDuration = 30 days;
    //     uint256 rewardAmount = 1000 ether;
    //     TODO use mock here instead of already added rewardsToken

    //     vm.startPrank(address(infrared));

    //     vm.expectEmit();
    //     emit RewardStored(address(rewardsToken), rewardsDuration);

    //     // Add reward
    //     infraredVault.addReward(address(0x3), rewardsDuration);

    //     // check reward token added to list
    //     assertEq(
    //         infraredVault.rewardTokens(rewardTokens.length),
    //         address(0x3)
    //     );

    //     // check reward data updated for reward token
    //     (address _rewardsDistributor, uint256 _rewardsDuration,,,,) =
    //         getRewardData(address(infraredVault), address(rewardsToken));
    //     assertEq(_rewardsDistributor, infraredVault.infrared());
    //     assertEq(_rewardsDuration, rewardsDuration);

    //     deal(address(0x3), address(infrared), rewardAmount);
    //     rewardsToken.approve(address(infraredVault), rewardAmount);

    //     // Notify reward amount to set periodFinish
    //     infraredVault.notifyRewardAmount(address(rewardsToken), rewardAmount);

    //     (,, uint256 periodFinish,,,) =
    //         getRewardData(address(infraredVault), address(rewardsToken));
    //     assertTrue(periodFinish > block.timestamp, "Reward addition failed");
    // }

    function testRevertWithZeroAddressForTokenAddReward() public {
        uint256 rewardsDuration = 30 days;

        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.addReward(address(0), rewardsDuration);
        vm.stopPrank();
    }

    function testRevertWithZeroDurationAddReward() public {
        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAmount.selector);
        infraredVault.addReward(address(0x3), 0);
        vm.stopPrank();
    }

    function testAccessControlAddReward() public {
        uint256 rewardsDuration = 30 days;

        vm.expectRevert(
            abi.encodeWithSelector(Errors.Unauthorized.selector, address(this))
        );
        infraredVault.addReward(address(0x3), rewardsDuration);
    }

    function testMaxRewardTokenAddReward() public {
        uint256 rewardsDuration = 30 days;

        vm.startPrank(address(infrared));
        for (uint160 i = 0; i < 8; i++) {
            infraredVault.addReward(address(i + 900), rewardsDuration);
        }
        // Now reached max reward tokens
        vm.expectRevert(abi.encodeWithSignature("MaxNumberOfRewards()"));
        infraredVault.addReward(address(1000), rewardsDuration);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        notifyRewardAmount
    //////////////////////////////////////////////////////////////*/

    event RewardAdded(uint256 amount);

    // function testSuccessfulNotification() public {
    //     uint256 rewardAmount = 1000 ether;
    //     TODO use mock here instead of already added rewardsToken

    //     vm.startPrank(address(infrared));
    //     infraredVault.addReward(address(0x3), 30 days);

    //     deal(address(rewardsToken), address(infrared), rewardAmount);
    //     rewardsToken.approve(address(infraredVault), rewardAmount);

    //     vm.expectEmit();
    //     emit RewardAdded(rewardAmount);

    //     infraredVault.notifyRewardAmount(address(rewardsToken), rewardAmount);

    //     (
    //         ,
    //         ,
    //         uint256 periodFinish,
    //         uint256 rewardRate,
    //         uint256 lastUpdateTime,
    //         uint256 rewardPerTokenStored
    //     ) = getRewardData(address(infraredVault), address(rewardsToken));
    //     assertTrue(periodFinish > block.timestamp, "Reward notification failed");

    //     // check reward data updated on notify
    //     assertEq(rewardRate, rewardAmount / (30 days));
    //     assertEq(lastUpdateTime, block.timestamp);
    //     assertEq(periodFinish, block.timestamp + 30 days);
    //     assertEq(rewardPerTokenStored, 0);

    //     // check balance transfer
    //     assertEq(rewardsToken.balanceOf(address(infraredVault)), rewardAmount);
    //     assertEq(rewardsToken.balanceOf(address(infrared)), 0);
    // }

    function testRevertWithZeroAddressForToken() public {
        uint256 rewardAmount = 1000 ether;

        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.notifyRewardAmount(address(0), rewardAmount);
        vm.stopPrank();
    }

    function testRevertWithZeroAmount() public {
        vm.startPrank(address(infrared));
        infraredVault.addReward(address(0x3), 30 days);

        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAmount.selector);
        infraredVault.notifyRewardAmount(address(rewardsToken), 0);
        vm.stopPrank();
    }

    function testAccessControlNotifyRewardAmount() public {
        uint256 rewardAmount = 1000 ether;

        vm.startPrank(address(infrared));
        infraredVault.addReward(address(0x3), 30 days);
        vm.stopPrank();

        vm.expectRevert(
            abi.encodeWithSignature("Unauthorized(address)", address(this))
        );
        infraredVault.notifyRewardAmount(address(0x3), rewardAmount);
    }

    function testRewardTokenAlreadyAdded() public {
        uint256 rewardAmount = 1000 ether;

        vm.startPrank(address(infrared));
        vm.expectRevert(bytes(""));
        infraredVault.addReward(address(rewardsToken), 30 days);
    }

    /*//////////////////////////////////////////////////////////////
                        recoverERC20
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulRecoverERC20() public {
        // deploy a random token
        MockERC20 randomToken = new MockERC20("Random Token", "RND", 18);

        // deal and send in random token to infraredVault
        uint256 amountTotal = 200 ether;
        deal(address(randomToken), address(infraredVault), amountTotal);

        // recover random token with admin
        vm.startPrank(address(infrared));
        uint256 amount = 100 ether;
        infraredVault.recoverERC20(user2, address(randomToken), amount);
        vm.stopPrank();

        // check amount sent to user
        assertEq(randomToken.balanceOf(user2), amount);
    }

    function testRevertWithAmountGreaterThanBalanceRecoverERC20() public {
        // deploy a random token
        MockERC20 randomToken = new MockERC20("Random Token", "RND", 18);

        // deal and send in random token to infraredVault
        uint256 amountTotal = 200 ether;
        deal(address(randomToken), address(infraredVault), amountTotal);

        // check cannot recover random token with amount greater than balance
        vm.startPrank(address(infrared));
        vm.expectRevert();
        infraredVault.recoverERC20(user2, address(randomToken), amountTotal + 1);
        vm.stopPrank();
    }

    function testRevertWithZeroAddressToRecoverERC20() public {
        // deploy a random token
        MockERC20 randomToken = new MockERC20("Random Token", "RND", 18);

        // deal and send in random token to infraredVault
        uint256 amount = 200 ether;
        deal(address(randomToken), address(infraredVault), amount);

        // check cannot recover random token to zero address
        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.recoverERC20(address(0), address(randomToken), amount);
        vm.stopPrank();
    }

    function testRevertWithZeroAddressTokenRecoverERC20() public {
        // deploy a random token
        MockERC20 randomToken = new MockERC20("Random Token", "RND", 18);

        // deal and send in random token to infraredVault
        uint256 amount = 200 ether;
        deal(address(randomToken), address(infraredVault), amount);

        // check cannot recover random token zero
        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.recoverERC20(user2, address(0), amount);
        vm.stopPrank();
    }

    function testRevertWithZeroAmountRecoverERC20() public {
        // deploy a random token
        MockERC20 randomToken = new MockERC20("Random Token", "RND", 18);

        // deal and send in random token to infraredVault
        uint256 amount = 200 ether;
        deal(address(randomToken), address(infraredVault), amount);

        // check cannot recover random token with zero amount
        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAmount.selector);
        infraredVault.recoverERC20(user2, address(randomToken), 0);
        vm.stopPrank();
    }

    function testRevertWithTokenStakingTokenRecoverERC20() public {
        uint256 stakeAmount = 100 ether;
        deal(address(wbera), user, stakeAmount);

        // User approves the infraredVault to spend their tokens
        vm.startPrank(user);
        wbera.approve(address(infraredVault), stakeAmount);

        // User stakes tokens into the infraredVault
        infraredVault.stake(stakeAmount);
        vm.stopPrank();

        // check cannot recover staking token
        vm.startPrank(address(infrared));
        vm.expectRevert("Cannot withdraw staking token");
        infraredVault.recoverERC20(user2, address(wbera), stakeAmount);
        vm.stopPrank();
    }

    function testRevertWithTokenRewardTokenRecoverERC20() public {
        // Setup reward token in the infraredVault and mint rewards
        vm.startPrank(address(infrared));
        uint256 rewardsAmount = 100 ether;
        infraredVault.addReward(address(0x3), 86400);
        rewardsToken.mint(address(infrared), rewardsAmount);
        rewardsToken.approve(address(infraredVault), rewardsAmount);
        infraredVault.notifyRewardAmount(address(rewardsToken), rewardsAmount);
        vm.stopPrank();

        // check cannot recover reward token
        (,,,, uint256 lastUpdateTime,) =
            infraredVault.rewardData(address(rewardsToken));
        assertTrue(lastUpdateTime != 0);

        vm.startPrank(address(infrared));
        vm.expectRevert("Cannot withdraw reward token");
        infraredVault.recoverERC20(user2, address(rewardsToken), rewardsAmount);
        vm.stopPrank();
    }

    function testAccessControlRecoverERC20() public {
        // deploy a random token
        address unauthorizedUser = address(3);
        MockERC20 randomToken = new MockERC20("Random Token", "RND", 18);

        // deal and send in random token to infraredVault
        uint256 amount = 200 ether;
        deal(address(randomToken), address(infraredVault), amount);

        // check unauthorized user cannot recover
        vm.startPrank(unauthorizedUser);
        vm.expectRevert();
        infraredVault.recoverERC20(user, address(randomToken), amount);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        updateRewardsDuration
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulDurationUpdate() public {
        uint256 newDuration = 7 days;

        vm.startPrank(address(infrared));
        infraredVault.addReward(address(0x3), newDuration); // Setup reward token
        vm.stopPrank();
        vm.startPrank(address(infrared));
        vm.expectEmit();
        emit IMultiRewards.RewardsDurationUpdated(
            address(rewardsToken), newDuration
        );
        infraredVault.updateRewardsDuration(address(rewardsToken), newDuration);
        vm.stopPrank();

        // Verify that the rewards duration was updated correctly
        (, uint256 actualDuration,,,,) =
            getRewardData(address(infraredVault), address(rewardsToken));
        assertEq(
            actualDuration,
            newDuration,
            "Rewards duration not updated correctly"
        );
    }

    function testRevertWithZeroAddressForTokenUpdateRewardsDuration() public {
        uint256 newDuration = 7 days;

        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.updateRewardsDuration(address(0), newDuration);
        vm.stopPrank();
    }

    function testRevertWithZeroDurationUpdateRewardsDuration() public {
        vm.startPrank(address(infrared));
        infraredVault.addReward(address(0x3), 1 days); // Setup reward token
        vm.stopPrank();
        vm.startPrank(address(infrared));
        vm.expectRevert(Errors.ZeroAmount.selector);
        infraredVault.updateRewardsDuration(address(rewardsToken), 0);
        vm.stopPrank();
    }

    function testAccessControlUpdateRewardsDuration() public {
        uint256 newDuration = 7 days;

        vm.startPrank(address(infrared));
        infraredVault.addReward(address(0x3), newDuration); // Setup reward token
        vm.stopPrank();

        vm.startPrank(address(5)); // Non-admin address
        vm.expectRevert(
            abi.encodeWithSelector(Errors.Unauthorized.selector, address(5))
        );
        infraredVault.updateRewardsDuration(address(rewardsToken), newDuration);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        togglePause
    //////////////////////////////////////////////////////////////*/

    event Paused(address account);

    function testSuccessfulPause() public {
        // check not paused
        assertTrue(!infraredVault.paused());

        // check paused event emitted
        vm.expectEmit();
        emit Paused(address(infrared));

        // pause infraredVault
        vm.startPrank(address(infrared));
        infraredVault.togglePause();
        vm.stopPrank();

        // check now paused
        assertTrue(infraredVault.paused());
    }

    event Unpaused(address account);

    function testSuccessfulUnpause() public {
        // set up so paused
        vm.startPrank(address(infrared));
        infraredVault.togglePause();
        vm.stopPrank();
        assertTrue(infraredVault.paused());

        // check unpaused event emitted
        vm.expectEmit();
        emit Unpaused(address(infrared));

        // unpause infraredVault
        vm.startPrank(address(infrared));
        infraredVault.togglePause();
        vm.stopPrank();

        // check now unpaused
        assertTrue(!infraredVault.paused());
    }

    function testAccessControlPause() public {
        address unauthorizedUser = address(4);
        vm.startPrank(unauthorizedUser);
        vm.expectRevert();
        infraredVault.togglePause();
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        stake
    //////////////////////////////////////////////////////////////*/

    event Staked(address indexed user, uint256 amount);

    function testSuccessfulStake() public {
        uint256 stakeAmount = 100 ether;
        deal(user, stakeAmount);
        vm.startPrank(user);
        wbera.deposit{value: stakeAmount}();

        console.log("STAKING TOKEN IS: ", address(infraredVault.stakingToken()));
        console.log("WBERA IS: ", address(wbera));

        // User approves the infraredVault to spend their tokens
        wbera.approve(address(infraredVault), stakeAmount);

        // check stake event emitted
        emit Staked(user, stakeAmount);

        // User stakes tokens into the infraredVault
        infraredVault.stake(stakeAmount);

        // Check user's balance in the infraredVault
        uint256 userBalance = infraredVault.balanceOf(user);
        assertEq(userBalance, stakeAmount, "User balance should be updated");

        // Check total supply in the infraredVault
        uint256 totalSupply = infraredVault.totalSupply();
        assertEq(totalSupply, stakeAmount, "Total supply should be updated");

        // Check staking token transferred to berachain rewards infraredVault
        assertEq(
            wbera.balanceOf(address(infraredVault.rewardsVault())), stakeAmount
        );
        assertEq(wbera.balanceOf(address(infraredVault)), 0);
        assertEq(wbera.balanceOf(user), 0);

        vm.stopPrank();
    }

    function testStakeWithZeroAmount() public {
        deal(address(wbera), user, 0);
        vm.startPrank(user);
        wbera.approve(address(infraredVault), 0);

        vm.expectRevert("Cannot stake 0");
        infraredVault.stake(0);
        vm.stopPrank();
    }

    function testStakeMoreThanUsersBalance() public {
        uint256 stakeAmount = 2000 ether; // More than user's balance

        deal(address(wbera), user, stakeAmount - 1000 ether);
        vm.startPrank(user);
        wbera.approve(address(infraredVault), stakeAmount);

        vm.expectRevert(); // Expect revert due to insufficient balance
        infraredVault.stake(stakeAmount);
        vm.stopPrank();
    }

    // Assuming there's no access control for staking, otherwise:
    function testAccessControlOnStake() public {
        address unauthorizedUser = address(3);
        uint256 stakeAmount = 100 ether;
        deal(address(wbera), user, stakeAmount);

        // User approves the infraredVault to spend their tokens
        vm.startPrank(unauthorizedUser);
        wbera.approve(address(infraredVault), stakeAmount);

        vm.expectRevert();
        infraredVault.stake(stakeAmount);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        withdraw
    //////////////////////////////////////////////////////////////*/

    event Withdrawn(address indexed user, uint256 amount);

    function testSuccessfulWithdraw() public {
        deal(user2, 500 ether);
        vm.startPrank(user2);
        wbera.deposit{value: 500 ether}();
        // User stakes tokens
        wbera.approve(address(infraredVault), 500 ether);
        infraredVault.stake(500 ether);
        vm.stopPrank();

        uint256 withdrawAmount = 500 ether;

        // check withdrawn event emitted
        vm.expectEmit();
        emit Withdrawn(user2, withdrawAmount);

        vm.startPrank(user2);
        infraredVault.withdraw(withdrawAmount);
        vm.stopPrank();

        // Check user's balance in the infraredVault after withdrawal
        uint256 userBalance = infraredVault.balanceOf(user2);
        assertEq(
            userBalance, 0, "User balance should decrease after withdrawal"
        );

        // Check total supply in the infraredVault after withdrawal
        uint256 totalSupply = infraredVault.totalSupply();
        assertEq(
            totalSupply, 0, "Total supply should decrease after withdrawal"
        );

        // Check user's token balance
        uint256 userTokenBalance = wbera.balanceOf(user2);
        assertEq(
            userTokenBalance,
            500 ether,
            "User should receive the withdrawn tokens"
        );
    }

    function testWithdrawMoreThanStaked() public {
        // User stakes tokens
        deal(user2, 500 ether);
        vm.startPrank(user2);
        wbera.deposit{value: 500 ether}();
        wbera.approve(address(infraredVault), 500 ether);
        infraredVault.stake(500 ether);
        vm.stopPrank();

        uint256 withdrawAmount = 600 ether; // More than staked amount

        vm.startPrank(user2);
        vm.expectRevert(); // Expect revert due to insufficient balance
        infraredVault.withdraw(withdrawAmount);
        vm.stopPrank();
    }

    function testWithdrawZeroAmount() public {
        // User stakes tokens
        deal(user2, 500 ether);
        vm.startPrank(user2);
        wbera.deposit{value: 500 ether}();
        wbera.approve(address(infraredVault), 500 ether);
        infraredVault.stake(500 ether);
        vm.stopPrank();

        vm.startPrank(user2);
        vm.expectRevert("Cannot withdraw 0");
        infraredVault.withdraw(0);
        vm.stopPrank();
    }

    function testWithdrawAsDifferentUser() public {
        // User stakes tokens
        deal(user2, 500 ether);
        vm.startPrank(user2);
        wbera.deposit{value: 500 ether}();
        wbera.approve(address(infraredVault), 500 ether);
        infraredVault.stake(500 ether);
        vm.stopPrank();

        address otherUser = address(6);
        uint256 withdrawAmount = 100 ether;

        vm.startPrank(otherUser);
        // Assuming otherUser hasn't staked anything
        vm.expectRevert(); // Expect revert due to insufficient balance
        infraredVault.withdraw(withdrawAmount);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        getReward
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulGetReward() public {
        uint256 rewardsAmount = 100 ether;
        uint256 rewardsDuration = 30 days;
        setUpGetReward(rewardsAmount, rewardsDuration);

        vm.startPrank(user);
        // Manipulate time to simulate the passage of the reward duration
        skip(rewardsDuration + 100 minutes);
        infraredVault.getReward();

        vm.stopPrank();

        // Check user's rewards token balance
        uint256 userRewardsBalance = rewardsToken.balanceOf(user);
        assertAlmostEqual(
            userRewardsBalance,
            rewardsAmount,
            tolerance,
            "User should receive the rewards within tolerance"
        );
    }

    function testGetRewardWhenNoRewards() public {
        uint256 rewardsAmount = 100 ether;
        uint256 rewardsDuration = 30 days;
        setUpGetReward(rewardsAmount, rewardsDuration);

        address otherUser = address(3);

        // Simulate another user who hasn't earned any rewards
        vm.startPrank(otherUser);
        infraredVault.getReward();
        vm.stopPrank();

        // Check other user's rewards token balance
        uint256 otherUserRewardsBalance = rewardsToken.balanceOf(otherUser);
        assertEq(
            otherUserRewardsBalance, 0, "User should not receive any rewards"
        );
    }

    function testMultipleRewardsClaim() public {
        uint256 rewardsAmount = 100 ether;
        uint256 rewardsDuration = 30 days;
        setUpGetReward(rewardsAmount, rewardsDuration);
        // Claim rewards twice
        vm.startPrank(user);
        // First claim
        skip(rewardsDuration + 1 minutes / 2); // Simulate half the reward duration
        infraredVault.getReward();

        // Second claim
        skip(rewardsDuration + 1 minutes / 2); // Complete the reward duration
        infraredVault.getReward();

        vm.stopPrank();

        // Check user's rewards token balance after second claim

        uint256 userRewardsBalanceAfterSecondClaim =
            rewardsToken.balanceOf(user);
        assertAlmostEqual(
            userRewardsBalanceAfterSecondClaim,
            rewardsAmount,
            tolerance,
            "User should receive the full rewards within tolerance after second claim"
        );
    }

    function testMultipleRewardTokensClaim() public {
        uint256 firstRewardAmount = 50 ether;
        uint256 rewardsDuration = 30 days;
        setUpGetReward(firstRewardAmount, rewardsDuration);
        // Initialize second mock reward token
        MockERC20 secondRewardsToken =
            new MockERC20("Second Reward Token", "SRWD", 18);

        // Add the second reward token to the infraredVault
        vm.startPrank(address(infrared));
        infraredVault.addReward(address(secondRewardsToken), rewardsDuration);

        vm.stopPrank();

        uint256 amountToStake = 100 ether;

        // Users stake some tokens
        vm.deal(address(user), amountToStake);
        vm.startPrank(user);
        wbera.deposit{value: amountToStake}();
        wbera.approve(address(infraredVault), amountToStake);
        infraredVault.stake(amountToStake);
        vm.stopPrank();

        // Notify rewards for both tokens
        uint256 secondRewardAmount = 75 ether;

        vm.startPrank(address(infrared));
        secondRewardsToken.mint(address(infrared), secondRewardAmount);
        secondRewardsToken.approve(address(infraredVault), secondRewardAmount);
        infraredVault.notifyRewardAmount(
            address(secondRewardsToken), secondRewardAmount
        );
        vm.stopPrank();

        // Skip time to ensure rewards are distributed
        skip(rewardsDuration + 100 minutes);

        // User claims rewards
        vm.startPrank(user);
        infraredVault.getReward();
        vm.stopPrank();

        // Check user received rewards for both tokens
        uint256 userFirstRewardBalance = rewardsToken.balanceOf(user);
        uint256 userSecondRewardBalance = secondRewardsToken.balanceOf(user);

        assertAlmostEqual(
            userFirstRewardBalance,
            firstRewardAmount,
            tolerance,
            "Incorrect first reward amount"
        );
        assertAlmostEqual(
            userSecondRewardBalance,
            secondRewardAmount,
            tolerance,
            "Incorrect second reward amount"
        );
    }

    /*//////////////////////////////////////////////////////////////
                        getRewardForUser
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulGetRewardForUser() public {
        uint256 rewardsAmount = 100 ether;
        uint256 rewardsDuration = 30 days;
        setUpGetReward(rewardsAmount, rewardsDuration);

        // Manipulate time to simulate the passage of the reward duration
        skip(rewardsDuration + 100 minutes);
        infraredVault.getRewardForUser(user);

        // Check user's rewards token balance
        uint256 userRewardsBalance = rewardsToken.balanceOf(user);
        assertAlmostEqual(
            userRewardsBalance,
            rewardsAmount,
            tolerance,
            "User should receive the rewards within tolerance"
        );
    }

    /*//////////////////////////////////////////////////////////////
                        HELPER
    //////////////////////////////////////////////////////////////*/

    function getRewardData(address _infraredVault, address _rewardsToken)
        internal
        returns (
            address rewardsDistributor,
            uint256 rewardsDuration,
            uint256 periodFinish,
            uint256 rewardRate,
            uint256 lastUpdateTime,
            uint256 rewardPerTokenStored
        )
    {
        (bool success, bytes memory data) = _infraredVault.call(
            abi.encodeWithSignature("rewardData(address)", _rewardsToken)
        );
        require(success, "Failed to get reward data");

        // Decode the returned data based on the structure of the Reward struct
        (
            rewardsDistributor,
            rewardsDuration,
            periodFinish,
            rewardRate,
            lastUpdateTime,
            rewardPerTokenStored
        ) = abi.decode(
            data, (address, uint256, uint256, uint256, uint256, uint256)
        );
        return (
            rewardsDistributor,
            rewardsDuration,
            periodFinish,
            rewardRate,
            lastUpdateTime,
            rewardPerTokenStored
        );
    }

    function setUpGetReward(uint256 rewardsAmount, uint256 rewardsDuratoin)
        internal
    {
        // Setup reward token in the infraredVault and mint rewards
        vm.startPrank(address(infrared));
        infraredVault.addReward(address(0x3), rewardsDuratoin);
        rewardsToken.mint(address(infrared), rewardsAmount);
        rewardsToken.approve(address(infraredVault), rewardsAmount);
        infraredVault.notifyRewardAmount(address(rewardsToken), rewardsAmount);
        vm.stopPrank();

        // User stakes tokens
        vm.deal(address(user), 500 ether);
        vm.startPrank(user);
        wbera.deposit{value: 500 ether}();
        wbera.approve(address(infraredVault), 500 ether);
        infraredVault.stake(500 ether);
        vm.stopPrank();
    }

    uint256 constant tolerance = 1 ether / 1e12; // Example tolerance: 0.000001 ether

    // Helper function to assert equality within a tolerance range
    function assertAlmostEqual(
        uint256 left,
        uint256 right,
        uint256 _tolerance,
        string memory message
    ) internal {
        if (left > right) {
            assertTrue(left - right <= _tolerance, message);
        } else {
            assertTrue(right - left <= _tolerance, message);
        }
    }
}
