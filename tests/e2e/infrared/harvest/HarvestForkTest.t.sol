// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {IBeraChef} from "@berachain/pol/interfaces/IBeraChef.sol";
import {IRewardVault} from "@berachain/pol/interfaces/IRewardVault.sol";
import {IMultiRewards} from "@interfaces/IMultiRewards.sol";

import {InfraredForkTest} from "../../InfraredForkTest.t.sol";

contract HarvestForkTest is InfraredForkTest {
/*
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
    */
}
