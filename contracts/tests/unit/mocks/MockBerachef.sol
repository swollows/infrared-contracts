// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import {IBeraChef} from "@berachain/interfaces/IBeraChef.sol";

contract MockBeraChef is IBeraChef {
    struct ValidatorInfo {
        CuttingBoard activeCuttingBoard;
        CuttingBoard queuedCuttingBoard;
        address delegationAddress;
    }

    mapping(address => ValidatorInfo) public validators;
    CuttingBoard public defaultCuttingBoard;
    bool public ready = false;
    uint8 public maxNumWeightsPerCuttingBoard;
    uint64 public cuttingBoardBlockDelay;

    // Admin Functions
    function setMaxNumWeightsPerCuttingBoard(
        uint8 _maxNumWeightsPerCuttingBoard
    ) external override {
        maxNumWeightsPerCuttingBoard = _maxNumWeightsPerCuttingBoard;
    }

    function setCuttingBoardBlockDelay(uint64 _cuttingBoardBlockDelay)
        external
        override
    {
        cuttingBoardBlockDelay = _cuttingBoardBlockDelay;
    }

    function updateFriendsOfTheChef(address receiver, bool isFriendOfTheChef)
        external
        override
    {
        // Simulate updating friends of the chef (whitelisting)
    }

    function setDefaultCuttingBoard(CuttingBoard calldata cuttingBoard)
        external
        override
    {
        defaultCuttingBoard = cuttingBoard;
        emit SetDefaultCuttingBoard(block.number, cuttingBoard);
        ready = true;
    }

    // Setters
    function queueNewCuttingBoard(
        address valCoinbase,
        uint64 startBlock,
        Weight[] calldata weights
    ) external override {
        validators[valCoinbase].queuedCuttingBoard =
            CuttingBoard(startBlock, weights);
        emit QueueCuttingBoard(valCoinbase, startBlock, weights);
    }

    function activateQueuedCuttingBoard(address valCoinbase)
        external
        override
    {
        ValidatorInfo storage validator = validators[valCoinbase];
        validator.activeCuttingBoard = validator.queuedCuttingBoard;
        emit ActivateCuttingBoard(
            valCoinbase,
            validator.queuedCuttingBoard.startBlock,
            validator.queuedCuttingBoard.weights
        );
    }

    function setDelegation(address delegationAddress) external override {
        validators[msg.sender].delegationAddress = delegationAddress;
        emit SetDelegation(msg.sender, delegationAddress);
    }

    // Getters
    function getActiveCuttingBoard(address valCoinbase)
        external
        view
        override
        returns (CuttingBoard memory)
    {
        return validators[valCoinbase].activeCuttingBoard;
    }

    function getQueuedCuttingBoard(address valCoinbase)
        external
        view
        override
        returns (CuttingBoard memory)
    {
        return validators[valCoinbase].queuedCuttingBoard;
    }

    function getDelegation(address valCoinbase)
        external
        view
        override
        returns (address)
    {
        return validators[valCoinbase].delegationAddress;
    }

    function getDefaultCuttingBoard()
        external
        view
        override
        returns (CuttingBoard memory)
    {
        return defaultCuttingBoard;
    }

    function isQueuedCuttingBoardReady(address valCoinbase)
        external
        view
        override
        returns (bool)
    {
        return block.number
            >= validators[valCoinbase].queuedCuttingBoard.startBlock;
    }

    function isReady() external view override returns (bool) {
        return ready;
    }
}
