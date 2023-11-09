// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Scripts etc.
import {Script, console2} from "forge-std/Script.sol";
import {AddressesAddress} from "./Configuration.sol";
import {Addreses} from "./Addresses.sol";
import {Infrared} from "@core/Infrared.sol";

contract HarvestVault is Script {
    function run() public {
        vm.startBroadcast();

        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Load the Infrared contract.
        Infrared infrared = Infrared(addresses.infrared());

        // Call the harvest on the usdc vault.
        infrared.harvestVault(addresses.usdcVault());

        vm.stopBroadcast();
    }
}
