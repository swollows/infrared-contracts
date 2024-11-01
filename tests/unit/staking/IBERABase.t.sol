// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

// Testing Libraries.
import "forge-std/Test.sol";

// Mocks
import {MockInfrared} from "@mocks/MockInfrared.sol";

import {BeaconDeposit} from "@berachain/pol/BeaconDeposit.sol";

import {IBERA} from "@staking/IBERA.sol";
import {IBERADepositor} from "@staking/IBERADepositor.sol";
import {IBERAWithdrawor} from "@staking/IBERAWithdrawor.sol";
import {IBERAClaimor} from "@staking/IBERAClaimor.sol";
import {IBERAFeeReceivor} from "@staking/IBERAFeeReceivor.sol";
import {IBERAConstants} from "@staking/IBERAConstants.sol";

contract IBERABaseTest is Test {
    IBERA public ibera;
    IBERADepositor public depositor;
    IBERAWithdrawor public withdrawor;
    IBERAClaimor public claimor;
    IBERAFeeReceivor public receivor;

    BeaconDeposit public depositContract;
    bytes public constant withdrawPrecompile = abi.encodePacked(
        hex"7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff5f556101f480602d5f395ff33373fffffffffffffffffffffffffffffffffffffffe1460c7573615156028575f545f5260205ff35b36603814156101f05760115f54807fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff146101f057600182026001905f5b5f821115608057810190830284830290049160010191906065565b9093900434106101f057600154600101600155600354806003026004013381556001015f35815560010160203590553360601b5f5260385f601437604c5fa0600101600355005b6003546002548082038060101160db575060105b5f5b81811461017f5780604c02838201600302600401805490600101805490600101549160601b83528260140152807fffffffffffffffffffffffffffffffff0000000000000000000000000000000016826034015260401c906044018160381c81600701538160301c81600601538160281c81600501538160201c81600401538160181c81600301538160101c81600201538160081c81600101535360010160dd565b9101809214610191579060025561019c565b90505f6002555f6003555b5f54807fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff14156101c957505f5b6001546002828201116101de5750505f6101e4565b01600290035b5f555f600155604c025ff35b5f5ffd"
    );

    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    address public keeper = makeAddr("keeper");
    address public governor = makeAddr("governor");
    address public deployer = makeAddr("deployer");

    address public ibgt = makeAddr("iBGT");
    address public ired = makeAddr("iRED");
    address public rewardsFactory = makeAddr("berachainRewardsVaultFactory");

    MockInfrared public infrared;
    address public validator0 = makeAddr("v0");
    address public validator1 = makeAddr("v1");
    bytes public pubkey0 = abi.encodePacked(bytes32("v0"), bytes16("")); // must be len 48
    bytes public pubkey1 = abi.encodePacked(bytes32("v1"), bytes16(""));
    bytes public signature0 =
        abi.encodePacked(bytes32("v0"), bytes32(""), bytes32("")); // must be len 96
    bytes public signature1 =
        abi.encodePacked(bytes32("v1"), bytes32(""), bytes32(""));

    function setUp() public virtual {
        infrared = new MockInfrared(ibgt, ired, rewardsFactory);
        vm.prank(deployer);
        ibera = new IBERA(address(infrared));

        depositor = IBERADepositor(ibera.depositor());
        withdrawor = IBERAWithdrawor(ibera.withdrawor());
        claimor = IBERAClaimor(ibera.claimor());
        receivor = IBERAFeeReceivor(payable(ibera.receivor()));

        // etch deposit contract at depositor constant deposit contract address
        depositContract = new BeaconDeposit();
        address DEPOSIT_CONTRACT = depositor.DEPOSIT_CONTRACT();
        vm.etch(DEPOSIT_CONTRACT, address(depositContract).code);

        // etch withdraw precompile at withdraw precompile contract address
        address WITHDRAW_PRECOMPILE = withdrawor.WITHDRAW_PRECOMPILE();
        vm.etch(WITHDRAW_PRECOMPILE, withdrawPrecompile);

        // initialize IBERA
        uint256 value =
            IBERAConstants.MINIMUM_DEPOSIT + IBERAConstants.MINIMUM_DEPOSIT_FEE;
        ibera.initialize{value: value}();

        // deal to alice and bob + approve ibera to spend for them
        vm.deal(alice, 1000 ether);
        vm.deal(bob, 1000 ether);
        vm.prank(alice);
        ibera.approve(address(ibera), type(uint256).max);
        vm.prank(bob);
        ibera.approve(address(ibera), type(uint256).max);

        // add validators to infrared
        infrared.addValidator(validator0, pubkey0);
        infrared.addValidator(validator1, pubkey1);

        // grant roles to keeper and governor
        bytes32 kr = ibera.KEEPER_ROLE();
        bytes32 gr = ibera.GOVERNANCE_ROLE();
        vm.prank(deployer);
        ibera.grantRole(kr, keeper);
        vm.prank(deployer);
        ibera.grantRole(gr, governor);

        labelContracts();
    }

    function labelContracts() public {
        vm.label(address(infrared), "Infrared");
        vm.label(address(ibera), "iBERA");
        vm.label(address(depositor), "iBERADepositor");
        vm.label(address(withdrawor), "iBERAWithdrawor");
        vm.label(address(claimor), "iBERAClaimor");
        vm.label(address(receivor), "iBERAReceivor");
        vm.label(depositor.DEPOSIT_CONTRACT(), "DepositContract");
        vm.label(withdrawor.WITHDRAW_PRECOMPILE(), "WithdrawPrecompile");
    }

    function testSetUp() public virtual {
        assertTrue(address(depositor) != address(0), "depositor == address(0)");
        assertTrue(
            address(withdrawor) != address(0), "withdrawor == address(0)"
        );
        assertTrue(address(claimor) != address(0), "claimor == address(0)");
        assertTrue(address(receivor) != address(0), "receivor == address(0)");

        assertEq(ibera.allowance(alice, address(ibera)), type(uint256).max);
        assertEq(ibera.allowance(bob, address(ibera)), type(uint256).max);
        assertEq(alice.balance, 1000 ether);
        assertEq(bob.balance, 1000 ether);

        assertTrue(infrared.isInfraredValidator(pubkey0));
        assertTrue(infrared.isInfraredValidator(pubkey1));

        assertTrue(ibera.hasRole(ibera.DEFAULT_ADMIN_ROLE(), deployer));
        assertTrue(ibera.keeper(keeper));
        assertTrue(ibera.governor(governor));

        address DEPOSIT_CONTRACT = depositor.DEPOSIT_CONTRACT();
        assertTrue(DEPOSIT_CONTRACT.code.length > 0);

        address WITHDRAW_PRECOMPILE = withdrawor.WITHDRAW_PRECOMPILE();
        assertTrue(WITHDRAW_PRECOMPILE.code.length > 0);
    }
}
