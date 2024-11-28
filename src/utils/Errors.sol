// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library Errors {
    // General errors.
    error ZeroAddress();
    error ZeroAmount();
    error ZeroBytes();
    error OverFlow();
    error UnderFlow();
    error InvalidArrayLength();
    error AlreadySet();

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
    error IREDNotRewardToken();
    error IBGTNotStakingToken();
    error StakedInRewardsVault();
    error NoRewardsVault();
    error RegistrationPaused();
    error RewardTokenNotWhitelisted();

    // InfraredValidators errors.
    error InvalidValidator();
    error InvalidOperator();
    error InvalidDepositAmount();

    // Infrared errors.
    error VaultNotSupported();
    error VaultNotStaked();
    error ClaimDistrRewardsFailed();
    error ClaimableRewardsExist();
    error DuplicateAssetAddress();
    error VaultDeploymentFailed();
    error RewardTokenNotSupported();
    error BGTBalanceMismatch();
    error NotInfrared();
    error NotInitialized();
    error InvalidFee();
    error InvalidCommissionRate();
    error InvalidDelegatee();
    error InvalidWeight();
    error MaxProtocolFeeAmount();
    error BoostExceedsSupply();
    error ETHTransferFailed();
}
