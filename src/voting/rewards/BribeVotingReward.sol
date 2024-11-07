// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.26;

import {IVoter} from "../interfaces/IVoter.sol";
import {VotingReward} from "./VotingReward.sol";

/**
 * @title BribeVotingReward
 * @notice Implementation of voting rewards for bribes based on user votes
 * @dev Final implementation of voting rewards specifically for bribe distribution
 */
contract BribeVotingReward is VotingReward {
    /**
     * @notice Initializes bribe voting rewards
     * @param _voter Address of voter contract
     * @param _rewards Initial array of reward token addresses
     */
    constructor(address _voter, address[] memory _rewards)
        VotingReward(_voter, _rewards)
    {}

    /**
     * @inheritdoc VotingReward
     * @dev Validates and whitelists reward tokens before processing
     */
    function notifyRewardAmount(address token, uint256 amount)
        external
        override
        nonReentrant
    {
        if (!isReward[token]) {
            if (!IVoter(voter).isWhitelistedToken(token)) {
                revert NotWhitelisted();
            }
            isReward[token] = true;
            rewards.push(token);
        }

        _notifyRewardAmount(msg.sender, token, amount);
    }
}
