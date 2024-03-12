// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @notice The deposit function allows users to deposit EVM balance (BERA) into the contract.
 * It mints an equivalent amount of WBERA tokens and assigns them to the sender.
 */
interface IWBERA {
    function deposit() external payable;
}
