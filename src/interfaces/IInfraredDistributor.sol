// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IInfraredDistributor {
    /// @notice Returns amounts accumulator for rewards notified to contract per validator
    function amountsCumulative() external view returns (uint256);

    /// @notice Snapshot of the amounts accumulator
    struct Snapshot {
        /// amounts cumulative value at last claim
        uint256 amountCumulativeLast;
        /// amounts cumulative value at final claim
        uint256 amountCumulativeFinal;
    }

    /// @notice Returns the snapshot for a validator
    /// @param pubkey bytes The pubkey of the validator
    /// @return amountCumulativeLast The value of amounts cumulative at last claim
    /// @return amountCumulativeFinal The value of amount cumulative at final claim
    function snapshots(bytes memory pubkey)
        external
        view
        returns (uint256 amountCumulativeLast, uint256 amountCumulativeFinal);

    /// @notice Returns the amounts accumulator snapshot for a validator
    /// @param pubkey bytes The pubkey of the validator
    /// @return validator address The address that can claim for the validator
    function validators(bytes memory pubkey) external view returns (address);

    /// @notice Emitted when add validator to validator set elligible for commissions
    /// @param pubkey bytes The pubkey of the validator to add
    /// @param validator address The address of the validator to add
    /// @param amountCumulative uint256 The snapshot of amountsCumulative to start commission stream at
    event Added(bytes pubkey, address validator, uint256 amountCumulative);

    /// @notice Emitted when remove validator from validator set elligible for commissions
    /// @param pubkey bytes The pubkey of the validator to remove
    /// @param validator address The address of the validator to remove
    /// @param amountCumulative uint256 The snapshot of amountsCumulative to end commissions stream at
    event Removed(bytes pubkey, address validator, uint256 amountCumulative);

    /// @notice Emitted when purge validator from validator registry elligible for commissions
    /// @param pubkey bytes The pubkey fo the validator to remove
    event Purged(bytes pubkey, address validator);

    /// @notice Emitted when notify commissions contract of new commissions
    /// @param amount uint256 The amount of commission rewards added to contract
    /// @param num uint256 The number of current validators in the validator set
    event Notified(uint256 amount, uint256 num);

    /// @notice Emitted when validator claims outstanding commissions owed
    /// @param pubkey    bytes   The pubkey of the validator claiming
    /// @param validator address The address of the validator claiming
    /// @param recipient address The address of the recipient of the claimed commissions
    /// @param amount    uint256 The amount of commissions claimed
    event Claimed(
        bytes pubkey, address validator, address recipient, uint256 amount
    );

    /// @notice Adds a validator to validator set to track commission status
    /// @dev Only callable by infrared coordinator
    /// @param pubkey    bytes   The pubkey of the validator to add
    /// @param validator address The address of the validator to add
    function add(bytes calldata pubkey, address validator) external;

    /// @notice Removes a validator from validator set to stop commissions
    /// @dev Only callable by infrared coordinator. Does remove from registry in case claim after remove
    /// @param pubkey    bytes   The pubkey of the validator to remove
    function remove(bytes calldata pubkey) external;

    /// @notice Purges a validator from validator registry
    /// @dev Only callable if all outstanding commissions claimed
    /// @param pubkey    bytes   The pubkey of the validator to purge
    function purge(bytes calldata pubkey) external;

    /// @notice Notifies commission contract of new commissions to be distributed to existing validator set
    /// @param amount uint256 The amount of commission token to distribute equally amongst validator set
    function notifyRewardAmount(uint256 amount) external;

    /// @notice Claims outstanding commissions owed for validator
    /// @param pubkey    bytes   The pubkey of the validator to claim for
    /// @param recipient address The address for validator to send their owed commissions
    function claim(bytes calldata pubkey, address recipient) external;
}
