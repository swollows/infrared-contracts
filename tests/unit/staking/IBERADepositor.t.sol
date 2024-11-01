// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {IBeaconDeposit} from "@berachain/pol/interfaces/IBeaconDeposit.sol";
import {BeaconDeposit} from "@berachain/pol/BeaconDeposit.sol";

import {IIBERA} from "@interfaces/IIBERA.sol";
import {IIBERADepositor} from "@interfaces/IIBERADepositor.sol";
import {IBERAConstants} from "@staking/IBERAConstants.sol";

import {IBERABaseTest} from "./IBERABase.t.sol";

contract IBERADepositorTest is IBERABaseTest {
    function testQueueUpdatesFees() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 amount = value - fee;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);

        uint256 fees = depositor.fees();
        vm.prank(address(ibera));
        depositor.queue{value: value}(amount);

        assertEq(depositor.fees(), fees + fee);
    }

    function testQueueUpdatesNonce() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 amount = value - fee;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);

        uint256 nonceSlip = depositor.nonceSlip();
        uint256 nonceSubmit = depositor.nonceSubmit();

        vm.prank(address(ibera));
        depositor.queue{value: value}(amount);

        assertEq(depositor.nonceSlip(), nonceSlip + 1);
        assertEq(depositor.nonceSubmit(), nonceSubmit);
    }

    function testQueueStoresSlip() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 amount = value - fee;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);

        uint256 nonceSlip = depositor.nonceSlip();
        (uint96 _timestamp, uint256 _fee, uint256 _amount) =
            depositor.slips(nonceSlip);
        assertEq(_timestamp, 0);
        assertEq(_fee, 0);
        assertEq(_amount, 0);

        vm.prank(address(ibera));
        uint256 nonce_ = depositor.queue{value: value}(amount);

        assertEq(nonce_, nonceSlip);
        (uint96 timestamp_, uint256 fee_, uint256 amount_) =
            depositor.slips(nonce_);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(fee_, fee);
        assertEq(amount_, amount);
    }

    function testQueueUpdatesReserves() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 amount = value - fee;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);

        uint256 balanceDepositor = address(depositor).balance;
        uint256 reserves = depositor.reserves();
        uint256 fees = depositor.fees();
        assertEq(reserves, balanceDepositor - fees);

        vm.prank(address(ibera));
        depositor.queue{value: value}(amount);

        assertEq(depositor.reserves(), reserves + amount);
    }

    function testQueueWhenSenderWithdrawor() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 amount = value - fee;

        vm.deal(address(withdrawor), value);
        assertTrue(address(withdrawor).balance >= value);

        vm.prank(address(withdrawor));
        uint256 nonce_ = depositor.queue{value: value}(amount);

        (uint96 timestamp_, uint256 fee_, uint256 amount_) =
            depositor.slips(nonce_);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(fee_, fee);
        assertEq(amount_, amount);
    }

    function testQueueEmitsQueue() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 amount = value - fee;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);
        uint256 nonce = depositor.nonceSlip();

        vm.expectEmit();
        emit IIBERADepositor.Queue(nonce, amount);
        vm.prank(address(ibera));
        depositor.queue{value: value}(amount);
    }

    function testQueueMultiple() public {
        uint256 value = 144 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;

        uint256 reserves = depositor.reserves();
        uint256 fees = depositor.fees();

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);
        uint256 nonce = depositor.nonceSlip();

        vm.prank(address(ibera));
        depositor.queue{value: 40 ether}(40 ether - fee);
        vm.prank(address(ibera));
        depositor.queue{value: 48 ether}(48 ether - fee);
        vm.prank(address(ibera));
        depositor.queue{value: 56 ether}(56 ether - fee);

        assertEq(depositor.reserves(), reserves + 144 ether - 3 * fee);
        assertEq(depositor.fees(), fees + 3 * fee);
        assertEq(address(depositor).balance, reserves + fees + 144 ether);
        assertEq(depositor.nonceSlip(), nonce + 3);

        (,, uint256 amountFirst_) = depositor.slips(nonce);
        (,, uint256 amountSecond_) = depositor.slips(nonce + 1);
        (,, uint256 amountThird_) = depositor.slips(nonce + 2);
        assertEq(amountFirst_, 40 ether - fee);
        assertEq(amountSecond_, 48 ether - fee);
        assertEq(amountThird_, 56 ether - fee);
    }

    function testQueueRevertsWhenSenderUnauthorized() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 amount = value - fee;

        vm.expectRevert(IIBERADepositor.Unauthorized.selector);
        depositor.queue{value: value}(amount);
    }

    function testQueueRevertsWhenAmountZero() public {
        uint256 value = 1 ether;
        uint256 amount = 0;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);

        vm.expectRevert(IIBERADepositor.InvalidAmount.selector);
        vm.prank(address(ibera));
        depositor.queue{value: value}(amount);
    }

    function testQueueRevertsWhenValueLessThanAmount() public {
        uint256 value = 1 ether;
        uint256 amount = 2 ether;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);

        vm.expectRevert(IIBERADepositor.InvalidAmount.selector);
        vm.prank(address(ibera));
        depositor.queue{value: value}(amount);
    }

    function testQueueRevertsWhenFeeLessThanMin() public {
        uint256 value = 1 ether;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE - 1;
        uint256 amount = value - fee;

        vm.deal(address(ibera), value);
        assertTrue(address(ibera).balance >= value);

        vm.expectRevert(IIBERADepositor.InvalidFee.selector);
        vm.prank(address(ibera));
        depositor.queue{value: value}(amount);
    }

    function testExecuteUpdatesSlipsNonceFeesWhenFillAmounts() public {
        testQueueMultiple();
        // should have the min deposit from iibera.initialize call to push through
        assertEq(depositor.nonceSlip(), 5); // 1 on init, 3 on test multiple
        assertEq(depositor.nonceSubmit(), 1); // none submitted yet

        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(1);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(2);

        uint256 amount = amountFirst + amountSecond;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);

        // nonce submit should have been bumped up by 2 given processed 2 slips
        assertEq(depositor.nonceSubmit(), 3);
        assertEq(depositor.fees(), fees - feeFirst - feeSecond);

        (, uint256 feeFirst_, uint256 amountFirst_) = depositor.slips(1);
        (, uint256 feeSecond_, uint256 amountSecond_) = depositor.slips(2);
        assertEq(feeFirst_, 0);
        assertEq(feeSecond_, 0);
        assertEq(amountFirst_, 0);
        assertEq(amountSecond_, 0);
    }

    function testExecuteUpdatesSlipNonceFeesWhenFillAmount() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 fee, uint256 amount) = depositor.slips(nonce);
        assertTrue(amount > 32 ether); // min deposit for deposit contract
        assertTrue(amount % 1 gwei == 0);

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);

        (, uint256 fee_, uint256 amount_) = depositor.slips(nonce);
        assertEq(fee_, 0);
        assertEq(amount_, 0);

        assertEq(depositor.fees(), fees - fee);
        assertEq(depositor.nonceSubmit(), nonce + 1);
    }

    function testExecuteUpdatesSlipNonceFeesWhenPartialAmount() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 fee, uint256 _amount) = depositor.slips(nonce);
        uint256 amount = ((3 * _amount / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether); // min deposit for deposit contract
        assertTrue(amount % 1 gwei == 0);

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);

        (, uint256 fee_, uint256 amount_) = depositor.slips(nonce);
        assertEq(fee_, 0);
        assertEq(amount_, _amount - amount);

        assertEq(depositor.fees(), fees - fee);
        assertEq(depositor.nonceSubmit(), nonce); // same nonce since didnt fill
    }

    function testExecuteUpdatesSlipsNonceFeesWhenPartialLastAmount() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);

        // nonce submit should have been bumped up by only 1 given fully processed 1 slip
        assertEq(depositor.nonceSubmit(), nonce + 1);
        assertEq(depositor.fees(), fees - feeFirst - feeSecond);

        (, uint256 feeFirst_, uint256 amountFirst_) = depositor.slips(nonce);
        (, uint256 feeSecond_, uint256 amountSecond_) =
            depositor.slips(nonce + 1);
        assertEq(feeFirst_, 0);
        assertEq(feeSecond_, 0);
        assertEq(amountFirst_, 0);
        assertEq(amountSecond_, amountSecond - (amount - amountFirst));
    }

    function testExecuteDepositsToDepositContract() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);
        uint64 amountInGwei = uint64(amount / 1 gwei);
        bytes memory credentials = abi.encodePacked(
            depositor.ETH1_ADDRESS_WITHDRAWAL_PREFIX(),
            uint88(0),
            ibera.withdrawor()
        ); // TODO: check

        address DEPOSIT_CONTRACT = depositor.DEPOSIT_CONTRACT();
        uint64 depositCount = BeaconDeposit(DEPOSIT_CONTRACT).depositCount();
        uint256 balanceZero = address(0).balance;

        vm.expectEmit();
        emit IBeaconDeposit.Deposit(
            pubkey0, credentials, amountInGwei, signature0, depositCount
        );

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);

        assertEq(address(0).balance, balanceZero + amount);
    }

    function testExecuteRegistersDeposit() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        uint256 stake = ibera.stakes(pubkey0);
        vm.expectEmit();
        emit IIBERA.Register(pubkey0, int256(amount), stake + amount);

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);
        assertEq(ibera.stakes(pubkey0), stake + amount);
    }

    function testExecuteTransfersETH() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        uint256 balanceDepositor = address(depositor).balance;
        uint256 balanceKeeper = address(keeper).balance;
        uint256 balanceZero = address(0).balance;

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);

        assertEq(address(keeper).balance, balanceKeeper + feeFirst + feeSecond);
        assertEq(address(0).balance, balanceZero + amount);
        assertEq(
            address(depositor).balance,
            balanceDepositor - amount - feeFirst - feeSecond
        );
    }

    function testExecuteEmitsExecute() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        vm.expectEmit();
        emit IIBERADepositor.Execute(pubkey0, nonce, nonce + 1, amount);

        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);
    }

    function testExecuteRevertsWhenAmountExceedsSlips() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();
        uint256 amount = 1000 ether;
        vm.expectRevert(IIBERADepositor.InvalidAmount.selector);
        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);
    }

    function testExecuteRevertsWhenSenderNotKeeper() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        vm.expectRevert(IIBERADepositor.Unauthorized.selector);
        depositor.execute(pubkey0, amount, signature0);
    }

    function testExecuteRevertsWhenNotEnoughTime() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (uint256 timestampFirst, uint256 feeFirst, uint256 amountFirst) =
            depositor.slips(nonce);
        (uint256 timestampSecond, uint256 feeSecond, uint256 amountSecond) =
            depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        vm.expectRevert(IIBERADepositor.Unauthorized.selector);
        depositor.execute(pubkey0, amount, signature0);

        // check can push it through once enough time has passed
        vm.warp(timestampSecond + IBERAConstants.FORCED_MIN_DELAY + 10);
        vm.prank(alice);
        depositor.execute(pubkey0, amount, signature0);
    }

    function testExecuteRevertsWhenInvalidValidator() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);

        vm.expectRevert(IIBERADepositor.InvalidValidator.selector);
        vm.prank(keeper);
        depositor.execute(bytes(""), amount, signature0);
    }

    function testExecuteRevertsWhenAmountZero() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();
        uint256 amount = 0;
        vm.expectRevert(IIBERADepositor.InvalidAmount.selector);
        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);
    }

    function testExecuteRevertsWhenAmountNotDivisibleByGwei() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();

        uint256 nonce = depositor.nonceSubmit();
        uint256 fees = depositor.fees();
        (, uint256 feeFirst, uint256 amountFirst) = depositor.slips(nonce);
        (, uint256 feeSecond, uint256 amountSecond) = depositor.slips(nonce + 1);

        uint256 amount = ((amountFirst + amountSecond / 4) / 1 gwei) * 1 gwei;
        assertTrue(amount > 32 ether);
        assertTrue(amount % 1 gwei == 0);
        amount += 1;

        vm.expectRevert(IIBERADepositor.InvalidAmount.selector);
        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);
    }

    function testExecuteRevertsWhenAmountGreaterThanMax() public {
        testExecuteUpdatesSlipsNonceFeesWhenFillAmounts();
        uint256 stake = ibera.stakes(pubkey0);
        uint256 amount = uint256(type(uint64).max) * (1 gwei) - stake + 1 gwei;
        vm.expectRevert(IIBERADepositor.InvalidAmount.selector);
        vm.prank(keeper);
        depositor.execute(pubkey0, amount, signature0);
    }
}
