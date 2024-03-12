// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";
import {MultiRewards} from "@core/MultiRewards.sol";
import {SafeMath} from "@utils/SafeMath.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

/// @notice Multirewards but focused on single reward token
/// @dev For testing InfraredVault.sol and Infrared.sol
contract MockBerachainRewardsVault is MultiRewards {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address public bgt;
    address public distributor;
    mapping(address => address) public operator;

    constructor(address _stakingToken) MultiRewards(_stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }

    function initialize(
        address _bgt,
        address _distributor,
        uint256 _rewardDuration
    ) external {
        distributor = _distributor;
        bgt = _bgt;
        _addReward(bgt, distributor, _rewardDuration);
    }

    function earned(address account) external view returns (uint256) {
        return earned(account, bgt);
    }

    function getRewardForDuration() external view returns (uint256) {
        address _rewardsToken = bgt;
        return rewardData[_rewardsToken].rewardRate.mul(
            rewardData[_rewardsToken].rewardsDuration
        );
    }

    function lastTimeRewardApplicable() external view returns (uint256) {
        return lastTimeRewardApplicable(bgt);
    }

    function rewardPerToken() external view returns (uint256) {
        return rewardPerToken(bgt);
    }

    function setDistributor(address _distributor) external {
        distributor = _distributor;
    }

    function notifyRewardAmount(uint256 rewards) external {
        _notifyRewardAmount(bgt, rewards);
    }

    function recoverERC20(address token, uint256 amount) external {
        _recoverERC20(msg.sender, token, amount);
    }

    function setRewardsDuration(uint256 _duration) external {
        _setRewardsDuration(bgt, _duration);
    }

    // function getReward(address user) external {
    //     getRewardForUser(user);
    // }

    event RewardsClaimedByOperator(
        address operator, address user, uint256 amount
    );

    function getReward(address user) external {
        require(
            msg.sender == user || operator[user] == msg.sender,
            "msg.sender != user or operator"
        );
        getRewardForUser(user);
    }

    function setOperator(address _operator) external {
        operator[msg.sender] = _operator;
    }

    // no-ops
    function pause(bool _paused) external {}

    function onStake(uint256 amount) internal override {}

    function onWithdraw(uint256 amount) internal override {}
}
