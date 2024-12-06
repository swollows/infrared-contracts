// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import {IIBERAClaimor} from "src/interfaces/IIBERAClaimor.sol";
import {IBERABaseTest} from "./IBERABase.t.sol";

contract IBERAClaimorTest is IBERABaseTest {
    function testQueueUpdatesClaims() public {
        uint256 claim = claimor.claims(alice);
        uint256 balance = address(claimor).balance;
        uint256 amount = 1 ether;

        claimor.queue{value: amount}(alice);
        assertEq(claimor.claims(alice), claim + amount);
        assertEq(address(claimor).balance, balance + amount);
    }

    function testQueueEmitsQueue() public {
        uint256 claim = claimor.claims(alice);
        uint256 amount = 1 ether;

        vm.expectEmit();
        emit IIBERAClaimor.Queue(alice, amount, claim + amount);
        claimor.queue{value: amount}(alice);
    }

    function testSweepUpdatesClaims() public {
        testQueueUpdatesClaims();
        assertTrue(claimor.claims(alice) > 0);
        claimor.sweep(alice);
        assertEq(claimor.claims(alice), 0);
    }

    function testSweepTransfersETH() public {
        testQueueUpdatesClaims();
        uint256 claim = claimor.claims(alice);
        assertTrue(claim > 0);

        uint256 balanceClaimor = address(claimor).balance;
        uint256 balanceAlice = address(alice).balance;

        claimor.sweep(alice);
        assertEq(address(claimor).balance, balanceClaimor - claim);
        assertEq(address(alice).balance, balanceAlice + claim);
    }

    function testSweepEmitsSweep() public {
        testQueueUpdatesClaims();
        uint256 claim = claimor.claims(alice);
        assertTrue(claim > 0);

        vm.expectEmit();
        emit IIBERAClaimor.Sweep(alice, claim, 0);
        claimor.sweep(alice);
    }
}
