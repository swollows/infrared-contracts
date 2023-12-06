// SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {InfraredVault} from "@core/InfraredVault.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {IERC20DexModule} from "@berachain/ERC20Dex.sol";

// This contract is used to donate LP tokens to the infrared vault of choice.
contract Donate {
    function donate(address pool, address vault) external {
        // The wrapper around the dex module to allow for easy use with erc20s.
        IERC20DexModule dex =
            IERC20DexModule(0x0d5862FDbdd12490f9b4De54c236cff63B038074);

        // Get the pool options.
        IERC20DexModule.PoolOptions memory options = dex.getPoolOptions(pool);

        // Get the tokens in the pool.
        address[] memory tokens = new address[](options.weights.length);
        for (uint256 i = 0; i < options.weights.length; i++) {
            tokens[i] = options.weights[i].asset;
        }

        // Transfer the tokens from the msg sender to here.
        for (uint256 i = 0; i < tokens.length; i++) {
            IERC20 token = IERC20(tokens[i]);
            require(
                token.transferFrom(msg.sender, address(this), 100 ether),
                "transferFrom failed"
            );
        }

        // Max approve the tokens to the pool.
        for (uint256 i = 0; i < tokens.length; i++) {
            IERC20 token = IERC20(tokens[i]);
            require(token.approve(pool, type(uint256).max), "approve failed");
        }

        uint256[] memory amountsIn = new uint256[](tokens.length);
        for (uint256 i = 0; i < tokens.length; i++) {
            amountsIn[i] = 100 ether; // THIS IS FIXED FOR NOW.
        }

        // Add liquidity to the pool. (100 token0, 100 token1).
        dex.addLiquidity(
            pool,
            vault, // The vault to send the LP
            tokens,
            amountsIn
        );
    }
}

// Deploys the donate contract.
contract DeployDonate is Script {
    function run() public {
        vm.startBroadcast();

        // Deploy the donate contract.
        new Donate();

        vm.stopBroadcast();
    }
}
