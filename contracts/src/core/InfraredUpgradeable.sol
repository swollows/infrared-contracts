// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {AccessControlUpgradeable} from
    "@openzeppelin-upgradeable/access/AccessControlUpgradeable.sol";
import {
    UUPSUpgradeable,
    ERC1967Utils
} from "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {Errors} from "@utils/Errors.sol";
import {IInfraredUpgradeable} from "@interfaces/IInfraredUpgradeable.sol";

/**
 * @title InfraredUpgradeable
 * @notice This contract provides base upgradeability functionality for Infrared.
 */
abstract contract InfraredUpgradeable is
    UUPSUpgradeable,
    AccessControlUpgradeable,
    IInfraredUpgradeable
{
    // Access control constants.
    bytes32 public constant KEEPER_ROLE = keccak256("KEEPER_ROLE");
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    modifier onlyKeeper() {
        _checkRole(KEEPER_ROLE);
        _;
    }

    modifier onlyGovernor() {
        _checkRole(GOVERNANCE_ROLE);
        _;
    }

    modifier whenInitialized() {
        if (_isInitializing()) revert Errors.NotInitialized();
        _;
    }

    constructor() {
        //. prevents implementation contracts from being used
        _disableInitializers();
    }

    function __InfraredUpgradeable_init() internal onlyInitializing {
        __UUPSUpgradeable_init();
        __AccessControl_init();
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyGovernor
    {
        // allow only owner to upgrade the implementation
        // will be called by upgradeToAndCall
    }

    function currentImplementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
