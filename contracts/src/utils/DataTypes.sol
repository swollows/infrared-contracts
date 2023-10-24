// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library DataTypes {
    // The actions preformed on the validator set.
    enum ValidatorSetAction {
        Add,
        Remove,
        Replace
    }

    // Represents a token and amount.
    struct Token {
        address tokenAddress;
        uint256 amount;
    }
}
