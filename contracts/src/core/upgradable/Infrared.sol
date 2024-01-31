// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External dependencies.
import {AccessControlUpgradeable} from
    "@openzeppelin-upgradeable/access/AccessControlUpgradeable.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";
import {
    UUPSUpgradeable,
    ERC1967Utils
} from "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from
    "@openzeppelin-upgradeable/access/OwnableUpgradeable.sol";

import {IBankModule} from "@polaris/IBankModule.sol";

// Internal dependencies.
import {ValidatorSet} from "@utils/ValidatorSet.sol";
import {InfraredVaultDeployer} from "@utils/InfraredVaultDeployer.sol";
import {ValidatorRewards} from "@utils/ValidatorRewards.sol";
import {ValidatorManagment} from "@utils/ValidatorManagment.sol";
import {Errors} from "@utils/Errors.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {IERC20Mintable} from "@interfaces/IERC20Mintable.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

/**
 * @title Infrared
 * @dev A contract for managing the set of infrared validators, infrared vaults, and interacting with the rewards handler.
 * @dev This contract is the main entry point for interacting with the Infrared protocol.
 * @dev It is an immutable contract that interacts with the upgradable rewards handler and staking handler. These contracts are upgradable by governance (app + chain), main reason is that they could change with a chain upgrade.
 */
contract Infrared is
    UUPSUpgradeable,
    OwnableUpgradeable,
    AccessControlUpgradeable
{
    using ValidatorSet for EnumerableSet.AddressSet;
    using SafeERC20 for IERC20Mintable;

    /*//////////////////////////////////////////////////////////////
                           STORAGE/EVENTS
    //////////////////////////////////////////////////////////////*/

    // Access control constants.
    bytes32 public constant KEEPER_ROLE = keccak256("KEEPER_ROLE");
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    // mapping of whitelisted reward tokens
    mapping(address => bool) public whitelistedRewardTokens;

    // Mapping of pool address to `IInfraredVault`.
    mapping(address _poolAddress => IInfraredVault _vault) public vaultRegistry;

    // The set of infrared validators.
    EnumerableSet.AddressSet internal _infraredValidators;

    // The IBGT Liquid staked token.
    IERC20Mintable public ibgt;

    // GOVERNANCE token
    IERC20Mintable public ired;

    // The IBGT vault.
    IInfraredVault public ibgtVault;

    // precompile addresses
    address public erc20BankPrecompile;
    address public distributionPrecompile;
    address public wbera;
    address public stakingPrecompile;
    address public rewardsPrecompile;
    IBankModule public bankModulePrecompile;

    // The rewards duration.
    uint256 public rewardsDuration = 7 days;

    event NewVault(
        address _sender,
        address indexed _pool,
        address indexed _vault,
        address _asset,
        address[] _rewardTokens
    );
    event IBGTSupplied(address indexed _vault, uint256 _amt);
    event RewardSupplied(
        address indexed _vault, address indexed _token, uint256 _amt
    );
    event Recovered(address _sender, address indexed _token, uint256 _amount);
    event RewardTokenNotSupported(address _token);
    event IBGTUpdated(address _sender, address _oldIbgt, address _newIbgt);
    event IBGTVaultUpdated(
        address _sender, address _oldIbgtVault, address _newIbgtVault
    );
    event WhiteListedRewardTokensUpdated(
        address _sender,
        address indexed _token,
        bool _wasWhitelisted,
        bool _isWhitelisted
    );
    event RewardsDurationUpdated(
        address _sender, uint256 _oldDuration, uint256 _newDuration
    );
    event VaultHarvested(
        address _sender,
        address indexed _pool,
        address indexed _vault,
        uint256 _bgtAmt
    );
    event ValidatorHarvested(
        address _sender,
        address indexed _validator,
        DataTypes.Token[] _rewards,
        uint256 _bgtAmt
    );
    event ValidatorsAdded(address _sender, address[] _validators);
    event ValidatorsRemoved(address _sender, address[] _validators);
    event ValidatorReplaced(address _sender, address _current, address _new);
    event Delegated(address _sender, address _validator, uint256 _amt);
    event Undelegated(address _sender, address _validator, uint256 _amt);
    event RedelegateStarted(
        address _sender, address _from, address _to, uint256 _amt
    );
    event UnbondingDelegationCancelled(
        address _sender,
        address indexed _validator,
        uint256 _amt,
        int64 _creationHeight
    );

    /*//////////////////////////////////////////////////////////////
                INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    function initialize(
        address _admin,
        address _ibgt,
        address _erc20BankPrecompile,
        address _distributionPrecompile,
        address _wbera,
        address _stakingPrecompile,
        address _rewardsPrecompile,
        address _ired,
        uint256 _rewardsDuration,
        address _bankModulePrecompile
    ) external initializer {
        if (_admin == address(0) || _ibgt == address(0)) {
            revert Errors.ZeroAddress();
        }
        if (
            _erc20BankPrecompile == address(0)
                || _distributionPrecompile == address(0) || _wbera == address(0)
                || _stakingPrecompile == address(0)
                || _rewardsPrecompile == address(0)
        ) {
            revert Errors.ZeroAddress();
        }

        erc20BankPrecompile = _erc20BankPrecompile;
        distributionPrecompile = _distributionPrecompile;
        wbera = _wbera;
        stakingPrecompile = _stakingPrecompile;
        rewardsPrecompile = _rewardsPrecompile;

        ibgt = IERC20Mintable(_ibgt);
        ired = IERC20Mintable(_ired);

        rewardsDuration = _rewardsDuration;
        bankModulePrecompile = IBankModule(_bankModulePrecompile);

        __Ownable_init(_admin);
        __UUPSUpgradeable_init();
        __AccessControl_init();

        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        _grantRole(GOVERNANCE_ROLE, _admin);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(GOVERNANCE_ROLE)
    {
        // allow only owner to upgrade the implementation
        // will be called by upgradeToAndCall
    }

    function currentImplementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }

    /*//////////////////////////////////////////////////////////////
                        VAULT REGISTRY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Registers a new vault.
     * @param _asset            address          The address of the asset, e.g. Honey:Bera LP token.
     * @param _poolAddress      address          The address of the pool.
     * @return _new             IInfraredVault   The address of the new `InfraredVault` contract.
     */
    function registerVault(
        address _asset,
        address[] memory _rewardTokens,
        address _poolAddress
    ) public onlyRole(KEEPER_ROLE) returns (IInfraredVault) {
        // Check for duplicate pool address
        if (vaultRegistry[_poolAddress] != IInfraredVault(address(0))) {
            revert Errors.DuplicatePoolAddress();
        }
        // Check for invalid reward tokens
        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            if (!whitelistedRewardTokens[_rewardTokens[i]]) {
                revert Errors.RewardTokenNotSupported();
            }
        }
        address _new;
        try InfraredVaultDeployer.deploy(
            owner(), // admin
            _asset,
            address(this),
            _poolAddress,
            rewardsPrecompile,
            distributionPrecompile,
            _rewardTokens,
            rewardsDuration
        ) returns (address deployedAddress) {
            _new = deployedAddress;
        } catch {
            revert Errors.VaultDeploymentFailed();
        }

        if (_new == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Update pool address to vault if pass in zero address
        if (_poolAddress == address(0)) _poolAddress = _new;
        vaultRegistry[_poolAddress] = IInfraredVault(_new);

        emit NewVault(msg.sender, _poolAddress, _new, _asset, _rewardTokens);

        return IInfraredVault(_new);
    }

    /**
     * @notice Updates the IBGT token.
     * @param _newIbgt address The address of the new IBGT token.
     */
    function updateIbgt(address _newIbgt) external onlyRole(GOVERNANCE_ROLE) {
        if (_newIbgt == address(0)) {
            revert Errors.ZeroAddress();
        }

        emit IBGTUpdated(msg.sender, address(ibgt), _newIbgt);

        ibgt = IERC20Mintable(_newIbgt);
    }

    /**
     * @notice Updates the IBGT vault.
     * @param _newIbgtVault address The address of the new `InfraredVault` contract that will hold IBGT.
     */
    function updateIbgtVault(address _newIbgtVault)
        public
        onlyRole(GOVERNANCE_ROLE)
    {
        if (_newIbgtVault == address(0)) {
            revert Errors.ZeroAddress();
        }

        emit IBGTVaultUpdated(msg.sender, address(ibgtVault), _newIbgtVault);

        ibgtVault = IInfraredVault(_newIbgtVault);
    }

    /**
     * @notice whitelists a reward token
     * @param _token address The address of the token to whitelist.
     * @param _whitelisted bool Whether the token is whitelisted or not.
     */
    function updateWhiteListedRewardTokens(address _token, bool _whitelisted)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        emit WhiteListedRewardTokensUpdated(
            msg.sender, _token, whitelistedRewardTokens[_token], _whitelisted
        );
        whitelistedRewardTokens[_token] = _whitelisted;
    }

    /**
     * @notice Updates the period that rewards will be distributed over in InfraredVaults.
     * @param _rewardsDuration uint256 The new rewards duration.
     */
    function updateRewardsDuration(uint256 _rewardsDuration)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        if (_rewardsDuration == 0) {
            revert Errors.ZeroAmount();
        }
        emit RewardsDurationUpdated(
            msg.sender, rewardsDuration, _rewardsDuration
        );
        rewardsDuration = _rewardsDuration;
    }

    /**
     * @notice Recover ERC20 tokens that were accidentally sent to the contract or where not whitelisted.
     * @param _to     address The address to send the tokens to.
     * @param _token  address The address of the token to recover.
     * @param _amount uint256 The amount of the token to recover.
     */
    function recoverERC20(address _to, address _token, uint256 _amount)
        external
        onlyRole(GOVERNANCE_ROLE)
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

        IERC20Mintable(_token).safeTransfer(_to, _amount);
        emit Recovered(msg.sender, _token, _amount);
    }

    /*//////////////////////////////////////////////////////////////
                            REWARDS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Claims all the rewards for this vault.
     * @param _pool address The address of the pool lp token that the vault is for.
     */
    function harvestVault(address _pool) external onlyRole(KEEPER_ROLE) {
        if (_pool == address(0)) {
            revert Errors.ZeroAddress();
        }

        IInfraredVault vault = vaultRegistry[_pool];
        if (vault == IInfraredVault(address(0))) {
            revert Errors.VaultNotSupported();
        }

        uint256 balanceBefore = getBGTBalance();

        uint256 bgtAmt = vault.claimRewardsPrecompile();

        if (getBGTBalance() - balanceBefore != bgtAmt) {
            revert Errors.BGTBalanceMismatch();
        }

        DataTypes.Token[] memory empty;

        _handleRewards(vault, empty, bgtAmt);

        emit VaultHarvested(msg.sender, _pool, address(vault), bgtAmt);
    }

    /**
     * @notice Claims all the rewards for this validator and supplies them to the IBGT vault.
     * @param _validator address The address of the validator.
     */
    function harvestValidator(address _validator)
        external
        onlyRole(KEEPER_ROLE)
    {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (!isInfraredValidator(_validator)) {
            revert Errors.InvalidValidator();
        }

        uint256 balanceBefore = getBGTBalance();

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) =
            _claimDistr(_validator);

        if (getBGTBalance() - balanceBefore != bgtAmt) {
            revert Errors.BGTBalanceMismatch();
        }

        _handleRewards(ibgtVault, tokens, bgtAmt);

        emit ValidatorHarvested(msg.sender, _validator, tokens, bgtAmt);
    }

    /*//////////////////////////////////////////////////////////////
                            VALIDATORS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Adds validators to the set of `InfraredValidators`.
     * @param _validators address[] memory The addresses of the validators.
     */
    function addValidators(address[] memory _validators)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        for (uint256 i = 0; i < _validators.length; i++) {
            if (_validators[i] == address(0)) {
                revert Errors.ZeroAddress();
            }

            _infraredValidators.add(_validators[i]);
        }

        emit ValidatorsAdded(msg.sender, _validators);
    }

    /**
     * @notice Removes validators from the set of `InfraredValidators`.
     * @param _validators address[] memory The addresses of the validators.
     */
    function removeValidators(address[] memory _validators)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        for (uint256 i = 0; i < _validators.length; i++) {
            if (_validators[i] == address(0)) {
                revert Errors.ZeroAddress();
            }

            if (!isInfraredValidator(_validators[i])) {
                revert Errors.InvalidValidator();
            }

            _infraredValidators.remove(_validators[i]);
        }

        emit ValidatorsRemoved(msg.sender, _validators);
    }

    /**
     * @notice Replaces a validator in the set of `InfraredValidators`.
     * @param _current address The address of the validator to replace.
     * @param _new     address The address of the new validator.
     */
    function replaceValidator(address _current, address _new)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        if (_current == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_new == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (!isInfraredValidator(_current)) {
            revert Errors.InvalidValidator();
        }

        _infraredValidators.replace(_current, _new);

        emit ValidatorReplaced(msg.sender, _current, _new);
    }

    /**
     * @notice Delegate `_amt` of tokens to `_validator`.
     * @param _validator address The validator to delegate to.
     * @param _amt       uint256 The amount of tokens to delegate.
     */
    function delegate(address _validator, uint256 _amt)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }

        if (!isInfraredValidator(_validator)) {
            revert Errors.InvalidValidator();
        }

        bool success =
            ValidatorManagment._delegate(_validator, _amt, stakingPrecompile);
        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        emit Delegated(msg.sender, _validator, _amt);
    }

    /**
     * @notice Undelegate `_amt` of tokens from `_validator`.
     * @param _validator address The validator to undelegate from.
     * @param _amt       uint256 The amount of tokens to undelegate.
     */
    function undelegate(address _validator, uint256 _amt)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }
        if (!isInfraredValidator(_validator)) {
            revert Errors.InvalidValidator();
        }

        bool success =
            ValidatorManagment._undelegate(_validator, _amt, stakingPrecompile);
        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        emit Undelegated(msg.sender, _validator, _amt);
    }

    /**
     * @notice Begin a redelegation from `_from` to `_to`.
     * @param _from address The address of the validator to redelegate from.
     * @param _to   address The address of the validator to redelegate to.
     * @param _amt  uint256 The amount of tokens to redelegate.
     */
    function beginRedelegate(address _from, address _to, uint256 _amt)
        external
        onlyRole(GOVERNANCE_ROLE)
    {
        if (_from == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_to == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }

        if (!isInfraredValidator(_from) || !isInfraredValidator(_to)) {
            revert Errors.InvalidValidator();
        }

        bool success = ValidatorManagment._beginRedelegate(
            _from, _to, _amt, stakingPrecompile
        );
        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        emit RedelegateStarted(msg.sender, _from, _to, _amt);
    }

    /**
     * @notice Cancel an unbonding delegation from `_validator` with `_amt` tokens and `_creationHeight` creation height.
     * @param _validator     address The validator to cancel the unbonding delegation from.
     * @param _amt           uint256 The amount of tokens to cancel the unbonding delegation for.
     * @param _creationHeight int64   The height at which the unbonding delegation was created.
     */
    function cancelUnbondingDelegation(
        address _validator,
        uint256 _amt,
        int64 _creationHeight
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amt == 0) {
            revert Errors.ZeroAmount();
        }

        if (!isInfraredValidator(_validator)) {
            revert Errors.InvalidValidator();
        }

        bool success = ValidatorManagment._cancelUnbondingDelegation(
            _validator, _amt, _creationHeight, stakingPrecompile
        );
        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        emit UnbondingDelegationCancelled(
            msg.sender, _validator, _amt, _creationHeight
        );
    }

    /*//////////////////////////////////////////////////////////////
                            HELPERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Handles the supply of rewards to the vault, both IBGT and other tokens.
     * @param _vault    address                  The address of the vault.
     * @param _tokens   DataTypes.Token[] memory The reward tokens.
     * @param _bgtAmt   uint256                  The amount of BGT to supply.
     */
    function _handleRewards(
        IInfraredVault _vault,
        DataTypes.Token[] memory _tokens,
        uint256 _bgtAmt
    ) internal {
        for (uint256 i = 0; i < _tokens.length; i++) {
            if (!whitelistedRewardTokens[_tokens[i].tokenAddress]) {
                emit RewardTokenNotSupported(_tokens[i].tokenAddress);
                continue; // skip non-whitelisted tokens
            }
            IERC20Mintable(_tokens[i].tokenAddress).safeIncreaseAllowance(
                address(_vault), _tokens[i].amount
            );
            // add reward if not already added
            if (_vault.rewardData(_tokens[i].tokenAddress).rewardsDuration == 0)
            {
                _vault.addReward(_tokens[i].tokenAddress, rewardsDuration);
            }
            _vault.notifyRewardAmount(
                _tokens[i].tokenAddress, _tokens[i].amount
            );

            emit RewardSupplied(
                address(_vault), _tokens[i].tokenAddress, _tokens[i].amount
            );
        }

        if (_bgtAmt > 0) {
            if (_vault.rewardData(address(ibgt)).rewardsDuration == 0) {
                _vault.addReward(address(ibgt), rewardsDuration);
            }
            ibgt.mint(address(this), _bgtAmt);
            ibgt.safeIncreaseAllowance(address(_vault), _bgtAmt);
            _vault.notifyRewardAmount(address(ibgt), _bgtAmt);

            emit IBGTSupplied(address(_vault), _bgtAmt);
        }
    }

    /**
     * @notice Claims the distribution rewards for a validator.
     * @param _validator  address                  The address of the validator.
     * @return _tokens    DataTypes.Token[] memory The reward tokens claimed.
     * @return _bgtAmt    uint256                  The amount of BGT to claimed.
     */
    function _claimDistr(address _validator)
        internal
        returns (DataTypes.Token[] memory _tokens, uint256 _bgtAmt)
    {
        // abstract call to rewards precompile to library
        (_tokens, _bgtAmt) = ValidatorRewards.claimDistrPrecompile(
            _validator,
            ValidatorRewards.PrecompileAddresses(
                erc20BankPrecompile, distributionPrecompile, wbera
            )
        );
    }

    /**
     * @notice Gets the set of infrared validators.
     * @return _validators address[] memory The set of infrared validators.
     */
    function infraredValidators()
        public
        view
        virtual
        returns (address[] memory _validators)
    {
        return _infraredValidators.validators();
    }

    /**
     * @notice Checks if a validator is an infrared validator.
     * @param _validator    address  The validator to check.
     * @return _isValidator bool     Whether the validator is an infrared validator.
     */
    function isInfraredValidator(address _validator)
        public
        view
        returns (bool)
    {
        return _infraredValidators.isValidator(_validator);
    }

    function getBGTBalance() internal view returns (uint256) {
        return bankModulePrecompile.getBalance(address(this), "abgt");
    }
}
