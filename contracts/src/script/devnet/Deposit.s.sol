// SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

import {Script, console2} from 'forge-std/Script.sol';
import {Addreses} from './Addresses.sol';
import {AddressesAddress, GenesisPools} from './Configuration.sol';
import {InfraredVault} from '@core/InfraredVault.sol';
import {IERC20} from '@openzeppelin/token/ERC20/IERC20.sol';

contract Deposit is Script {
    function run() public {
        vm.startBroadcast();

        // Load the addresses contract.
        Addreses addresses = Addreses(AddressesAddress.addr);

        // Load the usdc vault.
        InfraredVault usdcVault = InfraredVault(addresses.usdcVault());

        // Approve the vault to spend the LP tokens.
        IERC20(GenesisPools.USDC_HONEY_POOL_TOKEN).approve(address(usdcVault), type(uint256).max);

        // Deposit the LP tokens to the vault.
        usdcVault.deposit(
            1 ether, // Should have 1000's if not deposit in the dex.
            msg.sender
        );

        console2.log('Deposited 1 LP token to the usdc vault.');

        vm.stopBroadcast();
    }
}
