// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

/// @notice Interface of POL errors
interface IPOLErrors {
    error NotApprovedSender();
    error NotRootFollower();
    error NotProver();
    error NotStaker();
    error NotBGT();
    error NotBlockRewardController();
    error NotDistributor();
    error NotFeeCollector();
    error NotFriendOfTheChef();
    error NotGovernance();
    error NotOperator();
    error NotValidatorOrOperator();
    error NotEnoughBalance();
    error NotEnoughTime();
    error InvalidMinter();
    error InvalidStartBlock();
    error InvalidCuttingBoardWeights();
    error InvalidCommission();
    error QueuedCuttingBoardNotReady();
    error QueuedCuttingBoardNotFound();
    error TooManyWeights();
    error AlreadyInitialized();
    error VaultAlreadyExists();
    error ZeroAddress();
    error ProvidedRewardTooHigh();
    error CannotRecoverRewardToken();
    error CannotRecoverStakingToken();
    error RewardCycleNotEnded();
    error StakeAmountIsZero();
    error WithdrawAmountIsZero();
    error PayoutAmountIsZero();
    error PayoutTokenIsZero();
    error MaxNumWeightsPerCuttingBoardIsZero();
    error TokenNotWhitelisted();
    error NoWhitelistedTokens();
    error InsufficientSelfStake();
    error TokenAlreadyWhitelistedOrLimitReached();
    error AmountLessThanMinIncentiveRate();
    error InvalidMaxIncentiveTokensCount();

    /// @dev Unauthorized caller
    error Unauthorized(address);
    /// @dev The queried block is not in the buffer range
    error BlockNotInBuffer();
    /// @dev distributeFor was called with a block number that is not the next actionable block
    error NotActionableBlock();
    /// @dev The block number does not exist yet
    error BlockDoesNotExist();
    error InvariantCheckFailed();
}
