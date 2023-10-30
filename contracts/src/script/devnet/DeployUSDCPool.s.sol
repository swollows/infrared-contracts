// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Scripts etc.
import {Script, console2} from 'forge-std/Script.sol';
import {Validators, Precompiles, AddressesAddress, Actors, GenesisPools} from './Configuration.sol';
import {Addreses} from './Addresses.sol';

// Contracts.
import {IBGT} from '@core/IBGT.sol';
import {Infrared} from '@core/Infrared.sol';
import {IERC20Mintable} from '@interfaces/IERC20Mintable.sol';

contract DeployUSDCPool is Script {
    function run() public {
        vm.startBroadcast();

        USDCPoolFactory factory = new USDCPoolFactory();

        // Give KEEPER ability to the factory so that it can register the pools.
        Infrared infrared = Infrared(Addreses(AddressesAddress.addr).infrared());
        infrared.grantRole(infrared.KEEPER_ROLE(), address(factory));

        vm.stopBroadcast();
    }
}

contract USDCPoolFactory {
    function deploy() public {
        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Load the infrared contract.
        Infrared infrared = Infrared(addresses.infrared());

        // Register the USDC-Honey Pool.
        address[] memory rewards = new address[](1);
        rewards[0] = addresses.ibgt();
        infrared.registerVault(
            GenesisPools.USDC_HONEY_POOL_TOKEN,
            'USDC-HONEY Vault',
            'USDC-HONEY-V',
            rewards,
            GenesisPools.USDC_HONEY_POOL_ADDRESS
        );
    }
}
