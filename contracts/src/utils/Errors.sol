// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

library Errors {
    // General errors.
    error ZeroAddress();
    error ZeroAmount();
    error OverFlow();

    // ValidatorSet errors.
    error ValidatorAlreadyExists();
    error FailedToAddValidator();
    error ValidatorDoesNotExist();
    error FailedToRemoveValidator();

    // Berachain interaction errors.
    error DenomNotFound(string denom);
    error FailedToConvertCoin(string denom, uint256 amount);
    error WrongDataResponse();
    error DelegateCallFailed();
    error SetWithdrawAddressFailed();

    // InfraredVault errors.
    error WithdrawAddressNotSet();
    error MaxNumberOfRewards();

    // InfraredValidators errors.
    error InvalidValidator();

    // Infrared errors.
    error VaultNotSupported();
    error ClaimDistrRewardsFailed();
    error DuplicatePoolAddress();
    error VaultDeploymentFailed();
    error RewardTokenNotSupported();
    error BGTBalanceMismatch();
}
