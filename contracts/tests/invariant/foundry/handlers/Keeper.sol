// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.22;

// import "@core/IBGT.sol";
// import "@core/InfraredVault.sol";
// import "@core/Infrared.sol";

// import "../SetupHelper.sol";
// import "forge-std/Test.sol";

// contract InfraredVaultHandler is Test {
//     Infrared public infrared;
//     IInfraredVault public vault;
//     address public keeper;
//     address public rewardsModuleAddress;

//     uint256 public totalBgtRewards;

//     uint256 public totalDelegatedBgt;
//     address public validator;

//     constructor(
//         Infrared _infrared,
//         address _keeper,
//         address _rewardsModuleAddress,
//         address _validator
//     ) public {
//         // Initialize mock assets
//         (
//             address stakingTokenAddress,
//             address mockRewardTokenAddress,
//             address mockPoolAddress
//         ) = SetupHelper.setUpMockAssets();
//         MockERC20 stakingToken = MockERC20(stakingTokenAddress);
//         MockERC20 mockRewardToken = MockERC20(mockRewardTokenAddress);
//         MockERC20 mockPool = MockERC20(mockPoolAddress);

//         address[] memory rewardTokens = new address[](1);
//         rewardTokens[0] = address(_infrared.ibgt()); // all Infrared vaults will only receive ibgt as rewards

//         vm.startPrank(_keeper);
//         vault = _infrared.registerVault(stakingTokenAddress, rewardTokens);
//         vm.stopPrank();

//         infrared = _infrared;
//         keeper = _keeper;
//         rewardsModuleAddress = _rewardsModuleAddress;
//         validator = _validator;
//     }

//     function harvestVault(uint256 bgtReward) public {
//         vm.assume(
//             bgtReward < type(uint256).max
//                 && bgtReward < type(uint128).max - totalBgtRewards
//         );

//         // Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
//         // rewards[0] = Cosmos.Coin(bgtReward, "abgt"); // 100 bgt

//         // set bgt rewards on rewards
//         // MockRewardsPrecompile(rewardsModuleAddress).setMockRewards(rewards);

//         totalBgtRewards += bgtReward;

//         // impersonate keeper and call harvestVault
//         vm.prank(keeper);
//         infrared.harvestVault(address(vault));
//         vm.stopPrank();
//     }

//     function delegateBGT(uint256 amount) public {
//         vm.assume(totalBgtRewards >= totalDelegatedBgt + amount);
//         totalDelegatedBgt += amount;

//         // infrared.delegate(validator, amount);
//     }

//     function undelegateBGT(uint256 amount) public {
//         vm.assume(totalDelegatedBgt >= amount);
//         totalDelegatedBgt -= amount;

//         // infrared.undelegate(validator, amount);
//     }
// }
