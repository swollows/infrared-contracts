// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IBerachainRewardsVault.sol";
import {IMultiRewards} from "./IMultiRewards.sol";

interface IInfraredVault is IMultiRewards {
    /// @notice The infrared core coordinate/factory contract address
    function infrared() external view returns (address);

    /// @notice The berachain rewards vault contract for the staking token
    function rewardsVault() external view returns (IBerachainRewardsVault);

    /**
     * @notice Update the rewards duration for a specific rewards token.
     * @dev    The token must be a valid rewards token and have a non-zero duration.
     * @param _rewardsToken    address The address of the rewards token.
     * @param _rewardsDuration uint256 The duration of the rewards to be distributed over.
     */
    function updateRewardsDuration(
        address _rewardsToken,
        uint256 _rewardsDuration
    ) external;

    /**
     * @notice Pause or Unpauses the vault.
     * @dev    This function is only callable by the infrared factory.
     */
    function togglePause() external;

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

    /**
     * @notice Recover ERC20 tokens that were accidentally sent to the contract.
     * @param _to     address The address to send the tokens to.
     * @param _token  address The address of the token to recover.
     * @param _amount uint256 The amount of the token to recover.
     */
    function recoverERC20(address _to, address _token, uint256 _amount)
        external;
}
