// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library Errors {
    error ValidatorDoesNotExist(address _validator);
    error ValidatorAlreadyExists(address _validator);
    error ZeroAddress();
    error ZeroString();
    error ERC20ModuleTransferFailed();
    error VaultNotSupported(address _vault);
    error ZeroAmount();
    error SetWithdrawAddressFailed();
    error VaultAlreadyRegistered();
    error DelegationFailed();
    error UndelegateFailed();
    error BeginRedelegateFailed();
    error CancelUnbondingDelegationFailed();
    error ApprovalFailed();
    error ElementAlreadyExists();
    error FaliedToRemoveValidator();
    error FailedToAddValidator();
    error IncorrectArrayLength();
    error EmptyArray();
    error IncorrectInfraredVaultArray();
}
