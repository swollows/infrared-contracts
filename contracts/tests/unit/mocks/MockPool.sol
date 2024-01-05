// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract MockPool {
    // Example state variable
    uint256 public totalLiquidity;

    constructor() {
        totalLiquidity = 1000; // Arbitrary value for illustration
    }

    // Example function
    function getPoolInfo() public view returns (uint256 liquidity) {
        return totalLiquidity;
    }
}
