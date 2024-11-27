// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockDistributor {
    address public token;

    constructor(address _token) {
        require(_token != address(0), "Token cannot be zero address");
        token = _token;
    }
}
