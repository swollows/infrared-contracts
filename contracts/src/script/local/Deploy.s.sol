// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console2} from 'forge-std/Script.sol';
import {Precompiles, Actors, Validators} from './Configuration.sol';

// Contracts.
import {IBGT} from '@core/IBGT.sol';
import {Infrared} from '@core/Infrared.sol';
import {IERC20Mintable} from '@interfaces/IERC20Mintable.sol';
import {WrappedIBGT} from '@core/WIBGT.sol';
import {IERC20} from '@openzeppelin/token/ERC20/IERC20.sol';
import {InfraredVault} from '@core/InfraredVault.sol';
import {IInfraredVault} from '@interfaces/IInfraredVault.sol';

// Deploys the IBGT token.
contract DeployIBGT is Script {
    function run() public {
        vm.startBroadcast();

        // Deploy the ibgt token.
        new IBGT();

        vm.stopBroadcast();
    }
}

// Deploys the main Infrared contract.
contract DeployInfrared is Script {
    function run() public {
        vm.startBroadcast();

        // Load the address from the environment.
        address ibgtAddress = vm.envOr('IBGT_ADDRESS', address(0));

        // Deploy the infrared contract.
        new Infrared(
            Precompiles.REWARDS_PRECOMPILE,
            Precompiles.DISTRIBUTION_PRECOMPILE,
            Precompiles.ERC20_PRECOMPILE,
            Precompiles.STAKING_PRECOMPILE,
            'abgt',
            Actors.DEFAULT_ADMIN,
            IERC20Mintable(ibgtAddress)
        );

        vm.stopBroadcast();
    }
}

contract ConfigurePermissions is Script {
    function run() public {
        vm.startBroadcast();

        // Load the address from the environment.
        address infraredAddress = vm.envOr('INFRARED_ADDRESS', address(0));
        address ibgtAddress = vm.envOr('IBGT_ADDRESS', address(0));

        Infrared infrared = Infrared(infraredAddress);
        IBGT ibgt = IBGT(ibgtAddress);

        // Grant the infrared contract minting rights over ibgt.
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        // Grant the KEEPER role.
        infrared.grantRole(infrared.KEEPER_ROLE(), Actors.KEEPER);

        // Grant the GOVERNANCE role.
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), Actors.GOVERNANCE);

        vm.stopBroadcast();
    }
}

contract SetupValidators is Script {
    function run() public {
        vm.startBroadcast();

        address[] memory validators = new address[](1);
        validators[0] = Validators.VAL_0;

        // Load the address from the environment.
        address infraredAddress = vm.envOr('INFRARED_ADDRESS', address(0));
        Infrared infrared = Infrared(infraredAddress);

        infrared.addValidators(validators);

        vm.stopBroadcast();
    }
}

contract DeployWIBGT is Script {
    function run() public {
        vm.startBroadcast();

        address ibgtAddress = vm.envOr('IBGT_ADDRESS', address(0));
        new WrappedIBGT(IERC20(ibgtAddress));

        vm.stopBroadcast();
    }
}

contract ConfigureWIBGT is Script {
    function run() public {
        vm.startBroadcast();

        // Load the wibgt-vault address.
        address wibgtAddress = vm.envOr('WIBGT_ADDRESS', address(0));
        address wibgtVaultAddress = vm.envOr('WIBGT_VAULT_ADDRESS', address(0));
        address ibgtAddress = vm.envOr('IBGT_ADDRESS', address(0));
        address infraredAddress = vm.envOr('INFRARED_ADDRESS', address(0));

        WrappedIBGT wibgt = WrappedIBGT(wibgtAddress);
        wibgt.grantRole(wibgt.DEFAULT_ADMIN_ROLE(), Actors.DEFAULT_ADMIN);

        // Update the wibgt vault in the infrared contract.
        address[] memory rewards = new address[](1);
        rewards[0] = ibgtAddress;
        Infrared(infraredAddress).updateWIBGTVault(IInfraredVault(wibgtVaultAddress), rewards);

        // // Set the vault in the wibgt contract.
        WrappedIBGT(wibgtAddress).setVault(InfraredVault(wibgtVaultAddress));
        WrappedIBGT(wibgtAddress).approveVault();

        vm.stopBroadcast();
    }
}
