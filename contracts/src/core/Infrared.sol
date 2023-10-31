// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {BerachainHandler} from './BerachainHandler.sol';
import {InfraredValidators} from './InfraredValidators.sol';
import {AccessControl} from '@openzeppelin/access/AccessControl.sol';
import {Errors} from '@utils/Errors.sol';
import {ValidatorSet} from '@utils/ValidatorSet.sol';
import {EnumerableSet} from '@openzeppelin/utils/structs/EnumerableSet.sol';
import {DataTypes} from '@utils/DataTypes.sol';
import {Cosmos} from '@polaris/CosmosTypes.sol';
import {IInfraredVault} from '@interfaces/IInfraredVault.sol';
import {InfraredVaultDeployer} from '@utils/InfraredVaultDeployer.sol';
import {IERC20Mintable} from '@interfaces/IERC20Mintable.sol';
import {SafeERC20} from '@openzeppelin/token/ERC20/utils/SafeERC20.sol';

/**
 * The main infrared contract.
 */
contract Infrared is BerachainHandler, InfraredValidators, AccessControl {
    // Library for dealing with the validator set data structure.
    using ValidatorSet for EnumerableSet.AddressSet;
    // Library for dealing with ERC20's safly.
    using SafeERC20 for IERC20Mintable;

    // Access control constants.
    bytes32 public constant KEEPER_ROLE = keccak256('KEEPER_ROLE');
    bytes32 public constant GOVERNANCE_ROLE = keccak256('GOVERNANCE_ROLE');

    // A registry of all vaults.
    mapping(address _vaultAddress => IInfraredVault _vault) public vaultRegistry;

    // The IBT token.
    IERC20Mintable public ibgt;

    // The Wrapped IBGT Vault.
    IInfraredVault public wrappedIBGTVault;

    /*//////////////////////////////////////////////////////////////
                        EVENTS
    //////////////////////////////////////////////////////////////*/

    event NewVault(address indexed _vault, address indexed _pool);

    event NewWrappedIBGTVault(address indexed _vault);

    event NewValidator(address indexed _validator);

    event ValidatorRemoved(address indexed _validator);

    event ValidatorReplaced(address indexed _current, address indexed _new);

    event RewardsSupplied(address indexed _vault, DataTypes.Token[] _rewardTokens);

    event IBGTSupplied(address indexed _vault, uint256 _amount);

    /*//////////////////////////////////////////////////////////////
                        CONSTRUCTOR/INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/
    constructor(
        address _rewardsPrecompileAddress,
        address _distributionPrecompileAddress,
        address _erc20PrecompileAddress,
        address _stakingPrecompileAddress,
        string memory _bgtDenom,
        address _admin,
        IERC20Mintable _ibgt
    )
        BerachainHandler(_rewardsPrecompileAddress, _distributionPrecompileAddress, _erc20PrecompileAddress, _bgtDenom)
        InfraredValidators(_stakingPrecompileAddress)
    {
        if (_admin == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (address(_ibgt) == address(0)) {
            revert Errors.ZeroAddress();
        }

        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        ibgt = _ibgt;
    }

    /*//////////////////////////////////////////////////////////////
                       Vault Registry
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Registers a new vault.
     * @param _asset         ERC20               The underlying asset.
     * @param _name          string              The name of the vault token.
     * @param _symbol        string              The symbol of the vault token.
     * @param _rewardTokens  address[]           The reward tokens.
     * @param _poolAddress   address             The address of the pool (dex/lending..etc) that this contract is representing.
     * @return _newVault     IInfraredVault       The newly created vault.
     */
    function registerVault(
        address _asset,
        string memory _name,
        string memory _symbol,
        address[] memory _rewardTokens,
        address _poolAddress
    ) external onlyRole(KEEPER_ROLE) returns (IInfraredVault) {
        // Deploy the new vault.
        address _newVault = InfraredVaultDeployer.deployInfraredVault(
            _asset,
            _name,
            _symbol,
            _rewardTokens,
            address(this),
            _poolAddress,
            REWARDS_PRECOMPILE,
            DISTRIBUTION_PRECOMPILE,
            address(this)
        );
        // // Add the vault to the registry.
        vaultRegistry[_newVault] = IInfraredVault(_newVault);

        emit NewVault(_newVault, _poolAddress);

        // Approve the reward tokens to the vault.
        _approveRewardTokens(_newVault, _rewardTokens);

        return IInfraredVault(_newVault);
    }

    /**
     * @notice Registers a new wrapped IBGT vault.
     * @param _new IInfraredVault The new vault.
     * @param _rewardTokens address[] The reward tokens.
     */
    function updateWIBGTVault(IInfraredVault _new, address[] memory _rewardTokens) external onlyRole(GOVERNANCE_ROLE) {
        if (address(_new) == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Approve the reward tokens to the vault.
        _approveRewardTokens(address(_new), _rewardTokens);

        wrappedIBGTVault = _new;

        emit NewWrappedIBGTVault(address(_new));
    }

    /**
     * @notice Checks if the given address is a registered vault.
     * @param  _vault   address The vault to check.
     * @return _isVault bool    Whether or not the given address is a registered vault.
     */
    function isInfraredVault(address _vault) public view returns (bool _isVault) {
        return address(vaultRegistry[_vault]) != address(0);
    }

    /*//////////////////////////////////////////////////////////////
                   Validator Set 
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Add a validator to the validators set.
     * @param  _validators  address[] calldata  New validators to be added.
     */
    function addValidators(address[] calldata _validators) external onlyRole(GOVERNANCE_ROLE) {
        for (uint256 _i; _i < _validators.length; ) {
            if (_validators[_i] == address(0)) {
                revert Errors.ZeroAddress();
            }

            // Add the validator to the set.
            _infraredValidatorsSet.addValidator(_validators[_i]);

            emit NewValidator(_validators[_i]);

            // Iteration is safe here.
            unchecked {
                ++_i;
            }
        }
    }

    /**
     * @notice Remove validators from the validators set.
     * @param  _validators  address[] calldata  Validators to be removed.
     */
    function removeValidators(address[] calldata _validators) external onlyRole(GOVERNANCE_ROLE) {
        for (uint256 _i; _i < _validators.length; ) {
            if (_validators[_i] == address(0)) {
                revert Errors.ZeroAddress();
            }

            // Remove the validator from the set.
            _infraredValidatorsSet.removeValidator(_validators[_i]);

            emit ValidatorRemoved(_validators[_i]);

            // Iteration is safe here.
            unchecked {
                ++_i;
            }
        }
    }

    /**
     * @notice Replace a validator in the validators set.
     * @param  _current  address  The current validator to be replaced.
     * @param  _new      address  The new validator.
     */
    function replaceValidator(address _current, address _new) external onlyRole(GOVERNANCE_ROLE) {
        _infraredValidatorsSet.replaceValidator(_current, _new);

        emit ValidatorReplaced(_current, _new);
    }

    /**
     * @notice Delegates tokens to a validator.
     * @notice The validator must be in the set of validators chosen by governance.
     * @param _validator  address  The validator to delegate to.
     * @param _amount     uint256  The amount of tokens to delegate.
     */
    function delegate(address _validator, uint256 _amount) external onlyRole(KEEPER_ROLE) {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amount == 0) {
            revert Errors.ZeroAmount();
        }

        bool _success = _delegate(_validator, _amount);

        if (!_success) {
            revert Errors.DelegationFailed();
        }
    }

    /**
     * @notice Undelegates tokens from a validator.
     * @notice The validator must be in the set of validators chosen by governance.
     * @param _validator  address  The validator to undelegate from.
     * @param _amount     uint256  The amount of tokens to undelegate.
     */
    function undelegate(address _validator, uint256 _amount) external onlyRole(GOVERNANCE_ROLE) {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amount == 0) {
            revert Errors.ZeroAmount();
        }

        bool _success = _undelegate(_validator, _amount);

        if (!_success) {
            revert Errors.UndelegateFailed();
        }
    }

    /**
     * @notice Begins a redelegation from one validator to another.
     * @notice Both validator must be in the set of validators chosen by governance.
     * @param _from     address  The validator to redelegate from.
     * @param _to       address  The validator to redelegate to.
     * @param _amount   uint256  The amount of tokens to redelegate.
     */
    function beginRedelegate(address _from, address _to, uint256 _amount) external onlyRole(GOVERNANCE_ROLE) {
        if (_from == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_to == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amount == 0) {
            revert Errors.ZeroAmount();
        }

        bool _success = _beginRedelegate(_from, _to, _amount);

        if (!_success) {
            revert Errors.BeginRedelegateFailed();
        }
    }

    /**
     * @notice Cancels an unbonding delegation.
     * @notice The validator must be in the set of validators chosen by governance.
     * @param _validator      address  The validator to cancel the unbonding delegation for.
     * @param _amount         uint256  The amount of tokens to cancel the unbonding delegation for.
     * @param _creationHeigh  int64    The creation height of the unbonding delegation.
     */
    function cancelUnbondingDelegation(
        address _validator,
        uint256 _amount,
        int64 _creationHeigh
    ) external onlyRole(GOVERNANCE_ROLE) {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_amount == 0) {
            revert Errors.ZeroAmount();
        }

        if (_creationHeigh == 0) {
            revert Errors.ZeroAmount();
        }

        bool _success = _cancelUnbondingDelegation(_validator, _amount, _creationHeigh);

        if (!_success) {
            revert Errors.CancelUnbondingDelegationFailed();
        }
    }

    /*//////////////////////////////////////////////////////////////
                  Reward Distribution 
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Distributes the rewards for the given validator, the rewards are then supplied to the wrapped ibgt vault.
     * @param _validator address  The validator to distribute rewards for.
     */
    function harvestValidator(address _validator) external {
        if (_validator == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (!isInfraredValidator(_validator)) {
            revert Errors.ValidatorDoesNotExist(_validator);
        }

        // Withdraw the rewards from the distribution module.
        (Cosmos.Coin[] memory _rewards, uint256 _bgtAmount) = _withdrawDistributionRewards(_validator);

        // Handle the rewards.
        _handleRewards(_rewards, _bgtAmount, wrappedIBGTVault);
    }

    /**
     * @notice Distributes the rewards for the given vault, the rewards are then supplied to the vault.
     * @param _vaultAddress address  The vault to distribute rewards for.
     */
    function harvestVault(address _vaultAddress) external {
        if (_vaultAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Load the vault from storage to save on SLOAD.
        IInfraredVault _vault = vaultRegistry[_vaultAddress];
        if (_vault == IInfraredVault(address(0))) {
            revert Errors.VaultNotSupported(_vaultAddress);
        }

        // Withdraw the rewards from the rewards module.
        (Cosmos.Coin[] memory _rewards, uint256 _bgtAmount) = _withdrawRewards(_vaultAddress, _vault.poolAddress());

        // Handle the rewards.
        _handleRewards(_rewards, _bgtAmount, _vault);
    }

    /*//////////////////////////////////////////////////////////////
                       Internal Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Max approves the reward tokens to be used by the vault.
     * @notice This shoud be safe as this contract will hold no funds other than the BGT that is non-transferable.
     * @notice Zero address checked by safeApprove.
     * @param _vault         address        The vault to approve the reward tokens for.
     * @param _rewardTokens  address[]            The reward tokens to approve.
     */
    function _approveRewardTokens(address _vault, address[] memory _rewardTokens) internal {
        for (uint256 _i; _i < _rewardTokens.length; ) {
            // Approve the reward token to the vault.
            IERC20Mintable(_rewardTokens[_i]).safeIncreaseAllowance(
                _vault,
                type(uint256).max - IERC20Mintable(_rewardTokens[_i]).allowance(address(this), _vault)
            );

            // Iteration is safe here.
            unchecked {
                ++_i;
            }
        }
    }

    /**
     * @notice Handles the rewards for the given vault.
     * @param _rewards   Cosmos.Coin[] memory The rewards to handle.
     * @param _bgtAmount uint256              The amount of BGT to handle.
     * @param _vault     IInfraredVault        The vault to handle the rewards for.
     */
    function _handleRewards(Cosmos.Coin[] memory _rewards, uint256 _bgtAmount, IInfraredVault _vault) internal {
        // If there are no rewards to supply then return.
        if (_rewards.length == 0 && _bgtAmount == 0) {
            return;
        }

        // If there are rewards to supply then convert them to ERC20 tokens.
        if (_rewards.length > 0) {
            // Parse the tokens to ERC20's.
            DataTypes.Token[] memory _tokens = _parseCoins(_rewards);

            // Convert the tokens to ERC20's.
            _convertCoins(_rewards);

            // Supply the tokens to the vault.
            _supply(_vault, _tokens);
        }

        // If there is BGT to supply then mint and supply it.
        if (_bgtAmount > 0) {
            IERC20Mintable _ibgt = ibgt; // Save on SLOAD.

            // Mint the BGT.
            _ibgt.mint(address(this), _bgtAmount);

            // Supply the BGT to the vault.
            _vault.supply(address(this), address(_ibgt), _bgtAmount);

            emit IBGTSupplied(address(_vault), _bgtAmount);
        }
    }

    /**
     * @notice Withdraws the rewards for the given vault from the rewards module.
     * @param _vault                 address              The vault to withdraw rewards for.
     * @param _pool                  address              The pool address to withdraw rewards for.
     * @return _filteredRewards      Cosmos.Coin[] memory The coins that were withdrawn excluding BGT.
     * @return _bgtAmount            uint256              The amount of BGT that was withdrawn.
     */
    function _withdrawRewards(
        address _vault,
        address _pool
    ) internal returns (Cosmos.Coin[] memory _filteredRewards, uint256 _bgtAmount) {
        // Withdraw rewards from the rewards module.
        Cosmos.Coin[] memory _rewards = _withdrawPOLRewards(_vault, _pool);

        // Remove BGT from the rewards since we don't want to distribute it.
        return _removeBGTFromCoins(_rewards);
    }

    /**
     * @notice Withdraws the rewards for the given validator from the distribution module.
     * @param  _validator            address              The validator to withdraw rewards for.
     * @return _filteredRewards      Cosmos.Coin[] memory The coins that were withdrawn excluding BGT.
     * @return _bgtAmount            uint256              The amount of BGT that was withdrawn.
     */
    function _withdrawDistributionRewards(
        address _validator
    ) internal returns (Cosmos.Coin[] memory _filteredRewards, uint256 _bgtAmount) {
        // Withdraw rewards from the distribution module.
        Cosmos.Coin[] memory _rewards = _withdrawDistrRewards(_validator);

        // Remove BGT from the rewards since we don't want to distribute it.
        return _removeBGTFromCoins(_rewards);
    }

    /**
     * @notice Supplies Tokens to the given vault.
     * @param _vault     IInfraredVault            The vault to supply the tokens to.
     * @param _rewards   DataTypes.Token[] memory The tokens to supply.
     */
    function _supply(IInfraredVault _vault, DataTypes.Token[] memory _rewards) internal {
        for (uint256 _i; _i < _rewards.length; ) {
            // Supply the token to the vault.
            _vault.supply(address(this), _rewards[_i].tokenAddress, _rewards[_i].amount);

            // Safe here.
            unchecked {
                ++_i;
            }
        }

        emit RewardsSupplied(address(_vault), _rewards);
    }
}
