// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IREDVestingFactory} from "@vesting/IREDVestingFactory.sol";
import {Helper} from "./Helper.sol";

contract VestingWalletTest is Helper {
    function testVestingWalletDeploymentForTreasury() public {
        assertEq(_treasuryVestingWallet.owner(), address(1));
        assertEq(_treasuryVestingWallet.start(), uint64(block.timestamp));
        assertEq(_treasuryVestingWallet.duration(), 365 days);
    }

    function testVestingWalletDeploymentForTeam() public {
        assertEq(_teamVestingWallet.owner(), address(2));
        assertEq(_teamVestingWallet.start(), uint64(block.timestamp));
        assertEq(_teamVestingWallet.duration(), 720 days);
    }

    function testVestingWalletDeploymentForInvestor() public {
        assertEq(_investorVestingWallet.owner(), address(3));
        assertEq(_investorVestingWallet.start(), uint64(block.timestamp));
        assertEq(_investorVestingWallet.duration(), 900 days);
    }
}
