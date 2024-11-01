// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IBGT} from "@berachain/pol/interfaces/IBGT.sol";
import {IBerachainBGTStaker} from "@interfaces/IBerachainBGTStaker.sol";

interface IBerachainBGT is IBGT {
    /// @dev Temp override of interface to include left out staker view
    function staker() external view returns (IBerachainBGTStaker);
}
