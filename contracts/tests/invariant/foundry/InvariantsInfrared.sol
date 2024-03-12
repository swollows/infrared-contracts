// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.22;

// import "forge-std/Test.sol";

// import "./SetupHelper.sol";
// import "./handlers/InfraredVaultHandler.sol";
// import "./handlers/IBGTVaultHandler.sol";
// import "./handlers/UserHandler.sol";

// import "@core/MultiRewards.sol";

// contract InvariantsInfrared is Test {
//     InfraredVaultHandler public infraredVaultHandler;
//     IBGTVaultHandler public ibgtVaultHandler;
//     UserHandler public userHandler;
//     Infrared public infrared;
//     IInfraredVault vault;
//     IBGT public ibgt;

//     // setup infrared to be able to claim bgt rewards on infrared vault
//     function setUp() public {
//         /* Infrared Setup */

//         // Initialize tokens
//         (address bgtAddress, address ibgtAddress, address iredAddress) =
//             SetupHelper.setUpTokens();
//         MockERC20 bgt = MockERC20(bgtAddress);
//         ibgt = IBGT(ibgtAddress);
//         MockERC20 ired = MockERC20(iredAddress);

//         // Set roles
//         (address admin, address keeper, address governance) =
//             SetupHelper.setUpRoles(address(this));

//         // Initialize mock contracts
//         (
//             address mockErc20Bank,
//             address mockWbera,
//             address rewardsModuleAddress,
//             address distributionModuleAddress,
//             address stakingModuleAddress,
//             address bankModuleAddress
//         ) = SetupHelper.setUpMockContracts(bgtAddress);
//         // Additional mock contracts initialization as necessary

//         // Initialize Infrared with modules etc.
//         // Assuming the creation and setup of modules array is handled properly before this step
//         address infraredAddress = SetupHelper.setUpInfrared(
//             admin,
//             ibgtAddress,
//             address(0), // rewardsModuleAddress
//             mockWbera,
//             iredAddress,
//             keeper,
//             governance
//         );
//         infrared = Infrared(infraredAddress);

//         address validator = address(888);
//         address[] memory validatorAddresses = new address[](1);
//         validatorAddresses[0] = validator;

//         vm.startPrank(governance);
//         // infrared.addValidators(validatorAddresses);
//         vm.stopPrank();

//         // Set ERC20 addresses in MockERC20BankModule
//         SetupHelper.setErc20Addresses(mockErc20Bank, bgtAddress);

//         /* Handler Setup */

//         // deploy the handler contracts
//         infraredVaultHandler = new InfraredVaultHandler(
//             infrared, keeper, rewardsModuleAddress, validator
//         );

//         ibgtVaultHandler = new IBGTVaultHandler(
//             infrared,
//             address(infrared.ibgtVault()),
//             keeper,
//             governance,
//             distributionModuleAddress,
//             validator,
//             mockErc20Bank
//         );

//         userHandler =
//             new UserHandler(infrared, address(infraredVaultHandler.vault()));

//         address[] memory handlers = new address[](2);
//         handlers[0] = address(infraredVaultHandler);
//         handlers[1] = address(ibgtVaultHandler);

//         targetContract(address(infraredVaultHandler));
//         targetContract(address(ibgtVaultHandler));
//         targetContract(address(userHandler));
//     }

//     function invariant_ibgt_minted_equal_to_bgt_rewards() public {
//         // assert that the total minted ibgt is equal to the total bgt rewards
//         assertEq(
//             ibgt.totalSupply(),
//             infraredVaultHandler.totalBgtRewards(),
//             "Invariant: Minted IBGT should be equal to total BGT rewards"
//         );
//     }

//     function invariant_delegated_amount_not_bigger_than_BGT_balance() public {
//         // assert that the total delegated bgt is not bigger than the total bgt rewards
//         assertTrue(
//             infraredVaultHandler.totalDelegatedBgt()
//                 <= infraredVaultHandler.totalBgtRewards(),
//             "Invariant: Delegated BGT amount should not be bigger than BGT balance"
//         );
//     }

//     function invariant_only_whitelisted_reward_tokens_are_distributed_to_IBGTVault(
//     ) public {
//         address otherToken = ibgtVaultHandler.otherToken(); // non whitelisted token that can be part of the rewards array in the harvestValidator function
//         // assert that only whitelisted reward tokens are distributed
//         assertTrue(
//             MultiRewards(address(infrared.ibgtVault())).rewardPerToken(
//                 otherToken
//             ) == 0,
//             "Invariant: Only whitelisted reward tokens should be distributed"
//         );
//     }

//     function invariant_rewards_are_distributed_to_ibgt_vault() public {
//         MultiRewards ibgtVault = MultiRewards(address(infrared.ibgtVault()));
//         // address ibgt = address(ibgtVaultHandler.ibgt());
//         // address ired = address(ibgtVaultHandler.ired());
//         // address wbera = address(ibgtVaultHandler.wbera());
//         // assert that the total rewards are distributed to the ibgt vault
//         // assertTrue(ibgtVaultHandler.ibgtRewards() > 0 && ibgtVault.rewardPerToken(ibgt) > 0 , "Invariant: Rewards should be distributed to IBGT vault");
//         // assertTrue(ibgtVaultHandler.iredRewards() > 0 && ibgtVault.rewardPerToken(ired) > 0 , "Invariant: Rewards should be distributed to IBGT vault");
//         // assertTrue(ibgtVaultHandler.wberaRewards() > 0 && ibgtVault.rewardPerToken(wbera) > 0 , "Invariant: Rewards should be distributed to IBGT vault");
//     }

//     function invariant_users_earn_ibgt_rewards() public {
//         // assert that the users earn ibgt rewards
//         uint256 user1Rewards = userHandler.userClaimed(userHandler.user1());
//         assertTrue(
//             ibgt.balanceOf(userHandler.user1()) == user1Rewards,
//             "Invariant: Users should earn IBGT rewards"
//         );
//     }
// }
