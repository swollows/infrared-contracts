// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {IBeaconDepositContract} from
    "@berachain/interfaces/IBeaconDepositContract.sol";
import {IBeraChef} from "@berachain/interfaces/IBeraChef.sol";
import {IBerachainRewardsVaultFactory} from
    "@berachain/interfaces/IBerachainRewardsVaultFactory.sol";
import {IWBERA} from "@berachain/interfaces/IWBERA.sol";

import {IIBGT} from "@interfaces/IIBGT.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

import {DataTypes} from "@utils/DataTypes.sol";

interface IInfrared {
    /// @notice The IBGT liquid staked token
    function ibgt() external view returns (IIBGT);

    /// @notice The Infrared governance token
    function ired() external view returns (IERC20);

    /// @notice The Berachain rewards vault factory address
    function rewardsFactory()
        external
        view
        returns (IBerachainRewardsVaultFactory);

    /// @notice The Berachain deposit contract for staking to validators
    function depositor() external view returns (IBeaconDepositContract);

    /// @notice The Berachain chef contract for distributing validator rewards
    function chef() external view returns (IBeraChef);

    /// @notice The IBGT vault
    function ibgtVault() external view returns (IInfraredVault);

    /// @notice Wrapped bera
    function wbera() external view returns (IWBERA);

    /// @notice The rewards duration
    function rewardsDuration() external view returns (uint256);

    /// @notice Initializes Infrared by whitelisting rewards tokens, granting admin access roles, and deploying the ibgt vault
    function initialize(address _admin, uint256 _rewardsDuration) external;

    /**
     * @notice Registers a new vault.
     * @dev Infrared.sol must be admin over MINTER_ROLE on IBGT to grant minter role to deployed vault.
     * @param _asset            address          The address of the asset, e.g. Honey:Bera LP token.
     * @return vault            IInfraredVault   The address of the new `InfraredVault` contract.
     */
    function registerVault(address _asset, address[] memory _rewardTokens)
        external
        returns (IInfraredVault vault);

    /**
     * @notice whitelists a reward token
     * @param _token address The address of the token to whitelist.
     * @param _whitelisted bool Whether the token is whitelisted or not.
     */
    function updateWhiteListedRewardTokens(address _token, bool _whitelisted)
        external;

    /**
     * @notice Updates the period that rewards will be distributed over in InfraredVaults.
     * @param _rewardsDuration uint256 The new rewards duration.
     */
    function updateRewardsDuration(uint256 _rewardsDuration) external;

    /**
     * @notice Pauses staking functionality on this vault.
     * @param _asset address The address of the staking asset that the vault is for.
     */
    function pauseVault(address _asset) external;

    /**
     * @notice Recover ERC20 tokens that were accidentally sent to the contract or where not whitelisted.
     * @param _to     address The address to send the tokens to.
     * @param _token  address The address of the token to recover.
     * @param _amount uint256 The amount of the token to recover.
     */
    function recoverERC20(address _to, address _token, uint256 _amount)
        external;

    /**
     * @notice Claims all the BGT rewards for the vault associated with the given staking token.
     * @param _asset address The address of the staking asset that the vault is for.
     */
    function harvestVault(address _asset) external;

    /**
     * @notice Claims all the token rewards in the contract forwarded from validators.
     * @param _tokens address[] memory The addresses of the tokens to harvest.
     */
    function harvestTokenRewards(address[] memory _tokens) external;

    /**
     * @notice Adds validators to the set of `InfraredValidators`.
     * @param _validators DataTypes.Validator[] memory The validators to add.
     */
    function addValidators(DataTypes.Validator[] memory _validators) external;

    /**
     * @notice Removes validators from the set of `InfraredValidators`.
     * @param _validators DataTypes.Validator[] memory The validators to remove.
     */
    function removeValidators(DataTypes.Validator[] memory _validators)
        external;

    /**
     * @notice Replaces a validator in the set of `InfraredValidators`.
     * @param _current DataTypes.Validator memory The validator to replace.
     * @param _new     DataTypes.Validator memory The new validator.
     */
    function replaceValidator(
        DataTypes.Validator memory _current,
        DataTypes.Validator memory _new
    ) external;

    /**
     * @notice Delegate `_amt` of tokens to `_validator`.
     * @param _pubKey    bytes   The public key of the validator to delegate to.
     * @param _amt       uint256 The amount of tokens to delegate.
     * @param _signature bytes   The signature for deposit contract.
     */
    function delegate(
        bytes calldata _pubKey,
        uint64 _amt,
        bytes calldata _signature
    ) external;

    /**
     * @notice Begin a redelegation from `_from` to `_to`.
     * @param _fromPubKey bytes   The public key of the validator to redelegate from.
     * @param _toPubKey   bytes   The public key of the validator to redelegate to.
     * @param _amt        uint256 The amount of tokens to redelegate.
     */
    function redelegate(
        bytes calldata _fromPubKey,
        bytes calldata _toPubKey,
        uint64 _amt
    ) external;

    /**
     * @notice Queues a new cutting board on BeraChef for reward weight distribution for validator
     * @param _pubKey             bytes                         The public key of the validator to queue for
     * @param _startBlock         uint64                        The start block for reward weightings
     * @param _weights            IBeraChef.Weight[] calldata   The weightings used when distributor calls chef to distribute validator rewards
     */
    function queue(
        bytes calldata _pubKey,
        uint64 _startBlock,
        IBeraChef.Weight[] calldata _weights
    ) external;

    /**
     * @notice Gets the set of infrared validators.
     * @return _validators address[] memory The set of infrared validators.
     */
    function infraredValidators()
        external
        view
        returns (DataTypes.Validator[] memory _validators);

    /**
     * @notice Checks if a validator is an infrared validator.
     * @param _pubKey       bytes    The public key of the validator to check.
     * @return _isValidator bool     Whether the validator is an infrared validator.
     */
    function isInfraredValidator(bytes memory _pubKey)
        external
        view
        returns (bool);

    /**
     * @notice Gets the BGT balance for this contract
     * @return bgtBalance The BGT balance held by this address
     */
    function getBGTBalance() external view returns (uint256 bgtBalance);
}
