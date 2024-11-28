// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {ERC20PresetMinterPauser} from "../vendors/ERC20PresetMinterPauser.sol";

/**
 * @title RED
 * @notice This contract is the RED token.
 */
contract RED is ERC20PresetMinterPauser {
    address public immutable ibgt;
    address public immutable infrared;

    constructor(address _ibgt, address _infrared)
        ERC20PresetMinterPauser("Infared Governance Token", "RED")
    {
        ibgt = _ibgt;
        infrared = _infrared;

        _grantRole(MINTER_ROLE, infrared);
    }
}
