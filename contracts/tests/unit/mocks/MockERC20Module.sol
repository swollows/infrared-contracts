// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {IERC20} from '@polaris/IERC20.sol';

contract MockERC20Module {
    function erc20AddressForCoinDenom(string calldata) external view returns (IERC20 _token) {}

    function transferCoinToERC20(string calldata, uint256) external pure returns (bool) {
        return true;
    }
}
