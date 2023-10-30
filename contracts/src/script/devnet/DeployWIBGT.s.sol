// SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

import {Script} from 'forge-std/Script.sol';
import {Precompiles, AddressesAddress, Actors} from './Configuration.sol';
import {Addreses} from './Addresses.sol';

import {WrappedIBGT} from '@core/WIBGT.sol';
import {IERC20} from '@openzeppelin/token/ERC20/IERC20.sol';
import {InfraredVault} from '@core/InfraredVault.sol';
import {Infrared} from '@core/Infrared.sol';
import {IInfraredVault} from '@interfaces/IInfraredVault.sol';

// Deploy this as the governance private key.
contract DeployWIBGT is Script {
    function run() public {
        vm.startBroadcast();

        new WIBGTFactory();

        vm.stopBroadcast();
    }
}

// Deploy as the default admin private key.
contract WIBGTFactory {
    constructor() {}

    function deploy() external {
        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Deploy the wibgt token.
        WrappedIBGT wibgt = new WrappedIBGT(IERC20(addresses.ibgt()));

        // Setup the rewards.
        address[] memory rewards = new address[](1);
        rewards[0] = addresses.ibgt();

        // Deploy and infrared vault that takes in the wrapped token.
        InfraredVault wibgtVault = new InfraredVault(
            address(wibgt),
            'Wrapped IBGT Vault',
            'WIBGT-V',
            rewards,
            addresses.infrared(),
            address(101), // No need for a pool address.
            Precompiles.REWARDS_PRECOMPILE,
            Precompiles.DISTRIBUTION_PRECOMPILE,
            Actors.DEFAULT_ADMIN
        );

        // Update the wibgt token in the addresses contract.
        addresses.setWibgt(address(wibgt));

        // Update the wibgt vault in the addresses contract.
        addresses.setWibgtVault((address(wibgtVault)));

        // Grant the actors the roles.
        wibgt.grantRole(wibgt.DEFAULT_ADMIN_ROLE(), Actors.DEFAULT_ADMIN);
    }
}

// Run as the governance
contract ConfigureWIBGT is Script {
    function run() public {
        vm.startBroadcast();

        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Load the wibgt token.
        address wibgt = addresses.wibgt();

        // Load the wibgt vault token.
        address wibgtVault = addresses.wibgtVault();

        // Load the infrared contract.
        address infrared = addresses.infrared();

        address[] memory rewards = new address[](1);
        rewards[0] = addresses.ibgt();

        // Set the wibgt vault in the infrared contract.
        Infrared(infrared).updateWIBGTVault(IInfraredVault(wibgtVault), rewards);

        // Set the vault in the in wibgt token.
        WrappedIBGT(wibgt).setVault(InfraredVault(addresses.wibgtVault()));

        // Approve the vault to transfer the wibgt and vault share tokens.
        WrappedIBGT(wibgt).approveVault();

        vm.stopBroadcast();
    }
}
