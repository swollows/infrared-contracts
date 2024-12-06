// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {AccessControlUpgradeable} from
    "@openzeppelin-upgradeable/access/AccessControlUpgradeable.sol";
import {
    UUPSUpgradeable,
    ERC1967Utils
} from "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import {Errors} from "src/utils/Errors.sol";

import {IInfrared} from "src/interfaces/IInfrared.sol";
import {IInfraredUpgradeable} from "src/interfaces/IInfraredUpgradeable.sol";

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

    /// @inheritdoc IInfraredUpgradeable
    IInfrared public immutable infrared;

    modifier onlyKeeper() {
        _checkRole(KEEPER_ROLE);
        _;
    }

    modifier onlyGovernor() {
        _checkRole(GOVERNANCE_ROLE);
        _;
    }

    modifier onlyInfrared() {
        if (msg.sender != address(infrared)) revert Errors.NotInfrared();
        _;
    }

    modifier whenInitialized() {
        uint64 _version = _getInitializedVersion();
        if (_version == 0 || _version == type(uint64).max) {
            revert Errors.NotInitialized();
        }
        _;
    }

    constructor(address _infrared) {
        // _infrared == address(0) means this is infrared
        infrared = IInfrared(_infrared);
        // prevents implementation contracts from being used
        _disableInitializers();
    }

    /// @dev Overrides to check role on infrared contract
    function _checkRole(bytes32 role, address account)
        internal
        view
        virtual
        override
    {
        if (infrared == IInfrared(address(0))) {
            super._checkRole(role, account);
        } else if (!infrared.hasRole(role, account)) {
            revert AccessControlUnauthorizedAccount(account, role);
        }
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
