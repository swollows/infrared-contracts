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
    address public constant DISTRIBUTION_PREOCMPILE = 0x0000000000000000000000000000000000000069;
    address public constant REWARDS_PRECOMPILE = 0x55684e2cA2bace0aDc512C1AFF880b15b8eA7214;
    address public constant STAKING_PRECOMPILE = 0xd9A998CaC66092748FfEc7cFBD155Aae1737C2fF;
    address public constant ERC20_PRECOMPILE = 0x0000000000000000000000000000000000696969;
}

library AddressesAddress {
    address public constant addr = address(0x138F39471c7A96e1076cc870A96cFC404eCF83c4);
}

library Actors {
    address public constant DEFAULT_ADMIN = 0x2D764DFeaAc00390c69985631aAA7Cc3fcfaFAfF;
    address public constant GOVERNANCE = 0x999fACda86674c43D0D95538631a55Eeeb7c3cDa;
    address public constant KEEPER = 0x1b7EA124Cd33d8128ac6768042e6b8d69AF9bB5A;
}
