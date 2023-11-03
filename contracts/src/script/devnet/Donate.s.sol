// SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

import {Script, console2} from 'forge-std/Script.sol';
import {Addreses} from './Addresses.sol';
import {AddressesAddress, GenesisPools} from './Configuration.sol';
import {InfraredVault} from '@core/InfraredVault.sol';
import {IERC20} from '@openzeppelin/token/ERC20/IERC20.sol';
import {IERC20DexModule} from '@berachain/ERC20Dex.sol';

contract Donate {
    function donate() public {
        IERC20DexModule dex = IERC20DexModule(0x0d5862FDbdd12490f9b4De54c236cff63B038074);

        // Get the pool options.
        IERC20DexModule.PoolOptions memory options = dex.getPoolOptions(GenesisPools.USDC_HONEY_POOL_ADDRESS);

        // Get the tokens in the pool.
        address[] memory tokens = new address[](options.weights.length);
        for (uint256 i = 0; i < options.weights.length; i++) {
            tokens[i] = options.weights[i].asset;
        }

        // Transfer the tokens from the msg sender to here.
        for (uint256 i = 0; i < tokens.length; i++) {
            IERC20 token = IERC20(tokens[i]);
            token.transferFrom(msg.sender, address(this), 100 ether);
        }

        // Max approve the tokens to the pool.
        for (uint256 i = 0; i < tokens.length; i++) {
            IERC20 token = IERC20(tokens[i]);
            token.approve(GenesisPools.USDC_HONEY_POOL_ADDRESS, type(uint256).max);
        }

        uint256[] memory amountsIn = new uint256[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            amountsIn[i] = 100 ether;
        }

        // Add liquidity to the pool. (100 USDC, 100 HONEY)
        dex.addLiquidity(
            GenesisPools.USDC_HONEY_POOL_ADDRESS,
            0x7DEB693e83E3525A6DC8a5E04DC50152F808d45d, // The usdc vault
            tokens,
            amountsIn
        );
    }
}

contract DonateScript is Script {
    function run() public {
        vm.startBroadcast();

        new Donate();

        vm.stopBroadcast();
    }
}
