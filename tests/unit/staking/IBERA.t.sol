// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

import {IIBERA} from "@interfaces/IIBERA.sol";
import {IIBERAWithdrawor} from "@interfaces/IIBERAWithdrawor.sol";
import {IBERAConstants} from "@staking/IBERAConstants.sol";
import {IBERA} from "@staking/IBERA.sol";

import {IBERABaseTest} from "./IBERABase.t.sol";

contract IBERATest is IBERABaseTest {
    function testInitializeMintsToIBERA() public {
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;

        assertEq(ibera.totalSupply(), min);
        assertEq(ibera.balanceOf(address(ibera)), min);
        assertEq(ibera.deposits(), min);

        assertEq(address(depositor).balance, min + fee);
        assertEq(depositor.fees(), fee);
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );

        assertEq(ibera.pending(), min);
        assertEq(ibera.confirmed(), 0);

        uint256 nonce_ = 1;
        (uint96 timestamp_, uint256 fee_, uint256 amount_) =
            depositor.slips(nonce_);
        assertEq(fee_, fee);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(amount_, min);
        assertEq(depositor.nonceSlip(), nonce_ + 1);
    }

    function testSweepQueuesToDepositor() public {
        uint256 deposits = ibera.deposits();
        uint256 totalSupply = ibera.totalSupply();

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();
        uint256 depositorNonce = depositor.nonceSlip();

        uint256 pending = ibera.pending();
        uint256 confirmed = ibera.confirmed();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;
        assertTrue(value > min + fee);

        ibera.sweep{value: value}();

        assertEq(ibera.deposits(), deposits + value - fee);
        assertEq(ibera.totalSupply(), totalSupply);

        assertEq(address(depositor).balance, depositorBalance + value);
        assertEq(depositor.fees(), depositorFees + fee);
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );

        assertEq(ibera.pending(), pending + value - fee);
        assertEq(ibera.confirmed(), confirmed);

        (uint96 timestamp_, uint256 fee_, uint256 amount_) =
            depositor.slips(depositorNonce);
        assertEq(fee_, fee);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(amount_, value - fee);
        assertEq(depositor.nonceSlip(), depositorNonce + 1);
    }

    function testSweepEmitsSweep() public {
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;
        assertTrue(value > min + fee);
        vm.expectEmit();
        emit IIBERA.Sweep(value);
        ibera.sweep{value: value}();
    }

    function testCompoundSweepsFromReceivor() public {
        uint256 deposits = ibera.deposits();
        uint256 totalSupply = ibera.totalSupply();

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();

        uint256 pending = ibera.pending();
        uint256 confirmed = ibera.confirmed();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;

        payable(address(receivor)).transfer(value);
        uint256 balanceReceivor = address(receivor).balance;
        uint256 protocolFeesReceivor = receivor.shareholderFees();

        (uint256 amount, uint256 protocolFee) = receivor.distribution();
        assertTrue(amount >= min + fee);

        ibera.compound();

        assertEq(address(receivor).balance, balanceReceivor - amount);
        assertEq(receivor.shareholderFees(), protocolFeesReceivor + protocolFee);

        assertEq(ibera.deposits(), deposits + amount - fee);
        assertEq(ibera.totalSupply(), totalSupply);

        assertEq(address(depositor).balance, depositorBalance + amount);
        assertEq(depositor.fees(), depositorFees + fee);
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );

        assertEq(ibera.pending(), pending + amount - fee);
        assertEq(ibera.confirmed(), confirmed);
    }

    function testCompoundPassesWhenDistributionBelowMin() public {
        uint256 deposits = ibera.deposits();
        uint256 totalSupply = ibera.totalSupply();

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();

        uint256 pending = ibera.pending();
        uint256 confirmed = ibera.confirmed();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 0.01 ether;

        payable(address(receivor)).transfer(value);
        uint256 balanceReceivor = address(receivor).balance;
        uint256 protocolFeesReceivor = receivor.shareholderFees();

        (uint256 amount, uint256 protocolFee) = receivor.distribution();
        assertTrue(amount < min + fee);

        ibera.compound();

        assertEq(address(receivor).balance, value);
        assertEq(receivor.shareholderFees(), protocolFeesReceivor);

        assertEq(ibera.deposits(), deposits);
        assertEq(ibera.totalSupply(), totalSupply);

        assertEq(address(depositor).balance, depositorBalance);
        assertEq(depositor.fees(), depositorFees);
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );

        assertEq(ibera.pending(), pending);
        assertEq(ibera.confirmed(), confirmed);
    }

    function testMintMintsShares() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 deposits = ibera.deposits();
        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;
        assertTrue(value > min + fee);

        (, uint256 shares_) = ibera.mint{value: value}(alice);

        uint256 amount = value - fee;
        uint256 shares = Math.mulDiv(totalSupply, amount, deposits);
        assertEq(ibera.balanceOf(alice), sharesAlice + shares);
        assertEq(ibera.totalSupply(), totalSupply + shares);
        assertEq(shares_, shares);

        // check amount inferred from shares held
        uint256 _deposits = ibera.deposits();
        uint256 _totalSupply = ibera.totalSupply();
        uint256 _amount = Math.mulDiv(_deposits, shares, _totalSupply);
        assertEq(_amount, amount);

        uint256 delta = _deposits - _amount; // should have given amount burned at init
        assertEq(delta, min);
        uint256 _delta =
            Math.mulDiv(_deposits, _totalSupply - shares, _totalSupply);
        assertEq(delta, _delta);
    }

    function testMintUpdatesDeposits() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 deposits = ibera.deposits();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;
        assertTrue(value > min + fee);

        ibera.mint{value: value}(alice);
        assertEq(ibera.deposits(), deposits + value - fee);
    }

    function testMintQueuesToDepositor() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();
        uint256 depositorNonce = depositor.nonceSlip();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;
        assertTrue(value > min + fee);

        (uint256 nonce_,) = ibera.mint{value: value}(alice);

        assertEq(depositor.fees(), depositorFees + fee);
        assertEq(address(depositor).balance, depositorBalance + value);
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );

        assertEq(nonce_, depositorNonce);
        (uint96 timestamp_, uint256 fee_, uint256 amount_) =
            depositor.slips(nonce_);
        assertEq(fee_, fee);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(amount_, value - fee);

        assertEq(depositor.nonceSlip(), nonce_ + 1);
    }

    function testMintCompoundsPrior() public {
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        payable(address(receivor)).transfer(1 ether);

        (uint256 comp_, uint256 pf_) = receivor.distribution();
        assertTrue(comp_ >= min + fee);

        uint256 totalSupply = ibera.totalSupply();
        uint256 deposits = ibera.deposits();
        uint256 sharesAlice = ibera.balanceOf(alice);

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();
        uint256 depositorNonce = depositor.nonceSlip();

        vm.expectEmit();
        emit IIBERA.Sweep(comp_);

        uint256 value = 100 ether;
        (uint256 nonce_, uint256 shares_) = ibera.mint{value: value}(alice);

        assertEq(depositor.fees(), depositorFees + 2 * fee);
        assertEq(address(depositor).balance, depositorBalance + value + comp_);
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );

        assertEq(nonce_, depositorNonce + 1);
        assertEq(depositor.nonceSlip(), depositorNonce + 2);

        (uint96 timestamp_, uint256 fee_, uint256 amount_) =
            depositor.slips(nonce_);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(fee_, fee);
        assertEq(amount_, value - fee);

        (uint96 timestampComp_, uint256 feeComp_, uint256 amountComp_) =
            depositor.slips(nonce_ - 1);
        assertEq(timestampComp_, uint96(block.timestamp));
        assertEq(feeComp_, fee);
        assertEq(amountComp_, comp_ - fee);

        // check ibera state
        uint256 deposits_ = ibera.deposits();
        assertEq(deposits_, deposits + comp_ + value - 2 * fee);

        uint256 shares =
            Math.mulDiv(totalSupply, value - fee, (deposits + comp_ - fee));
        assertEq(shares, shares_);
        assertEq(ibera.totalSupply(), totalSupply + shares);
        assertEq(ibera.balanceOf(alice), sharesAlice + shares);
    }

    function testMintEmitsMint() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;
        assertTrue(value > min + fee);

        uint256 nonce = depositor.nonceSlip();
        uint256 amount = value - fee;
        uint256 shares =
            Math.mulDiv(ibera.totalSupply(), amount, ibera.deposits());

        vm.expectEmit();
        emit IIBERA.Mint(alice, nonce, amount, shares, fee);
        ibera.mint{value: value}(alice);
    }

    function testMintRevertsWhenAmountLessThanDepositFee() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 0.001 ether;
        assertTrue(value < min + fee);

        vm.expectRevert(IIBERA.InvalidAmount.selector);
        ibera.mint{value: value}(alice);
    }

    function testMintRevertsWhenSharesZero() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = min + fee;

        // need to donate 1e16 ether to reach this error given min deposit of 0.1 ether
        vm.deal(address(receivor), 1e16 ether);
        (uint256 comp_, uint256 pf_) = receivor.distribution();

        uint256 shares =
            Math.mulDiv(ibera.totalSupply(), min, ibera.deposits() + comp_);
        assertEq(shares, 0);

        vm.expectRevert(IIBERA.InvalidShares.selector);
        ibera.mint{value: value}(alice);
    }

    function testMintRevertsWhenNotInitialized() public {
        IBERA _ibera = new IBERA(address(infrared));
        vm.expectRevert(IIBERA.NotInitialized.selector);
        _ibera.mint{value: 1 ether}(alice);
    }

    function testBurnBurnsShares() public {
        testMintCompoundsPrior();

        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 fee = IBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);

        vm.expectRevert(IIBERA.WithdrawalsNotEnabled.selector);
        vm.prank(alice);
        ibera.burn{value: fee}(bob, shares);

        vm.prank(governor);
        ibera.setWithdrawalsEnabled(true);

        vm.prank(alice);
        ibera.burn{value: fee}(bob, shares);

        assertEq(ibera.totalSupply(), totalSupply - shares);
        assertEq(ibera.balanceOf(alice), sharesAlice - shares);
    }

    function testBurnUpdatesDeposits() public {
        testMintCompoundsPrior();

        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 fee = IBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);
        uint256 amount = Math.mulDiv(deposits, shares, totalSupply);

        vm.prank(governor);
        ibera.setWithdrawalsEnabled(true);

        vm.prank(alice);
        (, uint256 amount_) = ibera.burn{value: fee}(bob, shares);

        assertEq(amount_, amount);
        assertEq(ibera.deposits(), deposits - amount);
    }

    function testBurnQueuesToWithdrawor() public {
        testMintCompoundsPrior();

        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 fee = IBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);

        uint256 amount = Math.mulDiv(deposits, shares, totalSupply);
        uint256 nonce = withdrawor.nonceRequest();

        uint256 withdraworBalance = address(withdrawor).balance;
        uint256 withdraworFees = withdrawor.fees();

        vm.prank(governor);
        ibera.setWithdrawalsEnabled(true);

        vm.prank(alice);
        (uint256 nonce_,) = ibera.burn{value: fee}(bob, shares);

        assertEq(nonce_, nonce);
        assertEq(withdrawor.nonceRequest(), nonce + 1);

        assertEq(withdrawor.fees(), withdraworFees + fee);
        assertEq(address(withdrawor).balance, withdraworBalance + fee);
        assertEq(
            withdrawor.reserves(),
            address(withdrawor).balance - withdrawor.fees()
        );

        (
            address receiver_,
            uint96 timestamp_,
            uint256 fee_,
            uint256 amountSubmit_,
            uint256 amountProcess_
        ) = withdrawor.requests(nonce);
        assertEq(receiver_, bob);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(fee_, fee);

        assertEq(amountSubmit_, amount);
        assertEq(amountProcess_, amount);
    }

    function testBurnCompoundsPrior() public {
        testMintCompoundsPrior();

        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 df = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        payable(address(receivor)).transfer(1 ether);

        (uint256 comp_, uint256 pf_) = receivor.distribution();
        assertTrue(comp_ >= min + df);

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();
        uint256 depositorNonce = depositor.nonceSlip();

        uint256 withdraworBalance = address(withdrawor).balance;
        uint256 withdraworFees = withdrawor.fees();
        uint256 withdraworNonce = withdrawor.nonceRequest();

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 wf = IBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);

        vm.prank(governor);
        ibera.setWithdrawalsEnabled(true);

        vm.expectEmit();
        emit IIBERA.Sweep(comp_);

        vm.prank(alice);
        (uint256 nonce_, uint256 amount_) = ibera.burn{value: wf}(bob, shares);

        (uint96 timestampComp_, uint256 feeComp_, uint256 amountComp_) =
            depositor.slips(depositorNonce);
        assertEq(timestampComp_, uint96(block.timestamp));
        assertEq(feeComp_, df);
        assertEq(amountComp_, comp_ - df);

        assertEq(address(depositor).balance, depositorBalance + comp_);
        assertEq(depositor.fees(), depositorFees + df);
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );
        assertEq(depositor.nonceSlip(), depositorNonce + 1);

        // check ibera state
        uint256 deposits_ = ibera.deposits();
        uint256 amount =
            Math.mulDiv((deposits + comp_ - df), shares, totalSupply);
        assertEq(deposits_, deposits + comp_ - amount - df);
        assertEq(amount_, amount);

        // check withdrawor state
        assertEq(nonce_, withdraworNonce);
        assertEq(withdrawor.nonceRequest(), nonce_ + 1);

        assertEq(withdrawor.fees(), withdraworFees + wf);
        assertEq(address(withdrawor).balance, withdraworBalance + wf);
        assertEq(
            withdrawor.reserves(),
            address(withdrawor).balance - withdrawor.fees()
        );

        (
            address receiver_,
            uint96 timestamp_,
            uint256 fee_,
            uint256 amountSubmit_,
            uint256 amountProcess_
        ) = withdrawor.requests(nonce_);
        assertEq(receiver_, bob);
        assertEq(timestamp_, uint96(block.timestamp));
        assertEq(fee_, wf);

        assertEq(amountSubmit_, amount);
        assertEq(amountProcess_, amount);
    }

    function testBurnEmitsBurn() public {
        testMintCompoundsPrior();

        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 fee = IBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);
        uint256 amount = Math.mulDiv(deposits, shares, totalSupply);
        uint256 nonce = withdrawor.nonceRequest();

        vm.prank(governor);
        ibera.setWithdrawalsEnabled(true);

        vm.expectEmit();
        emit IIBERA.Burn(bob, nonce, amount, shares, fee);

        vm.prank(alice);
        ibera.burn{value: fee}(bob, shares);
    }

    function testBurnRevertsWhenSharesZero() public {
        testMintCompoundsPrior();

        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        vm.prank(governor);
        ibera.setWithdrawalsEnabled(true);

        uint256 fee = IBERAConstants.MINIMUM_WITHDRAW_FEE;
        vm.expectRevert(IIBERA.InvalidShares.selector);
        vm.prank(alice);
        ibera.burn{value: fee}(bob, 0);
    }

    function testBurnRevertsWhenFeeBelowMinimum() public {
        testMintCompoundsPrior();

        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);

        vm.prank(governor);
        ibera.setWithdrawalsEnabled(true);

        vm.expectRevert(IIBERAWithdrawor.InvalidFee.selector);
        vm.prank(alice);
        ibera.burn(bob, shares);
    }

    function testBurnRevertsWhenNotInitialized() public {
        IBERA _ibera = new IBERA(address(infrared));
        _ibera.grantRole(_ibera.GOVERNANCE_ROLE(), governor);
        vm.prank(governor);
        _ibera.setWithdrawalsEnabled(true);
        vm.expectRevert(IIBERA.InvalidShares.selector);
        uint256 fee = IBERAConstants.MINIMUM_WITHDRAW_FEE;
        _ibera.burn{value: fee}(alice, 1e18);
    }

    function testPreviewMintMatchesActualMint() public {
        // First test basic mint without compound
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 1 ether;
        assertTrue(value > min + fee);

        // Get preview
        (uint256 previewShares, uint256 previewFee) = ibera.previewMint(value);

        // Do actual mint
        (uint256 nonce, uint256 actualShares) = ibera.mint{value: value}(alice);

        // Compare results
        assertEq(
            previewShares,
            actualShares,
            "Preview shares should match actual shares"
        );
        assertEq(previewFee, fee, "Preview fee should match actual fee");
    }

    function testPreviewMintWithCompoundMatchesActualMint() public {
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        payable(address(receivor)).transfer(1 ether);

        (uint256 compAmount, uint256 pf) = receivor.distribution();
        assertTrue(compAmount >= min + fee);

        uint256 value = 100 ether;

        // Get compound preview before any state changes
        (uint256 previewShares, uint256 previewFee) = ibera.previewMint(value);

        // Do actual mint which will compound first
        (uint256 nonce, uint256 actualShares) = ibera.mint{value: value}(alice);

        assertEq(
            previewShares,
            actualShares,
            "Preview shares should match actual shares with compound"
        );
        assertEq(
            previewFee, fee, "Preview fee should match actual fee with compound"
        );
    }

    function testPreviewMintReturnsZeroForInvalidAmount() public {
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 0.001 ether;
        assertTrue(value < min + fee);

        (uint256 shares, uint256 previewFee) = ibera.previewMint(value);
        assertEq(shares, 0, "Should return 0 shares for invalid amount");
        assertEq(previewFee, fee, "Should still return fee amount");
    }

    function testPreviewBurnMatchesActualBurn() public {
        // Setup mint first like in testBurn
        testMintCompoundsPrior();

        vm.startPrank(governor);
        ibera.setWithdrawalsEnabled(true);
        ibera.setDepositSignature(pubkey0, signature0);
        vm.stopPrank();
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);

        uint256 shares = ibera.balanceOf(alice) / 3;
        assertTrue(shares > 0);

        // Get preview
        (uint256 previewAmount, uint256 previewFee) = ibera.previewBurn(shares);

        // Do actual burn
        vm.prank(alice);
        (uint256 nonce, uint256 actualAmount) =
            ibera.burn{value: IBERAConstants.MINIMUM_WITHDRAW_FEE}(bob, shares);

        assertEq(
            previewAmount,
            actualAmount,
            "Preview amount should match actual amount"
        );
        assertEq(
            previewFee,
            IBERAConstants.MINIMUM_WITHDRAW_FEE,
            "Preview fee should match withdraw fee"
        );
    }

    function testPreviewBurnWithCompoundMatchesActualBurn() public {
        // Setup compound scenario
        testMintCompoundsPrior();

        // Setup validator signature like in testBurn
        vm.startPrank(governor);
        ibera.setWithdrawalsEnabled(true);
        ibera.setDepositSignature(pubkey0, signature0);
        vm.stopPrank();
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, IBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(pubkey0, _reserves - IBERAConstants.INITIAL_DEPOSIT);
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        // Add rewards to test compound
        payable(address(receivor)).transfer(1 ether);

        uint256 shares = ibera.balanceOf(alice) / 3;
        assertTrue(shares > 0);

        // Get preview before any state changes
        (uint256 previewAmount, uint256 previewFee) = ibera.previewBurn(shares);

        // Do actual burn
        vm.prank(alice);
        (uint256 nonce, uint256 actualAmount) =
            ibera.burn{value: IBERAConstants.MINIMUM_WITHDRAW_FEE}(bob, shares);

        assertEq(
            previewAmount,
            actualAmount,
            "Preview amount should match actual amount with compound"
        );
        assertEq(
            previewFee,
            IBERAConstants.MINIMUM_WITHDRAW_FEE,
            "Preview fee should match withdraw fee with compound"
        );
    }

    function testPreviewBurnReturnsZeroForInvalidShares() public {
        (uint256 amount, uint256 fee) = ibera.previewBurn(0);
        assertEq(amount, 0, "Should return 0 amount for 0 shares");
        assertEq(
            fee,
            IBERAConstants.MINIMUM_WITHDRAW_FEE,
            "Should still return withdraw fee"
        );
    }

    function testRegisterUpdatesStakeWhenDeltaGreaterThanZero() public {
        uint256 stake = ibera.stakes(pubkey0);
        uint256 amount = 1 ether;
        int256 delta = int256(amount);

        vm.prank(address(depositor));
        ibera.register(pubkey0, delta);
        assertEq(ibera.stakes(pubkey0), stake + amount);
    }

    function testRegisterUpdatesStakeWhenDeltaLessThanZero() public {
        testRegisterUpdatesStakeWhenDeltaGreaterThanZero();
        uint256 stake = ibera.stakes(pubkey0);
        uint256 amount = 0.25 ether;
        assertTrue(amount <= stake);

        int256 delta = -int256(amount);
        vm.prank(address(withdrawor));
        ibera.register(pubkey0, delta);
        assertEq(ibera.stakes(pubkey0), stake - amount);
    }

    function testRegisterEmitsRegister() public {
        uint256 stake = ibera.stakes(pubkey0);
        uint256 amount = 1 ether;
        int256 delta = int256(amount);

        vm.expectEmit();
        emit IIBERA.Register(pubkey0, delta, stake + amount);
        vm.prank(address(withdrawor));
        ibera.register(pubkey0, delta);
    }

    function testRegisterRevertsWhenUnauthorized() public {
        uint256 stake = ibera.stakes(pubkey0);
        uint256 amount = 1 ether;
        int256 delta = int256(amount);
        vm.expectRevert(IIBERA.Unauthorized.selector);
        ibera.register(pubkey0, delta);
    }

    function testsetFeeShareholdersUpdatesFeeProtocol() public {
        assertEq(ibera.feeShareholders(), 0);
        uint16 feeShareholders = 4; // 25% of fees
        vm.prank(governor);
        ibera.setFeeShareholders(feeShareholders);
        assertEq(ibera.feeShareholders(), feeShareholders);
    }

    function testsetFeeShareholdersEmitssetFeeShareholders() public {
        assertEq(ibera.feeShareholders(), 0);
        uint16 feeShareholders = 4; // 25% of fees

        vm.expectEmit();
        emit IIBERA.SetFeeShareholders(0, feeShareholders);
        vm.prank(governor);
        ibera.setFeeShareholders(feeShareholders);
    }

    function testsetFeeShareholdersRevertsWhenUnauthorized() public {
        assertEq(ibera.feeShareholders(), 0);
        uint16 feeShareholders = 4; // 25% of fees
        vm.expectRevert(IIBERA.Unauthorized.selector);
        ibera.setFeeShareholders(feeShareholders);
    }

    function testSetDepositSignatureUpdatesSignature() public {
        assertEq(ibera.signatures(pubkey0).length, 0);
        vm.prank(governor);
        ibera.setDepositSignature(pubkey0, signature0);
        assertEq(ibera.signatures(pubkey0), signature0);
    }

    function testSetDepositSignatureEmitsSetDepositSignature() public {
        assertEq(ibera.signatures(pubkey0).length, 0);
    }

    function testSetDepositSignatureRevertsWhenUnauthorized() public {
        assertEq(ibera.signatures(pubkey0).length, 0);
    }
}
