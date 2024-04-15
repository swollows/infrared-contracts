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

    /// @notice The Infrared protocol fee rates for a given token
    /// @dev In units of 1e6 or hundredths of 1 bip
    /// @param token address The token address to charge the protocol fee rate
    function protocolFeeRates(address token) external view returns (uint256);

    /// @notice The unclaimed Infrared protocol fees of token accumulated by contract
    /// @param token address The token address for the accumulated fees
    function protocolFeeAmounts(address token)
        external
        view
        returns (uint256);

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
     * @notice Updates the protocol fee rate charged on harvest
     * @dev Fee rate in units of 1e6 or hundredths of 1 bip
     * @param _token   address The address of the token for the protocol fee rate
     * @param _feeRate uint256 The protocol fee rate to update to
     */
    function updateProtocolFeeRate(address _token, uint256 _feeRate) external;

    /**
     * @notice Claims accumulated protocol fees in contract
     * @param _to     address The recipient of the fees
     * @param _token  address The token to claim fees in
     * @param _amount uint256 The amount of accumulated fees to claim
     */
    function claimProtocolFees(address _to, address _token, uint256 _amount)
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

    /**
     * @notice Emitted when a new vault is registered.
     * @param _sender The address that initiated the vault registration.
     * @param _asset The address of the asset for which the vault is registered.
     * @param _vault The address of the newly created vault.
     * @param _rewardTokens An array of addresses of the reward tokens for the new vault.
     */
    event NewVault(
        address _sender,
        address indexed _asset,
        address indexed _vault,
        address[] _rewardTokens
    );

    /**
     * @notice Emitted when IBGT tokens are supplied to a vault.
     * @param _vault The address of the vault receiving the IBGT tokens.
     * @param _amt The amount of IBGT tokens supplied.
     */
    event IBGTSupplied(address indexed _vault, uint256 _amt);

    /**
     * @notice Emitted when rewards are supplied to a vault.
     * @param _vault The address of the vault receiving the reward.
     * @param _token The address of the token being supplied as a reward.
     * @param _amt The amount of the reward token supplied.
     */
    event RewardSupplied(
        address indexed _vault, address indexed _token, uint256 _amt
    );

    /**
     * @notice Emitted when tokens are recovered from the contract.
     * @param _sender The address that initiated the recovery.
     * @param _token The address of the token being recovered.
     * @param _amount The amount of the token recovered.
     */
    event Recovered(address _sender, address indexed _token, uint256 _amount);

    /**
     * @notice Emitted when a reward token is marked as unsupported.
     * @param _token The address of the reward token.
     */
    event RewardTokenNotSupported(address _token);

    /**
     * @notice Emitted when the IBGT token address is updated.
     * @param _sender The address that initiated the update.
     * @param _oldIbgt The previous address of the IBGT token.
     * @param _newIbgt The new address of the IBGT token.
     */
    event IBGTUpdated(address _sender, address _oldIbgt, address _newIbgt);

    /**
     * @notice Emitted when the IBGT vault address is updated.
     * @param _sender The address that initiated the update.
     * @param _oldIbgtVault The previous address of the IBGT vault.
     * @param _newIbgtVault The new address of the IBGT vault.
     */
    event IBGTVaultUpdated(
        address _sender, address _oldIbgtVault, address _newIbgtVault
    );

    /**
     * @notice Emitted when reward tokens are whitelisted or unwhitelisted.
     * @param _sender The address that initiated the update.
     * @param _token The address of the token being updated.
     * @param _wasWhitelisted The previous whitelist status of the token.
     * @param _isWhitelisted The new whitelist status of the token.
     */
    event WhiteListedRewardTokensUpdated(
        address _sender,
        address indexed _token,
        bool _wasWhitelisted,
        bool _isWhitelisted
    );

    /**
     * @notice Emitted when the rewards duration is updated.
     * @param _sender The address that initiated the update.
     * @param _oldDuration The previous rewards duration.
     * @param _newDuration The new rewards duration.
     */
    event RewardsDurationUpdated(
        address _sender, uint256 _oldDuration, uint256 _newDuration
    );

    /**
     * @notice Emitted when protocol fee rate is updated.
     * @param _sender The address that initiated the update.
     * @param _token The address of the token for the protocol fee rate.
     * @param _oldFeeRate The old protocol fee rate.
     * @param _newFeeRate The new protocol fee rate.
     */
    event ProtocolFeeRateUpdated(
        address _sender,
        address _token,
        uint256 _oldFeeRate,
        uint256 _newFeeRate
    );

    /**
     * @notice Emitted when protocol fees claimed.
     * @param _sender The address that initiated the claim.
     * @param _to The address to send protocol fees to.
     * @param _token The address of the token protocol fees in.
     * @param _amount The amount of protocol fees claimed.
     */
    event ProtocolFeesClaimed(
        address _sender, address _to, address _token, uint256 _amount
    );

    /**
     * @notice Emitted when a vault harvests its rewards.
     * @param _sender The address that initiated the harvest.
     * @param _asset The asset associated with the vault being harvested.
     * @param _vault The address of the vault being harvested.
     * @param _bgtAmt The amount of BGT harvested.
     */
    event VaultHarvested(
        address _sender,
        address indexed _asset,
        address indexed _vault,
        uint256 _bgtAmt
    );

    /**
     * @notice Emitted when a validator harvests its rewards.
     * @param _sender The address that initiated the harvest.
     * @param _validator The public key of the validator.
     * @param _rewards An array of tokens and amounts harvested.
     * @param _bgtAmt The amount of BGT included in the rewards.
     */
    event ValidatorHarvested(
        address _sender,
        bytes indexed _validator,
        DataTypes.Token[] _rewards,
        uint256 _bgtAmt
    );

    /**
     * @notice Emitted when validators are added.
     * @param _sender The address that initiated the addition.
     * @param _validators An array of validators' public keys that were added.
     */
    event ValidatorsAdded(address _sender, bytes[] _validators);

    /**
     * @notice Emitted when validators are removed from validator set.
     * @param _sender The address that initiated the removal.
     * @param _validators An array of validators' public keys that were removed.
     */
    event ValidatorsRemoved(address _sender, bytes[] _validators);

    /**
     * @notice Emitted when a validator is replaced with a new validator.
     * @param _sender The address that initiated the replacement.
     * @param _current The public key of the current validator being replaced.
     * @param _new The public key of the new validator.
     */
    event ValidatorReplaced(address _sender, bytes _current, bytes _new);

    /**
     * @notice Emitted when tokens are delegated to a validator.
     * @param _sender The address that initiated the delegation.
     * @param _validator The public key of the validator to which tokens are delegated.
     * @param _amt The amount of tokens that were delegated.
     */
    event Delegated(address _sender, bytes _validator, uint256 _amt);

    /**
     * @notice Emitted when tokens are undelegated from a validator.
     * @param _sender The address that initiated the undelegation.
     * @param _validator The public key of the validator from which tokens are undelegated.
     * @param _amt The amount of tokens that were undelegated.
     */
    event Undelegated(address _sender, bytes _validator, uint256 _amt);

    /**
     * @notice Emitted when tokens are redelegated from one validator to another.
     * @param _sender The address that initiated the redelegation.
     * @param _from The public key of the validator from which tokens are redelegated.
     * @param _to The public key of the validator to which tokens are redelegated.
     * @param _amt The amount of tokens that were redelegated.
     */
    event Redelegated(address _sender, bytes _from, bytes _to, uint256 _amt);
}
