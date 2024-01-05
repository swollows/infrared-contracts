// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Cosmos} from "@polaris/CosmosTypes.sol";

/**
 * @title PureUtils
 * @dev A library for utility functions that do not modify state.
 *
 * This library provides functions for string comparison and manipulation of Cosmos.Coin arrays.
 * The functions are marked as `pure`, meaning they do not read from or write to the contract's state.
 * This makes them suitable for use in other `pure` or `view` functions.
 *
 * The `isStringSame` function compares two strings for equality. It is more efficient than hashing the strings for short strings.
 *
 * The `removeCoinFromCoins` function removes a coin with a specific denomination from an array of Cosmos.Coin. It returns the new array and the amount of the removed coin.
 *
 * The `isCoinInCoins` åfunction checks if a coin with a specific denomination is in an array of Cosmos.Coin.
 *
 */
library PureUtils {
    /**
     * @notice Checks if two strings are the same.
     * @notice More efficient than `keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b))` for short strings.
     * @param  _a      string memory The first string.
     * @param  _b      string memory The second string.
     * @return _isSame bool          Whether the two strings are the same.
     */
    function isStringSame(string memory _a, string memory _b)
        internal
        pure
        returns (bool _isSame)
    {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);

        if (a.length != b.length) {
            return false;
        }

        for (uint256 i = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
                return false;
            }
        }

        return true;
    }

    /**
     * @notice Removes a cosmos coin from an array of cosmos coins.
     * @param  _coins    Cosmos.Coin[] memory The array of cosmos coins.
     * @param  _denom    string memory        The denom of the coin to remove.
     * @return _newCoins Cosmos.Coin[] memory The new array of cosmos coins.
     * @return _amt      uint256              The amount of the denom that was removed.
     */
    function removeCoinFromCoins(
        Cosmos.Coin[] memory _coins,
        string memory _denom
    ) internal pure returns (Cosmos.Coin[] memory _newCoins, uint256 _amt) {
        uint256 counter = 0;
        uint256 amt = 0;

        // First pass: find the coins to remove, accumulate their amounts, and count the remaining coins
        for (uint256 i = 0; i < _coins.length; i++) {
            if (isStringSame(_coins[i].denom, _denom)) {
                amt += _coins[i].amount;
            } else {
                counter++;
            }
        }

        // If the denomination was not found, return the original array and 0
        if (amt == 0) {
            return (_coins, 0);
        }

        // Second pass: create a new array with the remaining coins
        Cosmos.Coin[] memory newCoins = new Cosmos.Coin[](counter);
        uint256 j = 0;
        for (uint256 i = 0; i < _coins.length; i++) {
            if (!isStringSame(_coins[i].denom, _denom)) {
                newCoins[j] = _coins[i];
                j++;
            }
        }

        return (newCoins, amt);
    }

    function isCoinInCoins(Cosmos.Coin[] memory _coins, string memory _denom)
        internal
        pure
        returns (bool isFound)
    {
        // Loop through the coins array and check if the denom is in the array.
        for (uint256 i = 0; i < _coins.length; i++) {
            if (isStringSame(_coins[i].denom, _denom)) {
                return true;
            }
        }

        return false;
    }
}
