// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library IBERAConstants {
    uint256 public constant MINIMUM_DEPOSIT = 0.1 ether; // 1e17; TODO: fix if too large
    uint256 public constant MINIMUM_DEPOSIT_FEE = 0.01 ether; // TODO: fix for actual fee amount need to provide per deposit queue request; should include gas cost to keeper to execute
    uint256 public constant MINIMUM_WITHDRAW_FEE = 0.01 ether; // TODO: fix for actual fee amount need to provide per withdraw queue request; should include gas cost to keeper to execute
    uint256 public constant FORCED_MIN_DELAY = 7 days;
}
