// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

library DataTypes {
    // Enum for the actions used in the ValidatorSet library.
    enum ValidatorSetAction {
        Add,
        Remove,
        Replace
    }

    // Struct for ERC20 token information.
    struct Token {
        address tokenAddress;
        uint256 amount;
    }

    enum RewardContract {
        Distribution,
        Rewards
    }
}
