// // SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library Validators {
    address public constant VAL_0 = 0x6c1a8ef7ead982bfc52693976b8F11C0fA6ef688;
    address public constant VAL_1 = 0x8aFaBfD41E8C6489812F4457e8d8DfcF75EbaA32;
    address public constant VAL_2 = 0x8F0C8170ec6bc4ff0fFC3cbCf87D1A2666924725;
    address public constant VAL_3 = 0xfd8106B6917c8F593a3145b44e0d6a2251C72Ba2;
}

library Precompiles {
    address public constant BANK_PRECOMPILE = 0x4381dC2aB14285160c808659aEe005D51255adD7;
    address public constant DISTRIBUTION_PRECOMPILE = 0x0000000000000000000000000000000000000069;
    address public constant REWARDS_PRECOMPILE = 0x55684e2cA2bace0aDc512C1AFF880b15b8eA7214;
    address public constant STAKING_PRECOMPILE = 0xd9A998CaC66092748FfEc7cFBD155Aae1737C2fF;
    address public constant ERC20_PRECOMPILE = 0x0000000000000000000000000000000000696969;
}

library AddressesAddress {
    //NOTE: Please update after running `make deploy-addresses``
    address public constant addr = address(0x916A843ec0dC01Da08656c0C132db75468af787A);
}

// NOTE: The private keys of the test accounts (add to metamask or other script etc)
// c4d888b633f4299813325540d67419fe50418f1aca87ddd01a2e15c5d85f6536 // DEFAULT KEEPER
// d331822f304b5cb63f23e95cddee0728460f2507ea821889da6cf1cfb9c2dfb9 // GOVERNANCE
// 010b8742512b091fa10ff09626afbb6dea23f0792992c9bfa9e35cb227fd7df3 // KEEPER.

library Actors {
    address public constant DEFAULT_ADMIN = 0x2D764DFeaAc00390c69985631aAA7Cc3fcfaFAfF;
    address public constant GOVERNANCE = 0x999fACda86674c43D0D95538631a55Eeeb7c3cDa;
    address public constant KEEPER = 0x1b7EA124Cd33d8128ac6768042e6b8d69AF9bB5A;
}

library GenesisPools {
    address public constant USDC_HONEY_POOL_TOKEN = 0xc70c2FD8f8E3DBbb6f73502C70952f115Bb93929;
    address public constant USDC_HONEY_POOL_ADDRESS = 0x101f52c804C1C02c0A1D33442ecA30ecb6fB2434;
}
