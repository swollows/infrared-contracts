// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Scripts etc.
import {Script, console2} from 'forge-std/Script.sol';
import {Validators, Precompiles, AddressesAddress, Actors} from './Configuration.sol';
import {Addreses} from './Addresses.sol';

// Contracts.
import {IBGT} from '@core/IBGT.sol';
import {Infrared} from '@core/Infrared.sol';
import {WrappedIBGT} from '@core/WIBGT.sol';
import {IERC20} from '@openzeppelin/token/ERC20/IERC20.sol';
import {InfraredVault} from '@core/InfraredVault.sol';
import {IInfraredVault} from '@interfaces/IInfraredVault.sol';

contract DeployWIBGTVault is Script {
    function run() public {
        vm.startBroadcast();

        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Deploy the wrapped ibgt token.
        WrappedIBGT wibgt = new WrappedIBGT(IERC20(addresses.ibgt()));

        // Setup the rewards for this vault.
        address[] memory rewards = new address[](1);
        rewards[0] = addresses.ibgt();

        // Deploy the Vault.
        InfraredVault wibgtVault = new InfraredVault(
            address(wibgt),
            'Wrapped IBGT Vault',
            'WIBGT-V',
            rewards,
            addresses.infrared(),
            address(101), // Fake since this is the IBGT vault.
            Precompiles.REWARDS_PRECOMPILE,
            Precompiles.DISTRIBUTION_PRECOMPILE,
            Actors.DEFAULT_ADMIN
        );

        // // Update the vault in the infrared contract.
        // Infrared infrared = Infrared(addresses.infrared());
        // infrared.updateWIBGTVault(IInfraredVault(address(wibgtVault)), rewards);

        // // Set in the addresses contract.
        // addresses.setWibgt(address(wibgt));
        // addresses.setWibgtVault(address(wibgtVault));

        // Log the addresses.
        console2.log('WIBGT: ', address(wibgt));
        console2.log('WIBGT Vault: ', address(wibgtVault));

        vm.stopBroadcast();
    }
}
