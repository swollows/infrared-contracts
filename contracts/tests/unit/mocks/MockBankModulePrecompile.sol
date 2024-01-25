// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./MockERC20.sol";
import "@forge-std/console2.sol";

contract MockBankModule {
    MockERC20 public bgt;

    constructor(MockERC20 _bgt) {
        bgt = _bgt;
    }
    // Mapping to store mocked balances for accounts

    mapping(address => mapping(string => uint256)) public balances;

    // Set a balance for an account for testing
    function setBalance(address account, string memory denom, uint256 amount)
        public
    {
        balances[account][denom] = amount;
    }

    // Implementing getBalance function from the IBankModule interface
    function getBalance(address accountAddress, string calldata denom)
        external
        view
        returns (uint256)
    {
        if (isStringSame(denom, "abgt")) {
            return bgt.balanceOf(accountAddress);
        }
        return balances[accountAddress][denom];
    }

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
}
