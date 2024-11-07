// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EnumerableSet} from
    "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

library DataTypes {
    // Enum for the actions used in the ValidatorSet library.
    enum ValidatorSetAction {
        Add,
        Remove,
        Replace
    }

    // Struct for validator details
    struct Validator {
        // CL public key
        bytes pubKey;
        // coinbase address for validator
        address coinbase;
    }

    // Struct for tracking many validators
    struct ValidatorSet {
        EnumerableSet.Bytes32Set keys;
        mapping(bytes32 => Validator) map;
    }

    // Struct for ERC20 token information.
    struct Token {
        address tokenAddress;
        uint256 amount;
    }

    /// @dev The address of the native asset as of EIP-7528.
    address public constant NATIVE_ASSET =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    enum RewardContract {
        Distribution,
        Rewards
    }
}
