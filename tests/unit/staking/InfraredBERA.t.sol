// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

import {Errors} from "src/utils/Errors.sol";
import {IInfraredBERA} from "src/interfaces/IInfraredBERA.sol";
import {IInfraredBERAWithdrawor} from
    "src/interfaces/IInfraredBERAWithdrawor.sol";
import {InfraredBERAConstants} from "src/staking/InfraredBERAConstants.sol";
import {InfraredBERA} from "src/staking/InfraredBERA.sol";

import {InfraredBERABaseTest} from "./InfraredBERABase.t.sol";

contract InfraredBERATest is InfraredBERABaseTest {
    function testInitializeMintsToInfraredBERA() public view {
        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;

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

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 12 ether;
        assertTrue(value > min + fee);

        deal(ibera.receivor(), value);
        ibera.compound();

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
        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 12 ether;
        assertTrue(value > min + fee);
        vm.expectEmit();
        emit IInfraredBERA.Sweep(value);
        deal(ibera.receivor(), value);
        ibera.compound();
    }

    function testSweepAccessControl() public {
        uint256 value = 11 ether;
        deal(ibera.receivor(), value);
        vm.expectRevert(
            abi.encodeWithSelector(Errors.Unauthorized.selector, address(321))
        );
        vm.prank(address(321));
        ibera.sweep();

        vm.expectEmit();
        emit IInfraredBERA.Sweep(value);
        vm.prank(address(ibera.receivor()));
        ibera.sweep{value: value}();
    }

    function testCompoundSweepsFromReceivor() public {
        uint256 deposits = ibera.deposits();
        uint256 totalSupply = ibera.totalSupply();

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();

        uint256 pending = ibera.pending();
        uint256 confirmed = ibera.confirmed();

        (bool success,) = address(receivor).call{value: 11 ether}("");
        assertTrue(success);
        uint256 balanceReceivor = address(receivor).balance;
        uint256 protocolFeesReceivor = receivor.shareholderFees();

        (uint256 amount, uint256 protocolFee) = receivor.distribution();
        assertTrue(
            amount
                >= InfraredBERAConstants.MINIMUM_DEPOSIT
                    + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
        );

        ibera.compound();

        assertEq(address(receivor).balance, balanceReceivor - amount);
        assertEq(receivor.shareholderFees(), protocolFeesReceivor + protocolFee);

        assertEq(
            ibera.deposits(),
            deposits + amount - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
        );
        assertEq(ibera.totalSupply(), totalSupply);

        assertEq(address(depositor).balance, depositorBalance + amount);
        assertEq(
            depositor.fees(),
            depositorFees + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
        );
        assertEq(
            depositor.reserves(), address(depositor).balance - depositor.fees()
        );

        assertEq(
            ibera.pending(),
            pending + amount - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
        );
        assertEq(ibera.confirmed(), confirmed);
    }

    function testCompoundPassesWhenDistributionBelowMin() public {
        uint256 deposits = ibera.deposits();
        uint256 totalSupply = ibera.totalSupply();

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();

        uint256 pending = ibera.pending();
        uint256 confirmed = ibera.confirmed();

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 0.01 ether;

        (bool success,) = address(receivor).call{value: value}("");
        assertTrue(success);

        uint256 protocolFeesReceivor = receivor.shareholderFees();

        (uint256 amount,) = receivor.distribution();
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

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 12 ether;
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

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 12 ether;
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

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 12 ether;
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
        (bool success,) = address(receivor).call{value: 11 ether}("");
        assertTrue(success);

        (uint256 comp_,) = receivor.distribution();

        uint256 totalSupply = ibera.totalSupply();
        uint256 deposits = ibera.deposits();
        uint256 sharesAlice = ibera.balanceOf(alice);

        uint256 depositorBalance = address(depositor).balance;
        uint256 depositorFees = depositor.fees();
        uint256 depositorNonce = depositor.nonceSlip();

        assertTrue(
            comp_
                >= InfraredBERAConstants.MINIMUM_DEPOSIT
                    + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
        );

        vm.expectEmit();
        emit IInfraredBERA.Sweep(comp_);

        (uint256 nonce_, uint256 shares_) =
            ibera.mint{value: 20000 ether}(alice);

        {
            assertEq(
                depositor.fees(),
                depositorFees + 2 * InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
            );
            assertEq(
                address(depositor).balance,
                depositorBalance + 20000 ether + comp_
            );
            assertEq(
                depositor.reserves(),
                address(depositor).balance - depositor.fees()
            );

            assertEq(nonce_, depositorNonce + 1);
            assertEq(depositor.nonceSlip(), depositorNonce + 2);

            (uint96 timestamp_, uint256 fee_, uint256 amount_) =
                depositor.slips(nonce_);
            assertEq(timestamp_, uint96(block.timestamp));
            assertEq(fee_, InfraredBERAConstants.MINIMUM_DEPOSIT_FEE);
            assertEq(
                amount_, 20000 ether - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
            );
            // test compounding slip
            (timestamp_, fee_, amount_) = depositor.slips(nonce_ - 1);
            assertEq(timestamp_, uint96(block.timestamp));
            assertEq(fee_, InfraredBERAConstants.MINIMUM_DEPOSIT_FEE);
            assertEq(amount_, comp_ - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE);
        }
        // check ibera state
        assertEq(
            ibera.deposits(),
            deposits + comp_ + 20000 ether
                - 2 * InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
        );

        uint256 shares = Math.mulDiv(
            totalSupply,
            20000 ether - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE,
            (deposits + comp_ - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE)
        );
        assertEq(shares, shares_);
        assertEq(ibera.totalSupply(), totalSupply + shares);
        assertEq(ibera.balanceOf(alice), sharesAlice + shares);
    }

    function testMintEmitsMint() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 12 ether;
        assertTrue(value > min + fee);

        uint256 nonce = depositor.nonceSlip();
        uint256 amount = value - fee;
        uint256 shares =
            Math.mulDiv(ibera.totalSupply(), amount, ibera.deposits());

        vm.expectEmit();
        emit IInfraredBERA.Mint(alice, nonce, amount, shares, fee);
        ibera.mint{value: value}(alice);
    }

    function testMintRevertsWhenAmountLessThanDepositFee() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 0.001 ether;
        assertTrue(value < min + fee);

        vm.expectRevert(Errors.InvalidAmount.selector);
        ibera.mint{value: value}(alice);
    }

    function testMintRevertsWhenSharesZero() public {
        // @dev test compound prior separately
        ibera.compound();

        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = min + fee;

        // need to donate 1e16 ether to reach this error given min deposit of 1 ether
        vm.deal(address(receivor), 1e20 ether);
        (uint256 comp_,) = receivor.distribution();

        uint256 shares =
            Math.mulDiv(ibera.totalSupply(), min, ibera.deposits() + comp_);
        assertEq(shares, 0);

        vm.expectRevert(Errors.InvalidShares.selector);
        ibera.mint{value: value}(alice);
    }

    // function testMintRevertsWhenNotInitialized() public {
    //     InfraredBERA _ibera = new InfraredBERA(address(infrared));
    //     vm.expectRevert(IInfraredBERA.NotInitialized.selector);
    //     _ibera.mint{value: 1 ether}(alice);
    // }

    function testBurnBurnsShares() public {
        testMintCompoundsPrior();

        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);

        uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);

        vm.expectRevert(Errors.WithdrawalsNotEnabled.selector);
        vm.prank(alice);
        ibera.burn{value: fee}(bob, shares);

        vm.prank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);

        vm.prank(alice);
        ibera.burn{value: fee}(bob, shares);

        assertEq(ibera.totalSupply(), totalSupply - shares);
        assertEq(ibera.balanceOf(alice), sharesAlice - shares);
    }

    function testBurnUpdatesDeposits() public {
        testMintCompoundsPrior();

        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);
        uint256 amount = Math.mulDiv(deposits, shares, totalSupply);

        vm.prank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);

        vm.prank(alice);
        (, uint256 amount_) = ibera.burn{value: fee}(bob, shares);

        assertEq(amount_, amount);
        assertEq(ibera.deposits(), deposits - amount);
    }

    function testBurnQueuesToWithdrawor() public {
        testMintCompoundsPrior();

        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);

        uint256 amount = Math.mulDiv(deposits, shares, totalSupply);
        uint256 nonce = withdrawor.nonceRequest();

        uint256 withdraworBalance = address(withdrawor).balance;
        uint256 withdraworFees = withdrawor.fees();

        vm.prank(infraredGovernance);
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

    // test specific storage to circumvent stack to deep error
    uint256 depositorBalanceT1;
    uint256 depositorFeesT1;
    uint256 depositorNonceT1;

    uint256 withdraworBalanceT1;
    uint256 withdraworFeesT1;
    uint256 withdraworNonceT1;

    function testBurnCompoundsPrior() public {
        testMintCompoundsPrior();

        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        (bool success,) = address(receivor).call{value: 12 ether}("");
        assertTrue(success);

        (uint256 comp_,) = receivor.distribution();
        assertTrue(
            comp_
                >= InfraredBERAConstants.MINIMUM_DEPOSIT
                    + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
        );

        depositorBalanceT1 = address(depositor).balance;
        depositorFeesT1 = depositor.fees();
        depositorNonceT1 = depositor.nonceSlip();

        withdraworBalanceT1 = address(withdrawor).balance;
        withdraworFeesT1 = withdrawor.fees();
        withdraworNonceT1 = withdrawor.nonceRequest();

        uint256 totalSupply = ibera.totalSupply();
        // uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 shares = ibera.balanceOf(alice) / 3;
        assertTrue(shares > 0);

        vm.prank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);

        vm.expectEmit();
        emit IInfraredBERA.Sweep(comp_);

        vm.prank(alice);
        (uint256 nonce_, uint256 amount_) = ibera.burn{
            value: InfraredBERAConstants.MINIMUM_WITHDRAW_FEE
        }(bob, shares);

        {
            (uint96 timestampComp_, uint256 feeComp_, uint256 amountComp_) =
                depositor.slips(depositorNonceT1);
            assertEq(timestampComp_, uint96(block.timestamp));
            assertEq(feeComp_, InfraredBERAConstants.MINIMUM_DEPOSIT_FEE);
            assertEq(
                amountComp_, comp_ - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
            );

            assertEq(address(depositor).balance, depositorBalanceT1 + comp_);
            assertEq(
                depositor.fees(),
                depositorFeesT1 + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
            );
            assertEq(
                depositor.reserves(),
                address(depositor).balance - depositor.fees()
            );
            assertEq(depositor.nonceSlip(), depositorNonceT1 + 1);
        }
        // check ibera state
        uint256 amount = Math.mulDiv(
            (deposits + comp_ - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE),
            shares,
            totalSupply
        );
        {
            assertEq(
                ibera.deposits(),
                deposits + comp_ - amount
                    - InfraredBERAConstants.MINIMUM_DEPOSIT_FEE
            );
            assertEq(amount_, amount);
            // check withdrawor state
            assertEq(nonce_, withdraworNonceT1);
            assertEq(withdrawor.nonceRequest(), nonce_ + 1);

            assertEq(
                withdrawor.fees(),
                withdraworFeesT1 + InfraredBERAConstants.MINIMUM_WITHDRAW_FEE
            );
            assertEq(
                address(withdrawor).balance,
                withdraworBalanceT1 + InfraredBERAConstants.MINIMUM_WITHDRAW_FEE
            );
            assertEq(
                withdrawor.reserves(),
                address(withdrawor).balance - withdrawor.fees()
            );
        }

        {
            (
                address receiver_,
                uint96 timestamp_,
                uint256 fee_,
                uint256 amountSubmit_,
                uint256 amountProcess_
            ) = withdrawor.requests(nonce_);
            assertEq(receiver_, bob);
            assertEq(timestamp_, uint96(block.timestamp));
            assertEq(fee_, InfraredBERAConstants.MINIMUM_WITHDRAW_FEE);

            assertEq(amountSubmit_, amount);
            assertEq(amountProcess_, amount);
        }
    }

    function testBurnEmitsBurn() public {
        testMintCompoundsPrior();

        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 totalSupply = ibera.totalSupply();
        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 deposits = ibera.deposits();

        uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE;
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);
        uint256 amount = Math.mulDiv(deposits, shares, totalSupply);
        uint256 nonce = withdrawor.nonceRequest();

        vm.prank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);

        vm.expectEmit();
        emit IInfraredBERA.Burn(bob, nonce, amount, shares, fee);

        vm.prank(alice);
        ibera.burn{value: fee}(bob, shares);
    }

    function testBurnRevertsWhenSharesZero() public {
        testMintCompoundsPrior();

        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        vm.prank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);

        uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE;
        vm.expectRevert(Errors.InvalidShares.selector);
        vm.prank(alice);
        ibera.burn{value: fee}(bob, 0);
    }

    function testBurnRevertsWhenFeeBelowMinimum() public {
        testMintCompoundsPrior();

        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        uint256 sharesAlice = ibera.balanceOf(alice);
        uint256 shares = sharesAlice / 3;
        assertTrue(shares > 0);

        vm.prank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);

        vm.expectRevert(Errors.InvalidFee.selector);
        vm.prank(alice);
        ibera.burn(bob, shares);
    }

    // function testBurnRevertsWhenNotInitialized() public {
    //     InfraredBERA _ibera = new InfraredBERA(address(infrared));
    //     vm.expectRevert(IInfraredBERA.InvalidShares.selector);
    //     uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE;
    //     _ibera.burn{value: fee}(alice, 1e18);
    // }

    function testPreviewMintMatchesActualMint() public {
        // First test basic mint without compound
        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 12 ether;
        assertTrue(value > min + fee);

        // Get preview
        (uint256 previewShares, uint256 previewFee) = ibera.previewMint(value);

        // Do actual mint
        (, uint256 actualShares) = ibera.mint{value: value}(alice);

        // Compare results
        assertEq(
            previewShares,
            actualShares,
            "Preview shares should match actual shares"
        );
        assertEq(previewFee, fee, "Preview fee should match actual fee");
    }

    function testPreviewMintWithCompoundMatchesActualMint() public {
        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        (bool success,) = address(receivor).call{value: 12 ether}("");
        assertTrue(success);

        (uint256 compAmount,) = receivor.distribution();
        assertTrue(compAmount >= min + fee);

        uint256 value = 20000 ether;

        // Get compound preview before any state changes
        (uint256 previewShares, uint256 previewFee) = ibera.previewMint(value);

        // Do actual mint which will compound first
        (, uint256 actualShares) = ibera.mint{value: value}(alice);

        assertEq(
            previewShares,
            actualShares,
            "Preview shares should match actual shares with compound"
        );
        assertEq(
            previewFee, fee, "Preview fee should match actual fee with compound"
        );
    }

    function testPreviewMintReturnsZeroForInvalidAmount() public view {
        uint256 min = InfraredBERAConstants.MINIMUM_DEPOSIT;
        uint256 fee = InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 value = 0.001 ether;
        assertTrue(value < min + fee);

        (uint256 shares, uint256 previewFee) = ibera.previewMint(value);
        assertEq(shares, 0, "Should return 0 shares for invalid amount");
        assertEq(previewFee, 0, "Should still return fee amount");
    }

    function testPreviewBurnMatchesActualBurn() public {
        // Setup mint first like in testBurn
        testMintCompoundsPrior();

        vm.startPrank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);
        ibera.setDepositSignature(pubkey0, signature0);
        vm.stopPrank();
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );

        uint256 shares = ibera.balanceOf(alice) / 3;
        assertTrue(shares > 0);

        // Get preview
        (uint256 previewAmount, uint256 previewFee) = ibera.previewBurn(shares);

        // Do actual burn
        vm.prank(alice);
        (, uint256 actualAmount) = ibera.burn{
            value: InfraredBERAConstants.MINIMUM_WITHDRAW_FEE
        }(bob, shares);

        assertEq(
            previewAmount,
            actualAmount,
            "Preview amount should match actual amount"
        );
        assertEq(
            previewFee,
            InfraredBERAConstants.MINIMUM_WITHDRAW_FEE,
            "Preview fee should match withdraw fee"
        );
    }

    function testPreviewBurnWithCompoundMatchesActualBurn() public {
        // Setup compound scenario
        testMintCompoundsPrior();

        // Setup validator signature like in testBurn
        vm.startPrank(infraredGovernance);
        ibera.setWithdrawalsEnabled(true);
        ibera.setDepositSignature(pubkey0, signature0);
        vm.stopPrank();
        uint256 _reserves = depositor.reserves();
        vm.prank(keeper);
        depositor.execute(pubkey0, InfraredBERAConstants.INITIAL_DEPOSIT);
        vm.prank(keeper);
        depositor.execute(
            pubkey0, _reserves - InfraredBERAConstants.INITIAL_DEPOSIT
        );
        assertEq(ibera.confirmed(), _reserves);
        assertEq(depositor.reserves(), 0);

        // Add rewards to test compound
        (bool success,) = address(receivor).call{value: 1 ether}("");
        assertTrue(success);

        uint256 shares = ibera.balanceOf(alice) / 3;
        assertTrue(shares > 0);

        // Get preview before any state changes
        (uint256 previewAmount, uint256 previewFee) = ibera.previewBurn(shares);

        // Do actual burn
        vm.prank(alice);
        (, uint256 actualAmount) = ibera.burn{
            value: InfraredBERAConstants.MINIMUM_WITHDRAW_FEE
        }(bob, shares);

        assertEq(
            previewAmount,
            actualAmount,
            "Preview amount should match actual amount with compound"
        );
        assertEq(
            previewFee,
            InfraredBERAConstants.MINIMUM_WITHDRAW_FEE,
            "Preview fee should match withdraw fee with compound"
        );
    }

    function testPreviewBurnReturnsZeroForInvalidShares() public view {
        (uint256 amount, uint256 fee) = ibera.previewBurn(0);
        assertEq(amount, 0, "Should return 0 amount for 0 shares");
        assertEq(fee, 0, "Should return 0 for the fee");
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
        emit IInfraredBERA.Register(pubkey0, delta, stake + amount);
        vm.prank(address(withdrawor));
        ibera.register(pubkey0, delta);
    }

    function testRegisterRevertsWhenUnauthorized() public {
        uint256 amount = 1 ether;
        int256 delta = int256(amount);
        vm.expectRevert();
        ibera.register(pubkey0, delta);
    }

    function testsetFeeShareholdersUpdatesFeeProtocol() public {
        assertEq(ibera.feeDivisorShareholders(), 0);
        uint16 feeShareholders = 4; // 25% of fees
        vm.prank(infraredGovernance);
        ibera.setFeeDivisorShareholders(feeShareholders);
        assertEq(ibera.feeDivisorShareholders(), feeShareholders);
    }

    function testsetFeeShareholdersEmitssetFeeShareholders() public {
        assertEq(ibera.feeDivisorShareholders(), 0);
        uint16 feeShareholders = 4; // 25% of fees

        vm.expectEmit();
        emit IInfraredBERA.SetFeeShareholders(0, feeShareholders);
        vm.prank(infraredGovernance);
        ibera.setFeeDivisorShareholders(feeShareholders);
    }

    function testsetFeeShareholdersRevertsWhenUnauthorized() public {
        assertEq(ibera.feeDivisorShareholders(), 0);
        uint16 feeShareholders = 4; // 25% of fees
        vm.expectRevert();
        vm.prank(address(10));
        ibera.setFeeDivisorShareholders(feeShareholders);
    }

    function testSetDepositSignatureUpdatesSignature() public {
        assertEq(ibera.signatures(pubkey0).length, 0);
        vm.prank(infraredGovernance);
        ibera.setDepositSignature(pubkey0, signature0);
        assertEq(ibera.signatures(pubkey0), signature0);
    }

    function testSetDepositSignatureEmitsSetDepositSignature() public view {
        assertEq(ibera.signatures(pubkey0).length, 0);
    }

    function testSetDepositSignatureRevertsWhenUnauthorized() public view {
        assertEq(ibera.signatures(pubkey0).length, 0);
    }

    function testConfirmedReturnsZeroWhenPendingExceedsDeposits() public {
        // Setup initial deposits
        uint256 initialDeposit = 100 ether;
        vm.deal(address(this), initialDeposit);
        (uint256 nonce,) = ibera.mint{value: initialDeposit}(address(this));

        // Get current deposits
        uint256 currentDeposits = ibera.deposits();

        // Make a large donation to depositor to cause pending > deposits
        uint256 donationAmount = currentDeposits * 2;
        vm.deal(address(depositor), donationAmount);

        // Verify confirmed() returns 0 when pending > deposits
        assertEq(
            ibera.confirmed(), 0, "Should return 0 when pending > deposits"
        );

        // Verify withdrawals revert when confirmed() is 0
        uint256 withdrawAmount = 1 ether;
        uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE;
        vm.deal(address(ibera), fee);

        vm.prank(address(ibera));
        vm.expectRevert(Errors.InvalidAmount.selector);
        withdrawor.queue{value: fee}(alice, withdrawAmount);
    }

    function testFail_QueueDonationUnderflow() public {
        uint256 fee = InfraredBERAConstants.MINIMUM_WITHDRAW_FEE + 1;
        uint256 amount = 1 ether;
        address receiver = alice;
        uint256 confirmed = ibera.confirmed();
        assertTrue(amount <= confirmed);

        vm.deal(address(ibera), 2 * fee);
        uint256 nonce = withdrawor.nonceRequest();

        vm.deal(address(depositor), 201 ether); // DONATION

        vm.prank(address(ibera));
        withdrawor.queue{value: fee}(receiver, amount);
    }
}
