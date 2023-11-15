// SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

import {Script, console2} from 'forge-std/Script.sol';
import {Addreses} from './Addresses.sol';
import {AddressesAddress} from './Configuration.sol';

contract GetAddresses is Script {
    function run() public view {
        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Log the IBGT address.
        console2.log('IBGT: ', addresses.ibgt());

        // Log the Infrared address.
        console2.log('Infrared: ', addresses.infrared());

        // Log the wIBGT address.
        console2.log('WIBGT Token: ', addresses.wibgt());

        // Log the wIBGT Vault address.
        console2.log('WIBGT Vault: ', addresses.wibgtVault());

        // Log the USDC Vault address.
        console2.log('USDC Vault: ', addresses.usdcVault());
    }
}
