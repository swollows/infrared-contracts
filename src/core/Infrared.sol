// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

// External dependencies.
import {Address} from "@openzeppelin/utils/Address.sol";
import {Math} from "@openzeppelin/utils/math/Math.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";
import {Strings} from "@openzeppelin/utils/Strings.sol";

import {IBeraChef} from "@berachain/pol/interfaces/IBeraChef.sol";
import {IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IBerachainRewardsVault.sol";
import {IBerachainRewardsVaultFactory} from
    "@berachain/pol/interfaces/IBerachainRewardsVaultFactory.sol";
import {IBerachainBGT} from "@interfaces/IBerachainBGT.sol"; // TODO: update when BGT interface fixed
import {IBerachainBGTStaker} from "@interfaces/IBerachainBGTStaker.sol"; // TODO: update when BGT staker interface fixed

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
    using EnumerableSet for EnumerableSet.Bytes32Set;

    /*//////////////////////////////////////////////////////////////
                           STORAGE/EVENTS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Mapping of tokens that are whitelisted to be used as rewards or accepted as bribes
     * @dev serves as central source of truth for whitelisted reward tokens for all Infrared contracts
     */
    mapping(address => bool) public whitelistedRewardTokens;

    /**
     * @notice Mapping of staking token addresses to their corresponding InfraredVault
     * @dev Each staking token can only have one vault
     */
    mapping(address => IInfraredVault) public vaultRegistry;

    /**
     * @notice Set of infrared validator IDs where an ID is keccak256(pubkey)
     * @dev Used to track active validators in the system
     */
    EnumerableSet.Bytes32Set internal _infraredValidatorIds;

    /**
     * @notice Mapping of validator IDs to their CL public keys
     * @dev Maps the keccak256 hash of a validator's pubkey to their actual pubkey
     */
    mapping(bytes32 id => bytes pub) internal _infraredValidatorPubkeys;

    /**
     * @notice The BGT token contract reference
     * @dev Immutable IBerachainBGT instance of the BGT token
     */
    IBerachainBGT internal immutable _bgt;

    /// @inheritdoc IInfrared
    IIBGT public immutable ibgt;

    /// @inheritdoc IInfrared
    IERC20Mintable public immutable ired;

    /// @inheritdoc IInfrared
    IERC20 public immutable wibera;

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
    uint256 public rewardsDuration;

    /// @inheritdoc IInfrared
    uint256 public iredMintRate;

    /// @inheritdoc IInfrared
    IInfraredVault public ibgtVault;

    /// @inheritdoc IInfrared
    IInfraredVault public wiberaVault;

    /// @inheritdoc IInfrared
    mapping(address => uint256) public protocolFeeAmounts;

    /// @inheritdoc IInfrared
    mapping(uint256 => uint256) public weights;

    /// @inheritdoc IInfrared
    mapping(uint256 => uint256) public fees;

    /**
     * @notice Weight units when partitioning reward amounts in hundredths of 1 bip
     * @dev Used as the denominator when calculating weighted distributions (1e6)
     */
    uint256 internal constant WEIGHT_UNIT = 1e6;

    /**
     * @notice Protocol fee rate in hundredths of 1 bip
     * @dev Used as the denominator when calculating protocol fees (1e6)
     */
    uint256 internal constant FEE_UNIT = 1e6;

    /**
     * @notice IRED mint rate in hundredths of 1 bip
     * @dev Used as the denominator when calculating IRED minting (1e6)
     */
    uint256 internal constant RATE_UNIT = 1e6;

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
        address _wbera,
        address _honey,
        address _ired,
        address _wibera
    ) InfraredUpgradeable(address(0)) {
        wbera = IWBERA(_wbera);
        honey = IERC20(_honey);
        rewardsFactory = IBerachainRewardsVaultFactory(_rewardsFactory);
        chef = IBeraChef(_chef);

        ibgt = IIBGT(_ibgt);
        _bgt = IBerachainBGT(ibgt.bgt());
        ired = IERC20Mintable(_ired);
        wibera = IERC20(_wibera);
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
        _updateWhiteListedRewardTokens(address(wbera), true);
        _updateWhiteListedRewardTokens(address(ibgt), true);
        _updateWhiteListedRewardTokens(address(ired), true);
        _updateWhiteListedRewardTokens(address(honey), true);

        // grant admin access roles
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        _grantRole(GOVERNANCE_ROLE, _admin);

        // set collector, validator distributor, and veIRED voter fee vault
        collector = IBribeCollector(_collector);
        distributor = IInfraredDistributor(_distributor);
        voter = IVoter(_voter);

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
        if (_rewardsDuration == 0) {
            revert Errors.ZeroAmount();
        }
        emit RewardsDurationUpdated(
            msg.sender, rewardsDuration, _rewardsDuration
        );
        rewardsDuration = _rewardsDuration;
    }

    /// @inheritdoc IInfrared
    function updateIredMintRate(uint256 _iredMintRate)
        external
        onlyGovernor
        whenInitialized
    {
        emit IredMintRateUpdated(msg.sender, iredMintRate, _iredMintRate);
        iredMintRate = _iredMintRate;
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
    function updateWeight(WeightType _t, uint256 _weight)
        external
        onlyGovernor
        whenInitialized
    {
        if (_weight > WEIGHT_UNIT) revert Errors.InvalidWeight();
        emit WeightUpdated(msg.sender, _t, weights[uint256(_t)], _weight);
        weights[uint256(_t)] = _weight;
    }

    /// @inheritdoc IInfrared
    function updateFee(FeeType _t, uint256 _fee)
        external
        onlyGovernor
        whenInitialized
    {
        if (_fee > FEE_UNIT) revert Errors.InvalidFee();
        emit FeeUpdated(msg.sender, _t, fees[uint256(_t)], _fee);
        fees[uint256(_t)] = _fee;
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

    function chargedFeesOnRewards(
        uint256 _amt,
        uint256 _feeTotal,
        uint256 _feeProtocol
    )
        public
        view
        returns (uint256 amtRecipient, uint256 amtVoter, uint256 amtProtocol)
    {
        amtRecipient = _amt;
        if (_feeTotal == 0) return (amtRecipient, 0, 0);

        uint256 _amtTotal = Math.mulDiv(amtRecipient, _feeTotal, FEE_UNIT);
        amtProtocol = Math.mulDiv(_amtTotal, _feeProtocol, FEE_UNIT);
        amtVoter = _amtTotal - amtProtocol;
        amtRecipient -= (amtProtocol + amtVoter);
    }

    function _distributeFeesOnRewards(
        address _token,
        uint256 _amtVoter,
        uint256 _amtProtocol
    ) internal {
        // add protocol fees to accumulator for token
        protocolFeeAmounts[_token] += _amtProtocol;

        // forward voter fees
        if (_amtVoter > 0) {
            address voterFeeVault = voter.feeVault();
            IERC20(_token).safeIncreaseAllowance(voterFeeVault, _amtVoter);
            IReward(voterFeeVault).notifyRewardAmount(_token, _amtVoter);
        }
    }

    /// @inheritdoc IInfrared
    function harvestBase() external whenInitialized {
        uint256 minted = ibgt.totalSupply();
        uint256 bgtBalance = getBGTBalance();
        // @dev should never happen but check in case
        if (bgtBalance <= minted) revert Errors.UnderFlow();

        uint256 bgtAmt = bgtBalance - minted;

        // split bgt amt between wibera vault and validator distributor
        uint256 w = weights[uint256(WeightType.HarvestBaseWiberaVault)];
        uint256 bgtAmtVault = Math.mulDiv(bgtAmt, w, WEIGHT_UNIT);
        uint256 bgtAmtDistributor = bgtAmt - bgtAmtVault;

        // get total and protocol fee rates
        uint256 feeTotal = fees[uint256(FeeType.HarvestBaseFeeRate)];
        uint256 feeProtocol = fees[uint256(FeeType.HarvestBaseProtocolRate)];

        _handleBGTRewardsForVault(
            wiberaVault, bgtAmtVault, feeTotal, feeProtocol
        );
        _handleBGTRewardsForDistributor(
            bgtAmtDistributor, feeTotal, feeProtocol
        );

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
        rewardsVault.getReward(address(vault), address(this));

        uint256 bgtAmt = getBGTBalance() - balanceBefore;

        // get total and protocol fee rates
        uint256 feeTotal = fees[uint256(FeeType.HarvestVaultFeeRate)];
        uint256 feeProtocol = fees[uint256(FeeType.HarvestVaultProtocolRate)];

        _handleBGTRewardsForVault(vault, bgtAmt, feeTotal, feeProtocol);

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
    function collectBribes(address _token, uint256 _amount)
        external
        onlyCollector
        whenInitialized
    {
        if (!whitelistedRewardTokens[_token]) {
            revert Errors.RewardTokenNotSupported();
        }
        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);

        // split collected bribe amount between wibera and ibgt vaults
        uint256 w = weights[uint256(WeightType.CollectBribesWiberaVault)];
        uint256 amtWiberaVault = Math.mulDiv(_amount, w, WEIGHT_UNIT);
        uint256 amtIbgtVault = _amount - amtWiberaVault;

        // get total and protocol fee rates
        uint256 feeTotal = fees[uint256(FeeType.HarvestBribesFeeRate)];
        uint256 feeProtocol = fees[uint256(FeeType.HarvestBribesProtocolRate)];

        _handleTokenRewardsForVault(
            wiberaVault, _token, amtWiberaVault, feeTotal, feeProtocol
        );
        _handleTokenRewardsForVault(
            ibgtVault, _token, amtIbgtVault, feeTotal, feeProtocol
        );

        emit BribesCollected(msg.sender, _token, amtWiberaVault, amtIbgtVault);
    }

    /// @inheritdoc IInfrared
    function harvestBoostRewards() external whenInitialized {
        IBerachainBGTStaker _bgtStaker = _bgt.staker();
        address _token = address(_bgtStaker.rewardToken());

        // claim boost reward
        // @dev not trusting return from bgt staker in case transfer fees
        uint256 balanceBefore = IERC20(_token).balanceOf(address(this));
        _bgtStaker.getReward();
        uint256 _amount =
            IERC20(_token).balanceOf(address(this)) - balanceBefore;

        // get total and protocol fee rates
        uint256 feeTotal = fees[uint256(FeeType.HarvestBoostFeeRate)];
        uint256 feeProtocol = fees[uint256(FeeType.HarvestBoostProtocolRate)];

        _handleTokenRewardsForVault(
            ibgtVault, _token, _amount, feeTotal, feeProtocol
        );
    }

    /**
     * @notice Handles non-IBGT token rewards to the vault.
     * @param _vault       IInfraredVault   The address of the vault.
     * @param _token       address          The reward token.
     * @param _amount      uint256          The amount of reward token to send to vault.
     * @param _feeTotal    uint256          The rate to charge for total fees on `_amount`.
     * @param _feeProtocol uint256          The rate to charge for protocol treasury on total fees.
     */
    function _handleTokenRewardsForVault(
        IInfraredVault _vault,
        address _token,
        uint256 _amount,
        uint256 _feeTotal,
        uint256 _feeProtocol
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

        uint256 _amtVoter;
        uint256 _amtProtocol;

        // calculate and distribute fees on rewards
        (_amount, _amtVoter, _amtProtocol) =
            chargedFeesOnRewards(_amount, _feeTotal, _feeProtocol);
        _distributeFeesOnRewards(_token, _amtVoter, _amtProtocol);

        // increase allowance then notify vault of new rewards
        if (_amount > 0) {
            IERC20(_token).safeIncreaseAllowance(address(_vault), _amount);
            _vault.notifyRewardAmount(_token, _amount);
        }

        emit RewardSupplied(address(_vault), _token, _amount);
    }

    /**
     * @notice Handles non-IBGT token bribe rewards to a non-vault receiver address.
     * @dev Does *not* take protocol fee on bribe coin, as taken on bribe collector payout token in eventual callback.
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

        // transfer rewards to recipient
        IERC20(_token).safeTransfer(_recipient, _amount);
        emit BribeSupplied(_recipient, _token, _amount);
    }

    /**
     * @notice Handles BGT token rewards, minting IBGT and supplying to the vault.
     * @param _vault       address         The address of the vault.
     * @param _bgtAmt      uint256         The BGT reward amount.
     * @param _feeTotal    uint256         The rate to charge for total fees on iBGT `_bgtAmt`.
     * @param _feeProtocol uint256         The rate to charge for protocol treasury on total iBGT fees.
     */
    function _handleBGTRewardsForVault(
        IInfraredVault _vault,
        uint256 _bgtAmt,
        uint256 _feeTotal,
        uint256 _feeProtocol
    ) internal {
        // pass if no bgt rewards
        if (_bgtAmt == 0) return;

        // handle bgt rewards by minting and supplying IBGT to vault
        ibgt.mint(address(this), _bgtAmt);

        // mint IRED rewards for associated IBGT mint based on protocol set mint rate
        uint256 _iredAmt = Math.mulDiv(_bgtAmt, iredMintRate, RATE_UNIT);
        ired.mint(address(this), _iredAmt);

        // for both ired and ibgt, take protocol fee cut and notify vault of reward
        // indices: 0: ibgt, 1: ired
        address[] memory _tokens = new address[](2);
        uint256[] memory _amts = new uint256[](2);
        uint256[] memory _feeTotals = new uint256[](2);
        uint256[] memory _feeProtocols = new uint256[](2);

        // ibgt attrs. feeTotal and feeProtocol charged on minted ibgt
        _tokens[0] = address(ibgt);
        _amts[0] = _bgtAmt;
        _feeTotals[0] = _feeTotal;
        _feeProtocols[0] = _feeProtocol;

        // ired attrs. zero fee rates charged on newly minted ired
        _tokens[1] = address(ired);
        _amts[1] = _iredAmt;

        for (uint256 i = 0; i < _tokens.length; i++) {
            address _token = _tokens[i];
            uint256 _amt = _amts[i];

            uint256 _amtVoter;
            uint256 _amtProtocol;

            // calculate and distribute fees on rewards
            (_amt, _amtVoter, _amtProtocol) =
                chargedFeesOnRewards(_amt, _feeTotals[i], _feeProtocols[i]);
            _distributeFeesOnRewards(_token, _amtVoter, _amtProtocol);

            // send token rewards less fee to vault
            if (_amt > 0) {
                IERC20(_token).safeIncreaseAllowance(address(_vault), _amt);
                _vault.notifyRewardAmount(_token, _amt);
            }
        }

        emit IBGTSupplied(address(_vault), _bgtAmt, _iredAmt);
    }

    /**
     * @notice Handles BGT base rewards supplied to validator distributor.
     * @param _bgtAmt      uint256         The BGT reward amount.
     * @param _feeTotal    uint256         The rate to charge for total fees on `_bgtAmt`.
     * @param _feeProtocol uint256         The rate to charge for protocol treasury on total fees.
     */
    function _handleBGTRewardsForDistributor(
        uint256 _bgtAmt,
        uint256 _feeTotal,
        uint256 _feeProtocol
    ) internal {
        // pass if no bgt rewards
        if (_bgtAmt == 0) return;

        // handle bgt rewards by minting and supplying to distributor
        ibgt.mint(address(this), _bgtAmt);

        address _token = address(ibgt);
        uint256 _amt = _bgtAmt;

        uint256 _amtVoter;
        uint256 _amtProtocol;

        // calculate and distribute fees on rewards
        (_amt, _amtVoter, _amtProtocol) =
            chargedFeesOnRewards(_amt, _feeTotal, _feeProtocol);
        _distributeFeesOnRewards(_token, _amtVoter, _amtProtocol);

        // send token rewards less fee to vault
        if (_amt > 0) {
            IERC20(_token).safeIncreaseAllowance(address(distributor), _amt);
            distributor.notifyRewardAmount(_amt);
        }
        emit IBGTDistributed(address(distributor), _amt);
    }

    /*//////////////////////////////////////////////////////////////
                            VALIDATORS
    //////////////////////////////////////////////////////////////*/

    /// @notice Gets the validator ID for associated CL pubkey
    /// @param pubkey The CL pubkey of validator
    function _getValidatorId(bytes memory pubkey)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(pubkey);
    }

    /// @notice Adds validator pubkey to validator set
    /// @dev Reverts if already exists in set
    function _addValidatorToSet(bytes memory pubkey) private {
        bytes32 id = _getValidatorId(pubkey);
        if (!_infraredValidatorIds.add(id)) {
            revert Errors.InvalidValidator();
        }
        _infraredValidatorPubkeys[id] = pubkey;
    }

    /// @notice Removes validator pubkey from validator set
    /// @dev Reverts if does not already exist in set
    function _removeValidatorFromSet(bytes memory pubkey) private {
        bytes32 id = _getValidatorId(pubkey);
        if (!_infraredValidatorIds.remove(id)) {
            revert Errors.InvalidValidator();
        }
        delete _infraredValidatorPubkeys[id];
    }

    /// @inheritdoc IInfrared
    function addValidators(Validator[] memory _validators)
        external
        onlyGovernor
        whenInitialized
    {
        for (uint256 i = 0; i < _validators.length; i++) {
            Validator memory v = _validators[i];

            // update infrared validator sets
            _addValidatorToSet(v.pubkey);

            // add pubkey to those elligible for iBGT rewards
            distributor.add(v.pubkey, v.addr);

            // update commission validator charges
            // TODO: update for validator queue => activate commission flow
            // _updateValidatorCommission(v.pubkey, v.commission);
        }
        emit ValidatorsAdded(msg.sender, _validators);
    }

    /// @inheritdoc IInfrared
    function removeValidators(bytes[] memory _pubkeys)
        external
        onlyGovernor
        whenInitialized
    {
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            bytes memory pubkey = _pubkeys[i];

            // update infrared validator sets
            _removeValidatorFromSet(pubkey);

            // remove pubkey from those elligible for iBGT rewards
            distributor.remove(pubkey);

            // update commission validator charges to zero
            // TODO: update for validator queue => activate commission flow
            // _updateValidatorCommission(pubkey, 0);
        }
        emit ValidatorsRemoved(msg.sender, _pubkeys);
    }

    /// @inheritdoc IInfrared
    function replaceValidator(bytes calldata _current, bytes calldata _new)
        external
        onlyGovernor
        whenInitialized
    {
        uint256 _commission = _getValidatorCommission(_current);
        address _addr = _getValidatorAddress(_current);

        // remove current from set
        _removeValidatorFromSet(_current);
        distributor.remove(_current);

        // TODO: update for validator queue => activate commission flow
        // _updateValidatorCommission(_current, 0);

        // add new to set
        _addValidatorToSet(_new);
        distributor.add(_new, _addr);

        // TODO: fix for queue => activate commission change
        // _updateValidatorCommission(_new, _commission);

        emit ValidatorReplaced(msg.sender, _current, _new);
    }

    /// @notice Gets the current validator commission rate by calling BGT.
    function _getValidatorCommission(bytes memory _pubkey)
        internal
        view
        returns (uint256 rate)
    {
        rate = _bgt.commissions(_pubkey);
    }

    /// @notice Gets the validator address for claiming on distributor associated with pubkey
    function _getValidatorAddress(bytes memory _pubkey)
        internal
        view
        returns (address)
    {
        return distributor.validators(_pubkey);
    }

    /* TODO: update for queue => activate with commissions

    /// @notice Updates validator commission rate calling BGT to set.
    function _updateValidatorCommission(
        bytes memory _pubkey,
        uint256 _commission
    ) private {
        if (_commission > COMMISSION_MAX) revert Errors.InvalidCommissionRate();
        emit ValidatorCommissionUpdated(
            msg.sender, _pubkey, _getValidatorCommission(_pubkey), _commission
        );
        _bgt.setCommission(_pubkey, _commission);
    }

    /// @inheritdoc IInfrared
    function updateValidatorCommission(
        bytes calldata _pubkey,
        uint256 _commission
    ) external onlyGovernor whenInitialized {
        if (!isInfraredValidator(_pubkey)) revert Errors.InvalidValidator();
        _updateValidatorCommission(_pubkey, _commission);
    }

    */

    /// @inheritdoc IInfrared
    function queueNewCuttingBoard(
        bytes calldata _pubkey,
        uint64 _startBlock,
        IBeraChef.Weight[] calldata _weights
    ) external onlyKeeper {
        if (!isInfraredValidator(_pubkey)) revert Errors.InvalidValidator();
        chef.queueNewCuttingBoard(_pubkey, _startBlock, _weights);
    }

    /*//////////////////////////////////////////////////////////////
                            BOOSTS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function queueBoosts(bytes[] memory _pubkeys, uint128[] memory _amts)
        external
        onlyKeeper
        whenInitialized
    {
        if (_pubkeys.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            if (!isInfraredValidator(_pubkeys[i])) {
                revert Errors.InvalidValidator();
            }
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            _bgt.queueBoost(_pubkeys[i], _amts[i]);
        }
        emit QueuedBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function cancelBoosts(bytes[] memory _pubkeys, uint128[] memory _amts)
        external
        onlyKeeper
        whenInitialized
    {
        if (_pubkeys.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            _bgt.cancelBoost(_pubkeys[i], _amts[i]);
        }
        emit CancelledBoosts(msg.sender, _pubkeys, _amts);
    }

    /// @inheritdoc IInfrared
    function activateBoosts(bytes[] memory _pubkeys) external whenInitialized {
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            if (!isInfraredValidator(_pubkeys[i])) {
                revert Errors.InvalidValidator();
            }
            _bgt.activateBoost(address(this), _pubkeys[i]);
        }
        emit ActivatedBoosts(msg.sender, _pubkeys);
    }

    /* TODO: fix for queueing => activate drop boost updates
    /// @inheritdoc IInfrared
    function dropBoosts(bytes[] memory _pubkeys, uint128[] memory _amts)
        external
        onlyKeeper
        whenInitialized
    {
        if (_pubkeys.length != _amts.length) {
            revert Errors.InvalidArrayLength();
        }
        for (uint256 i = 0; i < _pubkeys.length; i++) {
            if (_amts[i] == 0) revert Errors.ZeroAmount();
            _bgt.dropBoost(address(this), _pubkeys[i], _amts[i]);
        }
        emit DroppedBoosts(msg.sender, _pubkeys, _amts);
    }
    */

    /*//////////////////////////////////////////////////////////////
                            HELPERS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IInfrared
    function infraredValidators()
        public
        view
        virtual
        returns (Validator[] memory validators)
    {
        bytes32[] memory ids = _infraredValidatorIds.values();
        validators = new Validator[](ids.length);

        for (uint256 i = 0; i < ids.length; i++) {
            bytes memory pubkey = _infraredValidatorPubkeys[ids[i]];
            validators[i] = Validator({
                pubkey: pubkey,
                addr: _getValidatorAddress(pubkey),
                commission: _getValidatorCommission(pubkey)
            });
        }
    }

    /// @inheritdoc IInfrared
    function numInfraredValidators() external view returns (uint256) {
        return _infraredValidatorIds.length();
    }

    /// @inheritdoc IInfrared
    function isInfraredValidator(bytes memory _validator)
        public
        view
        returns (bool)
    {
        return _infraredValidatorIds.contains(_getValidatorId(_validator));
    }

    /// @inheritdoc IInfrared
    function getBGTBalance() public view returns (uint256) {
        return _bgt.balanceOf(address(this));
    }
}
