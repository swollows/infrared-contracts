// // SPDX-License-Identifier: MIT
// pragma solidity 0.8.22;

// import "@core/IBGT.sol";
// import "@core/InfraredVault.sol";
// import "@core/Infrared.sol";

// import "../SetupHelper.sol";

// import "../../../unit/mocks/MockERC20.sol";

// contract UserHandler is Test {
//     Infrared public infrared;
//     InfraredVault public vault;
//     IERC20 public stakingToken;

//     address public user1;
//     address public user2;
//     address public user3;

//     uint256 public totalStaked;
//     uint256 public totalWithdrawn;

//     mapping(address => uint256) public userStaked;
//     mapping(address => uint256) public userClaimed;

//     constructor(Infrared _infrared, address _vault) public {
//         infrared = _infrared;
//         vault = InfraredVault(_vault);
//         stakingToken = InfraredVault(_vault).stakingToken();

//         // derrive user addresses from address(this)
//         user1 = address(
//             uint160(
//                 uint256(keccak256(abi.encodePacked(address(this), address(1))))
//             )
//         );
//         user2 = address(
//             uint160(
//                 uint256(keccak256(abi.encodePacked(address(this), address(2))))
//             )
//         );
//         user3 = address(
//             uint160(
//                 uint256(keccak256(abi.encodePacked(address(this), address(3))))
//             )
//         );
//     }

//     function deposit(uint256 amount, uint256 seed) public {
//         // jump in time
//         vm.warp(block.timestamp + 1 days);
//         // pick a user either user1, user2, or user3
//         address user;
//         if (seed % 3 == 0) {
//             user = user1;
//         } else if (seed % 3 == 1) {
//             user = user2;
//         } else {
//             user = user3;
//         }
//         vm.assume(
//             amount < type(uint256).max
//                 && amount < type(uint128).max - totalStaked
//         );

//         deal(address(stakingToken), user, amount);

//         totalStaked += amount;
//         userStaked[user] += amount;

//         stakingToken.approve(address(vault), amount);
//         vault.stake(amount);
//     }

//     function withdraw(uint256 amount, uint256 seed) public {
//         // jump in time
//         vm.warp(block.timestamp + 1 days);
//         // pick a user either user1, user2, or user3
//         address user;
//         if (seed % 3 == 0) {
//             user = user1;
//         } else if (seed % 3 == 1) {
//             user = user2;
//         } else {
//             user = user3;
//         }

//         vm.assume(amount <= userStaked[user]);

//         totalWithdrawn += amount;
//         userStaked[user] -= amount;

//         vault.withdraw(amount);
//     }

//     function claim(uint256 seed) public {
//         // jump in time
//         vm.warp(block.timestamp + 1 days);
//         // pick a user either user1, user2, or user3
//         address user;
//         if (seed % 3 == 0) {
//             user = user1;
//         } else if (seed % 3 == 1) {
//             user = user2;
//         } else {
//             user = user3;
//         }

//         uint256 reward = vault.earned(user, address(infrared.ibgt()));
//         vault.getReward();
//         userClaimed[user] += reward;
//     }
// }
