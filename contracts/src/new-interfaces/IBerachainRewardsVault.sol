// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

interface IBerachainRewardsVault {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Emitted when a reward has been added to the vault.
     * @param reward The amount of reward added.
     */
    event RewardAdded(uint256 reward);

    /**
     * @notice Emitted when a user has staked.
     * @param user The user that has staked.
     * @param amount The amount of staked.
     */
    event Staked(address indexed user, uint256 amount);

    /**
     * @notice Emitted when a user has withdrawn.
     * @param user The user that has withdrawn.
     * @param amount The amount of withdrawn.
     */
    event Withdrawn(address indexed user, uint256 amount);

    /**
     * @notice Emitted when a user has claimed reward.
     * @param user The user that has claimed reward.
     * @param to The address that the reward was claimed to. (user or operator).
     * @param reward The amount of reward claimed.
     */
    event RewardPaid(address indexed user, address to, uint256 reward);

    /**
     * @notice Emitted when the reward duration has been updated.
     * @param newDuration The new duration of the reward.
     */
    event RewardsDurationUpdated(uint256 newDuration);

    /**
     * @notice Emitted when a token has been recovered.
     * @param token The token that has been recovered.
     * @param amount The amount of token recovered.
     */
    event Recovered(address token, uint256 amount);

    /**
     * @notice Emitted when the msg.sender has set an operator to handle its rewards.
     * @param user The user that has set the operator.
     * @param operator The operator that has been set.
     */
    event SetOperator(address user, address operator);

    /// @notice Emitted when the distributor is set.
    event SetDistributor(address indexed rewardDistribution);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                          GETTERS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Get the balance of the staked tokens for a user.
     * @param account The user to get the balance for.
     * @return The balance of the staked tokens for the user.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @notice Get the amount of reward that the user has earned.
     * @return The total balance of the staked tokens.
     */
    function earned(address account) external view returns (uint256);

    /**
     * @notice Get the duration of the reward.
     * @return The duration of the reward.
     */
    function getRewardForDuration() external view returns (uint256);

    /**
     * @notice Get the last time the reward was applicable.
     * @return The last time the reward was applicable.
     */
    function lastTimeRewardApplicable() external view returns (uint256);

    /**
     * @notice Get the reward per token.
     * @return The reward per token.
     */
    function rewardPerToken() external view returns (uint256);

    /**
     * @notice Get the address that is allowed to distribute rewards.
     * @return The address that is allowed to distribute rewards.
     */
    function distributor() external view returns (address);

    /**
     * @notice Get the totalSupply of the staked tokens in the vault.
     * @return The last time the reward was updated.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @notice Get the operator for a user.
     * @param user The user to get the operator for.
     * @return The operator for the user.
     */
    function operator(address user) external view returns (address);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         ADMIN                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Initialize the vault, this is only callable once and by the factory since its the deployer.
     * @param _bgt The address of the BGT token.
     * @param _stakingToken The address of the staking token.
     * @param _distributor The address of the distributor.
     * @param _governance The address of the governance.
     */
    function initialize(
        address _bgt,
        address _stakingToken,
        address _distributor,
        address _governance
    ) external;

    /**
     * @notice Allows the owner to set the contract that is allowed to distribute rewards.
     * @param _rewardDistribution The address that is allowed to distribute rewards.
     */
    function setDistributor(address _rewardDistribution) external;

    /**
     * @notice Allows the  distributor to notify the reward amount.
     * @param reward The amount of reward to notify.
     */
    function notifyRewardAmount(uint256 reward) external;

    /**
     * @notice Allows the owner to recover any ERC20 token from the vault.
     * @param tokenAddress The address of the token to recover.
     * @param tokenAmount The amount of token to recover.
     */
    function recoverERC20(address tokenAddress, uint256 tokenAmount) external;

    /**
     * @notice Allows the owner to update the duration of the rewards.
     * @param _rewardsDuration The new duration of the rewards.
     */
    function setRewardsDuration(uint256 _rewardsDuration) external;

    /**
     * @notice Allows the owner to update the pause state of the vault.
     * @param _paused The new pause state of the vault.
     */
    function pause(bool _paused) external;

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                         MUTATIVE                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Exit the vault with the staked tokens and claim the reward.
     */
    function exit() external;

    /**
     * @notice Claim the reward.
     * @notice if the operator is the one calling this method then the reward will be credited to that address.
     * @param user The user to claim the reward for.
     */
    function getReward(address user) external;

    /**
     * @notice Stake the tokens in the vault.
     * @param amount The amount of tokens to stake.
     */
    function stake(uint256 amount) external;

    /**
     * @notice Withdraw the staked tokens from the vault.
     * @param amount The amount of tokens to withdraw.
     */
    function withdraw(uint256 amount) external;

    /**
     * @notice Allows msg.sender to set another address to claim and manage their rewards.
     * @param _operator The address that will be allowed to claim and manage rewards.
     */
    function setOperator(address _operator) external;
}
