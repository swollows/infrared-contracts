// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IStakingRewards} from "./IStakingRewards.sol";

interface IBGTStaker is IStakingRewards {
    /// @notice Gets the reward for the staked BGT.
    function getReward() external returns (uint256);
}
