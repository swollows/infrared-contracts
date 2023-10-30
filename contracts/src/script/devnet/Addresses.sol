// SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

import {Script} from 'forge-std/Script.sol';

// Contract that keeps track of a given deployment of the contracts.
contract Addreses {
    // Core contracts.
    address public ibgt;
    address public infrared;
    address public wibgt;
    address public wibgtVault;

    function setIbgt(address _ibgt) external {
        ibgt = _ibgt;
    }

    function setInfrared(address _infrared) external {
        infrared = _infrared;
    }

    function setWibgt(address _wibgt) external {
        wibgt = _wibgt;
    }

    function setWibgtVault(address _wibgtVault) external {
        wibgtVault = _wibgtVault;
    }
}

// Script top deploy the addresses contract.
contract DeployAddresses is Script {
    function run() public {
        vm.startBroadcast();

        new Addreses();

        vm.stopBroadcast();
    }
}
