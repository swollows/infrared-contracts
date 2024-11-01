// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.26;

import {IVoter} from "../interfaces/IVoter.sol";
import {VotingReward} from "./VotingReward.sol";

/// @notice Bribes pay out rewards for a given pool based on the votes that were received from the user (goes hand in hand with Voter.vote())
contract BribeVotingReward is VotingReward {
    constructor(address _voter, address[] memory _rewards)
        VotingReward(_voter, _rewards)
    {}

    /// @inheritdoc VotingReward
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
