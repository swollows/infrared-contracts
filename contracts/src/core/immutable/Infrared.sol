// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External dependencies.
import {AccessControl} from "@openzeppelin/access/AccessControl.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";

// Internal dependencies.
import {ValidatorSet} from "@utils/ValidatorSet.sol";
import {InfraredVaultDeployer} from "@utils/InfraredVaultDeployer.sol";
import {Errors} from "@utils/Errors.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {InfraredValidators} from "./InfraredValidators.sol";
import {IERC20Mintable} from "@interfaces/IERC20Mintable.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";
import {IUpgradableRewardsHandler} from
    "@interfaces/IUpgradableRewardsHandler.sol";

/**
 * @title Infrared
 * @dev A contract for managing the set of infrared validators, infrared vaults, and interacting with the rewards handler.
 * @dev This contract is the main entry point for interacting with the Infrared protocol.
 * @dev It is an immutable contract that interacts with the upgradable rewards handler and staking handler. These contracts are upgradable by governance (app + chain), main reason is that they could change with a chain upgrade.
 */
contract Infrared is InfraredValidators, AccessControl {
    using ValidatorSet for EnumerableSet.AddressSet;
    using SafeERC20 for IERC20Mintable;

    /*//////////////////////////////////////////////////////////////
                           STORAGE/EVENTS
    //////////////////////////////////////////////////////////////*/

    // Access control constants.
    bytes32 public constant KEEPER_ROLE = keccak256("KEEPER_ROLE");
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    // Upgradable contract used to interact with the Berachain precompiled contracts.
    // These are upgradable by governance (app + chain), main reason is that they could change with a chain upgrade.
    IUpgradableRewardsHandler public immutable UPGRADABLE_REWARDS_HANDLER;

    // Mapping of pool address to `IInfraredVault`.
    mapping(address _poolAddress => IInfraredVault _vault) public vaultRegistry;

    // The IBGT Liquid staked token.
    IERC20Mintable public ibgt;

    // The IBGT vault.
    IInfraredVault public ibgtVault;

    event NewVault(address indexed _pool, address indexed _vault);

    event IBGTSupplied(address indexed _vault, uint256 _amt);

    event RewardSupplied(
        address indexed _vault, address indexed _token, uint256 _amt
    );

    /*//////////////////////////////////////////////////////////////
                    CONSTRUCTOR/INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Constructor for the Infrared contract.
     * @param _upgradableRewardsHandler address The address of the upgradable rewards handler.
     * @param _upgradableStakingHandler address The address of the upgradable staking handler.
     * @param _admin                    address The address of the admin.
     * @param _ibgt                     address The address of the IBGT token.
     */
    constructor(
        address _upgradableRewardsHandler,
        address _upgradableStakingHandler,
        address _admin,
        address _ibgt
    ) InfraredValidators(_upgradableStakingHandler) {
        if (_upgradableRewardsHandler == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_upgradableStakingHandler == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_admin == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_ibgt == address(0)) {
            revert Errors.ZeroAddress();
        }

        UPGRADABLE_REWARDS_HANDLER =
            IUpgradableRewardsHandler(_upgradableRewardsHandler);

        _grantRole(DEFAULT_ADMIN_ROLE, _admin);

        _grantRole(KEEPER_ROLE, _admin);

        ibgt = IERC20Mintable(_ibgt);
    }

    /*//////////////////////////////////////////////////////////////
                        VAULT REGISTRY
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Registers a new vault.
     * @param _asset            address          The address of the asset, e.g. Honey:Bera LP token.
     * @param _name             string    memory The name of the vault.
     * @param _symbol           string    memory The symbol of the vault.
     * @param _rewardTokens     address[] memory The reward tokens for the vault.
     * @param _poolAddress      address          The address of the pool.
     * @return _new             IInfraredVault   The address of the new `InfraredVault` contract.
     */
    function registerVault(
        address _asset,
        string memory _name,
        string memory _symbol,
        address[] memory _rewardTokens, // @red - dont we enfroce in claimRewardsPrecompile that rewards can only be abgt?
        address _poolAddress
    ) public onlyRole(KEEPER_ROLE) returns (IInfraredVault) {
        // Check for duplicate pool address
        if (vaultRegistry[_poolAddress] != IInfraredVault(address(0))) {
            revert Errors.DuplicatePoolAddress();
        }

        address _new;
        try InfraredVaultDeployer.deploy(
            _asset,
            _name,
            _symbol,
            _rewardTokens,
            address(this),
            _poolAddress,
            address(UPGRADABLE_REWARDS_HANDLER),
            address(this)
        ) returns (address deployedAddress) {
            _new = deployedAddress;
            IInfraredVault(deployedAddress).changeWithdrawAddress(address(this));
        } catch {
            revert Errors.VaultDeploymentFailed();
        }

        if (_new == address(0)) {
            revert Errors.ZeroAddress();
        }

        vaultRegistry[_poolAddress] = IInfraredVault(_new);

        emit NewVault(_poolAddress, _new);

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

        ibgtVault = IInfraredVault(_newIbgtVault);
    }

    function updateInfraredVaultWithdrawAddress(
        address _redVault,
        address _newWithdrawAddress
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (_newWithdrawAddress == address(0) || _redVault == address(0)) {
            revert Errors.ZeroAddress();
        }

        IInfraredVault(_redVault).changeWithdrawAddress(address(this));
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

        uint256 bgtAmt = vault.claimRewardsPrecompile();

        DataTypes.Token[] memory empty;

        _handleRewards(vault, empty, bgtAmt);
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

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) =
            _claimDistr(_validator);

        _handleRewards(ibgtVault, tokens, bgtAmt);
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

            _infraredValidators.remove(_validators[i]);
        }
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

        _infraredValidators.replace(_current, _new);
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

        bool success = _delegate(_validator, _amt);
        if (!success) {
            revert Errors.DelegateCallFailed();
        }
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

        bool success = _undelegate(_validator, _amt);
        if (!success) {
            revert Errors.DelegateCallFailed();
        }
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

        bool success = _beginRedelegate(_from, _to, _amt);
        if (!success) {
            revert Errors.DelegateCallFailed();
        }
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

        bool success =
            _cancelUnbondingDelegation(_validator, _amt, _creationHeight);
        if (!success) {
            revert Errors.DelegateCallFailed();
        }
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
            IERC20Mintable(_tokens[i].tokenAddress).safeIncreaseAllowance(
                address(_vault), _tokens[i].amount
            );
            _vault.supply(
                address(this), _tokens[i].tokenAddress, _tokens[i].amount
            );

            emit RewardSupplied(
                address(_vault), _tokens[i].tokenAddress, _tokens[i].amount
            );
        }

        if (_bgtAmt > 0) {
            ibgt.mint(address(this), _bgtAmt);
            ibgt.safeIncreaseAllowance(address(_vault), _bgtAmt);
            _vault.supply(address(this), address(ibgt), _bgtAmt);

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
        (bool success, bytes memory data) = address(UPGRADABLE_REWARDS_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_REWARDS_HANDLER.claimDistrPrecompile.selector,
                _validator,
                address(UPGRADABLE_REWARDS_HANDLER)
            )
        );

        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        return abi.decode(data, (DataTypes.Token[], uint256));
    }
}
