// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ValidatorTypes {
    /// @notice Validator information for validator set
    struct Validator {
        /// pubkey of the validator for beacon deposit contract
        bytes pubkey;
        /// address of the validator for claiming infrared commission rewards
        address addr;
        /// commission for validator to charge at core berachain level
        uint256 commission;
    }
}
