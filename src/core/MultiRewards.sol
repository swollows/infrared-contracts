// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IMultiRewards} from "../interfaces/IMultiRewards.sol";

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {Pausable} from "@openzeppelin/utils/Pausable.sol";
import {ReentrancyGuard} from "@openzeppelin/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {Errors} from "@utils/Errors.sol";
import {Math} from "@openzeppelin/utils/math/Math.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";
import {SafeMath} from "@utils/SafeMath.sol";

/**
 * @title MultiRewards
 * @dev Fork of https://github.com/curvefi/multi-rewards with hooks on stake/withdraw of LP tokens
 */
abstract contract MultiRewards is ReentrancyGuard, Pausable, IMultiRewards {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /*//////////////////////////////////////////////////////////////
                                STATE
    //////////////////////////////////////////////////////////////*/

    // The token that users stake to earn rewards.
    IERC20 public stakingToken;

    // RewardData for each reward token.
    mapping(address => Reward) public override rewardData;

    // List of reward tokens.
    address[] public rewardTokens;

    // The amount of reward token that a user has earned.
    mapping(address => mapping(address => uint256)) public
        userRewardPerTokenPaid;

    mapping(address => mapping(address => uint256)) public rewards;

    uint256 internal _totalSupply;

    // The balance of staked token for each user.
    mapping(address => uint256) internal _balances;

    /*//////////////////////////////////////////////////////////////
                            EVENTS
    //////////////////////////////////////////////////////////////*/

    event RewardAdded(uint256 reward);

    event Staked(address indexed user, uint256 amount);

    event Withdrawn(address indexed user, uint256 amount);

    event RewardPaid(
        address indexed user, address indexed rewardsToken, uint256 reward
    );

    event RewardsDurationUpdated(address token, uint256 newDuration);

    event Recovered(address token, uint256 amount);

    event RewardStored(address rewardsToken, uint256 rewardsDuration);

    /*//////////////////////////////////////////////////////////////
                        MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Updates the reward for the given account before executing the
     * function body.
     * @param account address The account to update the reward for.
     */
    modifier updateReward(address account) {
        for (uint256 i; i < rewardTokens.length; i++) {
            address token = rewardTokens[i];
            rewardData[token].rewardPerTokenStored = rewardPerToken(token);
            rewardData[token].lastUpdateTime = lastTimeRewardApplicable(token);
            if (account != address(0)) {
                rewards[account][token] = earned(account, token);
                userRewardPerTokenPaid[account][token] =
                    rewardData[token].rewardPerTokenStored;
            }
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                        CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Constructs the MultiRewards contract.
     * @param _stakingToken address The token that users stake to earn rewards.
     */
    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }

    /*//////////////////////////////////////////////////////////////
                               READS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the number of staked tokens.
     * @return uint256 The number of staked tokens.
     */
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @notice Returns the balance of staked tokens for the given account.
     * @param account   address The account to get the balance for.
     * @return _balance uint256 The balance of staked tokens.
     */
    function balanceOf(address account)
        external
        view
        returns (uint256 _balance)
    {
        return _balances[account];
    }

    /**
     * @notice Calculates the last time reward is applicable for a given rewards token.
     * @dev This function returns the minimum between the current block timestamp and the period finish time of the rewards token.
     * @param _rewardsToken address The address of the rewards token.
     * @return              uint256 value representing the last time reward is applicable.
     */
    function lastTimeRewardApplicable(address _rewardsToken)
        public
        view
        returns (uint256)
    {
        return Math.min(block.timestamp, rewardData[_rewardsToken].periodFinish);
    }

    /**
     * @notice Calculates the reward per token for a given rewards token.
     * @param _rewardsToken address  The address of the rewards token.
     * @return A uint256 value representing the reward per token.
     * @dev This function returns the stored reward per token if the total supply is 0.
     * Otherwise, it calculates the reward per token by adding the stored reward per token to the product of the reward rate and the time difference between the last applicable time for rewards and the last update time, multiplied by 1e18 and divided by the total supply.
     */
    function rewardPerToken(address _rewardsToken)
        public
        view
        returns (uint256)
    {
        if (_totalSupply == 0) {
            return rewardData[_rewardsToken].rewardPerTokenStored;
        }
        return rewardData[_rewardsToken].rewardPerTokenStored.add(
            lastTimeRewardApplicable(_rewardsToken).sub(
                rewardData[_rewardsToken].lastUpdateTime
            ).mul(rewardData[_rewardsToken].rewardRate).mul(1e18).div(
                _totalSupply
            )
        );
    }

    /**
     * @notice Calculates the earned rewards for a given account and rewards token.
     * @dev This function calculates the earned rewards by multiplying the account balance by the difference between the reward per token and the paid reward per token for the account, dividing by 1e18, and adding the rewards for the account.
     * @param account       address The address of the account.
     * @param _rewardsToken address The address of the rewards token.
     * @return              uint256 value representing the earned rewards.
     */
    function earned(address account, address _rewardsToken)
        public
        view
        returns (uint256)
    {
        return _balances[account].mul(
            rewardPerToken(_rewardsToken).sub(
                userRewardPerTokenPaid[account][_rewardsToken]
            )
        ).div(1e18).add(rewards[account][_rewardsToken]);
    }

    /**
     * @notice Calculates the total reward for the duration of a given rewards token.
     * @dev This function calculates the total reward by multiplying the reward rate by the rewards duration for the given rewards token.
     * @param _rewardsToken address The address of the rewards token.
     * @return              uint256 value representing the total reward for the duration.
     */
    function getRewardForDuration(address _rewardsToken)
        external
        view
        returns (uint256)
    {
        return rewardData[_rewardsToken].rewardRate.mul(
            rewardData[_rewardsToken].rewardsDuration
        );
    }

    /*//////////////////////////////////////////////////////////////
                            WRITES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Stakes the given amount of tokens for the user (msg.sender).
     * @param amount uint256 The amount of tokens to stake.
     */
    function stake(uint256 amount)
        external
        nonReentrant
        whenNotPaused
        updateReward(msg.sender)
    {
        require(amount > 0, "Cannot stake 0");
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);

        // transfer staking token in then hook stake, for hook to have access to collateral
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        onStake(amount);
        emit Staked(msg.sender, amount);
    }

    /**
     * @notice Hook called in the stake function after transfering staking token in
     * @param amount The amount of staking token transferred in to the contract
     */
    function onStake(uint256 amount) internal virtual;

    /**
     * @notice Withdraws the staked tokens for the user (msg.sender).
     * @param amount uint256 The amount of staked tokens to withdraw.
     */
    function withdraw(uint256 amount)
        public
        nonReentrant
        updateReward(msg.sender)
    {
        require(amount > 0, "Cannot withdraw 0");
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);

        // hook withdraw then transfer staking token out, in case hook needs to bring in collateral
        onWithdraw(amount);
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    /**
     * @notice Hook called in withdraw function before transferring staking token out
     * @param amount The amount of staking token to be transferred out of the contract
     */
    function onWithdraw(uint256 amount) internal virtual;

    /**
     * @notice claims the rewards for the given user.
     * @param _user address The address of the user to claim the rewards for.
     */
    function getRewardForUser(address _user)
        public
        nonReentrant
        updateReward(_user)
    {
        for (uint256 i; i < rewardTokens.length; i++) {
            address _rewardsToken = rewardTokens[i];
            uint256 reward = rewards[_user][_rewardsToken];
            if (reward > 0) {
                rewards[_user][_rewardsToken] = 0;
                IERC20(_rewardsToken).safeTransfer(_user, reward);
                emit RewardPaid(_user, _rewardsToken, reward);
            }
        }
    }

    /**
     * @notice Hook called in getRewardForUser function after updating rewards
     */
    function onReward() internal virtual;

    /**
     * @notice Claims all pending rewards for msg sender.
     * @dev Change from forked MultiRewards.sol to allow for claim of reward for any user to their address
     */
    function getReward() public {
        onReward();
        getRewardForUser(msg.sender);
    }

    /**
     * @notice Withdraws the staked tokens and all rewards for the user.
     */
    function exit() external {
        withdraw(_balances[msg.sender]);
        getReward();
    }

    /*//////////////////////////////////////////////////////////////
                            RESTRICTED
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets the rewards distributor for a reward token.
     * @param _rewardsToken       address The address of the reward token.
     * @param _rewardsDistributor address The address of the rewards distributor.
     */
    function _setRewardsDistributor(
        address _rewardsToken,
        address _rewardsDistributor
    ) internal {
        rewardData[_rewardsToken].rewardsDistributor = _rewardsDistributor;
    }

    /**
     * @notice Adds a reward token to the contract.
     * @param _rewardsToken       address The address of the reward token.
     * @param _rewardsDistributor address The address of the rewards distributor.
     * @param _rewardsDuration    uint256 The duration of the rewards period.
     */
    function _addReward(
        address _rewardsToken,
        address _rewardsDistributor,
        uint256 _rewardsDuration
    ) internal {
        require(rewardData[_rewardsToken].rewardsDuration == 0);
        rewardTokens.push(_rewardsToken);
        rewardData[_rewardsToken].rewardsDistributor = _rewardsDistributor;
        rewardData[_rewardsToken].rewardsDuration = _rewardsDuration;
        emit RewardStored(_rewardsToken, _rewardsDuration);
    }

    /**
     * @notice Notifies the contract that reward tokens is being sent to the contract.
     * @param _rewardsToken address The address of the reward token.
     * @param reward        uint256 The amount of reward tokens is being sent to the contract.
     */
    function _notifyRewardAmount(address _rewardsToken, uint256 reward)
        internal
        updateReward(address(0))
    {
        // handle the transfer of reward tokens via `transferFrom` to reduce the number
        // of transactions required and ensure correctness of the reward amount
        IERC20(_rewardsToken).safeTransferFrom(
            msg.sender, address(this), reward
        );

        if (block.timestamp >= rewardData[_rewardsToken].periodFinish) {
            rewardData[_rewardsToken].rewardRate =
                reward.div(rewardData[_rewardsToken].rewardsDuration);
        } else {
            uint256 remaining =
                rewardData[_rewardsToken].periodFinish.sub(block.timestamp);
            uint256 leftover =
                remaining.mul(rewardData[_rewardsToken].rewardRate);
            rewardData[_rewardsToken].rewardRate = reward.add(leftover).div(
                rewardData[_rewardsToken].rewardsDuration
            );
        }

        rewardData[_rewardsToken].lastUpdateTime = block.timestamp;
        rewardData[_rewardsToken].periodFinish =
            block.timestamp.add(rewardData[_rewardsToken].rewardsDuration);
        emit RewardAdded(reward);
    }

    /**
     * @notice Recovers ERC20 tokens sent to the contract.
     * @dev Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
     * @param to           address The address to send the tokens to.
     * @param tokenAddress address The address of the token to withdraw.
     * @param tokenAmount  uint256 The amount of tokens to withdraw.
     */
    function _recoverERC20(
        address to,
        address tokenAddress,
        uint256 tokenAmount
    ) internal {
        require(
            tokenAddress != address(stakingToken),
            "Cannot withdraw staking token"
        );
        require(
            rewardData[tokenAddress].lastUpdateTime == 0,
            "Cannot withdraw reward token"
        );
        IERC20(tokenAddress).safeTransfer(to, tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }

    /**
     * @notice Updates the reward duration for a reward token.
     * @param _rewardsToken    address The address of the reward token.
     * @param _rewardsDuration uint256 The new duration of the rewards period.
     */
    function _setRewardsDuration(
        address _rewardsToken,
        uint256 _rewardsDuration
    ) internal {
        require(
            block.timestamp > rewardData[_rewardsToken].periodFinish,
            "Reward period still active"
        );

        require(_rewardsDuration > 0, "Reward duration must be non-zero");

        rewardData[_rewardsToken].rewardsDuration = _rewardsDuration;
        emit RewardsDurationUpdated(
            _rewardsToken, rewardData[_rewardsToken].rewardsDuration
        );
    }
}
