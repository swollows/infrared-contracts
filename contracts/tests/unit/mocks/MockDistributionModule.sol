// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Cosmos} from '@polaris/CosmosTypes.sol';

contract MockDistributionModule {
    /**
     * @dev The caller (msg.sender) can set the address that will receive the deligation rewards.
     * @param withdrawAddress The address to set as the withdraw address.
     */
    function setWithdrawAddress(address withdrawAddress) external returns (bool) {}

    /**
     * @dev Withdraw the rewrads accumilated by the caller(msg.sender). Returns the rewards claimed.
     * @param delegator The delegator to withdraw the rewards from.
     * @param validator The validator to withdraw the rewards from.
     */
    function withdrawDelegatorReward(address delegator, address validator) external returns (Cosmos.Coin[] memory) {}
}
