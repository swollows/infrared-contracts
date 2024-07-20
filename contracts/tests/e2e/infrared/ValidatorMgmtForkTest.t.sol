// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IBeraChef} from "@berachain/interfaces/IBeraChef.sol";
import {InfraredForkTest} from "../InfraredForkTest.t.sol";

// TODO: test validator mgmt with bribes accumulated
contract ValidatorMgmtForkTest is InfraredForkTest {
/* TODO: fix for bytes validators
    function testAddValidators() public {
        vm.startPrank(admin);

        // priors checked
        assertEq(infrared.numInfraredValidators(), 0);
        assertEq(infrared.isInfraredValidator(infraredValidator), false);

        (, uint256 rate) = bgt.commissions(infraredValidator);
        assertEq(rate, 0);

        // add validator with commission weight
        address[] memory _validators = new address[](1);
        uint256[] memory _commissions = new uint256[](1);

        _validators[0] = infraredValidator;
        _commissions[0] = 1e2; // 1%

        infrared.addValidators(_validators, _commissions);

        // check validator added to infrared set
        assertEq(infrared.numInfraredValidators(), 1);
        assertEq(infrared.isInfraredValidator(infraredValidator), true);

        // check bgt commission rate updated for validator
        (, rate) = bgt.commissions(infraredValidator);
        assertEq(rate, 1e2);

        vm.stopPrank();
    }

    function testRemoveValidators() public {
        testAddValidators();

        // move forward beyond buffer length so enough time passed
        vm.roll(block.number + HISTORY_BUFFER_LENGTH + 1);
        vm.startPrank(admin);

        // remove infrared validator
        address[] memory _validators = new address[](1);
        _validators[0] = infraredValidator;

        infrared.removeValidators(_validators);

        // check valdiator removed from infrared set
        assertEq(infrared.numInfraredValidators(), 0);
        assertEq(infrared.isInfraredValidator(infraredValidator), false);

        // check bgt commission rate zeroed for validator
        (, uint256 rate) = bgt.commissions(infraredValidator);
        assertEq(rate, 0);

        vm.stopPrank();
    }

    function testReplaceValidator() public {
        testAddValidators();

        address _newValidator = address(0xA);
        vm.prank(_newValidator);
        beraChef.setOperator(address(infrared));

        // move forward beyond buffer length so enough time passed
        vm.roll(block.number + HISTORY_BUFFER_LENGTH + 1);
        vm.startPrank(admin);

        infrared.replaceValidator(infraredValidator, _newValidator);

        // check validator replaced in infrared set
        assertEq(infrared.numInfraredValidators(), 1);
        assertEq(infrared.isInfraredValidator(infraredValidator), false);
        assertEq(infrared.isInfraredValidator(_newValidator), true);

        // check bgt commission rate zeroed for prior validator and updated for new validator
        (, uint256 oldRate) = bgt.commissions(infraredValidator);
        (, uint256 newRate) = bgt.commissions(_newValidator);
        assertEq(oldRate, 0);
        assertEq(newRate, 1e2);

        vm.stopPrank();
    }

    function testUpdateValidatorCommission() public {
        testAddValidators();

        // move forward beyond buffer length so enough time passed
        vm.roll(block.number + HISTORY_BUFFER_LENGTH + 1);
        vm.startPrank(admin);

        infrared.updateValidatorCommission(infraredValidator, 2e2);

        // check bgt commission rate updated
        (, uint256 rate) = bgt.commissions(infraredValidator);
        assertEq(rate, 2e2);

        vm.stopPrank();
    }

    function testQueueNewCuttingBoard() public {
        testAddValidators();

        vm.startPrank(admin);

        // weight 100% of distributed rewards to lp vault
        address lpRewardsVaultAddress = address(lpVault.rewardsVault());
        IBeraChef.Weight[] memory _weights = new IBeraChef.Weight[](1);
        _weights[0] = IBeraChef.Weight({
            receiver: lpRewardsVaultAddress,
            percentageNumerator: 1e4
        });
        uint64 _startBlock =
            uint64(block.number) + beraChef.cuttingBoardBlockDelay() + 1;

        infrared.queueNewCuttingBoard(infraredValidator, _startBlock, _weights);

        // check cutting board queued for validator
        IBeraChef.CuttingBoard memory qcb =
            beraChef.getQueuedCuttingBoard(infraredValidator);
        assertEq(qcb.startBlock, _startBlock);
        assertEq(qcb.weights.length, 1);
        assertEq(qcb.weights[0].receiver, lpRewardsVaultAddress);
        assertEq(qcb.weights[0].percentageNumerator, 1e4);

        // move forward beyond buffer length so enough time passed through buffer
        vm.roll(block.number + HISTORY_BUFFER_LENGTH + 1);

        // roll with pol now over single block
        rollPol(infraredValidator, block.number + 1);

        // check cutting board activates for validator once roll pol again
        IBeraChef.CuttingBoard memory acb =
            beraChef.getActiveCuttingBoard(infraredValidator);
        assertEq(acb.startBlock, qcb.startBlock);
        assertEq(acb.weights.length, 1);
        assertEq(acb.weights[0].receiver, lpRewardsVaultAddress);
        assertEq(acb.weights[0].percentageNumerator, 1e4);

        // check queued cutting board deleted
        qcb = beraChef.getQueuedCuttingBoard(infraredValidator);
        assertEq(qcb.startBlock, 0);
        assertEq(qcb.weights.length, 0);
    }
    */

// TODO: BGTMgmtForkTest.t.sol separately for boosts
}
