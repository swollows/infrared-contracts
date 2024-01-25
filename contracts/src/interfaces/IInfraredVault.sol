// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

interface IInfraredVault {
    /**
     * @notice Returns the withdraw address for the rewards and distribution modules.
     */
    function getWithdrawAddress() external view returns (address);

    /**
     * @notice Claims all the rewards for this vault.
     * @dev    This function can only be called by the INFRARED.
     * @return _amt uint256 The amount of `abgt` that was claimed to the withdraw address.
     */
    function claimRewardsPrecompile() external returns (uint256 _amt);

    /**
     * @notice Add a reward to the vault and the period that it will be distributed over.
     * @param _rewardsToken    address The address of the rewards token.
     * @param _rewardsDuration address The duration of the rewards to be distributed over.
     */
    function addReward(address _rewardsToken, uint256 _rewardsDuration)
        external;

    /**
     * @notice Notify the vault that a reward has been added.
     * @param _rewardToken address The address of the reward token.
     * @param _reward      uint256 The amount of the reward.
     */
    function notifyRewardAmount(address _rewardToken, uint256 _reward)
        external;

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
     * @return reward Reward The reward data.
     */
    function rewardData(address _rewardsToken)
        external
        returns (Reward memory reward);
}
