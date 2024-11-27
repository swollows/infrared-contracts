// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockCollector {
    address public payoutToken;

    constructor(address _token) {
        require(_token != address(0), "Token cannot be zero address");
        payoutToken = _token;
    }
}
