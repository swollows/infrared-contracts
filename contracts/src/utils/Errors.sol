// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

library Errors {
    // General errors.
    error ZeroAddress();
    error ZeroAmount();

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

    // InfraredVault errors.
    error WithdrawAddressNotSet();

    // InfraredValidators errors.
    error InvalidValidator();

    // Infrared errors.
    error VaultNotSupported();
    error ClaimDistrRewardsFailed();
    error DuplicatePoolAddress();
    error VaultDeploymentFailed();
}
