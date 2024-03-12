// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.22;

// import "@core/IBGT.sol";
// import "@core/InfraredVault.sol";
// import "@core/Infrared.sol";

// import {Cosmos} from "@polaris/CosmosTypes.sol";

// import "forge-std/Test.sol";
// import "../../../unit/mocks/MockERC20.sol";

// contract IBGTVaultHandler is Test {
//     Infrared public infrared;
//     address public ibgtVault;
//     address public keeper;
//     address public distributionAddress;

//     uint256 public totalTokenRewards;
//     address public validator;

//     address public wbera;
//     address public ibgt;
//     address public ired;
//     address public otherToken;

//     uint256 public ibgtRewards;
//     uint256 public iredRewards;
//     uint256 public wberaRewards;
//     uint256 public otherRewards;

//     constructor(
//         Infrared _infrared,
//         address _vault,
//         address _keeper,
//         address governance,
//         address _distributionAddress,
//         address _validator,
//         address erc20BankModule
//     ) public {
//         infrared = _infrared;
//         ibgtVault = _vault;
//         keeper = _keeper;
//         distributionAddress = _distributionAddress;
//         validator = _validator;

//         vm.startPrank(governance);
//         // infrared.updateWhiteListedRewardTokens(infrared.wbera(), true);
//         vm.stopPrank();

//         wbera = address(infrared.wbera());
//         ibgt = address(infrared.ibgt());
//         ired = address(infrared.ired());
//         otherToken = address(new MockERC20("Other Token", "OTHER", 18));

//         // Assuming mockDistribution can link denom to token addresses
//         // MockERC20BankModule(erc20BankModule).setErc20AddressForCoinDenom(
//         //     "wbera", wbera
//         // );
//         // MockERC20BankModule(erc20BankModule).setErc20AddressForCoinDenom(
//         //     "ibgt", ibgt
//         // );
//         // MockERC20BankModule(erc20BankModule).setErc20AddressForCoinDenom(
//         //     "ired", ired
//         // );
//         // MockERC20BankModule(erc20BankModule).setErc20AddressForCoinDenom(
//         //     "other", otherToken
//         // );
//     }

//     function harvestValidator(uint8 numRewards, uint256 rand) public {
//         vm.assume(numRewards <= 25);
//         // Simulate setting random rewards in mockDistribution
//         Cosmos.Coin[] memory rewards = new Cosmos.Coin[](numRewards);
//         for (uint8 i = 0; i < numRewards; i++) {
//             string memory denom = i % 4 == 0
//                 ? "ibgt"
//                 : i % 4 == 1 ? "ired" : i % 4 == 2 ? "wbera" : "other";
//             uint256 amount =
//                 uint256(keccak256(abi.encodePacked(rand, i))) % 1000;
//             address tokenAddress = i % 4 == 0
//                 ? ibgt
//                 : i % 4 == 1 ? ired : i % 4 == 2 ? wbera : otherToken;
//             rewards[i] = Cosmos.Coin(amount, denom);
//             if (i % 4 == 0) {
//                 ibgtRewards += amount;
//             } else if (i % 4 == 1) {
//                 iredRewards += amount;
//             } else if (i % 4 == 2) {
//                 wberaRewards += amount;
//             } else {
//                 otherRewards += amount;
//             }
//         }
//         // MockDistributionPrecompile(distributionAddress).setMockRewards(rewards);

//         vm.prank(keeper); // Assuming the caller has the KEEPER_ROLE
//         // infrared.harvestValidator(validator);
//         vm.stopPrank();
//     }
// }
