// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IIBERAClaimor {
    event Queue(address indexed receiver, uint256 amount, uint256 claim);
    event Sweep(address indexed receiver, uint256 amount, uint256 claim);

    /// @notice Outstanding BERA claims for a receiver
    /// @param receiver The address of the claims receiver
    function claims(address receiver) external view returns (uint256);

    /// @notice Queues a new BERA claim for a receiver
    /// @param receiver The address of the claims receiver
    function queue(address receiver) external payable;

    /// @notice Sweeps oustanding BERA claims for a receiver to their address
    /// @param receiver The address of the claims receiver
    function sweep(address receiver) external;
}
