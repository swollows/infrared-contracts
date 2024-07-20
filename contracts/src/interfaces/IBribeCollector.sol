// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IPOLErrors} from "@berachain/interfaces/IPOLErrors.sol";

interface IBribeCollector is IPOLErrors {
    /// @notice Emitted when the admin updates the payout amount.
    event PayoutAmountSet(
        uint256 indexed oldPayoutAmount, uint256 indexed newPayoutAmount
    );

    /// @notice Emitted when the dapp fees are donated.
    /// @param caller Caller of the `donate` function.
    /// @param amount The amount of fee/payout token that is transfered.
    event FeesDonated(address indexed caller, uint256 amount);

    /// @notice Emitted when the fees are claimed.
    /// @param caller Caller of the `claimFees` function.
    /// @param recipient The address to which collected dapp fees will be transferred.
    /// @param feeToken The address of the fee token to collect.
    /// @param amount The amount of fee token to transfer.
    event FeesClaimed(
        address indexed caller,
        address indexed recipient,
        address indexed feeToken,
        uint256 amount
    );

    /// @notice The ERC-20 token which must be used to pay for fees when claiming dapp fees.
    function payoutToken() external view returns (address);

    /// @notice The amount of payout token that is required to claim dapp fees of a particular token.
    /// @dev This works as first come first serve basis. whoever pays this much amount of the payout amount first will
    /// get the fees.
    function payoutAmount() external view returns (uint256);

    /// @notice Update the payout amount to a new value. Must be called by admin.
    /// @param _newPayoutAmount The value that will be the new payout amount.
    function setPayoutAmount(uint256 _newPayoutAmount) external;

    /**
     * @notice Claim collected dapp fees and transfer them to the recipient.
     * @param recipient The address to which collected dapp fees will be transferred.
     * @param feeTokens The addresses of the fee token to collect to the recipient.
     * @dev Caller need to pay the PAYMENT_AMOUNT of PAYOUT_TOKEN tokens.
     */
    function claimFees(address recipient, address[] calldata feeTokens)
        external;
}
