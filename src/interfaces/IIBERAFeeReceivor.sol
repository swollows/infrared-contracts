// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IIBERAFeeReceivor {
    error Unauthorized();
    error InvalidAmount();

    event Sweep(address indexed receiver, uint256 amount, uint256 fees);
    event Collect(address indexed receiver, uint256 amount);

    /// @notice The address of IBERA
    function IBERA() external view returns (address);

    /// @notice Accumulated protocol fees in contract to be claimed by governor
    function protocolFees() external view returns (uint256);

    /// @notice Amount of BERA swept to IBERA and fees taken for protool on next call to sweep
    /// @return amount THe amount of BERA forwarded to IBERA on next sweep
    /// @return fees The protocol fees taken on next sweep
    function distribution()
        external
        view
        returns (uint256 amount, uint256 fees);

    /// @notice Sweeps accumulated coinbase priority fees + MEV to IBERA to autocompound principal
    function sweep() external returns (uint256 amount, uint256 fees);

    /// @notice Collects accumulated protocol fees
    /// @dev Reverts if msg.sender not IBERA governor
    /// @param recipient Address to send protocol fees to
    function collect(address recipient) external;
}
