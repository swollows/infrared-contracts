// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

// external
// import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// internal
import {Infrared, Errors, IInfraredVault} from "@core/upgradable/Infrared.sol";
import "@core/IBGT.sol";
import "@core/InfraredVault.sol";

// forge script --fork-url $BERA_DEVNET_RPC -vvvv

contract CoreDeploymentScript is Script {
    // Berachain Precompiled Contract and pre deployed contracts.
    address public REWARDS_PRECOMPILE =
        address(0x55684e2cA2bace0aDc512C1AFF880b15b8eA7214);
    address public DISTRIBUTION_PRECOMPILE =
        address(0x0000000000000000000000000000000000000069);
    address public ERC20_BANK_PRECOMPILE =
        address(0x0000000000000000000000000000000000696969);
    address public STAKING_PRECOMPILE =
        address(0xd9A998CaC66092748FfEc7cFBD155Aae1737C2fF);
    address public WBERA = address(0x5806E416dA447b267cEA759358cF22Cc41FAE80F);

    address public bankModulePrecompile =
        address(0x4381dC2aB14285160c808659aEe005D51255adD7);

    Infrared infrared;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // address admin = vm.address("ADMIN");
        // address keeper = vm.address("KEEPER");
        // address governance = vm.address("GOVERNANCE");
        address admin = msg.sender;
        address keeper = msg.sender;
        address governance = msg.sender;

        /// @notice this needs to be refactored so that implementation and proxy contract are deployed in the same transaction aka deployer contract

        IBGT ibgt = new IBGT();
        IBGT ired = new IBGT(); // TODO: replace with ired contract
        uint256 rewardsDuration = 86400; // 1 day

        // deploy Infrared Implementation contracts
        address infraredImpl = address(new Infrared());
        // deploy Infrared Proxy contracts
        address infraredProxy = address(new ERC1967Proxy(infraredImpl, ""));
        // initialize Infrared Proxy contracts
        infrared = Infrared(infraredProxy);
        infrared.initialize(
            admin, // make helper contract the admin
            address(ibgt),
            ERC20_BANK_PRECOMPILE,
            DISTRIBUTION_PRECOMPILE,
            WBERA,
            STAKING_PRECOMPILE,
            REWARDS_PRECOMPILE,
            address(ired),
            rewardsDuration,
            bankModulePrecompile
        );

        infrared.grantRole(infrared.KEEPER_ROLE(), keeper);
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), governance);

        address[] memory rewardTokens = new address[](2);
        rewardTokens[0] = address(ibgt);
        rewardTokens[1] = address(ired);
        InfraredVault ibgtVault = new InfraredVault(
            admin,
            address(ibgt),
            address(infrared),
            address(0),
            REWARDS_PRECOMPILE,
            DISTRIBUTION_PRECOMPILE,
            rewardTokens,
            rewardsDuration
        );

        infrared.updateIbgtVault(address(ibgtVault));

        infrared.grantRole(infrared.KEEPER_ROLE(), keeper);
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), governance);

        vm.stopBroadcast();

        console2.log("Infrared address: ", address(infrared));
        console2.log("IBGT Vault address: ", address(ibgtVault));
        console2.log("IBGT address: ", address(ibgt));
    }
}
