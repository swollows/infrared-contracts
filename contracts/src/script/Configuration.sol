// // SPDX-License-Identifier: MIT
/* solhint-disable */
pragma solidity 0.8.20;

// The precompiled addresses on the local berachain network.
library Precompiles {
    address public constant BANK_PRECOMPILE =
        0x4381dC2aB14285160c808659aEe005D51255adD7;
    address public constant DISTRIBUTION_PRECOMPILE =
        0x0000000000000000000000000000000000000069;
    address public constant REWARDS_PRECOMPILE =
        0x55684e2cA2bace0aDc512C1AFF880b15b8eA7214;
    address public constant STAKING_PRECOMPILE =
        0xd9A998CaC66092748FfEc7cFBD155Aae1737C2fF;
    address public constant ERC20_PRECOMPILE =
        0x0000000000000000000000000000000000000069;
}

library Actors {
    // Private-Key=dfc999fdf61a265eb65603288e6a3f68daf972f6fc6f3afd15738aaa5d340b28
    address public constant DEFAULT_ADMIN =
        0x08D9255C2922528da6e8853319bcc85A1f6e283c;
    address public constant KEEPER = 0x08D9255C2922528da6e8853319bcc85A1f6e283c;
    address public constant GOVERNANCE =
        0x08D9255C2922528da6e8853319bcc85A1f6e283c;
}

library GenesisPools {
    address public constant USDC_HONEY_POOL_TOKEN =
        0xc70c2FD8f8E3DBbb6f73502C70952f115Bb93929;
    address public constant USDC_HONEY_POOL_ADDRESS =
        0x101f52c804C1C02c0A1D33442ecA30ecb6fB2434;
}

library Validators {
    address public constant VAL_0 =
        address(0x133A576eA2500BEA75C691564122C9dcd2858F39); // TODO: Please update
        // this address.
}
