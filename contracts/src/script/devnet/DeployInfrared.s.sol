// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Scripts etc.
import {Script, console2} from 'forge-std/Script.sol';
import {Precompiles, AddressesAddress, Actors} from './Configuration.sol';
import {Addreses} from './Addresses.sol';

// Contracts.
import {IBGT} from '@core/IBGT.sol';
import {Infrared} from '@core/Infrared.sol';
import {IERC20Mintable} from '@interfaces/IERC20Mintable.sol';

// Deploy the Infrared contract.
contract DeployInfrared is Script {
    function run() public {
        vm.startBroadcast();

        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Deploy the ibgt token.
        IBGT ibgt = new IBGT();

        // Deploy the Infrared contract.
        Infrared infrared = new Infrared(
            Precompiles.REWARDS_PRECOMPILE,
            Precompiles.DISTRIBUTION_PRECOMPILE,
            Precompiles.ERC20_PRECOMPILE,
            Precompiles.STAKING_PRECOMPILE,
            'abgt',
            Actors.DEFAULT_ADMIN,
            IERC20Mintable(address(ibgt))
        );

        // Grant the infrared contract minting rights over ibgt.
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        // Grant the KEEPER role.
        infrared.grantRole(infrared.KEEPER_ROLE(), Actors.KEEPER);

        // Grant the GOVERNANCE role.
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), Actors.GOVERNANCE);

        // Grant the DEFAULT_ADMIN Governace rights.
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), Actors.DEFAULT_ADMIN);

        // Set the addresses in the addresses contract.
        addresses.setInfrared(address(infrared));
        addresses.setIbgt(address(ibgt));

        // Log the addresses.
        console2.log('Infrared: ', address(infrared));
        console2.log('IBGT: ', address(ibgt));

        vm.stopBroadcast();
    }
}
