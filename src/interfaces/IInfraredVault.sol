// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IRewardVault as IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IRewardVault.sol";
import {IMultiRewards} from "./IMultiRewards.sol";

interface IInfraredVault is IMultiRewards {
    /**
     * @notice Returns the Infrared protocol coordinator
     * @return The address of the Infrared contract
     */
    function infrared() external view returns (address);

    /**
     * @notice Returns the associated Berachain rewards vault
     * @return The rewards vault contract instance
     */
    function rewardsVault() external view returns (IBerachainRewardsVault);

    /**
     * @notice Updates reward duration for a specific reward token
     * @dev Only callable by Infrared contract
     * @param _rewardsToken The address of the reward token
     * @param _rewardsDuration The new duration in seconds
     * @custom:access-control Requires INFRARED_ROLE
     */
    function updateRewardsDuration(
        address _rewardsToken,
        uint256 _rewardsDuration
    ) external;

    /**
     * @notice Toggles pause state of the vault
     * @dev Affects all vault operations when paused
     * @custom:access-control Requires INFRARED_ROLE
     */
    function togglePause() external;

    /**
     * @notice Adds a new reward token to the vault
     * @dev Cannot exceed maximum number of reward tokens
     * @param _rewardsToken The reward token to add
     * @param _rewardsDuration The reward period duration
     * @custom:access-control Requires INFRARED_ROLE
     */
    function addReward(address _rewardsToken, uint256 _rewardsDuration)
        external;

    /**
     * @notice Notifies the vault of newly added rewards
     * @dev Updates internal reward rate calculations
     * @param _rewardToken The reward token address
     * @param _reward The amount of new rewards
     */
    function notifyRewardAmount(address _rewardToken, uint256 _reward)
        external;

    /**
     * @notice Recovers accidentally sent tokens
     * @dev Cannot recover staking token or active reward tokens
     * @param _to The address to receive the recovered tokens
     * @param _token The token to recover
     * @param _amount The amount to recover
     */
    function recoverERC20(address _to, address _token, uint256 _amount)
        external;
}
