// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";
import {IMultiRewards} from "@interfaces/IMultiRewards.sol";

import {HarvestForkTest} from "./HarvestForkTest.t.sol";

contract HarvestVaultForkTest is HarvestForkTest {
    function testHarvestVault() public {
        // stake lp token in vault to prep to earn rewards
        lpToken.approve(address(lpVault), type(uint256).max);
        lpVault.stake(100 ether);

        vm.startPrank(admin);

        // move timestamp forward to accumulate berachain vault rewards
        vm.warp(block.timestamp + 1 days);

        IBerachainRewardsVault lpRewardsVault = lpVault.rewardsVault();
        uint256 reward = lpRewardsVault.earned(address(lpVault));

        uint256 bgtBalanceInfraredBefore = bgt.balanceOf(address(infrared));
        uint256 ibgtTotalSupplyBefore = ibgt.totalSupply();
        uint256 ibgtBalanceVaultBefore = ibgt.balanceOf(address(lpVault));

        // TODO: include protocol fee rate
        infrared.harvestVault(address(lpToken));

        assertEq(
            bgt.balanceOf(address(infrared)), bgtBalanceInfraredBefore + reward
        );
        assertEq(ibgt.totalSupply(), ibgtTotalSupplyBefore + reward);
        assertEq(
            ibgt.balanceOf(address(lpVault)), ibgtBalanceVaultBefore + reward
        );

        // check reward notified in vault
        (, uint256 rewardDuration,, uint256 rewardRate, uint256 lastUpdateTime,)
        = IMultiRewards(address(lpVault)).rewardData(address(ibgt));
        assertEq(rewardRate, reward / rewardDuration);
        assertEq(lastUpdateTime, block.timestamp);

        vm.stopPrank();
    }
}
