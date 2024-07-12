// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

// External dependencies.
import {Address} from "@openzeppelin/utils/Address.sol";
import {Math} from "@openzeppelin/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";

import {IBeraChef} from "@berachain/interfaces/IBeraChef.sol";
import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";
import {IBerachainRewardsVaultFactory} from
    "@berachain/interfaces/IBerachainRewardsVaultFactory.sol";
import {IBGT as IBerachainBGT} from "@berachain/interfaces/IBGT.sol";
import {IBGTStaker as IBerachainBGTStaker} from
    "@berachain/interfaces/IBGTStaker.sol";
import {IWBERA} from "@berachain/interfaces/IWBERA.sol";

// Internal dependencies.
import {ValidatorSet} from "@utils/ValidatorSet.sol";
import {ValidatorUtils} from "@utils/ValidatorUtils.sol";

import {DataTypes} from "@utils/DataTypes.sol";
import {Errors} from "@utils/Errors.sol";
import {InfraredVaultDeployer} from "@utils/InfraredVaultDeployer.sol";

import {IIBGT} from "@interfaces/IIBGT.sol";
import {IBribeCollector} from "@interfaces/IBribeCollector.sol";
import {IInfraredBribes} from "@interfaces/IInfraredBribes.sol";
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
    using EnumerableSet for EnumerableSet.AddressSet;

    /*//////////////////////////////////////////////////////////////
                           STORAGE/EVENTS
    //////////////////////////////////////////////////////////////*/

    // mapping of whitelisted reward tokens
    mapping(address => bool) public whitelistedRewardTokens;

    // Mapping of staking token address to `IInfraredVault`.
    mapping(address => IInfraredVault) public vaultRegistry;

    // The set of infrared validators.
    EnumerableSet.AddressSet internal _infraredValidators;

    // The BGT address
    IBerachainBGT internal immutable _bgt;

    /// @inheritdoc IInfrared
    IIBGT public immutable ibgt;

    /// @inheritdoc IInfrared
    IERC20 public immutable ired;

    /// @inheritdoc IInfrared
    IERC20 public immutable wibera;

    /// @inheritdoc IInfrared
    IBerachainRewardsVaultFactory public immutable rewardsFactory;

    /// inheritdoc IInfrared
    IBeraChef public immutable chef;

    /// @inheritdoc IInfrared
    IWBERA public immutable wbera;

    /// @inheritdoc IInfrared
    IERC20 public immutable honey;

    /// @inheritdoc IInfrared
    IBribeCollector public collector;

    /// @inheritdoc IInfrared
    IInfraredBribes public bribes;

    /// @inheritdoc IInfrared
    uint256 public rewardsDuration;

    /// @inheritdoc IInfrared
    IInfraredVault public ibgtVault;

    /// @inheritdoc IInfrared
    IInfraredVault public wiberaVault;

    /// @inheritdoc IInfrared
    mapping(address => uint256) public protocolFeeRates;

    /// @inheritdoc IInfrared
    mapping(address => uint256) public protocolFeeAmounts;

    /// @notice Protocol fee rate in hundredths of 1 bip
    uint256 internal constant FEE_UNIT = 1e6;

    /// @notice Commission rate in units of 1 bip
    uint256 internal constant COMMISSION_MAX = 1e3;

    /*//////////////////////////////////////////////////////////////
                INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    constructor(
        address _ibgt,
        address _rewardsFactory,
        address _chef,
        address _wbera,
        address _honey,
        address _ired,
        address _wibera
    ) InfraredUpgradeable() {
        wbera = IWBERA(_wbera);
        honey = IERC20(_honey);
        rewardsFactory = IBerachainRewardsVaultFactory(_rewardsFactory);
        chef = IBeraChef(_chef);

        ibgt = IIBGT(_ibgt);
        _bgt = IBerachainBGT(ibgt.bgt());
        ired = IERC20(_ired);
        wibera = IERC20(_wibera);
    }

    function initialize(
        address _admin,
        address _collector,
        address _bribes,
        uint256 _rewardsDuration
    ) external initializer {
        // whitelist immutable tokens for rewards
        if (
            _admin == address(0) || _collector == address(0)
                || _bribes == address(0)
        ) revert Errors.ZeroAddress();
        _updateWhiteListedRewardTokens(address(wbera), true);
        _updateWhiteListedRewardTokens(address(ibgt), true);
        _updateWhiteListedRewardTokens(address(ired), true);
        _updateWhiteListedRewardTokens(address(honey), true);

        // grant admin access roles
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        _grantRole(GOVERNANCE_ROLE, _admin);

        // set collector and bribes
        collector = IBribeCollector(_collector);
        bribes = IInfraredBribes(_bribes);

        if (_rewardsDuration == 0) revert Errors.ZeroAmount();
        rewardsDuration = _rewardsDuration;

        // register ibgt vault which can have ibgt and ired rewards
        address[] memory rewardTokens = new address[](3);
        rewardTokens[0] = address(ibgt);
        rewardTokens[1] = address(ired);
        rewardTokens[2] = address(honey);
        address _ibgtVaultAddress = _registerVault(address(ibgt), rewardTokens);
        ibgtVault = IInfraredVault(_ibgtVaultAddress);

        // register wibera vault which can have ibgt and ired rewards
        address _wiberaVaultAddress =
            _registerVault(address(wibera), rewardTokens);
        wiberaVault = IInfraredVault(_wiberaVaultAddress);

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
    function delegateBGT(address _delegatee)
        external
        onlyGovernor
        whenInitialized
    {
        if (_delegatee == address(0)) revert Errors.ZeroAddress();
        if (_delegatee == address(this)) revert Errors.InvalidDelegatee();
        _bgt.delegate(_delegatee);
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
    function harvestBase() external whenInitialized {
        uint256 minted = ibgt.totalSupply();
        uint256 bgtBalance = getBGTBalance();
        // @dev should never happen but check in case
        if (bgtBalance <= minted) revert Errors.UnderFlow();

        uint256 bgtAmt = bgtBalance - minted;
        _handleBGTRewardsForVault(wiberaVault, bgtAmt);

        emit BaseHarvested(msg.sender, bgtAmt);
    }

    /// @inheritdoc IInfrared
    function harvestVault(address _asset) external whenInitialized {
        IInfraredVault vault = vaultRegistry[_asset];
        if (vault == IInfraredVault(address(0))) {
            revert Errors.VaultNotSupported();
        }

        uint256 balanceBefore = getBGTBalance();
        IBerachainRewardsVault rewardsVault = vault.rewardsVault();
        rewardsVault.getReward(address(vault));

        uint256 bgtAmt = getBGTBalance() - balanceBefore;
        _handleBGTRewardsForVault(vault, bgtAmt);

        emit VaultHarvested(msg.sender, _asset, address(vault), bgtAmt);
    }

    /// @inheritdoc IInfrared
    function harvestBribes(address[] memory _tokens) external whenInitialized {
        for (uint256 i = 0; i < _tokens.length; i++) {
            address _token = _tokens[i];
            if (_token == DataTypes.NATIVE_ASSET) {
                wbera.deposit{value: address(this).balance}();
                _token = address(wbera);
            }
            // amount to forward is balance of this address less existing protocol fees
            uint256 _amount = IERC20(_token).balanceOf(address(this))
                - protocolFeeAmounts[_token];
            _handleTokenBribesForReceiver(address(collector), _token, _amount);
        }
    }

    /// @inheritdoc IInfrared
    function harvestBoostRewards() external whenInitialized {
        IBerachainBGTStaker _bgtStaker = _bgt.staker();
        address _token = address(_bgtStaker.REWARD_TOKEN());

        // claim boost reward
        // @dev not trusting return from bgt staker in case transfer fees
        uint256 balanceBefore = IERC20(_token).balanceOf(address(this));
        _bgtStaker.getReward();
        uint256 _amount =
            IERC20(_token).balanceOf(address(this)) - balanceBefore;

        _handleTokenRewardsForVault(ibgtVault, _token, _amount);
    }

    /**
     * @notice Handles non-IBGT token rewards to the vault.
     * @param _vault   IInfraredVault      The address of the vault.
     * @param _token   address             The reward token.
     * @param _amount  uint256             The amount of reward token to send to vault.
     */
    function _handleTokenRewardsForVault(
        IInfraredVault _vault,
        address _token,
        uint256 _amount
    ) internal {
        if (!whitelistedRewardTokens[_token]) {
            emit RewardTokenNotSupported(_token);
            return; // skip non-whitelisted tokens
        }
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
     * @notice Handles non-IBGT token bribe rewards to a non-vault receiver address.
     * @param _recipient address  The address of the recipient.
     * @param _token     address  The address of the token to forward to recipient.
     */
    function _handleTokenBribesForReceiver(
        address _recipient,
        address _token,
        uint256 _amount
    ) internal {
        if (!whitelistedRewardTokens[_token]) {
            emit RewardTokenNotSupported(_token);
            return; // skip non-whitelisted tokens
        }
        if (_amount == 0) return;

        // take protocol fee
        uint256 _protocolFeeRate = protocolFeeRates[_token];
        if (_protocolFeeRate > 0) {
            uint256 _feeAmt = Math.mulDiv(_amount, _protocolFeeRate, FEE_UNIT);
            protocolFeeAmounts[_token] += _feeAmt;
            _amount -= _feeAmt;
        }

        // transfer rewards to recipient
        IERC20(_token).safeTransfer(_recipient, _amount);
        emit BribeSupplied(_recipient, _token, _amount);
    }

    /**
     * @notice Handles BGT token rewards, minting IBGT and supplying to the vault.
     * @param _vault    address                 The address of the vault.
     * @param _bgtAmt   uint256                 The BGT reward amount.
     */
    function _handleBGTRewardsForVault(IInfraredVault _vault, uint256 _bgtAmt)
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
    function addValidators(
        address[] memory _validators,
        uint256[] memory _commissions
    ) external onlyGovernor whenInitialized {
        if (_validators.length != _commissions.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _validators.length; i++) {
            _infraredValidators.add(_validators[i]);
            bribes.add(_validators[i]);
            _updateValidatorCommission(_validators[i], _commissions[i]);
        }
        emit ValidatorsAdded(msg.sender, _validators, _commissions);
    }

    /// @inheritdoc IInfrared
    function removeValidators(address[] memory _validators)
        external
        onlyGovernor
        whenInitialized
    {
        for (uint256 i = 0; i < _validators.length; i++) {
            if (!_infraredValidators.remove(_validators[i])) {
                revert Errors.InvalidValidator();
            }
            bribes.remove(_validators[i]);
            _updateValidatorCommission(_validators[i], 0);
        }
        emit ValidatorsRemoved(msg.sender, _validators);
    }

    /// @inheritdoc IInfrared
    function replaceValidator(address _current, address _new)
        external
        onlyGovernor
        whenInitialized
    {
        if (!_infraredValidators.remove(_current)) {
            revert Errors.InvalidValidator();
        }
        bribes.remove(_current);

        uint256 _commission = _getValidatorCommission(_current);
        _updateValidatorCommission(_current, 0);

        _infraredValidators.add(_new);
        bribes.add(_new);
        _updateValidatorCommission(_new, _commission);

        emit ValidatorReplaced(msg.sender, _current, _new);
    }

    /// @notice Gets the current validator commission rate by calling BGT.
    function _getValidatorCommission(address _validator)
        internal
        view
        returns (uint256 rate)
    {
        (, rate) = _bgt.commissions(_validator);
    }

    /// @notice Updates validator commission rate calling BGT to set.
    function _updateValidatorCommission(address _validator, uint256 _commission)
        private
    {
        if (_commission > COMMISSION_MAX) revert Errors.InvalidCommissionRate();
        emit ValidatorCommissionUpdated(
            msg.sender,
            _validator,
            _getValidatorCommission(_validator),
            _commission
        );
        _bgt.setCommission(_validator, _commission);
    }

    /// @inheritdoc IInfrared
    function updateValidatorCommission(address _validator, uint256 _commission)
        external
        onlyGovernor
        whenInitialized
    {
        if (!isInfraredValidator(_validator)) revert Errors.InvalidValidator();
        _updateValidatorCommission(_validator, _commission);
    }

    /// @inheritdoc IInfrared
    function queueNewCuttingBoard(
        address _validator,
        uint64 _startBlock,
        IBeraChef.Weight[] calldata _weights
    ) external onlyKeeper {
        if (!isInfraredValidator(_validator)) revert Errors.InvalidValidator();
        chef.queueNewCuttingBoard(_validator, _startBlock, _weights);
    }

    /*//////////////////////////////////////////////////////////////
                            BOOSTS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function queueBoosts(address[] memory _validators, uint128[] memory _amts)
        external
        onlyKeeper
        whenInitialized
    {
        if (_validators.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _validators.length; i++) {
            if (!isInfraredValidator(_validators[i])) {
                revert Errors.InvalidValidator();
            }
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            _bgt.queueBoost(_validators[i], _amts[i]);
        }
        emit QueuedBoosts(msg.sender, _validators, _amts);
    }

    /// @inheritdoc IInfrared
    function cancelBoosts(address[] memory _validators, uint128[] memory _amts)
        external
        onlyKeeper
        whenInitialized
    {
        if (_validators.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _validators.length; i++) {
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            _bgt.cancelBoost(_validators[i], _amts[i]);
        }
        emit CancelledBoosts(msg.sender, _validators, _amts);
    }

    /// @inheritdoc IInfrared
    function activateBoosts(address[] memory _validators)
        external
        whenInitialized
    {
        for (uint256 i = 0; i < _validators.length; i++) {
            if (!isInfraredValidator(_validators[i])) {
                revert Errors.InvalidValidator();
            }
            _bgt.activateBoost(_validators[i]);
        }
        emit ActivatedBoosts(msg.sender, _validators);
    }

    /// @inheritdoc IInfrared
    function dropBoosts(address[] memory _validators, uint128[] memory _amts)
        external
        onlyKeeper
        whenInitialized
    {
        if (_validators.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _validators.length; i++) {
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            _bgt.dropBoost(_validators[i], _amts[i]);
        }
        emit DroppedBoosts(msg.sender, _validators, _amts);
    }

    /*//////////////////////////////////////////////////////////////
                            HELPERS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function infraredValidators()
        public
        view
        virtual
        returns (address[] memory validators, uint256[] memory commissions)
    {
        validators = _infraredValidators.values();
        commissions = new uint256[](validators.length);
        for (uint256 i = 0; i < validators.length; i++) {
            commissions[i] = _getValidatorCommission(validators[i]);
        }
    }

    /// @inheritdoc IInfrared
    function numInfraredValidators() external view returns (uint256) {
        return _infraredValidators.length();
    }

    /// @inheritdoc IInfrared
    function isInfraredValidator(address _validator)
        public
        view
        returns (bool)
    {
        return _infraredValidators.contains(_validator);
    }

    /// @inheritdoc IInfrared
    function getBGTBalance() public view returns (uint256) {
        return _bgt.balanceOf(address(this));
    }
}
