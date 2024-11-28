// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {IERC20Mintable} from "./IERC20Mintable.sol";

interface IRED is IERC20Mintable, IAccessControl {
    /// @notice The address of the IBGT token
    function ibgt() external view returns (address);
    /// @notice The address of the Infrared contract
    function infrared() external view returns (address);
}
