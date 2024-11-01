// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {IIBERAFeeReceivor} from "@interfaces/IIBERAFeeReceivor.sol";
import {IBERAConstants} from "@staking/IBERAConstants.sol";

import {IBERABaseTest} from "./IBERABase.t.sol";

contract IBERAFeeReceivorTest is IBERABaseTest {
    function testDistributionReturnsWhenFeeZero() public {
        uint256 value = 1 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (uint256 amount, uint256 fees) = receivor.distribution();
        assertEq(amount, address(receivor).balance);
        assertEq(fees, 0);
    }

    function testDistributionReturnsWhenFeeGreaterThanZero() public {
        uint16 feeProtocol = 4; // 25% fee
        vm.prank(governor);
        ibera.setFeeProtocol(feeProtocol);
        assertEq(ibera.feeProtocol(), feeProtocol);

        uint256 value = 1 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (uint256 amount, uint256 fees) = receivor.distribution();
        assertEq(
            amount,
            address(receivor).balance - address(receivor).balance / feeProtocol
        );
        assertEq(fees, address(receivor).balance / feeProtocol);
    }

    function testDistributionReturnsWhenAccumulatedFeesGreaterThanZero()
        public
    {
        testDistributionReturnsWhenFeeGreaterThanZero();
        uint256 balanceReceivor = address(receivor).balance;
        uint16 feeProtocol = ibera.feeProtocol();
        uint256 protocolFees = receivor.protocolFees();

        (uint256 amount_, uint256 fees_) = receivor.sweep();
        assertEq(amount_, balanceReceivor - balanceReceivor / feeProtocol);
        assertEq(fees_, balanceReceivor / feeProtocol);

        uint256 protocolFees_ = receivor.protocolFees();
        assertEq(receivor.protocolFees(), protocolFees + fees_);

        // add in some more fees
        uint256 value = 0.5 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value + protocolFees_);

        // should not include already swept distribution in fees charged
        (uint256 amount, uint256 fees) = receivor.distribution();
        assertEq(amount, value - value / feeProtocol);
        assertEq(fees, value / feeProtocol);
    }

    function testSweepUpdatesProtocolFees() public {
        uint16 feeProtocol = 4; // 25% fee
        vm.prank(governor);
        ibera.setFeeProtocol(feeProtocol);
        assertEq(ibera.feeProtocol(), feeProtocol);

        uint256 value = 1 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (, uint256 fees) = receivor.distribution();
        assertTrue(fees > 0);

        uint256 protocolFees_ = receivor.protocolFees();
        (, uint256 fees_) = receivor.sweep();
        assertEq(fees_, fees);
        assertEq(receivor.protocolFees(), protocolFees_ + fees);

        // check distribution zeros
        (uint256 amountAfter, uint256 feesAfter) = receivor.distribution();
        assertEq(amountAfter, 0);
        assertEq(feesAfter, 0);
    }

    function testSweepNotUpdatesProtocolFeesWhenFeesZero() public {
        uint256 value = 1 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (, uint256 fees) = receivor.distribution();
        assertTrue(fees == 0);

        uint256 protocolFees_ = receivor.protocolFees();
        (, uint256 fees_) = receivor.sweep();
        assertEq(fees_, 0);
        assertEq(receivor.protocolFees(), protocolFees_);

        // check distribution zeros
        (uint256 amountAfter, uint256 feesAfter) = receivor.distribution();
        assertEq(amountAfter, 0);
        assertEq(feesAfter, 0);
    }

    function testSweepUpdatesProtocolFeesWhenAccumulatedFeesGreaterThanZero()
        public
    {
        testDistributionReturnsWhenFeeGreaterThanZero();
        (uint256 amount, uint256 fees) = receivor.distribution();
        assertTrue(amount > 0);
        assertTrue(fees > 0);

        uint256 protocolFees = receivor.protocolFees();
        (uint256 amount_, uint256 fees_) = receivor.sweep();
        assertEq(amount_, amount);
        assertEq(fees_, fees);
        assertEq(receivor.protocolFees(), protocolFees + fees);
    }

    function testSweepTransfersETH() public {
        uint16 feeProtocol = 4; // 25% fee
        vm.prank(governor);
        ibera.setFeeProtocol(feeProtocol);
        assertEq(ibera.feeProtocol(), feeProtocol);

        uint256 value = 1 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (uint256 amount, uint256 fees) = receivor.distribution();
        assertEq(amount, value - value / feeProtocol);
        assertEq(fees, value / feeProtocol);

        uint256 balanceDepositor = address(depositor).balance;
        uint256 balanceReceivor = address(receivor).balance;

        (uint256 amount_, uint256 fees_) = receivor.sweep();
        assertEq(amount_, amount);
        assertEq(fees_, fees);

        assertEq(address(depositor).balance, balanceDepositor + amount);
        assertEq(address(receivor).balance, balanceReceivor - amount);
    }

    function testSweepTransfersETHWhenFeesZero() public {
        uint256 value = 1 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (uint256 amount, uint256 fees) = receivor.distribution();
        assertEq(amount, value);
        assertEq(fees, 0);

        uint256 balanceDepositor = address(depositor).balance;
        uint256 balanceReceivor = address(receivor).balance;

        (uint256 amount_, uint256 fees_) = receivor.sweep();
        assertEq(amount_, amount);
        assertEq(fees_, fees);

        assertEq(address(depositor).balance, balanceDepositor + amount);
        assertEq(address(receivor).balance, balanceReceivor - amount);
    }

    function testSweepTransfersETHWhenAccumulatedFeesGreaterThanZero() public {
        testDistributionReturnsWhenAccumulatedFeesGreaterThanZero();
        (uint256 amount, uint256 fees) = receivor.distribution();
        assertTrue(amount > 0);
        assertTrue(fees > 0);

        uint256 balanceDepositor = address(depositor).balance;
        uint256 balanceReceivor = address(receivor).balance;

        (uint256 amount_, uint256 fees_) = receivor.sweep();
        assertEq(amount_, amount);
        assertEq(fees_, fees);

        assertEq(address(depositor).balance, balanceDepositor + amount);
        assertEq(address(receivor).balance, balanceReceivor - amount);
    }

    function testSweepEmitsSweep() public {
        uint16 feeProtocol = 4; // 25% fee
        vm.prank(governor);
        ibera.setFeeProtocol(feeProtocol);
        assertEq(ibera.feeProtocol(), feeProtocol);

        uint256 value = 1 ether;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (uint256 amount, uint256 fees) = receivor.distribution();
        assertEq(amount, value - value / feeProtocol);
        assertEq(fees, value / feeProtocol);

        vm.expectEmit();
        emit IIBERAFeeReceivor.Sweep(address(ibera), amount, fees);
        receivor.sweep();
    }

    function testSweepPassesBelowMin() public {
        uint256 value = IBERAConstants.MINIMUM_DEPOSIT;
        payable(address(receivor)).transfer(value);
        assertEq(address(receivor).balance, value);

        (uint256 amount, uint256 fees) = receivor.distribution();
        assertTrue(
            amount
                < IBERAConstants.MINIMUM_DEPOSIT
                    + IBERAConstants.MINIMUM_DEPOSIT_FEE
        );
        assertEq(fees, 0);

        uint256 balanceDepositor = address(depositor).balance;
        uint256 balanceReceivor = address(receivor).balance;
        uint256 protocolFees = receivor.protocolFees();

        (uint256 amount_, uint256 fees_) = receivor.sweep();
        assertEq(amount_, 0);
        assertEq(fees_, 0);

        assertEq(address(depositor).balance, balanceDepositor);
        assertEq(address(receivor).balance, balanceReceivor);
        assertEq(protocolFees, receivor.protocolFees());
    }

    function testCollectUpdatesProtocolFees() public {
        testSweepTransfersETHWhenAccumulatedFeesGreaterThanZero();
        uint256 protocolFees = receivor.protocolFees();
        assertTrue(protocolFees > 0);

        vm.prank(governor);
        receivor.collect(alice);
        assertEq(receivor.protocolFees(), 1);
    }

    function testCollectTransfersETH() public {
        testSweepTransfersETHWhenAccumulatedFeesGreaterThanZero();
        uint256 protocolFees = receivor.protocolFees();
        assertTrue(protocolFees > 0);

        uint256 balanceAlice = address(alice).balance;
        uint256 balanceReceivor = address(receivor).balance;

        vm.prank(governor);
        receivor.collect(alice);

        assertEq(address(alice).balance, balanceAlice + protocolFees - 1);
        assertEq(address(receivor).balance, balanceReceivor - protocolFees + 1);
    }

    function testCollectRevertsWhenNotGovernor() public {
        testSweepTransfersETHWhenAccumulatedFeesGreaterThanZero();
        uint256 protocolFees = receivor.protocolFees();
        assertTrue(protocolFees > 0);

        vm.expectRevert(IIBERAFeeReceivor.Unauthorized.selector);
        receivor.collect(alice);
    }

    function testCollectRevertsWhenProtocolFeesZero() public {
        uint256 protocolFees = receivor.protocolFees();
        assertTrue(protocolFees == 0);

        vm.expectRevert(IIBERAFeeReceivor.InvalidAmount.selector);
        vm.prank(governor);
        receivor.collect(alice);
    }
}
