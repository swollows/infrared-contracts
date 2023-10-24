// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Cosmos} from '@polaris/CosmosTypes.sol';

contract MockRewardsModule {
    function withdrawDepositorRewards(address, address) external pure returns (Cosmos.Coin[] memory _coins) {}

    function setDepositorWithdrawAddress(address) external pure returns (bool _success) {}
}
