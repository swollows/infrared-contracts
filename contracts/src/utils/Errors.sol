// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

library Errors {
    // General errors.
    error ZeroAddress();
    error ZeroAmount();
    error ZeroBytes();
    error OverFlow();
    error UnderFlow();
    error InvalidArrayLength();

    // ValidatorSet errors.
    error ValidatorAlreadyExists();
    error FailedToAddValidator();
    error ValidatorDoesNotExist();
    error FailedToRemoveValidator();

    // InfraredVault errors.
    error WithdrawAddressNotSet();
    error MaxNumberOfRewards();
    error Unauthorized(address sender);
    error NoRewardsHarvested();
    error IBGTNotRewardToken();
    error IBGTNotStakingToken();
    error StakedInRewardsVault();
    error NoRewardsVault();

    // InfraredValidators errors.
    error InvalidValidator();
    error InvalidDepositAmount();

    // Infrared errors.
    error VaultNotSupported();
    error VaultNotStaked();
    error ClaimDistrRewardsFailed();
    error DuplicateAssetAddress();
    error VaultDeploymentFailed();
    error RewardTokenNotSupported();
    error BGTBalanceMismatch();
    error NotInfrared();
    error NotInitialized();
    error InvalidProtocolFeeRate();
    error InvalidCommissionRate();
    error InvalidDelegatee();
    error MaxProtocolFeeAmount();
}
