// // SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

// The precompiled addresses on the local berachain network.
library Precompiles {
    address public constant BANK_PRECOMPILE = 0x4381dC2aB14285160c808659aEe005D51255adD7;
    address public constant DISTRIBUTION_PRECOMPILE = 0x0000000000000000000000000000000000000069;
    address public constant REWARDS_PRECOMPILE = 0x55684e2cA2bace0aDc512C1AFF880b15b8eA7214;
    address public constant STAKING_PRECOMPILE = 0xd9A998CaC66092748FfEc7cFBD155Aae1737C2fF;
    address public constant ERC20_PRECOMPILE = 0x0000000000000000000000000000000000000069;
}

library Actors {
    // Private-Key=0xfffdbb37105441e14b0ee6330d855d8504ff39e705c3afa8f859ac9865f99306
    address public constant DEFAULT_ADMIN = 0x20f33CE90A13a4b5E7697E3544c3083B8F8A51D4;
    address public constant KEEPER = 0x20f33CE90A13a4b5E7697E3544c3083B8F8A51D4;
    address public constant GOVERNANCE = 0x20f33CE90A13a4b5E7697E3544c3083B8F8A51D4;
}

library GenesisPools {
    address public constant USDC_HONEY_POOL_TOKEN = 0xc70c2FD8f8E3DBbb6f73502C70952f115Bb93929;
    address public constant USDC_HONEY_POOL_ADDRESS = 0x101f52c804C1C02c0A1D33442ecA30ecb6fB2434;
}
