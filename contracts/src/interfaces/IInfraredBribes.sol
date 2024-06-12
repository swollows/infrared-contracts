// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IInfraredBribes {
    /// @notice Emitted when add validator to validator set elligible for bribes
    /// @param validator address The validator to add
    /// @param amountCumulative uint256 The snapshot of amountsCumulative to start bribe stream at
    event Added(address validator, uint256 amountCumulative);

    /// @notice Emitted when remove validator from validator set elligible for bribes
    /// @param validator address The validator to remove
    /// @param amountCumulative uint256 The snapshot of amountsCumulative to end bribe stream at
    event Removed(address validator, uint256 amountCumulative);

    /// @notice Emitted when notify bribes contract of new bribes
    /// @param amount uint256 The amount of bribe rewards added to contract
    /// @param num uint256 The number of current validators in the validator set
    event Notified(uint256 amount, uint256 num);

    /// @notice Emitted when validator claims outstanding bribes owed
    /// @param recipient address The address of the recipient of the claimed bribes
    /// @param amount uint256 The amount of bribes claimed
    event Claimed(address recipient, uint256 amount);

    /// @notice Adds a validator to validator set to track bribe status
    /// @dev Only callable by infrared coordinator
    /// @param validator address The validator to add
    function add(address validator) external;

    /// @notice Removes a validator from validator set to stop bribing
    /// @dev Only callable by infrared coordinator
    /// @param validator address The validator to remove
    function remove(address validator) external;

    /// @notice Notifies bribe contract of new bribes to be distributed to existing validator set
    /// @dev Bribe collector must call this after auctioning off bribes for payout token
    /// @param amount uint256 The amount of bribe token to distribute equally amongst validator set
    function notifyRewardAmount(uint256 amount) external;

    /// @notice Claims outstanding bribes owed for validator
    /// @param recipient address The address for validator to send their owed bribes
    function claim(address recipient) external;
}
