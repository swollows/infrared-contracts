// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Cosmos} from '@polaris/CosmosTypes.sol';

contract MockRewardsModule {
    function withdrawAllDepositorRewards(address receiver) external pure returns (Cosmos.Coin[] memory) {}

    function setDepositorWithdrawAddress(address) external pure returns (bool _success) {}
}
