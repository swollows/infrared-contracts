// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Scripts etc.
import {Script} from "forge-std/Script.sol";
import {Validators, AddressesAddress} from "./Configuration.sol";
import {Addreses} from "./Addresses.sol";

// Contracts.
import {Infrared} from "@core/Infrared.sol";

// Script to setup the validators in the infrared contract.
contract SetupValidators is Script {
    function run() public {
        vm.startBroadcast();

        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Load the Infrared contract.
        Infrared infrared = Infrared(addresses.infrared());

        // Add the validators.
        address[] memory validators = new address[](4);

        validators[0] = Validators.VAL_0;
        validators[1] = Validators.VAL_1;
        validators[2] = Validators.VAL_2;
        validators[3] = Validators.VAL_3;

        infrared.addValidators(validators);

        vm.stopBroadcast();
    }
}
