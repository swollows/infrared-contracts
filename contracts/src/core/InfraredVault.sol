// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";
import {IBerachainRewardsVaultFactory} from
    "@berachain/interfaces/IBerachainRewardsVaultFactory.sol";

import {Errors} from "@utils/Errors.sol";
import {MultiRewards, IERC20, SafeERC20} from "@core/MultiRewards.sol";

import {IInfrared} from "@interfaces/IInfrared.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

/**
 * @title InfraredVault
 * @notice This contract is the vault for staking tokens, and receiving rewards from the Proof of Liquidity protocol.
 * @dev This contract uses the MultiRewards contract to distribute rewards to vault stakers, this is taken from curve.fi. (inspired by Synthetix).
 * @dev Does not support staking tokens with non-standard ERC20 transfer tax behavior.
 */
contract InfraredVault is MultiRewards, IInfraredVault {
    using SafeERC20 for IERC20;

    // Number of reward tokens that can be added to the vault.
    uint256 public constant MAX_NUM_REWARD_TOKENS = 10;

    // The infrared contract address acts a vault factory and coordinator
    address public immutable infrared;

    // The address of the berachain rewards vault
    IBerachainRewardsVault public rewardsVault;

    // events
    event UpdateOperator(address _sender, address _to);

    /// Modifier to check that the caller is infrared contract
    modifier onlyInfrared() {
        if (msg.sender != infrared) revert Errors.Unauthorized(msg.sender);
        _;
    }

    constructor(
        address _stakingToken,
        address[] memory _rewardTokens,
        uint256 _rewardsDuration
    ) MultiRewards(_stakingToken) {
        // infrared factory/coordinator
        infrared = msg.sender;

        if (_stakingToken == address(0)) revert Errors.ZeroAddress();
        if (_rewardsDuration == 0) revert Errors.ZeroAmount();
        if (_rewardTokens.length > MAX_NUM_REWARD_TOKENS) {
            revert Errors.MaxNumberOfRewards();
        }

        // set the berachain rewards vault and operator as infrared if rewards vault exists
        address _rewardsVaultAddress =
            getRewardsVaultAddress(infrared, _stakingToken);
        rewardsVault = IBerachainRewardsVault(_rewardsVaultAddress);
        if (_rewardsVaultAddress != address(0)) _setOperator(infrared);

        // add initial rewardToken
        bool hasIBGT;
        address _ibgt = address(IInfrared(infrared).ibgt());
        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            if (_rewardTokens[i] == address(0)) {
                revert Errors.ZeroAddress();
            }
            _addReward(_rewardTokens[i], infrared, _rewardsDuration);
            if (!hasIBGT) hasIBGT = (_rewardTokens[i] == _ibgt);
        }
        if (!hasIBGT) revert Errors.IBGTNotRewardToken();
    }

    /**
     * @notice Gets the berachain rewards vault address for given staking token
     * @param _infrared The address of Infrared
     * @param _stakingToken The address of the staking token for this vault
     * @return The address of the berachain rewards vault
     */
    function getRewardsVaultAddress(address _infrared, address _stakingToken)
        internal
        view
        returns (address)
    {
        IBerachainRewardsVaultFactory rewardsFactory =
            IInfrared(_infrared).rewardsFactory();
        return rewardsFactory.getVault(_stakingToken);
    }

    /**
     * @notice Sets operator address of rewards for harvesting vault.
     * @param to The operator address to manager rewards for this vault.
     */
    function _setOperator(address to) private {
        rewardsVault.setOperator(to);
        emit UpdateOperator(msg.sender, to);
    }

    /// @inheritdoc IInfraredVault
    function stakedInRewardsVault() public view returns (bool) {
        return (rewardsVault != IBerachainRewardsVault(address(0)));
    }

    /*//////////////////////////////////////////////////////////////
                            STAKE/WITHDRAW/CLAIM
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Transfers to berachain low level module on staking of LP tokens with the vault after transferring tokens in
     * @param amount The amount of staking token transferred in to the contract
     */
    function onStake(uint256 amount) internal override {
        if (!stakedInRewardsVault()) return;
        stakingToken.safeIncreaseAllowance(address(rewardsVault), amount);
        rewardsVault.stake(amount);
    }

    /**
     * @notice Redeems from berachain low level module on withdraw of LP tokens from the vault before transferring tokens out
     * @param amount The amount of staking token transferred out of the contract
     */
    function onWithdraw(uint256 amount) internal override {
        if (!stakedInRewardsVault()) return;
        rewardsVault.withdraw(amount);
    }

    /**
     * @notice hook called after the reward is claimed to harvest the rewards from the berachain rewards vault
     */
    function onReward() internal override {
        if (!stakedInRewardsVault()) return;
        IInfrared(infrared).harvestVault(address(stakingToken));
    }

    /// @inheritdoc IInfraredVault
    function migrate() external {
        if (stakedInRewardsVault()) revert Errors.StakedInRewardsVault();

        // set berachain rewards vault and set operator on vault as infrared
        address _rewardsVaultAddress =
            getRewardsVaultAddress(infrared, address(stakingToken));
        if (_rewardsVaultAddress == address(0)) {
            revert Errors.NoRewardsVault();
        }
        rewardsVault = IBerachainRewardsVault(_rewardsVaultAddress);
        _setOperator(infrared);

        // stake total supply for berachain proof of liquidity rewards
        stakingToken.safeIncreaseAllowance(_rewardsVaultAddress, _totalSupply);
        rewardsVault.stake(_totalSupply);
    }

    /*//////////////////////////////////////////////////////////////
                            INFRARED ONLY
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfraredVault
    function updateRewardsDuration(
        address _rewardsToken,
        uint256 _rewardsDuration
    ) external onlyInfrared {
        if (_rewardsToken == address(0)) revert Errors.ZeroAddress();
        if (_rewardsDuration == 0) revert Errors.ZeroAmount();
        _setRewardsDuration(_rewardsToken, _rewardsDuration);
    }

    /// @inheritdoc IInfraredVault
    function togglePause() external onlyInfrared {
        bool isPaused = paused();
        if (isPaused) _unpause();
        else _pause();
    }

    /// @inheritdoc IInfraredVault
    function addReward(address _rewardsToken, uint256 _rewardsDuration)
        external
        onlyInfrared
    {
        if (_rewardsToken == address(0)) revert Errors.ZeroAddress();
        if (_rewardsDuration == 0) revert Errors.ZeroAmount();
        if (rewardTokens.length == MAX_NUM_REWARD_TOKENS) {
            revert Errors.MaxNumberOfRewards();
        }
        _addReward(_rewardsToken, infrared, _rewardsDuration);
    }

    /// @inheritdoc IInfraredVault
    function notifyRewardAmount(address _rewardToken, uint256 _reward)
        external
        onlyInfrared
    {
        if (_rewardToken == address(0)) revert Errors.ZeroAddress();
        if (_reward == 0) revert Errors.ZeroAmount();
        _notifyRewardAmount(_rewardToken, _reward);
    }

    /// @inheritdoc IInfraredVault
    function recoverERC20(address _to, address _token, uint256 _amount)
        external
        onlyInfrared
    {
        if (_to == address(0) || _token == address(0)) {
            revert Errors.ZeroAddress();
        }
        if (_amount == 0) revert Errors.ZeroAmount();
        _recoverERC20(_to, _token, _amount);
    }
}
