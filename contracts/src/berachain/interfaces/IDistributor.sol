// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import {IPOLErrors} from "./IPOLErrors.sol";

/// @notice Interface of the Distributor contract.
interface IDistributor is IPOLErrors {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                           EVENTS                           */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    event Distributed(
        address indexed valCoinbase,
        uint256 indexed blockNumber,
        address indexed receiver,
        uint256 amount
    );

    function prover() external view returns (address);

    function getNextActionableBlock() external view returns (uint256);

    function getLastActionedBlock() external view returns (uint256);

    /**
     * @notice Distribute the rewards to the cutting board receivers.
     * @param coinbase The validator's coinbase address.
     * @param blockNumber The block number to distribute the rewards for.
     * @dev This is only callable by the `prover` contract.
     */
    function distributeFor(address coinbase, uint256 blockNumber) external;
}
