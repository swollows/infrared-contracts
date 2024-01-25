// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External.
import "@forge-std/Vm.sol";
import "@forge-std/Test.sol";
import "@forge-std/console2.sol";

// Internal.
import {Cosmos} from "@polaris/CosmosTypes.sol";
import {PureUtils} from "@utils/PureUtils.sol";

contract PureUtilsTest is Test {
    function testIsStringSameSame(string memory _a) public {
        bool isSame = PureUtils.isStringSame(_a, _a);
        assertTrue(isSame);
    }

    function testIsStringSameDifferent(string memory _a, string memory _b)
        public
    {
        vm.assume(
            keccak256(abi.encodePacked(_a)) != keccak256(abi.encodePacked(_b))
        );
        bool isSame = PureUtils.isStringSame(_a, _b);
        assertFalse(isSame);
    }

    function testRemoveCoinsFromCoins() public {
        // Initialize an array of coins
        Cosmos.Coin[] memory coins = new Cosmos.Coin[](2);
        coins[0] = Cosmos.Coin(200, "btc");
        coins[1] = Cosmos.Coin(300, "eth");

        // Call removeCoinFromCoins with a coin that is in the array
        (Cosmos.Coin[] memory newCoins, uint256 amt) =
            PureUtils.removeCoinFromCoins(coins, "btc");

        // Check that the returned array has one coin
        assertEq(newCoins.length, 1);

        // Check that the returned coin is the correct one
        assertEq(newCoins[0].denom, "eth");
        assertEq(newCoins[0].amount, 300);

        // Check that the returned amount is correct
        assertEq(amt, 200);
    }

    function testRemoveCoinsFromCoinsNoRemove() public {
        // Initialize an array of coins
        Cosmos.Coin[] memory coins = new Cosmos.Coin[](2);
        coins[0] = Cosmos.Coin(200, "btc");
        coins[1] = Cosmos.Coin(300, "eth");

        // Call removeCoinFromCoins with a coin that is not in the array
        (Cosmos.Coin[] memory newCoins, uint256 amt) =
            PureUtils.removeCoinFromCoins(coins, "bnb");

        // Check that the returned array is the same as the original
        assertEq(newCoins.length, 2);
        assertEq(newCoins[0].denom, "btc");
        assertEq(newCoins[0].amount, 200);
        assertEq(newCoins[1].denom, "eth");
        assertEq(newCoins[1].amount, 300);

        // Check that the returned amount is zero
        assertEq(amt, 0);
    }

    function testIsCoinInCoins(string memory _a) public {
        Cosmos.Coin[] memory coins = new Cosmos.Coin[](2);
        coins[0] = Cosmos.Coin(200, "btc");
        coins[1] = Cosmos.Coin(300, _a);

        bool isCoinInCoins = PureUtils.isCoinInCoins(coins, _a);
        assertTrue(isCoinInCoins);
    }

    function testIsCoinNotInCoins(string memory _a) public {
        vm.assume(!PureUtils.isStringSame(_a, "btc"));

        Cosmos.Coin[] memory coins = new Cosmos.Coin[](1);
        coins[0] = Cosmos.Coin(200, "btc");

        bool isCoinInCoins = PureUtils.isCoinInCoins(coins, _a);
        assertFalse(isCoinInCoins);
    }

    function testIsStringSameEmptyStrings() public {
        assertTrue(PureUtils.isStringSame("", ""));
    }

    function testRemoveCoinFromCoinsEmptyArray() public {
        Cosmos.Coin[] memory coins = new Cosmos.Coin[](0);
        (Cosmos.Coin[] memory newCoins, uint256 amt) =
            PureUtils.removeCoinFromCoins(coins, "btc");
        assertEq(newCoins.length, 0);
        assertEq(amt, 0);
    }

    function testIsCoinInCoinsEmptyArray() public {
        Cosmos.Coin[] memory coins = new Cosmos.Coin[](0);
        assertFalse(PureUtils.isCoinInCoins(coins, "btc"));
    }

    function testIsStringSameLongStrings() public {
        string memory longString1 = new string(256); // replace with the actual maximum length string
        string memory longString2 = new string(256); // similar to above
        assertTrue(PureUtils.isStringSame(longString1, longString2));
    }

    function testRemoveCoinFromCoinsLargeArray() public {
        uint256 largeSize = 256; // adjust size as necessary
        Cosmos.Coin[] memory coins = new Cosmos.Coin[](largeSize);
        for (uint256 i = 0; i < largeSize; i++) {
            coins[i] = Cosmos.Coin(i, "eth");
        }
        // Continue with the test logic...
    }

    function testIsStringSameSpecialChars() public {
        assertTrue(PureUtils.isStringSame("hello$%^&*", "hello$%^&*"));
        assertFalse(PureUtils.isStringSame("hello$%^&*", "different$%^&*"));
    }

    function testRemoveCoinFromCoinsRepeatedDenoms() public {
        Cosmos.Coin[] memory coins = new Cosmos.Coin[](3);
        coins[0] = Cosmos.Coin(100, "btc");
        coins[1] = Cosmos.Coin(200, "btc");
        coins[2] = Cosmos.Coin(300, "eth");

        (Cosmos.Coin[] memory newCoins, uint256 amt) =
            PureUtils.removeCoinFromCoins(coins, "btc");
        assertEq(newCoins.length, 1);
        assertEq(newCoins[0].denom, "eth");
        assertEq(amt, 300); // The sum of amounts of "btc"
    }
}
