// // SPDX-License-Identifier: MIT
// pragma solidity >=0.8.4;

import "@berachain/pol/interfaces/IBeaconDeposit.sol";

// contract MockBeaconDepositContract is IBeaconDeposit {
//     struct Validator {
//         uint64 totalStake;
//         bytes withdrawalCredentials;
//     }

//     //     mapping(bytes => Validator) public validators;
//     //     mapping(bytes => address) public getOperator;

//     //     function setOperator(bytes calldata pubkey, address operator) external {
//     //         getOperator[pubkey] = operator;
//     //     }

//     function deposit(
//         bytes calldata validatorPubKey,
//         bytes calldata stakingCredentials,
//         bytes calldata signature,
//         address operator
//     ) external payable override {
//         uint64 amount = uint64(msg.value / (1 gwei));
//         require(amount > 0, "Amount must be greater than 0");
//         // require(validatorPubKey.length == 48, "Invalid public key length");
//         // require(signature.length == 96, "Invalid signature length");

//         Validator storage validator = validators[validatorPubKey];
//         validator.totalStake += amount;
//         if (validator.withdrawalCredentials.length == 0) {
//             validator.withdrawalCredentials = stakingCredentials;
//         }
//         getOperator[validatorPubKey] = operator;

//         emit Deposit(validatorPubKey, stakingCredentials, amount, signature, 0);
//     }

//     function redirect(
//         bytes calldata fromPubKey,
//         bytes calldata toPubKey,
//         uint64 amount
//     ) external {
//         require(amount > 0, "Amount must be greater than 0");
//         Validator storage fromValidator = validators[fromPubKey];
//         Validator storage toValidator = validators[toPubKey];

//         require(
//             fromValidator.totalStake >= amount,
//             "Insufficient stake to redirect"
//         );
//         fromValidator.totalStake -= amount;
//         toValidator.totalStake += amount;
//     }

//     function withdraw(
//         bytes calldata validatorPubKey,
//         bytes calldata withdrawalCredentials,
//         uint64 amount
//     ) external {
//         Validator storage validator = validators[validatorPubKey];

//         //         require(
//         //             validator.totalStake >= amount, "Insufficient stake to withdraw"
//         //         );
//         //         require(
//         //             keccak256(validator.withdrawalCredentials)
//         //                 == keccak256(withdrawalCredentials),
//         //             "Invalid withdrawal credentials"
//         //         );

//         validator.totalStake -= amount;
//     }

//     function getValidatorTotalStake(
//         bytes calldata validatorPubKey
//     ) external view returns (uint64) {
//         return validators[validatorPubKey].totalStake;
//     }

//     // TODO: implement ...
//     function requestOperatorChange(
//         bytes calldata pubkey,
//         address newOperator
//     ) external {
//         revert("not implemented");
//     }

//     function cancelOperatorChange(bytes calldata pubkey) external {
//         revert("not implemented");
//     }

//     function acceptOperatorChange(bytes calldata pubkey) external {
//         revert("not implemented");
//     }
// }
