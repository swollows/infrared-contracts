// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

import {MultiRewards, IERC20, SafeERC20} from "./MultiRewards.sol";
import {AccessControl} from "@openzeppelin/access/AccessControl.sol";
import {Errors} from "@utils/Errors.sol";
import {IRewardsModule} from "@berachain/Rewards.sol";
import {IDistributionModule} from "@polaris/Distribution.sol";
import {Cosmos} from "@polaris/CosmosTypes.sol";
import {PureUtils} from "@utils/PureUtils.sol";

/**
 * @title InfraredVault
 * @notice This contract is the vault for staking tokens, and receiving rewards from the Proof of Liquidity protocol.
 * @dev This contract uses the MultiRewards contract to distribute rewards to stakers, this is taken from curve.fi. (inspired by Synthetix).
 */
contract InfraredVault is MultiRewards, AccessControl {
    using SafeERC20 for IERC20;
    // This role is reserved for the main infrared contract.

    bytes32 public constant INFRARED_ROLE = keccak256("INFRARED_ROLE");

    // The infrared contract address, this is where the rewards will be coming from .
    address public immutable INFRARED_ADDRESS;

    // The pool address that the staking token is coming from.
    address public immutable POOL_ADDRESS;

    // The rewards module.
    IRewardsModule public immutable REWARDS_MODULE;

    // The distribution module.
    IDistributionModule public immutable DISTRIBUTION_MODULE;

    // The token denominations for key berachain tokens.
    string public constant bgtDenom = "abgt";

    // Number of reward tokens that can be added to the vault.
    uint256 public constant MAX_NUM_REWARD_TOKENS = 10;

    // events
    event UpdateWithdrawAddress(
        address _sender,
        address _oldWithdrawAddress,
        address _newWithdrawAddress
    );
    event ClaimRewardsPrecompile(address _sender, uint256 _amt);

    constructor(
        address _admin,
        address _stakingToken,
        address _infrared,
        address _pool,
        address _rewardsModule,
        address _distributionModule,
        address[] memory _rewardTokens,
        uint256 _rewardsDuration
    ) MultiRewards(_stakingToken) {
        if (_admin == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_stakingToken == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_infrared == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_rewardsModule == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_distributionModule == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_rewardsDuration == 0) {
            revert Errors.ZeroAmount();
        }

        if (_rewardTokens.length > MAX_NUM_REWARD_TOKENS) {
            revert Errors.MaxNumberOfRewards();
        }

        // add initial rewardToken
        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            if (_rewardTokens[i] == address(0)) {
                revert Errors.ZeroAddress();
            }
            _addReward(_rewardTokens[i], _infrared, _rewardsDuration);
        }

        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(INFRARED_ROLE, _infrared);

        INFRARED_ADDRESS = _infrared;
        POOL_ADDRESS = _pool != address(0) ? _pool : address(this);
        REWARDS_MODULE = IRewardsModule(_rewardsModule);
        DISTRIBUTION_MODULE = IDistributionModule(_distributionModule);

        _setWithdrawAddress(_infrared);
    }

    /*//////////////////////////////////////////////////////////////
                             ADMIN
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Change the withdraw address for the depositor.
     * @param _withdrawAddress address The new withdraw address.
     */
    function _setWithdrawAddress(address _withdrawAddress) internal {
        if (_withdrawAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        bool success =
            REWARDS_MODULE.setDepositorWithdrawAddress(_withdrawAddress);

        if (!success) {
            revert Errors.SetWithdrawAddressFailed();
        }

        success = DISTRIBUTION_MODULE.setWithdrawAddress(_withdrawAddress);

        if (!success) {
            revert Errors.SetWithdrawAddressFailed();
        }
    }

    /**
     * @notice Recover ERC20 tokens that were accidentally sent to the contract.
     * @param _to     address The address to send the tokens to.
     * @param _token  address The address of the token to recover.
     * @param _amount uint256 The amount of the token to recover.
     */
    function recoverERC20(address _to, address _token, uint256 _amount)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_to == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_token == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amount == 0) {
            revert Errors.ZeroAmount();
        }

        _recoverERC20(_to, _token, _amount);
    }

    /**
     * @notice Update the rewards duration for a specific rewards token.
     * @dev    The token must be a valid rewards token and have a non-zero duration.
     * @param _rewardsToken    address The address of the rewards token.
     * @param _rewardsDuration uint256 The duration of the rewards to be distributed over.
     */
    function updateRewardsDuration(
        address _rewardsToken,
        uint256 _rewardsDuration
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        if (_rewardsToken == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_rewardsDuration == 0) {
            revert Errors.ZeroAmount();
        }

        _setRewardsDuration(_rewardsToken, _rewardsDuration);
    }

    /*//////////////////////////////////////////////////////////////
                            ADMIN
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Pause or Unpauses the vault.
     * @dev    This function is only callable by the DEFAULT_ADMIN_ROLE.
     */
    function togglePause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        bool isPaused = paused();
        if (isPaused) {
            _unpause();
        } else {
            _pause();
        }
    }

    /*//////////////////////////////////////////////////////////////
                            INFRARED
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Add a reward to the vault and the period that it will be distributed over.
     * @param _rewardsToken    address The address of the rewards token.
     * @param _rewardsDuration address The duration of the rewards to be distributed over.
     */
    function addReward(address _rewardsToken, uint256 _rewardsDuration)
        external
        onlyRewardRoles
    {
        if (_rewardsToken == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_rewardsDuration == 0) {
            revert Errors.ZeroAmount();
        }

        if (rewardTokens.length == MAX_NUM_REWARD_TOKENS) {
            revert Errors.MaxNumberOfRewards();
        }

        _addReward(_rewardsToken, INFRARED_ADDRESS, _rewardsDuration);
    }

    /**
     * @notice Notify the vault that a reward has been added.
     * @param _rewardToken address The address of the reward token.
     * @param _reward      uint256 The amount of the reward.
     */
    function notifyRewardAmount(address _rewardToken, uint256 _reward)
        external
        onlyRewardRoles
    {
        if (_rewardToken == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_reward == 0) {
            revert Errors.ZeroAmount();
        }

        _notifyRewardAmount(_rewardToken, _reward);
    }

    /**
     * @notice Claim the rewards for the vault from the rewards module.
     * @dev    This function is only callable by the INFRARED_ROLE.
     * @return _amt uint256 The amount of rewards claimed.
     */
    function claimRewardsPrecompile()
        external
        onlyRole(INFRARED_ROLE)
        returns (uint256 _amt)
    {
        // Claim from the rewards module, setting the POOL_ADDRESS as the reward receiver (where the rewards accrue from).
        Cosmos.Coin[] memory rewards =
            REWARDS_MODULE.withdrawAllDepositorRewards(POOL_ADDRESS);

        // Invariant: rewards.length <= 1, since we only have one reward token from the rewards module; "abgt".
        // Could be zero if there are no rewards to claim.
        // https://github.com/berachain/berachain/blob/ad8eefa4f27a4193209612542111090fbd7fd92f/x/cosmos/distribution/keeper/allocate.go#L119
        assert(rewards.length <= 1);

        if (rewards.length == 0) {
            return 0;
        }

        // Invariant: rewards[0].denom == "abgt", since we only have one reward token from the rewards module.
        assert(PureUtils.isStringSame(rewards[0].denom, bgtDenom)); // Sanity check. Should always be true.

        emit ClaimRewardsPrecompile(msg.sender, rewards[0].amount);

        return rewards[0].amount;
    }

    /*//////////////////////////////////////////////////////////////
                             USER INTERACTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice claims the rewards for the user.
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

    /*//////////////////////////////////////////////////////////////
                            VIEWS
    //////////////////////////////////////////////////////////////*/

    function getWithdrawAddress() public view returns (address) {
        return REWARDS_MODULE.getDepositorWithdrawAddress(address(this));
    }

    /*//////////////////////////////////////////////////////////////
                            MODIFIERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Modifier to check that the caller is the INFRARED_ROLE or the DEFAULT_ADMIN_ROLE.
     */
    modifier onlyRewardRoles() {
        if (
            !hasRole(INFRARED_ROLE, msg.sender)
                && !hasRole(DEFAULT_ADMIN_ROLE, msg.sender)
        ) {
            revert AccessControlUnauthorizedAccount(msg.sender, INFRARED_ROLE);
        }
        _;
    }
}
