// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import "forge-std/Test.sol";

import {InfraredVault, Errors} from "@core/InfraredVault.sol";

import "../mocks/MockERC20.sol";
import "../mocks/MockRewardsPrecompile.sol";
import "../mocks/MockDistributionPrecompile.sol";
import "../mocks/MockERC20BankModule.sol";
import {stdStorage, StdStorage} from "forge-std/Test.sol";

contract InfraredVaultTest is Test {
    InfraredVault public infraredVault;
    MockERC20 public stakingToken;
    MockRewardsPrecompile public mockRewardsModule;
    MockDistributionPrecompile public mockDistributionModule;
    MockERC20BankModule public mockErc20BankModule;
    MockERC20 public rewardsToken;
    address[] rewardTokens;

    address constant admin = address(1);
    address constant infrared = address(2);
    address constant pool = address(3);
    address constant user = address(4);
    address constant user2 = address(5);

    function setUp() public {
        // Initialize mock contracts
        mockErc20BankModule = new MockERC20BankModule();
        stakingToken = new MockERC20("Staking Token", "STK", 18);
        rewardsToken = new MockERC20("Reward Token", "RWD", 18);
        mockRewardsModule =
            new MockRewardsPrecompile(address(mockErc20BankModule));
        mockDistributionModule =
            new MockDistributionPrecompile(address(mockErc20BankModule));

        rewardTokens = new address[](1);
        rewardTokens[0] = address(14);

        // Deploy the InfraredVault contract
        infraredVault = new InfraredVault(
            admin,
            address(stakingToken),
            infrared,
            pool,
            address(mockRewardsModule),
            address(mockDistributionModule),
            rewardTokens,
            1 days // Rewards duration
        );

        // Set up initial state for tests
        deal(address(stakingToken), user2, 1000 ether);
    }

    /*//////////////////////////////////////////////////////////////
                        Constructor
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulDeployment() public {
        // Act: Deploy the contract with valid parameters
        InfraredVault vault = new InfraredVault(
            address(1), // admin
            address(stakingToken),
            address(2), // infrared address
            address(3), // pool address
            address(mockRewardsModule),
            address(mockDistributionModule),
            rewardTokens,
            1 days // Rewards duration
        );

        // Assert: Check if the contract is deployed successfully
        assertTrue(
            address(vault) != address(0),
            "Contract should be successfully deployed"
        );
    }

    function testRevertWithZeroAddressesInConstructor() public {
        // Test each parameter with zero address
        address[] memory testAddresses = new address[](8);
        testAddresses[0] = address(0); // Zero admin address
        testAddresses[1] = address(stakingToken);
        testAddresses[2] = address(2); // Infrared address
        testAddresses[3] = address(3); // Pool address
        testAddresses[4] = address(mockRewardsModule);
        testAddresses[5] = address(mockDistributionModule);
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
                constructorParams[0], // Admin
                constructorParams[1], // Staking Token
                constructorParams[2], // Infrared
                constructorParams[3], // Pool
                constructorParams[4], // Rewards Module
                constructorParams[5], // Distribution Module
                rewardTokens,
                1 days
            );
        }
    }

    /*//////////////////////////////////////////////////////////////
                        claimRewardsPrecompile
    //////////////////////////////////////////////////////////////*/

    event ClaimRewardsPrecompile(address _sender, uint256 _amt);

    function testClaimRewardsPrecompileSuccess() public {
        // Set up mock rewards
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockRewardsModule.setMockRewards(rewards);
        mockErc20BankModule.setErc20AddressForCoinDenom(
            "abgt", address(rewardsToken)
        );

        vm.prank(infrared);

        // event expect
        vm.expectEmit();
        emit ClaimRewardsPrecompile(infrared, 100);

        // Claim rewards
        uint256 bgtAmt = infraredVault.claimRewardsPrecompile();

        // Assert that the claimed amount is correct
        assertEq(bgtAmt, 100);
    }

    function testClaimRewardsPrecompileNoRewards() public {
        // Set up no rewards
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](0);
        mockRewardsModule.setMockRewards(rewards);

        vm.prank(infrared);
        // Claim rewards
        uint256 bgtAmt = infraredVault.claimRewardsPrecompile();

        // Assert that no rewards were claimed
        assertEq(bgtAmt, 0);
    }

    function testClaimRewardsPrecompileUnexpectedDenom() public {
        // Set up mock rewards with an unexpected denomination
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "unexpected"); // 100 of unexpected denom
        mockRewardsModule.setMockRewards(rewards);

        // Expect revert due to unexpected denomination
        vm.expectRevert();
        infraredVault.claimRewardsPrecompile();
    }

    function testClaimRewardsPrecompileMoreThanOneReward() public {
        // Set up mock rewards with more than one reward
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt");
        rewards[1] = Cosmos.Coin(50, "abgt");
        mockRewardsModule.setMockRewards(rewards);

        // Expect the function to revert due to more than one reward
        vm.expectRevert();
        infraredVault.claimRewardsPrecompile();
    }

    /*//////////////////////////////////////////////////////////////
                        addReward
    //////////////////////////////////////////////////////////////*/

    event RewardStored(address rewardsToken, uint256 rewardsDuration);

    function testSuccessfulRewardAddition() public {
        uint256 rewardsDuration = 30 days;
        uint256 rewardAmount = 1000 ether;

        vm.startPrank(infrared);

        vm.expectEmit();
        emit RewardStored(address(rewardsToken), rewardsDuration);

        // Add reward
        infraredVault.addReward(address(rewardsToken), rewardsDuration);

        deal(address(rewardsToken), address(infrared), rewardAmount);
        rewardsToken.approve(address(infraredVault), rewardAmount);

        // Notify reward amount to set periodFinish
        infraredVault.notifyRewardAmount(address(rewardsToken), rewardAmount);

        (,, uint256 periodFinish,,,) =
            getRewardData(address(infraredVault), address(rewardsToken));
        assertTrue(periodFinish > block.timestamp, "Reward addition failed");
    }

    function testRevertWithZeroAddressForTokenAddReward() public {
        uint256 rewardsDuration = 30 days;

        vm.startPrank(infrared);
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.addReward(address(0), rewardsDuration);
        vm.stopPrank();
    }

    function testRevertWithZeroDurationAddReward() public {
        vm.startPrank(infrared);
        vm.expectRevert(Errors.ZeroAmount.selector);
        infraredVault.addReward(address(rewardsToken), 0);
        vm.stopPrank();
    }

    function testAccessControlAddReward() public {
        uint256 rewardsDuration = 30 days;

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infraredVault.INFRARED_ROLE()
            )
        );
        infraredVault.addReward(address(rewardsToken), rewardsDuration);
    }

    /*//////////////////////////////////////////////////////////////
                        notifyRewardAmount
    //////////////////////////////////////////////////////////////*/

    event RewardAdded(uint256 amount);

    function testSuccessfulNotification() public {
        uint256 rewardAmount = 1000 ether;

        vm.startPrank(infrared);
        infraredVault.addReward(address(rewardsToken), 30 days);

        deal(address(rewardsToken), address(infrared), rewardAmount);
        rewardsToken.approve(address(infraredVault), rewardAmount);

        vm.expectEmit();
        emit RewardAdded(rewardAmount);

        infraredVault.notifyRewardAmount(address(rewardsToken), rewardAmount);

        (,, uint256 periodFinish,,,) =
            getRewardData(address(infraredVault), address(rewardsToken));
        assertTrue(periodFinish > block.timestamp, "Reward notification failed");
    }

    function testRevertWithZeroAddressForToken() public {
        uint256 rewardAmount = 1000 ether;

        vm.startPrank(infrared);
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.notifyRewardAmount(address(0), rewardAmount);
        vm.stopPrank();
    }

    function testRevertWithZeroAmount() public {
        vm.prank(infrared);
        infraredVault.addReward(address(rewardsToken), 30 days);

        vm.startPrank(infrared);
        vm.expectRevert(Errors.ZeroAmount.selector);
        infraredVault.notifyRewardAmount(address(rewardsToken), 0);
        vm.stopPrank();
    }

    function testAccessControlNotifyRewardAmount() public {
        uint256 rewardAmount = 1000 ether;

        vm.prank(infrared);
        infraredVault.addReward(address(rewardsToken), 30 days);

        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(this),
                infraredVault.INFRARED_ROLE()
            )
        );
        infraredVault.notifyRewardAmount(address(rewardsToken), rewardAmount);
    }

    /*//////////////////////////////////////////////////////////////
                        updateRewardsDuration
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulDurationUpdate() public {
        uint256 newDuration = 7 days;

        vm.startPrank(infrared);
        infraredVault.addReward(address(rewardsToken), newDuration); // Setup reward token
        vm.stopPrank();
        vm.startPrank(admin);
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

        vm.startPrank(admin);
        vm.expectRevert(Errors.ZeroAddress.selector);
        infraredVault.updateRewardsDuration(address(0), newDuration);
        vm.stopPrank();
    }

    function testRevertWithZeroDurationUpdateRewardsDuration() public {
        vm.startPrank(infrared);
        infraredVault.addReward(address(rewardsToken), 1 days); // Setup reward token
        vm.stopPrank();
        vm.startPrank(admin);
        vm.expectRevert(Errors.ZeroAmount.selector);
        infraredVault.updateRewardsDuration(address(rewardsToken), 0);
        vm.stopPrank();
    }

    function testAccessControlUpdateRewardsDuration() public {
        uint256 newDuration = 7 days;

        vm.startPrank(infrared);
        infraredVault.addReward(address(rewardsToken), newDuration); // Setup reward token
        vm.stopPrank();

        vm.startPrank(address(5)); // Non-admin address
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(5),
                infraredVault.DEFAULT_ADMIN_ROLE()
            )
        );
        infraredVault.updateRewardsDuration(address(rewardsToken), newDuration);
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                        stake
    //////////////////////////////////////////////////////////////*/
    function testSuccessfulStake() public {
        uint256 stakeAmount = 100 ether;
        deal(address(stakingToken), user, stakeAmount);

        // User approves the vault to spend their tokens
        vm.startPrank(user);
        stakingToken.approve(address(infraredVault), stakeAmount);

        // User stakes tokens into the vault
        infraredVault.stake(stakeAmount);

        // Check user's balance in the vault
        uint256 userBalance = infraredVault.balanceOf(user);
        assertEq(userBalance, stakeAmount, "User balance should be updated");

        // Check total supply in the vault
        uint256 totalSupply = infraredVault.totalSupply();
        assertEq(totalSupply, stakeAmount, "Total supply should be updated");
        vm.stopPrank();
    }

    function testStakeWithZeroAmount() public {
        deal(address(stakingToken), user, 0);
        vm.startPrank(user);
        stakingToken.approve(address(infraredVault), 0);

        vm.expectRevert("Cannot stake 0");
        infraredVault.stake(0);
        vm.stopPrank();
    }

    function testStakeMoreThanUsersBalance() public {
        uint256 stakeAmount = 2000 ether; // More than user's balance

        deal(address(stakingToken), user, stakeAmount - 1000 ether);
        vm.startPrank(user);
        stakingToken.approve(address(infraredVault), stakeAmount);

        vm.expectRevert(); // Expect revert due to insufficient balance
        infraredVault.stake(stakeAmount);
        vm.stopPrank();
    }

    // Assuming there's no access control for staking, otherwise:
    function testAccessControlOnStake() public {
        address unauthorizedUser = address(3);
        uint256 stakeAmount = 100 ether;
        deal(address(stakingToken), user, stakeAmount);

        // User approves the vault to spend their tokens
        vm.startPrank(unauthorizedUser);
        stakingToken.approve(address(infraredVault), stakeAmount);

        vm.expectRevert();
        infraredVault.stake(stakeAmount);
        vm.stopPrank();
    }
    /*//////////////////////////////////////////////////////////////
                        withdraw
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulWithdraw() public {
        // User stakes tokens
        vm.startPrank(user2);
        stakingToken.approve(address(infraredVault), 500 ether);
        infraredVault.stake(500 ether);
        vm.stopPrank();

        uint256 withdrawAmount = 100 ether;

        vm.startPrank(user2);
        infraredVault.withdraw(withdrawAmount);
        vm.stopPrank();

        // Check user's balance in the vault after withdrawal
        uint256 userBalance = infraredVault.balanceOf(user2);
        assertEq(
            userBalance,
            400 ether,
            "User balance should decrease after withdrawal"
        );

        // Check total supply in the vault after withdrawal
        uint256 totalSupply = infraredVault.totalSupply();
        assertEq(
            totalSupply,
            400 ether,
            "Total supply should decrease after withdrawal"
        );

        // Check user's token balance
        uint256 userTokenBalance = stakingToken.balanceOf(user2);
        assertEq(
            userTokenBalance,
            600 ether,
            "User should receive the withdrawn tokens"
        );
    }

    function testWithdrawMoreThanStaked() public {
        // User stakes tokens
        vm.startPrank(user2);
        stakingToken.approve(address(infraredVault), 500 ether);
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
        vm.startPrank(user2);
        stakingToken.approve(address(infraredVault), 500 ether);
        infraredVault.stake(500 ether);
        vm.stopPrank();

        vm.startPrank(user2);
        vm.expectRevert("Cannot withdraw 0");
        infraredVault.withdraw(0);
        vm.stopPrank();
    }

    function testWithdrawAsDifferentUser() public {
        // User stakes tokens
        vm.startPrank(user2);
        stakingToken.approve(address(infraredVault), 500 ether);
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

        // Add the second reward token to the vault
        vm.startPrank(infrared);
        infraredVault.addReward(address(secondRewardsToken), rewardsDuration);
        vm.stopPrank();

        uint256 amountToStake = 100 ether;

        // Users stake some tokens
        stakingToken.mint(user, amountToStake);
        vm.startPrank(user);
        stakingToken.approve(address(infraredVault), amountToStake);
        infraredVault.stake(amountToStake);
        vm.stopPrank();

        // Notify rewards for both tokens
        uint256 secondRewardAmount = 75 ether;

        vm.startPrank(infrared);
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
        // Setup reward token in the vault and mint rewards
        vm.startPrank(infrared);
        infraredVault.addReward(address(rewardsToken), rewardsDuratoin);
        rewardsToken.mint(address(infrared), rewardsAmount);
        rewardsToken.approve(address(infraredVault), rewardsAmount);
        infraredVault.notifyRewardAmount(address(rewardsToken), rewardsAmount);
        vm.stopPrank();

        // User stakes tokens
        vm.startPrank(user);
        stakingToken.mint(user, 500 ether);
        stakingToken.approve(address(infraredVault), 500 ether);
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
