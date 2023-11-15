// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {IERC20} from '@openzeppelin/token/ERC20/IERC20.sol';

interface IERC20Mintable is IERC20 {
    function mint(address to, uint256 amount) external;
}
