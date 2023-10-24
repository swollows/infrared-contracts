// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * @dev This library contains types used by the Cosmos module.
 */
library Cosmos {
    /**
     * @dev Represents a cosmos coin.
     */
    struct Coin {
        uint256 amount;
        string denom;
    }

    struct PageRequest {
        string key;
        uint64 offset;
        uint64 limit;
        bool countTotal;
        bool reverse;
    }

    struct PageResponse {
        string nextKey;
        uint64 total;
    }
}
