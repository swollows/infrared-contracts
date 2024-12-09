// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import "forge-std/Script.sol";

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {InfraredBERA} from "src/staking/InfraredBERA.sol";
import {InfraredBERAClaimor} from "src/staking/InfraredBERAClaimor.sol";
import {InfraredBERADepositor} from "src/staking/InfraredBERADepositor.sol";
import {InfraredBERAWithdrawor} from "src/staking/InfraredBERAWithdrawor.sol";
import {InfraredBERAFeeReceivor} from "src/staking/InfraredBERAFeeReceivor.sol";
import {InfraredBERAConstants} from "src/staking/InfraredBERAConstants.sol";

contract InfraredBERADeployer is Script {
    address public admin;

    InfraredBERA public ibera;
    InfraredBERADepositor public depositor;
    InfraredBERAWithdrawor public withdrawor;
    InfraredBERAClaimor public claimor;
    InfraredBERAFeeReceivor public receivor;

    function run(address _infrared, address depositContract) external {
        admin = msg.sender;
        vm.startBroadcast();

        ibera = InfraredBERA(setupProxy(address(new InfraredBERA())));

        depositor = InfraredBERADepositor(
            setupProxy(address(new InfraredBERADepositor()))
        );
        withdrawor = InfraredBERAWithdrawor(
            payable(setupProxy(address(new InfraredBERAWithdrawor())))
        );
        claimor =
            InfraredBERAClaimor(setupProxy(address(new InfraredBERAClaimor())));
        receivor = InfraredBERAFeeReceivor(
            payable(setupProxy(address(new InfraredBERAFeeReceivor())))
        );

        // initialize proxies
        depositor.initialize(admin, address(ibera), depositContract);
        withdrawor.initialize(admin, address(ibera));
        claimor.initialize(admin);
        receivor.initialize(admin, address(ibera), _infrared);

        // init deposit to avoid inflation attack
        uint256 _value = InfraredBERAConstants.MINIMUM_DEPOSIT
            + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;

        ibera.initialize{value: _value}(
            admin,
            _infrared,
            address(depositor),
            address(withdrawor),
            address(claimor),
            address(receivor)
        );

        vm.stopBroadcast();
    }

    function setupProxy(address implementation)
        internal
        returns (address proxy)
    {
        proxy = address(new ERC1967Proxy(implementation, ""));
    }
}
