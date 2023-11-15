// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console2} from 'forge-std/Script.sol';
import {Precompiles, Actors} from './Configuration.sol';

// Contracts.
import {IBGT} from '@core/IBGT.sol';
import {Infrared} from '@core/Infrared.sol';
import {IERC20Mintable} from '@interfaces/IERC20Mintable.sol';

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
