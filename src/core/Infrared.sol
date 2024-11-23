// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

// External dependencies.
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {SafeERC20} from
    "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {EnumerableSet} from
    "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {IBeraChef} from "@berachain/pol/interfaces/IBeraChef.sol";
import {IRewardVault as IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IRewardVault.sol";
import {IRewardVaultFactory as IBerachainRewardsVaultFactory} from
    "@berachain/pol/interfaces/IRewardVaultFactory.sol";
import {IBerachainBGT} from "@interfaces/IBerachainBGT.sol";
import {IBerachainBGTStaker} from "@interfaces/IBerachainBGTStaker.sol";

// Internal dependencies.
import {DataTypes} from "@utils/DataTypes.sol";
import {Errors} from "@utils/Errors.sol";
import {InfraredVaultDeployer} from "@utils/InfraredVaultDeployer.sol";

import {IVoter} from "@voting/interfaces/IVoter.sol";
import {IReward} from "@voting/interfaces/IReward.sol";

import {IWBERA} from "@interfaces/IWBERA.sol";
import {IERC20Mintable} from "@interfaces/IERC20Mintable.sol";
import {IIBGT} from "@interfaces/IIBGT.sol";
import {IBribeCollector} from "@interfaces/IBribeCollector.sol";
import {IInfraredDistributor} from "@interfaces/IInfraredDistributor.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";
import {ConfigTypes, IInfrared} from "@interfaces/IInfrared.sol";

import {InfraredUpgradeable} from "@core/InfraredUpgradeable.sol";
import {InfraredVault} from "@core/InfraredVault.sol";

import {ValidatorManagerLib} from "./libraries/ValidatorManagerLib.sol";
import {ValidatorTypes} from "./libraries/ValidatorTypes.sol";
import {VaultManagerLib} from "./libraries/VaultManagerLib.sol";
import {RewardsLib} from "./libraries/RewardsLib.sol";

/**
 * @title Infrared Protocol Core Contract
 * @notice Provides core functionalities for managing validators, vaults, and reward distribution in the Infrared protocol.
 * @dev Serves as the main entry point for interacting with the Infrared protocol
 * @dev The contract is upgradeable, ensuring flexibility for governance-led upgrades and chain compatibility.
 */
contract Infrared is InfraredUpgradeable, IInfrared {
    using SafeERC20 for IERC20;
    using SafeERC20 for IIBGT;
    using EnumerableSet for EnumerableSet.Bytes32Set;

    using ValidatorManagerLib for ValidatorManagerLib.ValidatorStorage;
    using VaultManagerLib for VaultManagerLib.VaultStorage;
    using RewardsLib for RewardsLib.RewardsStorage;

    /*//////////////////////////////////////////////////////////////
                           STORAGE/EVENTS
    //////////////////////////////////////////////////////////////*/

    // Storage for validator management
    ValidatorManagerLib.ValidatorStorage internal validatorStorage;
    // Vault storage instance
    VaultManagerLib.VaultStorage internal vaultStorage;
    RewardsLib.RewardsStorage internal rewardsStorage;

    /**
     * @notice The BGT token contract reference
     * @dev Immutable IBerachainBGT instance of the BGT token
     */
    IBerachainBGT internal immutable _bgt;

    /// @inheritdoc IInfrared
    IIBGT public immutable ibgt;

    /// @inheritdoc IInfrared
    IBerachainRewardsVaultFactory public immutable rewardsFactory;

    /// @inheritdoc IInfrared
    IBeraChef public immutable chef;

    /// @inheritdoc IInfrared
    IWBERA public immutable wbera;

    /// @inheritdoc IInfrared
    IERC20 public immutable honey;

    /// @inheritdoc IInfrared
    IBribeCollector public collector;

    /// @inheritdoc IInfrared
    IInfraredDistributor public distributor;

    /// @inheritdoc IInfrared
    IVoter public voter;

    /**
     * @notice Commission rate in units of 1 bip
     * @dev Maximum commission rate that can be set (1e3)
     */
    uint256 internal constant COMMISSION_MAX = 1e3;

    /**
     * @dev Ensures that only the collector contract can call the function
     * Reverts if the caller is not the collector
     */
    modifier onlyCollector() {
        if (msg.sender != address(collector)) {
            revert Errors.Unauthorized(msg.sender);
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////
                INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    constructor(
        address _ibgt,
        address _rewardsFactory,
        address _chef,
        address payable _wbera,
        address _honey
    ) InfraredUpgradeable(address(0)) {
        wbera = IWBERA(_wbera);
        honey = IERC20(_honey);
        rewardsFactory = IBerachainRewardsVaultFactory(_rewardsFactory);
        chef = IBeraChef(_chef);

        ibgt = IIBGT(_ibgt);
        _bgt = IBerachainBGT(ibgt.bgt());
    }

    function initialize(
        address _admin,
        address _collector,
        address _distributor,
        address _voter,
        uint256 _rewardsDuration
    ) external initializer {
        // whitelist immutable tokens for rewards
        if (
            _admin == address(0) || _collector == address(0)
                || _distributor == address(0)
        ) revert Errors.ZeroAddress();
        if (_rewardsDuration == 0) revert Errors.ZeroAmount();

        vaultStorage.rewardsDuration = _rewardsDuration;

        // grant admin access roles
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        _grantRole(GOVERNANCE_ROLE, _admin);

        vaultStorage.updateWhitelistedRewardTokens(address(wbera), true);
        vaultStorage.updateWhitelistedRewardTokens(address(ibgt), true);
        vaultStorage.updateWhitelistedRewardTokens(address(honey), true);

        // set collector, validator distributor, and veIRED voter fee vault
        collector = IBribeCollector(_collector);
        distributor = IInfraredDistributor(_distributor);
        voter = IVoter(_voter);

        validatorStorage.distributor = address(distributor);
        validatorStorage.bgt = address(_bgt);

        rewardsStorage.collector = address(collector);
        rewardsStorage.distributor = address(distributor);
        rewardsStorage.wbera = address(wbera);
        rewardsStorage.bgt = address(_bgt);
        rewardsStorage.ibgt = address(ibgt);
        rewardsStorage.voter = address(voter);
        rewardsStorage.rewardsDuration = _rewardsDuration;

        rewardsStorage.ibgtVault = vaultStorage.registerVault(address(ibgt));

        // init upgradeable components
        __InfraredUpgradeable_init();
    }

    /*//////////////////////////////////////////////////////////////
                        VAULT REGISTRY
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function registerVault(address _asset)
        external
        whenInitialized
        returns (IInfraredVault vault)
    {
        vault = IInfraredVault(vaultStorage.registerVault(_asset));
        emit NewVault(msg.sender, _asset, address(vault));
    }

    function addReward(
        address _stakingToken,
        address _rewardsToken,
        uint256 _rewardsDuration
    ) external onlyGovernor whenInitialized {
        vaultStorage.addReward(_stakingToken, _rewardsToken, _rewardsDuration);
    }

    /*//////////////////////////////////////////////////////////////
                        ADMIN
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function updateWhiteListedRewardTokens(address _token, bool _whitelisted)
        external
        onlyGovernor
        whenInitialized
    {
        bool previousStatus = whitelistedRewardTokens(_token);
        vaultStorage.updateWhitelistedRewardTokens(_token, _whitelisted);
        emit WhiteListedRewardTokensUpdated(
            msg.sender, _token, previousStatus, _whitelisted
        );
    }

    /// @inheritdoc IInfrared
    function updateRewardsDuration(uint256 _rewardsDuration)
        external
        onlyGovernor
        whenInitialized
    {
        uint256 oldRewardsDuration = rewardsDuration();
        vaultStorage.updateRewardsDuration(_rewardsDuration);
        rewardsStorage.updateRewardsDuration(_rewardsDuration);
        emit RewardsDurationUpdated(
            msg.sender, oldRewardsDuration, _rewardsDuration
        );
    }

    /// @inheritdoc IInfrared
    function pauseVault(address _asset) external onlyGovernor whenInitialized {
        vaultStorage.pauseVault(_asset);
    }

    /// @inheritdoc IInfrared
    function recoverERC20(address _to, address _token, uint256 _amount)
        external
        onlyGovernor
        whenInitialized
    {
        if (_to == address(0) || _token == address(0)) {
            revert Errors.ZeroAddress();
        }
        if (_amount == 0) revert Errors.ZeroAmount();
        IERC20(_token).safeTransfer(_to, _amount);
        emit Recovered(msg.sender, _token, _amount);
    }

    /// @inheritdoc IInfrared
    function delegateBGT(address _delegatee)
        external
        onlyGovernor
        whenInitialized
    {
        rewardsStorage.delegateBGT(_delegatee);
    }

    /// @inheritdoc IInfrared
    function updateWeight(ConfigTypes.WeightType _t, uint256 _weight)
        external
        onlyGovernor
        whenInitialized
    {
        uint256 prevWeight = weights(uint256(_t));
        rewardsStorage.updateWeight(_t, _weight);
        emit WeightUpdated(msg.sender, _t, prevWeight, _weight);
    }

    /// @inheritdoc IInfrared
    function updateFee(ConfigTypes.FeeType _t, uint256 _fee)
        external
        onlyGovernor
        whenInitialized
    {
        uint256 prevFee = fees(uint256(_t));
        rewardsStorage.updateFee(_t, _fee);
        emit FeeUpdated(msg.sender, _t, prevFee, _fee);
    }

    /// @inheritdoc IInfrared
    function claimProtocolFees(address _to, address _token, uint256 _amount)
        external
        onlyGovernor
        whenInitialized
    {
        rewardsStorage.claimProtocolFees(_to, _token, _amount);
        emit ProtocolFeesClaimed(msg.sender, _to, _token, _amount);
    }

    /*//////////////////////////////////////////////////////////////
                            REWARDS
    //////////////////////////////////////////////////////////////*/

    function chargedFeesOnRewards(
        uint256 _amt,
        uint256 _feeTotal,
        uint256 _feeProtocol
    )
        public
        view
        returns (uint256 amtRecipient, uint256 amtVoter, uint256 amtProtocol)
    {
        return
            rewardsStorage.chargedFeesOnRewards(_amt, _feeTotal, _feeProtocol);
    }

    /// @inheritdoc IInfrared
    function harvestBase() external whenInitialized {
        uint256 bgtAmt = rewardsStorage.harvestBase();
        emit BaseHarvested(msg.sender, bgtAmt);
    }

    /// @inheritdoc IInfrared
    function harvestVault(address _asset) external whenInitialized {
        IInfraredVault vault = vaultRegistry(_asset);
        uint256 bgtAmt = rewardsStorage.harvestVault(vault);
        emit VaultHarvested(msg.sender, _asset, address(vault), bgtAmt);
    }

    /// @inheritdoc IInfrared
    function harvestBribes(address[] calldata _tokens)
        external
        whenInitialized
    {
        uint256 len = _tokens.length;
        bool[] memory whitelisted = new bool[](len);
        for (uint256 i; i < len; ++i) {
            if (
                whitelistedRewardTokens(_tokens[i])
                    || _tokens[i] == DataTypes.NATIVE_ASSET
            ) {
                whitelisted[i] = true;
            }
        }
        (address[] memory tokens, uint256[] memory _amounts) =
            rewardsStorage.harvestBribes(_tokens, whitelisted);
        for (uint256 i; i < len; ++i) {
            if (whitelisted[i]) {
                emit BribeSupplied(address(collector), tokens[i], _amounts[i]);
            } else {
                emit RewardTokenNotSupported(_tokens[i]);
            }
        }
    }

    /// @inheritdoc IInfrared
    function collectBribes(address _token, uint256 _amount)
        external
        onlyCollector
        whenInitialized
    {
        if (!whitelistedRewardTokens(_token)) {
            revert Errors.RewardTokenNotSupported();
        }
        (uint256 amtWiberaVault, uint256 amtIbgtVault) =
            rewardsStorage.collectBribes(_token, _amount);

        emit BribesCollected(msg.sender, _token, amtWiberaVault, amtIbgtVault);
    }

    /// @inheritdoc IInfrared
    function harvestBoostRewards() external whenInitialized {
        (address _vault, address _token, uint256 _amount) =
            rewardsStorage.harvestBoostRewards();
        emit RewardSupplied(address(_vault), _token, _amount);
    }

    /*//////////////////////////////////////////////////////////////
                            VALIDATORS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function addValidators(ValidatorTypes.Validator[] calldata _validators)
        external
        onlyGovernor
        whenInitialized
    {
        validatorStorage.addValidators(_validators);
        emit ValidatorsAdded(msg.sender, _validators);
    }

    /// @inheritdoc IInfrared
    function removeValidators(bytes[] calldata _pubkeys)
        external
        onlyGovernor
        whenInitialized
    {
        validatorStorage.removeValidators(_pubkeys);
        emit ValidatorsRemoved(msg.sender, _pubkeys);
    }

    /// @inheritdoc IInfrared
    function replaceValidator(bytes calldata _current, bytes calldata _new)
        external
        onlyGovernor
        whenInitialized
    {
        validatorStorage.replaceValidator(_current, _new);
        emit ValidatorReplaced(msg.sender, _current, _new);
    }

    /// @inheritdoc IInfrared
    function queueNewCuttingBoard(
        bytes calldata _pubkey,
        uint64 _startBlock,
        IBeraChef.Weight[] calldata _weights
    ) external onlyKeeper {
        if (!isInfraredValidator(_pubkey)) revert Errors.InvalidValidator();
        chef.queueNewRewardAllocation(_pubkey, _startBlock, _weights);
    }

    /*//////////////////////////////////////////////////////////////
                            BOOSTS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function queueBoosts(bytes[] calldata _pubkeys, uint128[] calldata _amts)
        external
        onlyKeeper
        whenInitialized
    {
        validatorStorage.queueBoosts(_pubkeys, _amts);
        emit QueuedBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function cancelBoosts(bytes[] calldata _pubkeys, uint128[] calldata _amts)
        external
        onlyKeeper
        whenInitialized
    {
        validatorStorage.cancelBoosts(_pubkeys, _amts);
        emit CancelledBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function activateBoosts(bytes[] calldata _pubkeys)
        external
        whenInitialized
    {
        validatorStorage.activateBoosts(_pubkeys);
        emit ActivatedBoosts(msg.sender, _pubkeys);
    }

    /// @inheritdoc IInfrared
    function updateValidatorCommission(
        bytes calldata _pubkey,
        uint256 _commission
    ) external override {}

    /// @inheritdoc IInfrared
    function dropBoosts(bytes[] calldata _pubkeys, uint128[] calldata _amts)
        external
        override
    {}

    /*//////////////////////////////////////////////////////////////
                            HELPERS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function infraredValidators()
        public
        view
        virtual
        returns (ValidatorTypes.Validator[] memory validators)
    {
        return validatorStorage.infraredValidators();
    }

    /// @inheritdoc IInfrared
    function numInfraredValidators() external view returns (uint256) {
        return validatorStorage.numInfraredValidators();
    }

    /// @inheritdoc IInfrared
    function isInfraredValidator(bytes calldata _validator)
        public
        view
        returns (bool)
    {
        return validatorStorage.isValidator(_validator);
    }

    /// @inheritdoc IInfrared
    function getBGTBalance() public view returns (uint256) {
        return _bgt.balanceOf(address(this));
    }

    /**
     * @notice Mapping of tokens that are whitelisted to be used as rewards or accepted as bribes
     * @dev serves as central source of truth for whitelisted reward tokens for all Infrared contracts
     */
    function whitelistedRewardTokens(address token)
        public
        view
        returns (bool)
    {
        return vaultStorage.isWhitelisted(token);
    }

    /**
     * @notice Mapping of staking token addresses to their corresponding InfraredVault
     * @dev Each staking token can only have one vault
     */
    function vaultRegistry(address _stakingToken)
        public
        view
        returns (IInfraredVault vault)
    {
        vault = vaultStorage.vaultRegistry[_stakingToken];
    }

    /**
     * @notice Sets new vault registration paused or not
     * @param pause True to pause, False to un pause
     */
    function setVaultRegistrationPauseStatus(bool pause)
        external
        onlyGovernor
    {
        vaultStorage.setVaultRegistrationPauseStatus(pause);
        emit VaultRegistrationPauseStatus(pause);
    }

    /// @inheritdoc IInfrared
    function rewardsDuration() public view returns (uint256 duration) {
        return vaultStorage.rewardsDuration;
    }

    /// @inheritdoc IInfrared
    function weights(uint256 t) public view override returns (uint256) {
        return rewardsStorage.weights[t];
    }

    /// @inheritdoc IInfrared
    function fees(uint256 t) public view override returns (uint256) {
        return rewardsStorage.fees[t];
    }

    /// @inheritdoc IInfrared
    function ibgtVault() external view returns (IInfraredVault) {
        return IInfraredVault(rewardsStorage.ibgtVault);
    }

    /// @inheritdoc IInfrared
    function protocolFeeAmounts(address _token)
        external
        view
        returns (uint256)
    {
        return rewardsStorage.protocolFeeAmounts[_token];
    }
}
