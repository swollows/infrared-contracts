// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MockStakingModule {
    function delegate(address, uint256) external returns (bool) {}

    function undelegate(address, uint256) external payable returns (bool) {}

    function beginRedelegate(address, address, uint256) external payable returns (bool) {}

    function cancelUnbondingDelegation(address, uint256, int64) external payable returns (bool) {}
}
