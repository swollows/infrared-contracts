// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {ERC20PresetMinterPauser} from "../vendors/ERC20PresetMinterPauser.sol";

/**
 * @title IBGT
 * @notice This contract is the IBGT token.
 */
contract IBGT is ERC20PresetMinterPauser {
    address public immutable bgt;

    constructor(address _bgt) ERC20PresetMinterPauser("Infrared BGT", "iBGT") {
        bgt = _bgt;
    }
}
