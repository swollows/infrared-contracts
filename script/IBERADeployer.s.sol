// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import "forge-std/Script.sol";

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {IBERA} from "@staking/IBERA.sol";
import {IBERAClaimor} from "@staking/IBERAClaimor.sol";
import {IBERADepositor} from "@staking/IBERADepositor.sol";
import {IBERAWithdrawor} from "@staking/IBERAWithdrawor.sol";
import {IBERAFeeReceivor} from "@staking/IBERAFeeReceivor.sol";
import {IBERAConstants} from "@staking/IBERAConstants.sol";

contract IBERADeployer is Script {
    address public admin;

    IBERA public ibera;
    IBERADepositor public depositor;
    IBERAWithdrawor public withdrawor;
    IBERAClaimor public claimor;
    IBERAFeeReceivor public receivor;

    function run(address _infrared) external {
        admin = msg.sender;

        vm.startBroadcast();

        ibera = IBERA(setupProxy(address(new IBERA())));

        depositor = IBERADepositor(setupProxy(address(new IBERADepositor())));
        withdrawor =
            IBERAWithdrawor(payable(setupProxy(address(new IBERAWithdrawor()))));
        claimor = IBERAClaimor(setupProxy(address(new IBERAClaimor())));
        receivor = IBERAFeeReceivor(
            payable(setupProxy(address(new IBERAFeeReceivor())))
        );

        // initialize proxies
        depositor.initialize(admin, address(ibera));
        withdrawor.initialize(admin, address(ibera));
        claimor.initialize(admin);
        receivor.initialize(admin, address(ibera), _infrared);

        // init deposit to avoid inflation attack
        uint256 _value =
            IBERAConstants.MINIMUM_DEPOSIT + IBERAConstants.MINIMUM_DEPOSIT_FEE;

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
