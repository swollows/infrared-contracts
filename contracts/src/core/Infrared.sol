// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// External dependencies.
import {Address} from "@openzeppelin/utils/Address.sol";
import {Math} from "@openzeppelin/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";

import {IBeaconDepositContract} from
    "@berachain/interfaces/IBeaconDepositContract.sol";
import {IBeraChef} from "@berachain/interfaces/IBeraChef.sol";
import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";
import {IBerachainRewardsVaultFactory} from
    "@berachain/interfaces/IBerachainRewardsVaultFactory.sol";
import {IWBERA} from "@berachain/interfaces/IWBERA.sol";

// Internal dependencies.
import {ValidatorSet} from "@utils/ValidatorSet.sol";
import {ValidatorUtils} from "@utils/ValidatorUtils.sol";

import {DataTypes} from "@utils/DataTypes.sol";
import {Errors} from "@utils/Errors.sol";
import {InfraredVaultDeployer} from "@utils/InfraredVaultDeployer.sol";

import {IIBGT} from "@interfaces/IIBGT.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";
import {IInfrared} from "@interfaces/IInfrared.sol";

import {InfraredUpgradeable} from "@core/InfraredUpgradeable.sol";
import {InfraredVault} from "@core/InfraredVault.sol";

/**
 * @title Infrared
 * @dev A contract for managing the set of infrared validators, infrared vaults, and interacting with the rewards handler.
 * @dev This contract is the main entry point for interacting with the Infrared protocol.
 * @dev It is an immutable contract that interacts with the upgradable rewards handler and staking handler. These contracts are upgradable by governance (app + chain), main reason is that they could change with a chain upgrade.
 */
contract Infrared is InfraredUpgradeable, IInfrared {
    using SafeERC20 for IERC20;
    using SafeERC20 for IIBGT;
    using ValidatorSet for DataTypes.ValidatorSet;

    /*//////////////////////////////////////////////////////////////
                           STORAGE/EVENTS
    //////////////////////////////////////////////////////////////*/

    // mapping of whitelisted reward tokens
    mapping(address => bool) public whitelistedRewardTokens;

    // Mapping of staking token address to `IInfraredVault`.
    mapping(address => IInfraredVault) public vaultRegistry;

    // The set of infrared validators.
    DataTypes.ValidatorSet internal _infraredValidators;

    // The BGT address
    address internal immutable _bgt;

    /// @inheritdoc IInfrared
    IIBGT public immutable ibgt;

    /// @inheritdoc IInfrared
    IERC20 public immutable ired;

    /// @inheritdoc IInfrared
    IBerachainRewardsVaultFactory public immutable rewardsFactory;

    /// @inheritdoc IInfrared
    IBeaconDepositContract public immutable depositor;

    /// inheritdoc IInfrared
    IBeraChef public immutable chef;

    /// @inheritdoc IInfrared
    IWBERA public immutable wbera;

    /// @inheritdoc IInfrared
    uint256 public rewardsDuration;

    /// @inheritdoc IInfrared
    IInfraredVault public ibgtVault;

    /// @inheritdoc IInfrared
    mapping(address => uint256) public protocolFeeRates;

    /// @inheritdoc IInfrared
    mapping(address => uint256) public protocolFeeAmounts;

    /// @notice Protocol fee rate in hundredths of 1 bip
    uint256 internal constant FEE_UNIT = 1e6;

    /*//////////////////////////////////////////////////////////////
                INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    constructor(
        address _ibgt,
        address _rewardsFactory,
        address _depositor,
        address _chef,
        address _wbera,
        address _ired
    ) {
        wbera = IWBERA(_wbera);
        rewardsFactory = IBerachainRewardsVaultFactory(_rewardsFactory);
        depositor = IBeaconDepositContract(_depositor);
        chef = IBeraChef(_chef);

        ibgt = IIBGT(_ibgt);
        _bgt = ibgt.bgt();
        ired = IERC20(_ired);
    }

    function initialize(address _admin, uint256 _rewardsDuration)
        external
        initializer
    {
        // whitelist immutable tokens for rewards
        if (_admin == address(0)) revert Errors.ZeroAddress();
        _updateWhiteListedRewardTokens(address(wbera), true);
        _updateWhiteListedRewardTokens(address(ibgt), true);
        _updateWhiteListedRewardTokens(address(ired), true);

        // grant admin access roles
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        _grantRole(GOVERNANCE_ROLE, _admin);

        if (_rewardsDuration == 0) revert Errors.ZeroAmount();
        rewardsDuration = _rewardsDuration;

        // register ibgt vault which can have ibgt and ired rewards
        address[] memory rewardTokens = new address[](2);
        rewardTokens[0] = address(ibgt);
        rewardTokens[1] = address(ired);
        address vault = _registerVault(address(ibgt), rewardTokens);
        ibgtVault = IInfraredVault(vault);

        // init upgradeable components
        __InfraredUpgradeable_init();
    }

    /*//////////////////////////////////////////////////////////////
                        VAULT REGISTRY
    //////////////////////////////////////////////////////////////*/

    /// @notice Registers a new vault
    function _registerVault(address _asset, address[] memory _rewardTokens)
        private
        returns (address _new)
    {
        // Check for duplicate staking asset address
        if (vaultRegistry[_asset] != IInfraredVault(address(0))) {
            revert Errors.DuplicateAssetAddress();
        }
        // Check for invalid reward tokens
        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            if (!whitelistedRewardTokens[_rewardTokens[i]]) {
                revert Errors.RewardTokenNotSupported();
            }
        }

        _new =
            InfraredVaultDeployer.deploy(_asset, _rewardTokens, rewardsDuration);
        vaultRegistry[_asset] = IInfraredVault(_new);
        emit NewVault(msg.sender, _asset, _new, _rewardTokens);
    }

    /// @inheritdoc IInfrared
    function registerVault(address _asset, address[] memory _rewardTokens)
        external
        onlyKeeper
        whenInitialized
        returns (IInfraredVault)
    {
        if (_asset == address(0)) revert Errors.ZeroAddress();
        address vault = _registerVault(_asset, _rewardTokens);
        return IInfraredVault(vault);
    }

    /*//////////////////////////////////////////////////////////////
                        ADMIN
    //////////////////////////////////////////////////////////////*/

    /// @notice Updates whitelisted reward tokens
    function _updateWhiteListedRewardTokens(address _token, bool _whitelisted)
        private
    {
        emit WhiteListedRewardTokensUpdated(
            msg.sender, _token, whitelistedRewardTokens[_token], _whitelisted
        );
        whitelistedRewardTokens[_token] = _whitelisted;
    }

    /// @inheritdoc IInfrared
    function updateWhiteListedRewardTokens(address _token, bool _whitelisted)
        external
        onlyGovernor
        whenInitialized
    {
        _updateWhiteListedRewardTokens(_token, _whitelisted);
    }

    /// @inheritdoc IInfrared
    function updateRewardsDuration(uint256 _rewardsDuration)
        external
        onlyGovernor
        whenInitialized
    {
        // TODO: update rewards duration on this contract in addition to on vault
        if (_rewardsDuration == 0) {
            revert Errors.ZeroAmount();
        }
        emit RewardsDurationUpdated(
            msg.sender, rewardsDuration, _rewardsDuration
        );
        rewardsDuration = _rewardsDuration;
    }

    /// @inheritdoc IInfrared
    function pauseVault(address _asset) external onlyGovernor whenInitialized {
        IInfraredVault vault = vaultRegistry[_asset];
        if (vault == IInfraredVault(address(0))) {
            revert Errors.VaultNotSupported();
        }
        vault.togglePause();
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
    function updateProtocolFeeRate(address _token, uint256 _feeRate)
        external
        onlyGovernor
        whenInitialized
    {
        uint256 _protocolFeeRate = protocolFeeRates[_token];
        if (_feeRate >= FEE_UNIT) revert Errors.InvalidProtocolFeeRate();
        emit ProtocolFeeRateUpdated(
            msg.sender, _token, _protocolFeeRate, _feeRate
        );
        protocolFeeRates[_token] = _feeRate;
    }

    /// @inheritdoc IInfrared
    function claimProtocolFees(address _to, address _token, uint256 _amount)
        external
        onlyGovernor
        whenInitialized
    {
        if (_amount > protocolFeeAmounts[_token]) {
            revert Errors.MaxProtocolFeeAmount();
        }
        protocolFeeAmounts[_token] -= _amount;
        IERC20(_token).safeTransfer(_to, _amount);
        emit ProtocolFeesClaimed(msg.sender, _to, _token, _amount);
    }

    /*//////////////////////////////////////////////////////////////
                            REWARDS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function harvestVault(address _asset) external whenInitialized {
        IInfraredVault vault = vaultRegistry[_asset];
        if (vault == IInfraredVault(address(0))) {
            revert Errors.VaultNotSupported();
        } else if (!vault.stakedInRewardsVault()) {
            revert Errors.VaultNotStaked();
        }

        uint256 balanceBefore = getBGTBalance();
        IBerachainRewardsVault rewardsVault = vault.rewardsVault();
        rewardsVault.getReward(address(vault));

        uint256 bgtAmt = getBGTBalance() - balanceBefore;
        _handleBGTRewards(vault, bgtAmt);

        emit VaultHarvested(msg.sender, _asset, address(vault), bgtAmt);
    }

    /// @inheritdoc IInfrared
    function harvestTokenRewards(address[] memory _tokens)
        external
        onlyKeeper
        whenInitialized
    {
        for (uint256 i = 0; i < _tokens.length; i++) {
            address _token = _tokens[i];
            if (_token == DataTypes.NATIVE_ASSET) {
                wbera.deposit{value: address(this).balance}();
                _token = address(wbera);
            }
            _handleTokenRewards(ibgtVault, _token);
        }
    }

    /**
     * @notice Handles non-IBGT token rewards to the vault.
     * @param _vault   IInfraredVault      The address of the vault.
     * @param _token   address             The reward token.
     */
    function _handleTokenRewards(IInfraredVault _vault, address _token)
        internal
    {
        if (!whitelistedRewardTokens[_token]) {
            emit RewardTokenNotSupported(_token);
            return; // skip non-whitelisted tokens
        }

        // amount to forward is balance of this address less existing protocol fees
        uint256 _amount =
            IERC20(_token).balanceOf(address(this)) - protocolFeeAmounts[_token];
        if (_amount == 0) return;

        // add reward if not already added
        (, uint256 _vaultRewardsDuration,,,,) = _vault.rewardData(_token);
        if (_vaultRewardsDuration == 0) {
            _vault.addReward(_token, rewardsDuration);
        }

        // take protocol fee
        uint256 _protocolFeeRate = protocolFeeRates[_token];
        if (_protocolFeeRate > 0) {
            uint256 _feeAmt = Math.mulDiv(_amount, _protocolFeeRate, FEE_UNIT);
            protocolFeeAmounts[_token] += _feeAmt;
            _amount -= _feeAmt;
        }

        // increase allowance then notify vault of new rewards
        IERC20(_token).safeIncreaseAllowance(address(_vault), _amount);
        _vault.notifyRewardAmount(_token, _amount);

        emit RewardSupplied(address(_vault), _token, _amount);
    }

    /**
     * @notice Handles BGT token rewards, minting IBGT and supplying to the vault.
     * @param _vault    address                 The address of the vault.
     * @param _bgtAmt   uint256                 The BGT reward amount.
     */
    function _handleBGTRewards(IInfraredVault _vault, uint256 _bgtAmt)
        internal
    {
        // pass if no bgt rewards
        if (_bgtAmt == 0) return;

        // handle bgt rewards by minting and supplying IBGT to vault
        ibgt.mint(address(this), _bgtAmt);

        // take protocol fee
        uint256 _protocolFeeRate = protocolFeeRates[address(ibgt)];
        if (_protocolFeeRate > 0) {
            uint256 _feeAmt = Math.mulDiv(_bgtAmt, _protocolFeeRate, FEE_UNIT);
            protocolFeeAmounts[address(ibgt)] += _feeAmt;
            _bgtAmt -= _feeAmt;
        }

        // send bgt rewards less fee to vault
        ibgt.safeIncreaseAllowance(address(_vault), _bgtAmt);
        _vault.notifyRewardAmount(address(ibgt), _bgtAmt);

        emit IBGTSupplied(address(_vault), _bgtAmt);
    }

    /*//////////////////////////////////////////////////////////////
                            VALIDATORS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function addValidators(DataTypes.Validator[] memory _validators)
        external
        onlyGovernor
        whenInitialized
    {
        bytes[] memory _pubKeys = new bytes[](_validators.length);
        for (uint256 i = 0; i < _validators.length; i++) {
            if (_validators[i].pubKey.length == 0) revert Errors.ZeroBytes();
            _pubKeys[i] = _validators[i].pubKey;
            _infraredValidators.add(_validators[i]);
        }
        emit ValidatorsAdded(msg.sender, _pubKeys);
    }

    /// @inheritdoc IInfrared
    function removeValidators(DataTypes.Validator[] memory _validators)
        external
        onlyGovernor
        whenInitialized
    {
        bytes[] memory _pubKeys = new bytes[](_validators.length);
        for (uint256 i = 0; i < _validators.length; i++) {
            if (_validators[i].pubKey.length == 0) revert Errors.ZeroBytes();
            if (!isInfraredValidator(_validators[i].pubKey)) {
                revert Errors.InvalidValidator();
            }
            _pubKeys[i] = _validators[i].pubKey;
            _infraredValidators.remove(_validators[i]);
        }
        emit ValidatorsRemoved(msg.sender, _pubKeys);
    }

    /// @inheritdoc IInfrared
    function replaceValidator(
        DataTypes.Validator memory _current,
        DataTypes.Validator memory _new
    ) external onlyGovernor whenInitialized {
        if (_current.pubKey.length == 0 || _new.pubKey.length == 0) {
            revert Errors.ZeroBytes();
        }
        if (!isInfraredValidator(_current.pubKey)) {
            revert Errors.InvalidValidator();
        }
        _infraredValidators.replace(_current, _new);
        emit ValidatorReplaced(msg.sender, _current.pubKey, _new.pubKey);
    }

    /// @inheritdoc IInfrared
    function delegate(
        bytes calldata _pubKey,
        uint64 _amt,
        bytes calldata _signature
    ) external onlyGovernor whenInitialized {
        if (!isInfraredValidator(_pubKey)) revert Errors.InvalidValidator();
        if (_amt == 0) revert Errors.ZeroAmount();

        DataTypes.Validator memory _validator = _infraredValidators.get(_pubKey);
        bytes memory _stakingCredentials = ValidatorUtils.cred(address(this)); // Infrared.sol is operator
        depositor.deposit(
            _validator.pubKey, _stakingCredentials, _amt, _signature
        );

        emit Delegated(msg.sender, _validator.pubKey, _amt);
    }

    /// @inheritdoc IInfrared
    function redelegate(
        bytes calldata _fromPubKey,
        bytes calldata _toPubKey,
        uint64 _amt
    ) external onlyGovernor whenInitialized {
        if (
            !isInfraredValidator(_fromPubKey) || !isInfraredValidator(_toPubKey)
        ) {
            revert Errors.InvalidValidator();
        }
        if (_amt == 0) revert Errors.ZeroAmount();

        depositor.redirect(_fromPubKey, _toPubKey, _amt);
        emit Redelegated(msg.sender, _fromPubKey, _toPubKey, _amt);
    }

    /// @inheritdoc IInfrared
    function queue(
        bytes calldata _pubKey,
        uint64 _startBlock,
        IBeraChef.Weight[] calldata _weights
    ) external onlyGovernor {
        if (!isInfraredValidator(_pubKey)) revert Errors.InvalidValidator();
        DataTypes.Validator memory _validator = _infraredValidators.get(_pubKey);
        chef.queueNewCuttingBoard(_validator.coinbase, _startBlock, _weights);
    }

    /*//////////////////////////////////////////////////////////////
                            HELPERS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function infraredValidators()
        public
        view
        virtual
        returns (DataTypes.Validator[] memory _validators)
    {
        return _infraredValidators.validators();
    }

    /// @inheritdoc IInfrared
    function isInfraredValidator(bytes memory _pubKey)
        public
        view
        returns (bool)
    {
        return _infraredValidators.isValidator(_pubKey);
    }

    /// @inheritdoc IInfrared
    function getBGTBalance() public view returns (uint256) {
        return IERC20(_bgt).balanceOf(address(this));
    }
}
