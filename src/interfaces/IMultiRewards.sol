// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IMultiRewards {
    function totalSupply() external view returns (uint256);

    // Reward data for a particular reward token.
    struct Reward {
        address rewardsDistributor;
        uint256 rewardsDuration;
        uint256 periodFinish;
        uint256 rewardRate;
        uint256 lastUpdateTime;
        uint256 rewardPerTokenStored;
    }

    /**
     * @notice Gets the reward data for a given rewards token.
     * @param _rewardsToken address The address of the rewards token.
     */
    function rewardData(address _rewardsToken)
        external
        returns (
            address rewardsDistributor,
            uint256 rewardsDuration,
            uint256 periodFinish,
            uint256 rewardRate,
            uint256 lastUpdateTime,
            uint256 rewardPerTokenStored
        );

    function stake(uint256 amount) external;

    function withdraw(uint256 amount) external;

    function getReward() external;

    function exit() external;
}
