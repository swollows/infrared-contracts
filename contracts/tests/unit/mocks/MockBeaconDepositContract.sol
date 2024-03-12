// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@berachain/interfaces/IBeaconDepositContract.sol";

contract MockBeaconDepositContract is IBeaconDepositContract {
    struct Validator {
        uint64 totalStake;
        bytes withdrawalCredentials;
    }

    mapping(bytes => Validator) public validators;

    function deposit(
        bytes calldata validatorPubKey,
        bytes calldata stakingCredentials,
        uint64 amount,
        bytes calldata signature
    ) external payable override {
        require(amount > 0, "Amount must be greater than 0");
        // require(validatorPubKey.length == 48, "Invalid public key length");
        // require(signature.length == 96, "Invalid signature length");

        Validator storage validator = validators[validatorPubKey];
        validator.totalStake += amount;
        if (validator.withdrawalCredentials.length == 0) {
            validator.withdrawalCredentials = stakingCredentials;
        }

        emit Deposit(validatorPubKey, stakingCredentials, amount, signature);
    }

    function redirect(
        bytes calldata fromPubKey,
        bytes calldata toPubKey,
        uint64 amount
    ) external override {
        require(amount > 0, "Amount must be greater than 0");
        Validator storage fromValidator = validators[fromPubKey];
        Validator storage toValidator = validators[toPubKey];

        require(
            fromValidator.totalStake >= amount, "Insufficient stake to redirect"
        );
        fromValidator.totalStake -= amount;
        toValidator.totalStake += amount;

        emit Redirect(
            fromPubKey, toPubKey, fromValidator.withdrawalCredentials, amount
        );
    }

    function withdraw(
        bytes calldata validatorPubKey,
        bytes calldata withdrawalCredentials,
        uint64 amount
    ) external override {
        Validator storage validator = validators[validatorPubKey];

        require(
            validator.totalStake >= amount, "Insufficient stake to withdraw"
        );
        require(
            keccak256(validator.withdrawalCredentials)
                == keccak256(withdrawalCredentials),
            "Invalid withdrawal credentials"
        );

        validator.totalStake -= amount;

        emit Withdraw(validatorPubKey, withdrawalCredentials, amount);
    }

    function getValidatorTotalStake(bytes calldata validatorPubKey)
        external
        view
        returns (uint64)
    {
        return validators[validatorPubKey].totalStake;
    }
}
