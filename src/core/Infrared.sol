// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

// External dependencies.
import {Address} from "@openzeppelin/contracts/utils/Address.sol";
import {SafeERC20} from
    "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {EnumerableSet} from
    "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

import {IBeraChef} from "@berachain/pol/interfaces/IBeraChef.sol";
import {IRewardVault as IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IRewardVault.sol";
import {IRewardVaultFactory as IBerachainRewardsVaultFactory} from
    "@berachain/pol/interfaces/IRewardVaultFactory.sol";
import {IBerachainBGT} from "src/interfaces/IBerachainBGT.sol";
import {IBerachainBGTStaker} from "src/interfaces/IBerachainBGTStaker.sol";

// Internal dependencies.
import {DataTypes} from "src/utils/DataTypes.sol";
import {Errors} from "src/utils/Errors.sol";
import {InfraredVaultDeployer} from "src/utils/InfraredVaultDeployer.sol";

import {IVoter} from "src/voting/interfaces/IVoter.sol";
import {IReward} from "src/voting/interfaces/IReward.sol";

import {IWBERA} from "src/interfaces/IWBERA.sol";
import {IERC20Mintable} from "src/interfaces/IERC20Mintable.sol";
import {IIBGT} from "src/interfaces/IIBGT.sol";
import {IRED} from "src/interfaces/IRED.sol";
import {IBribeCollector} from "src/interfaces/IBribeCollector.sol";
import {IInfraredDistributor} from "src/interfaces/IInfraredDistributor.sol";
import {IInfraredVault} from "src/interfaces/IInfraredVault.sol";
import {ConfigTypes, IInfrared} from "src/interfaces/IInfrared.sol";

import {InfraredUpgradeable} from "src/core/InfraredUpgradeable.sol";
import {InfraredVault} from "src/core/InfraredVault.sol";
import {IIBERA} from "src/interfaces/IIBERA.sol";

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

    // @note Storage slot locations computed using ERC-7201 formula
    bytes32 public constant VALIDATOR_STORAGE_LOCATION = keccak256(
        abi.encode(uint256(keccak256(bytes("infrared.validatorStorage"))) - 1)
    ) & ~bytes32(uint256(0xff));

    bytes32 public constant VAULT_STORAGE_LOCATION = keccak256(
        abi.encode(uint256(keccak256(bytes("infrared.vaultStorage"))) - 1)
    ) & ~bytes32(uint256(0xff));

    bytes32 public constant REWARDS_STORAGE_LOCATION = keccak256(
        abi.encode(uint256(keccak256(bytes("infrared.rewardsStorage"))) - 1)
    ) & ~bytes32(uint256(0xff));

    // Helper functions to access the storage
    function _validatorStorage()
        internal
        pure
        returns (ValidatorManagerLib.ValidatorStorage storage vs)
    {
        bytes32 position = VALIDATOR_STORAGE_LOCATION;
        assembly {
            vs.slot := position
        }
    }

    function _vaultStorage()
        internal
        pure
        returns (VaultManagerLib.VaultStorage storage vs)
    {
        bytes32 position = VAULT_STORAGE_LOCATION;
        assembly {
            vs.slot := position
        }
    }

    function _rewardsStorage()
        internal
        pure
        returns (RewardsLib.RewardsStorage storage rs)
    {
        bytes32 position = REWARDS_STORAGE_LOCATION;
        assembly {
            rs.slot := position
        }
    }

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

    /// @inheritdoc IInfrared
    IIBERA public ibera;

    /// @inheritdoc IInfrared
    IRED public red;

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
        address _iBERA,
        uint256 _rewardsDuration
    ) external initializer {
        // whitelist immutable tokens for rewards
        if (
            _admin == address(0) || _collector == address(0)
                || _distributor == address(0) || _voter == address(0)
                || _iBERA == address(0)
        ) revert Errors.ZeroAddress();
        if (_rewardsDuration == 0) revert Errors.ZeroAmount();

        _vaultStorage().rewardsDuration = _rewardsDuration;

        // grant admin access roles
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        _grantRole(GOVERNANCE_ROLE, _admin);

        _vaultStorage().updateWhitelistedRewardTokens(address(wbera), true);
        _vaultStorage().updateWhitelistedRewardTokens(address(ibgt), true);
        _vaultStorage().updateWhitelistedRewardTokens(address(honey), true);

        // set collector, validator distributor, and veIRED voter fee vault
        collector = IBribeCollector(_collector);
        distributor = IInfraredDistributor(_distributor);
        voter = IVoter(_voter);
        ibera = IIBERA(_iBERA);

        if (collector.payoutToken() != address(wbera)) {
            revert Errors.RewardTokenNotSupported();
        }
        if (address(distributor.token()) != address(ibera)) {
            revert Errors.RewardTokenNotSupported();
        }

        _validatorStorage().distributor = address(distributor);
        _validatorStorage().bgt = address(_bgt);
        _validatorStorage().ibgt = address(ibgt);

        _rewardsStorage().collector = address(collector);
        _rewardsStorage().distributor = address(distributor);
        _rewardsStorage().wbera = address(wbera);
        _rewardsStorage().bgt = address(_bgt);
        _rewardsStorage().ibgt = address(ibgt);
        _rewardsStorage().voter = address(voter);
        _rewardsStorage().ibera = address(ibera);
        _rewardsStorage().rewardsDuration = _rewardsDuration;

        _rewardsStorage().ibgtVault =
            _vaultStorage().registerVault(address(ibgt));

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
        vault = IInfraredVault(_vaultStorage().registerVault(_asset));
        emit NewVault(msg.sender, _asset, address(vault));
    }

    function addReward(
        address _stakingToken,
        address _rewardsToken,
        uint256 _rewardsDuration
    ) external onlyGovernor whenInitialized {
        _vaultStorage().addReward(
            _stakingToken, _rewardsToken, _rewardsDuration
        );
    }

    function addIncentives(
        address _stakingToken,
        address _rewardsToken,
        uint256 _amount
    ) external whenInitialized {
        _vaultStorage().addIncentives(_stakingToken, _rewardsToken, _amount);
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
        _vaultStorage().updateWhitelistedRewardTokens(_token, _whitelisted);
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
        _vaultStorage().updateRewardsDuration(_rewardsDuration);
        _rewardsStorage().updateRewardsDuration(_rewardsDuration);
        emit RewardsDurationUpdated(
            msg.sender, oldRewardsDuration, _rewardsDuration
        );
    }

    /// @inheritdoc IInfrared
    function updateRewardsDurationForVault(
        address _stakingToken,
        address _rewardsToken,
        uint256 _rewardsDuration
    ) external onlyGovernor whenInitialized {
        _vaultStorage().updateRewardsDurationForVault(
            _stakingToken, _rewardsToken, _rewardsDuration
        );
    }

    /// @inheritdoc IInfrared
    function pauseVault(address _asset) external onlyGovernor whenInitialized {
        _vaultStorage().pauseVault(_asset);
    }

    /// @inheritdoc IInfrared
    function claimLostRewardsOnVault(address _asset)
        external
        onlyGovernor
        whenInitialized
    {
        _vaultStorage().claimLostRewardsOnVault(_asset);
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
    function recoverERC20FromVault(
        address _asset,
        address _to,
        address _token,
        uint256 _amount
    ) external onlyGovernor whenInitialized {
        _vaultStorage().recoverERC20FromVault(_asset, _to, _token, _amount);
    }

    /// @inheritdoc IInfrared
    function delegateBGT(address _delegatee)
        external
        onlyGovernor
        whenInitialized
    {
        _rewardsStorage().delegateBGT(_delegatee);
    }

    /// @inheritdoc IInfrared
    function updateIBERABribesWeight(uint256 _weight)
        external
        onlyGovernor
        whenInitialized
    {
        uint256 prevWeight = _rewardsStorage().collectBribesWeight;
        _rewardsStorage().updateIBERABribesWeight(_weight);
        emit IBERABribesWeightUpdated(msg.sender, prevWeight, _weight);
    }

    /// @inheritdoc IInfrared
    function updateFee(ConfigTypes.FeeType _t, uint256 _fee)
        external
        onlyGovernor
        whenInitialized
    {
        uint256 prevFee = fees(uint256(_t));
        _rewardsStorage().updateFee(_t, _fee);
        emit FeeUpdated(msg.sender, _t, prevFee, _fee);
    }

    /// @inheritdoc IInfrared
    function claimProtocolFees(address _to, address _token, uint256 _amount)
        external
        onlyGovernor
        whenInitialized
    {
        _rewardsStorage().claimProtocolFees(_to, _token, _amount);
        emit ProtocolFeesClaimed(msg.sender, _to, _token, _amount);
    }

    /// @inheritdoc IInfrared
    function setRed(address _red) external onlyGovernor whenInitialized {
        _rewardsStorage().setRed(_red);
        red = IRED(_red);
        emit RedSet(msg.sender, _red);
    }

    /// @inheritdoc IInfrared
    function updateRedMintRate(uint256 _redMintRate)
        external
        onlyGovernor
        whenInitialized
    {
        _rewardsStorage().updateRedMintRate(_redMintRate);
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
        return _rewardsStorage().chargedFeesOnRewards(
            _amt, _feeTotal, _feeProtocol
        );
    }

    /// @inheritdoc IInfrared
    function harvestBase() public whenInitialized {
        uint256 bgtAmt = _rewardsStorage().harvestBase();
        emit BaseHarvested(msg.sender, bgtAmt);
    }

    /// @inheritdoc IInfrared
    function harvestVault(address _asset) external whenInitialized {
        IInfraredVault vault = vaultRegistry(_asset);
        uint256 bgtAmt = _rewardsStorage().harvestVault(vault);
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
            _rewardsStorage().harvestBribes(_tokens, whitelisted);
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
        if (_token != address(wbera)) {
            revert Errors.RewardTokenNotSupported();
        }
        (uint256 amtIBERA, uint256 amtIbgtVault) =
            _rewardsStorage().collectBribesInWBERA(_amount);

        emit BribesCollected(msg.sender, _token, amtIBERA, amtIbgtVault);
    }

    function harvestOperatorRewards() public whenInitialized {
        uint256 _amt = _rewardsStorage().harvestOperatorRewards();
        emit OperatorRewardsDistributed(
            address(ibera), address(distributor), _amt
        );
    }

    /// @inheritdoc IInfrared
    function harvestBoostRewards() external whenInitialized {
        (address _vault, address _token, uint256 _amount) =
            _rewardsStorage().harvestBoostRewards();
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
        harvestBase();
        harvestOperatorRewards();
        _validatorStorage().addValidators(_validators);
        emit ValidatorsAdded(msg.sender, _validators);
    }

    /// @inheritdoc IInfrared
    function removeValidators(bytes[] calldata _pubkeys)
        external
        onlyGovernor
        whenInitialized
    {
        harvestBase();
        harvestOperatorRewards();
        _validatorStorage().removeValidators(_pubkeys);
        emit ValidatorsRemoved(msg.sender, _pubkeys);
    }

    /// @inheritdoc IInfrared
    function replaceValidator(bytes calldata _current, bytes calldata _new)
        external
        onlyGovernor
        whenInitialized
    {
        harvestBase();
        harvestOperatorRewards();
        _validatorStorage().replaceValidator(_current, _new);
        emit ValidatorReplaced(msg.sender, _current, _new);
    }

    /// @inheritdoc IInfrared
    function queueNewCuttingBoard(
        bytes calldata _pubkey,
        uint64 _startBlock,
        IBeraChef.Weight[] calldata _weights
    ) external onlyKeeper whenInitialized {
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
        _validatorStorage().queueBoosts(_pubkeys, _amts);
        emit QueuedBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function cancelBoosts(bytes[] calldata _pubkeys, uint128[] calldata _amts)
        external
        onlyKeeper
        whenInitialized
    {
        _validatorStorage().cancelBoosts(_pubkeys, _amts);
        emit CancelledBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function activateBoosts(bytes[] calldata _pubkeys)
        external
        whenInitialized
    {
        _validatorStorage().activateBoosts(_pubkeys);
        emit ActivatedBoosts(msg.sender, _pubkeys);
    }

    /// @inheritdoc IInfrared
    function queueDropBoosts(
        bytes[] calldata _pubkeys,
        uint128[] calldata _amts
    ) external onlyKeeper whenInitialized {
        _validatorStorage().queueDropBoosts(_pubkeys, _amts);
        emit QueueDropBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function cancelDropBoosts(
        bytes[] calldata _pubkeys,
        uint128[] calldata _amts
    ) external onlyKeeper whenInitialized {
        _validatorStorage().cancelDropBoosts(_pubkeys, _amts);
        emit CancelDropBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function dropBoosts(bytes[] calldata _pubkeys) external whenInitialized {
        _validatorStorage().dropBoosts(_pubkeys);
        emit DroppedBoosts(msg.sender, _pubkeys);
    }

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
        return _validatorStorage().infraredValidators();
    }

    /// @inheritdoc IInfrared
    function numInfraredValidators() external view returns (uint256) {
        return _validatorStorage().numInfraredValidators();
    }

    /// @inheritdoc IInfrared
    function isInfraredValidator(bytes calldata _validator)
        public
        view
        returns (bool)
    {
        return _validatorStorage().isValidator(_validator);
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
        return _vaultStorage().isWhitelisted(token);
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
        vault = _vaultStorage().vaultRegistry[_stakingToken];
    }

    /**
     * @notice Sets new vault registration paused or not
     * @param pause True to pause, False to un pause
     */
    function setVaultRegistrationPauseStatus(bool pause)
        external
        onlyGovernor
    {
        _vaultStorage().setVaultRegistrationPauseStatus(pause);
        emit VaultRegistrationPauseStatus(pause);
    }

    /// @inheritdoc IInfrared
    function rewardsDuration() public view returns (uint256 duration) {
        return _vaultStorage().rewardsDuration;
    }

    /// @inheritdoc IInfrared
    function fees(uint256 t) public view override returns (uint256) {
        return _rewardsStorage().fees[t];
    }

    /// @inheritdoc IInfrared
    function ibgtVault() external view returns (IInfraredVault) {
        return IInfraredVault(_rewardsStorage().ibgtVault);
    }

    /// @inheritdoc IInfrared
    function protocolFeeAmounts(address _token)
        external
        view
        returns (uint256)
    {
        return _rewardsStorage().protocolFeeAmounts[_token];
    }
}
