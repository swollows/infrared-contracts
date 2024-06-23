// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IBeraChef} from "@berachain/interfaces/IBeraChef.sol";
import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";
import {IMultiRewards} from "@interfaces/IMultiRewards.sol";

import {InfraredForkTest} from "../InfraredForkTest.t.sol";

contract HarvestVaultForkTest is InfraredForkTest {
    function setUp() public virtual override {
        super.setUp();

        vm.startPrank(admin);

        // add validator
        address[] memory _validators = new address[](1);
        uint256[] memory _commissions = new uint256[](1);

        _validators[0] = infraredValidator;
        _commissions[0] = 1e2; // 1%

        infrared.addValidators(_validators, _commissions);

        // queue cutting board
        address lpRewardsVaultAddress = address(lpVault.rewardsVault());
        IBeraChef.Weight[] memory _weights = new IBeraChef.Weight[](1);
        _weights[0] = IBeraChef.Weight({
            receiver: lpRewardsVaultAddress,
            percentageNumerator: 1e4
        });
        uint64 _startBlock =
            uint64(block.number) + beraChef.cuttingBoardBlockDelay() + 1;

        infrared.queueNewCuttingBoard(infraredValidator, _startBlock, _weights);

        // move forward beyond buffer length so enough time passed through buffer
        vm.roll(block.number + HISTORY_BUFFER_LENGTH + 1);

        // activate cutting board by rolling with pol now over single block
        rollPol(infraredValidator, block.number + 1);

        vm.stopPrank();
    }

    function testSetUp() public virtual override {
        super.testSetUp();

        assertEq(infrared.numInfraredValidators(), 1);
        assertEq(infrared.isInfraredValidator(infraredValidator), true);

        (, uint256 rate) = bgt.commissions(infraredValidator);
        assertEq(rate, 1e2);

        IBeraChef.CuttingBoard memory acb =
            beraChef.getActiveCuttingBoard(infraredValidator);
        assertTrue(acb.startBlock > 0);
        assertEq(acb.weights.length, 1);
        assertEq(acb.weights[0].receiver, address(lpVault.rewardsVault()));
        assertEq(acb.weights[0].percentageNumerator, 1e4);

        assertTrue(infrared.getBGTBalance() > 0);
    }

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
