// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IMultiRewards} from "@interfaces/IMultiRewards.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

import {HarvestForkTest} from "./HarvestForkTest.t.sol";

contract HarvestBaseForkTest is HarvestForkTest {
    function testHarvestBase() public {
        IInfraredVault wiberaVault = infrared.wiberaVault();

        uint256 ibgtTotalSupply = ibgt.totalSupply();
        uint256 ibgtBalanceVault = ibgt.balanceOf(address(wiberaVault));
        uint256 bgtBalance = bgt.balanceOf(address(infrared));
        assertTrue(ibgtTotalSupply == 0);
        assertTrue(bgtBalance > 0);

        uint256 amount = bgtBalance - ibgtTotalSupply;

        vm.startPrank(admin);

        // TODO: include protocol fee rate
        infrared.harvestBase();

        // check balances
        assertEq(bgt.balanceOf(address(infrared)), bgtBalance);
        assertEq(ibgt.totalSupply(), ibgtTotalSupply + amount);
        assertEq(
            ibgt.balanceOf(address(wiberaVault)), ibgtBalanceVault + amount
        );
        assertEq(bgt.balanceOf(address(infrared)), ibgt.totalSupply());

        // check reward notified in vault
        (, uint256 rewardDuration,, uint256 rewardRate, uint256 lastUpdateTime,)
        = IMultiRewards(address(wiberaVault)).rewardData(address(ibgt));
        assertEq(rewardRate, amount / rewardDuration);
        assertEq(lastUpdateTime, block.timestamp);

        vm.stopPrank();
    }
}
