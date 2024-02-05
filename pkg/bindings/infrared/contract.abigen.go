// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package infrared

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
	_ = abi.ConvertType
)

// ContractMetaData contains all meta data concerning the Contract contract.
var ContractMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"DEFAULT_ADMIN_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"GOVERNANCE_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"KEEPER_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"UPGRADE_INTERFACE_VERSION\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"addValidators\",\"inputs\":[{\"name\":\"_validators\",\"type\":\"address[]\",\"internalType\":\"address[]\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"bankModulePrecompile\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"contractIBankModule\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"beginRedelegate\",\"inputs\":[{\"name\":\"_from\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"cancelUnbondingDelegation\",\"inputs\":[{\"name\":\"_validator\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"_creationHeight\",\"type\":\"int64\",\"internalType\":\"int64\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"currentImplementation\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"delegate\",\"inputs\":[{\"name\":\"_validator\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"distributionPrecompile\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"erc20BankPrecompile\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getRoleAdmin\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"grantRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"harvestValidator\",\"inputs\":[{\"name\":\"_validator\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"harvestVault\",\"inputs\":[{\"name\":\"_pool\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"hasRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"ibgt\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"contractIERC20Mintable\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"ibgtVault\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"contractIInfraredVault\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"infraredValidators\",\"inputs\":[],\"outputs\":[{\"name\":\"_validators\",\"type\":\"address[]\",\"internalType\":\"address[]\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"initialize\",\"inputs\":[{\"name\":\"_admin\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_ibgt\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_erc20BankPrecompile\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_distributionPrecompile\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_wbera\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_stakingPrecompile\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_rewardsPrecompile\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_ired\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_rewardsDuration\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"_bankModulePrecompile\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"ired\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"contractIERC20Mintable\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"isInfraredValidator\",\"inputs\":[{\"name\":\"_validator\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"owner\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"proxiableUUID\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"recoverERC20\",\"inputs\":[{\"name\":\"_to\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"registerVault\",\"inputs\":[{\"name\":\"_asset\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_rewardTokens\",\"type\":\"address[]\",\"internalType\":\"address[]\"},{\"name\":\"_poolAddress\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"contractIInfraredVault\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"removeValidators\",\"inputs\":[{\"name\":\"_validators\",\"type\":\"address[]\",\"internalType\":\"address[]\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"renounceOwnership\",\"inputs\":[],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"renounceRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"callerConfirmation\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"replaceValidator\",\"inputs\":[{\"name\":\"_current\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_new\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"revokeRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"rewardsDuration\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"rewardsPrecompile\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"stakingPrecompile\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"supportsInterface\",\"inputs\":[{\"name\":\"interfaceId\",\"type\":\"bytes4\",\"internalType\":\"bytes4\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"transferOwnership\",\"inputs\":[{\"name\":\"newOwner\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"undelegate\",\"inputs\":[{\"name\":\"_validator\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"updateIbgt\",\"inputs\":[{\"name\":\"_newIbgt\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"updateIbgtVault\",\"inputs\":[{\"name\":\"_newIbgtVault\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"updateRewardsDuration\",\"inputs\":[{\"name\":\"_rewardsDuration\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"updateWhiteListedRewardTokens\",\"inputs\":[{\"name\":\"_token\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"_whitelisted\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"upgradeToAndCall\",\"inputs\":[{\"name\":\"newImplementation\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"payable\"},{\"type\":\"function\",\"name\":\"vaultRegistry\",\"inputs\":[{\"name\":\"_poolAddress\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"_vault\",\"type\":\"address\",\"internalType\":\"contractIInfraredVault\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"wbera\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"whitelistedRewardTokens\",\"inputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"event\",\"name\":\"Delegated\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_validator\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"IBGTSupplied\",\"inputs\":[{\"name\":\"_vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"IBGTUpdated\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_oldIbgt\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_newIbgt\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"IBGTVaultUpdated\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_oldIbgtVault\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_newIbgtVault\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Initialized\",\"inputs\":[{\"name\":\"version\",\"type\":\"uint64\",\"indexed\":false,\"internalType\":\"uint64\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"NewVault\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_pool\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_asset\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_rewardTokens\",\"type\":\"address[]\",\"indexed\":false,\"internalType\":\"address[]\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"OwnershipTransferred\",\"inputs\":[{\"name\":\"previousOwner\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"newOwner\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Recovered\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_amount\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RedelegateStarted\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_from\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_to\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RewardSupplied\",\"inputs\":[{\"name\":\"_vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RewardTokenNotSupported\",\"inputs\":[{\"name\":\"_token\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RewardsDurationUpdated\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_oldDuration\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"_newDuration\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleAdminChanged\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"previousAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"newAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleGranted\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleRevoked\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"UnbondingDelegationCancelled\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_validator\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"},{\"name\":\"_creationHeight\",\"type\":\"int64\",\"indexed\":false,\"internalType\":\"int64\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Undelegated\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_validator\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_amt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"Upgraded\",\"inputs\":[{\"name\":\"implementation\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ValidatorHarvested\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_validator\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_bgtAmt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ValidatorReplaced\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_current\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_new\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ValidatorSetUpdated\",\"inputs\":[{\"name\":\"_old\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_new\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_action\",\"type\":\"uint8\",\"indexed\":false,\"internalType\":\"enumDataTypes.ValidatorSetAction\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ValidatorsAdded\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_validators\",\"type\":\"address[]\",\"indexed\":false,\"internalType\":\"address[]\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"ValidatorsRemoved\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_validators\",\"type\":\"address[]\",\"indexed\":false,\"internalType\":\"address[]\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"VaultHarvested\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_pool\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_vault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_bgtAmt\",\"type\":\"uint256\",\"indexed\":false,\"internalType\":\"uint256\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"VaultWithdrawAddressUpdated\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_redVault\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_newWithdrawAddress\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"WhiteListedRewardTokensUpdated\",\"inputs\":[{\"name\":\"_sender\",\"type\":\"address\",\"indexed\":false,\"internalType\":\"address\"},{\"name\":\"_token\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"_wasWhitelisted\",\"type\":\"bool\",\"indexed\":false,\"internalType\":\"bool\"},{\"name\":\"_isWhitelisted\",\"type\":\"bool\",\"indexed\":false,\"internalType\":\"bool\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"AccessControlBadConfirmation\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AccessControlUnauthorizedAccount\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"neededRole\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AddressEmptyCode\",\"inputs\":[{\"name\":\"target\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"AddressInsufficientBalance\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"BGTBalanceMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"DelegateCallFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"DuplicatePoolAddress\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ERC1967InvalidImplementation\",\"inputs\":[{\"name\":\"implementation\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"ERC1967NonPayable\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"FailedInnerCall\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"FailedToAddValidator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"FailedToRemoveValidator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidInitialization\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidValidator\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotInitializing\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"OwnableInvalidOwner\",\"inputs\":[{\"name\":\"owner\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"OwnableUnauthorizedAccount\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"RewardTokenNotSupported\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"SafeERC20FailedOperation\",\"inputs\":[{\"name\":\"token\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"UUPSUnauthorizedCallContext\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UUPSUnsupportedProxiableUUID\",\"inputs\":[{\"name\":\"slot\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"ValidatorAlreadyExists\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ValidatorDoesNotExist\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"VaultDeploymentFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"VaultNotSupported\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ZeroAddress\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ZeroAmount\",\"inputs\":[]}]",
}

// ContractABI is the input ABI used to generate the binding from.
// Deprecated: Use ContractMetaData.ABI instead.
var ContractABI = ContractMetaData.ABI

// Contract is an auto generated Go binding around an Ethereum contract.
type Contract struct {
	ContractCaller     // Read-only binding to the contract
	ContractTransactor // Write-only binding to the contract
	ContractFilterer   // Log filterer for contract events
}

// ContractCaller is an auto generated read-only Go binding around an Ethereum contract.
type ContractCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ContractTransactor is an auto generated write-only Go binding around an Ethereum contract.
type ContractTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ContractFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type ContractFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// ContractSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type ContractSession struct {
	Contract     *Contract         // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// ContractCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type ContractCallerSession struct {
	Contract *ContractCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts   // Call options to use throughout this session
}

// ContractTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type ContractTransactorSession struct {
	Contract     *ContractTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// ContractRaw is an auto generated low-level Go binding around an Ethereum contract.
type ContractRaw struct {
	Contract *Contract // Generic contract binding to access the raw methods on
}

// ContractCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type ContractCallerRaw struct {
	Contract *ContractCaller // Generic read-only contract binding to access the raw methods on
}

// ContractTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type ContractTransactorRaw struct {
	Contract *ContractTransactor // Generic write-only contract binding to access the raw methods on
}

// NewContract creates a new instance of Contract, bound to a specific deployed contract.
func NewContract(address common.Address, backend bind.ContractBackend) (*Contract, error) {
	contract, err := bindContract(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Contract{ContractCaller: ContractCaller{contract: contract}, ContractTransactor: ContractTransactor{contract: contract}, ContractFilterer: ContractFilterer{contract: contract}}, nil
}

// NewContractCaller creates a new read-only instance of Contract, bound to a specific deployed contract.
func NewContractCaller(address common.Address, caller bind.ContractCaller) (*ContractCaller, error) {
	contract, err := bindContract(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &ContractCaller{contract: contract}, nil
}

// NewContractTransactor creates a new write-only instance of Contract, bound to a specific deployed contract.
func NewContractTransactor(address common.Address, transactor bind.ContractTransactor) (*ContractTransactor, error) {
	contract, err := bindContract(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &ContractTransactor{contract: contract}, nil
}

// NewContractFilterer creates a new log filterer instance of Contract, bound to a specific deployed contract.
func NewContractFilterer(address common.Address, filterer bind.ContractFilterer) (*ContractFilterer, error) {
	contract, err := bindContract(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &ContractFilterer{contract: contract}, nil
}

// bindContract binds a generic wrapper to an already deployed contract.
func bindContract(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := ContractMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Contract *ContractRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Contract.Contract.ContractCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Contract *ContractRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Contract.Contract.ContractTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Contract *ContractRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Contract.Contract.ContractTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Contract *ContractCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Contract.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Contract *ContractTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Contract.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Contract *ContractTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Contract.Contract.contract.Transact(opts, method, params...)
}

// DEFAULTADMINROLE is a free data retrieval call binding the contract method 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (_Contract *ContractCaller) DEFAULTADMINROLE(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "DEFAULT_ADMIN_ROLE")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// DEFAULTADMINROLE is a free data retrieval call binding the contract method 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (_Contract *ContractSession) DEFAULTADMINROLE() ([32]byte, error) {
	return _Contract.Contract.DEFAULTADMINROLE(&_Contract.CallOpts)
}

// DEFAULTADMINROLE is a free data retrieval call binding the contract method 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (_Contract *ContractCallerSession) DEFAULTADMINROLE() ([32]byte, error) {
	return _Contract.Contract.DEFAULTADMINROLE(&_Contract.CallOpts)
}

// GOVERNANCEROLE is a free data retrieval call binding the contract method 0xf36c8f5c.
//
// Solidity: function GOVERNANCE_ROLE() view returns(bytes32)
func (_Contract *ContractCaller) GOVERNANCEROLE(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "GOVERNANCE_ROLE")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// GOVERNANCEROLE is a free data retrieval call binding the contract method 0xf36c8f5c.
//
// Solidity: function GOVERNANCE_ROLE() view returns(bytes32)
func (_Contract *ContractSession) GOVERNANCEROLE() ([32]byte, error) {
	return _Contract.Contract.GOVERNANCEROLE(&_Contract.CallOpts)
}

// GOVERNANCEROLE is a free data retrieval call binding the contract method 0xf36c8f5c.
//
// Solidity: function GOVERNANCE_ROLE() view returns(bytes32)
func (_Contract *ContractCallerSession) GOVERNANCEROLE() ([32]byte, error) {
	return _Contract.Contract.GOVERNANCEROLE(&_Contract.CallOpts)
}

// KEEPERROLE is a free data retrieval call binding the contract method 0x364bc15a.
//
// Solidity: function KEEPER_ROLE() view returns(bytes32)
func (_Contract *ContractCaller) KEEPERROLE(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "KEEPER_ROLE")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// KEEPERROLE is a free data retrieval call binding the contract method 0x364bc15a.
//
// Solidity: function KEEPER_ROLE() view returns(bytes32)
func (_Contract *ContractSession) KEEPERROLE() ([32]byte, error) {
	return _Contract.Contract.KEEPERROLE(&_Contract.CallOpts)
}

// KEEPERROLE is a free data retrieval call binding the contract method 0x364bc15a.
//
// Solidity: function KEEPER_ROLE() view returns(bytes32)
func (_Contract *ContractCallerSession) KEEPERROLE() ([32]byte, error) {
	return _Contract.Contract.KEEPERROLE(&_Contract.CallOpts)
}

// UPGRADEINTERFACEVERSION is a free data retrieval call binding the contract method 0xad3cb1cc.
//
// Solidity: function UPGRADE_INTERFACE_VERSION() view returns(string)
func (_Contract *ContractCaller) UPGRADEINTERFACEVERSION(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "UPGRADE_INTERFACE_VERSION")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// UPGRADEINTERFACEVERSION is a free data retrieval call binding the contract method 0xad3cb1cc.
//
// Solidity: function UPGRADE_INTERFACE_VERSION() view returns(string)
func (_Contract *ContractSession) UPGRADEINTERFACEVERSION() (string, error) {
	return _Contract.Contract.UPGRADEINTERFACEVERSION(&_Contract.CallOpts)
}

// UPGRADEINTERFACEVERSION is a free data retrieval call binding the contract method 0xad3cb1cc.
//
// Solidity: function UPGRADE_INTERFACE_VERSION() view returns(string)
func (_Contract *ContractCallerSession) UPGRADEINTERFACEVERSION() (string, error) {
	return _Contract.Contract.UPGRADEINTERFACEVERSION(&_Contract.CallOpts)
}

// BankModulePrecompile is a free data retrieval call binding the contract method 0x7904b623.
//
// Solidity: function bankModulePrecompile() view returns(address)
func (_Contract *ContractCaller) BankModulePrecompile(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "bankModulePrecompile")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// BankModulePrecompile is a free data retrieval call binding the contract method 0x7904b623.
//
// Solidity: function bankModulePrecompile() view returns(address)
func (_Contract *ContractSession) BankModulePrecompile() (common.Address, error) {
	return _Contract.Contract.BankModulePrecompile(&_Contract.CallOpts)
}

// BankModulePrecompile is a free data retrieval call binding the contract method 0x7904b623.
//
// Solidity: function bankModulePrecompile() view returns(address)
func (_Contract *ContractCallerSession) BankModulePrecompile() (common.Address, error) {
	return _Contract.Contract.BankModulePrecompile(&_Contract.CallOpts)
}

// CurrentImplementation is a free data retrieval call binding the contract method 0xd8bd5c29.
//
// Solidity: function currentImplementation() view returns(address)
func (_Contract *ContractCaller) CurrentImplementation(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "currentImplementation")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// CurrentImplementation is a free data retrieval call binding the contract method 0xd8bd5c29.
//
// Solidity: function currentImplementation() view returns(address)
func (_Contract *ContractSession) CurrentImplementation() (common.Address, error) {
	return _Contract.Contract.CurrentImplementation(&_Contract.CallOpts)
}

// CurrentImplementation is a free data retrieval call binding the contract method 0xd8bd5c29.
//
// Solidity: function currentImplementation() view returns(address)
func (_Contract *ContractCallerSession) CurrentImplementation() (common.Address, error) {
	return _Contract.Contract.CurrentImplementation(&_Contract.CallOpts)
}

// DistributionPrecompile is a free data retrieval call binding the contract method 0x06d8c79b.
//
// Solidity: function distributionPrecompile() view returns(address)
func (_Contract *ContractCaller) DistributionPrecompile(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "distributionPrecompile")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// DistributionPrecompile is a free data retrieval call binding the contract method 0x06d8c79b.
//
// Solidity: function distributionPrecompile() view returns(address)
func (_Contract *ContractSession) DistributionPrecompile() (common.Address, error) {
	return _Contract.Contract.DistributionPrecompile(&_Contract.CallOpts)
}

// DistributionPrecompile is a free data retrieval call binding the contract method 0x06d8c79b.
//
// Solidity: function distributionPrecompile() view returns(address)
func (_Contract *ContractCallerSession) DistributionPrecompile() (common.Address, error) {
	return _Contract.Contract.DistributionPrecompile(&_Contract.CallOpts)
}

// Erc20BankPrecompile is a free data retrieval call binding the contract method 0x61d452c9.
//
// Solidity: function erc20BankPrecompile() view returns(address)
func (_Contract *ContractCaller) Erc20BankPrecompile(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "erc20BankPrecompile")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Erc20BankPrecompile is a free data retrieval call binding the contract method 0x61d452c9.
//
// Solidity: function erc20BankPrecompile() view returns(address)
func (_Contract *ContractSession) Erc20BankPrecompile() (common.Address, error) {
	return _Contract.Contract.Erc20BankPrecompile(&_Contract.CallOpts)
}

// Erc20BankPrecompile is a free data retrieval call binding the contract method 0x61d452c9.
//
// Solidity: function erc20BankPrecompile() view returns(address)
func (_Contract *ContractCallerSession) Erc20BankPrecompile() (common.Address, error) {
	return _Contract.Contract.Erc20BankPrecompile(&_Contract.CallOpts)
}

// GetRoleAdmin is a free data retrieval call binding the contract method 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (_Contract *ContractCaller) GetRoleAdmin(opts *bind.CallOpts, role [32]byte) ([32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getRoleAdmin", role)

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// GetRoleAdmin is a free data retrieval call binding the contract method 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (_Contract *ContractSession) GetRoleAdmin(role [32]byte) ([32]byte, error) {
	return _Contract.Contract.GetRoleAdmin(&_Contract.CallOpts, role)
}

// GetRoleAdmin is a free data retrieval call binding the contract method 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (_Contract *ContractCallerSession) GetRoleAdmin(role [32]byte) ([32]byte, error) {
	return _Contract.Contract.GetRoleAdmin(&_Contract.CallOpts, role)
}

// HasRole is a free data retrieval call binding the contract method 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (_Contract *ContractCaller) HasRole(opts *bind.CallOpts, role [32]byte, account common.Address) (bool, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "hasRole", role, account)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// HasRole is a free data retrieval call binding the contract method 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (_Contract *ContractSession) HasRole(role [32]byte, account common.Address) (bool, error) {
	return _Contract.Contract.HasRole(&_Contract.CallOpts, role, account)
}

// HasRole is a free data retrieval call binding the contract method 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (_Contract *ContractCallerSession) HasRole(role [32]byte, account common.Address) (bool, error) {
	return _Contract.Contract.HasRole(&_Contract.CallOpts, role, account)
}

// Ibgt is a free data retrieval call binding the contract method 0x3dafa4f3.
//
// Solidity: function ibgt() view returns(address)
func (_Contract *ContractCaller) Ibgt(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "ibgt")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Ibgt is a free data retrieval call binding the contract method 0x3dafa4f3.
//
// Solidity: function ibgt() view returns(address)
func (_Contract *ContractSession) Ibgt() (common.Address, error) {
	return _Contract.Contract.Ibgt(&_Contract.CallOpts)
}

// Ibgt is a free data retrieval call binding the contract method 0x3dafa4f3.
//
// Solidity: function ibgt() view returns(address)
func (_Contract *ContractCallerSession) Ibgt() (common.Address, error) {
	return _Contract.Contract.Ibgt(&_Contract.CallOpts)
}

// IbgtVault is a free data retrieval call binding the contract method 0xfd64c377.
//
// Solidity: function ibgtVault() view returns(address)
func (_Contract *ContractCaller) IbgtVault(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "ibgtVault")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// IbgtVault is a free data retrieval call binding the contract method 0xfd64c377.
//
// Solidity: function ibgtVault() view returns(address)
func (_Contract *ContractSession) IbgtVault() (common.Address, error) {
	return _Contract.Contract.IbgtVault(&_Contract.CallOpts)
}

// IbgtVault is a free data retrieval call binding the contract method 0xfd64c377.
//
// Solidity: function ibgtVault() view returns(address)
func (_Contract *ContractCallerSession) IbgtVault() (common.Address, error) {
	return _Contract.Contract.IbgtVault(&_Contract.CallOpts)
}

// InfraredValidators is a free data retrieval call binding the contract method 0xadc51dcb.
//
// Solidity: function infraredValidators() view returns(address[] _validators)
func (_Contract *ContractCaller) InfraredValidators(opts *bind.CallOpts) ([]common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "infraredValidators")

	if err != nil {
		return *new([]common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new([]common.Address)).(*[]common.Address)

	return out0, err

}

// InfraredValidators is a free data retrieval call binding the contract method 0xadc51dcb.
//
// Solidity: function infraredValidators() view returns(address[] _validators)
func (_Contract *ContractSession) InfraredValidators() ([]common.Address, error) {
	return _Contract.Contract.InfraredValidators(&_Contract.CallOpts)
}

// InfraredValidators is a free data retrieval call binding the contract method 0xadc51dcb.
//
// Solidity: function infraredValidators() view returns(address[] _validators)
func (_Contract *ContractCallerSession) InfraredValidators() ([]common.Address, error) {
	return _Contract.Contract.InfraredValidators(&_Contract.CallOpts)
}

// Ired is a free data retrieval call binding the contract method 0x203ae988.
//
// Solidity: function ired() view returns(address)
func (_Contract *ContractCaller) Ired(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "ired")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Ired is a free data retrieval call binding the contract method 0x203ae988.
//
// Solidity: function ired() view returns(address)
func (_Contract *ContractSession) Ired() (common.Address, error) {
	return _Contract.Contract.Ired(&_Contract.CallOpts)
}

// Ired is a free data retrieval call binding the contract method 0x203ae988.
//
// Solidity: function ired() view returns(address)
func (_Contract *ContractCallerSession) Ired() (common.Address, error) {
	return _Contract.Contract.Ired(&_Contract.CallOpts)
}

// IsInfraredValidator is a free data retrieval call binding the contract method 0x75f58651.
//
// Solidity: function isInfraredValidator(address _validator) view returns(bool)
func (_Contract *ContractCaller) IsInfraredValidator(opts *bind.CallOpts, _validator common.Address) (bool, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "isInfraredValidator", _validator)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsInfraredValidator is a free data retrieval call binding the contract method 0x75f58651.
//
// Solidity: function isInfraredValidator(address _validator) view returns(bool)
func (_Contract *ContractSession) IsInfraredValidator(_validator common.Address) (bool, error) {
	return _Contract.Contract.IsInfraredValidator(&_Contract.CallOpts, _validator)
}

// IsInfraredValidator is a free data retrieval call binding the contract method 0x75f58651.
//
// Solidity: function isInfraredValidator(address _validator) view returns(bool)
func (_Contract *ContractCallerSession) IsInfraredValidator(_validator common.Address) (bool, error) {
	return _Contract.Contract.IsInfraredValidator(&_Contract.CallOpts, _validator)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Contract *ContractCaller) Owner(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "owner")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Contract *ContractSession) Owner() (common.Address, error) {
	return _Contract.Contract.Owner(&_Contract.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Contract *ContractCallerSession) Owner() (common.Address, error) {
	return _Contract.Contract.Owner(&_Contract.CallOpts)
}

// ProxiableUUID is a free data retrieval call binding the contract method 0x52d1902d.
//
// Solidity: function proxiableUUID() view returns(bytes32)
func (_Contract *ContractCaller) ProxiableUUID(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "proxiableUUID")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// ProxiableUUID is a free data retrieval call binding the contract method 0x52d1902d.
//
// Solidity: function proxiableUUID() view returns(bytes32)
func (_Contract *ContractSession) ProxiableUUID() ([32]byte, error) {
	return _Contract.Contract.ProxiableUUID(&_Contract.CallOpts)
}

// ProxiableUUID is a free data retrieval call binding the contract method 0x52d1902d.
//
// Solidity: function proxiableUUID() view returns(bytes32)
func (_Contract *ContractCallerSession) ProxiableUUID() ([32]byte, error) {
	return _Contract.Contract.ProxiableUUID(&_Contract.CallOpts)
}

// RewardsDuration is a free data retrieval call binding the contract method 0x386a9525.
//
// Solidity: function rewardsDuration() view returns(uint256)
func (_Contract *ContractCaller) RewardsDuration(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "rewardsDuration")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// RewardsDuration is a free data retrieval call binding the contract method 0x386a9525.
//
// Solidity: function rewardsDuration() view returns(uint256)
func (_Contract *ContractSession) RewardsDuration() (*big.Int, error) {
	return _Contract.Contract.RewardsDuration(&_Contract.CallOpts)
}

// RewardsDuration is a free data retrieval call binding the contract method 0x386a9525.
//
// Solidity: function rewardsDuration() view returns(uint256)
func (_Contract *ContractCallerSession) RewardsDuration() (*big.Int, error) {
	return _Contract.Contract.RewardsDuration(&_Contract.CallOpts)
}

// RewardsPrecompile is a free data retrieval call binding the contract method 0xfdf82177.
//
// Solidity: function rewardsPrecompile() view returns(address)
func (_Contract *ContractCaller) RewardsPrecompile(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "rewardsPrecompile")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// RewardsPrecompile is a free data retrieval call binding the contract method 0xfdf82177.
//
// Solidity: function rewardsPrecompile() view returns(address)
func (_Contract *ContractSession) RewardsPrecompile() (common.Address, error) {
	return _Contract.Contract.RewardsPrecompile(&_Contract.CallOpts)
}

// RewardsPrecompile is a free data retrieval call binding the contract method 0xfdf82177.
//
// Solidity: function rewardsPrecompile() view returns(address)
func (_Contract *ContractCallerSession) RewardsPrecompile() (common.Address, error) {
	return _Contract.Contract.RewardsPrecompile(&_Contract.CallOpts)
}

// StakingPrecompile is a free data retrieval call binding the contract method 0xf845c5b3.
//
// Solidity: function stakingPrecompile() view returns(address)
func (_Contract *ContractCaller) StakingPrecompile(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "stakingPrecompile")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// StakingPrecompile is a free data retrieval call binding the contract method 0xf845c5b3.
//
// Solidity: function stakingPrecompile() view returns(address)
func (_Contract *ContractSession) StakingPrecompile() (common.Address, error) {
	return _Contract.Contract.StakingPrecompile(&_Contract.CallOpts)
}

// StakingPrecompile is a free data retrieval call binding the contract method 0xf845c5b3.
//
// Solidity: function stakingPrecompile() view returns(address)
func (_Contract *ContractCallerSession) StakingPrecompile() (common.Address, error) {
	return _Contract.Contract.StakingPrecompile(&_Contract.CallOpts)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_Contract *ContractCaller) SupportsInterface(opts *bind.CallOpts, interfaceId [4]byte) (bool, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "supportsInterface", interfaceId)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_Contract *ContractSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _Contract.Contract.SupportsInterface(&_Contract.CallOpts, interfaceId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_Contract *ContractCallerSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _Contract.Contract.SupportsInterface(&_Contract.CallOpts, interfaceId)
}

// VaultRegistry is a free data retrieval call binding the contract method 0x5487beb6.
//
// Solidity: function vaultRegistry(address _poolAddress) view returns(address _vault)
func (_Contract *ContractCaller) VaultRegistry(opts *bind.CallOpts, _poolAddress common.Address) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "vaultRegistry", _poolAddress)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// VaultRegistry is a free data retrieval call binding the contract method 0x5487beb6.
//
// Solidity: function vaultRegistry(address _poolAddress) view returns(address _vault)
func (_Contract *ContractSession) VaultRegistry(_poolAddress common.Address) (common.Address, error) {
	return _Contract.Contract.VaultRegistry(&_Contract.CallOpts, _poolAddress)
}

// VaultRegistry is a free data retrieval call binding the contract method 0x5487beb6.
//
// Solidity: function vaultRegistry(address _poolAddress) view returns(address _vault)
func (_Contract *ContractCallerSession) VaultRegistry(_poolAddress common.Address) (common.Address, error) {
	return _Contract.Contract.VaultRegistry(&_Contract.CallOpts, _poolAddress)
}

// Wbera is a free data retrieval call binding the contract method 0x31f41a33.
//
// Solidity: function wbera() view returns(address)
func (_Contract *ContractCaller) Wbera(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "wbera")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Wbera is a free data retrieval call binding the contract method 0x31f41a33.
//
// Solidity: function wbera() view returns(address)
func (_Contract *ContractSession) Wbera() (common.Address, error) {
	return _Contract.Contract.Wbera(&_Contract.CallOpts)
}

// Wbera is a free data retrieval call binding the contract method 0x31f41a33.
//
// Solidity: function wbera() view returns(address)
func (_Contract *ContractCallerSession) Wbera() (common.Address, error) {
	return _Contract.Contract.Wbera(&_Contract.CallOpts)
}

// WhitelistedRewardTokens is a free data retrieval call binding the contract method 0x5225f987.
//
// Solidity: function whitelistedRewardTokens(address ) view returns(bool)
func (_Contract *ContractCaller) WhitelistedRewardTokens(opts *bind.CallOpts, arg0 common.Address) (bool, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "whitelistedRewardTokens", arg0)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// WhitelistedRewardTokens is a free data retrieval call binding the contract method 0x5225f987.
//
// Solidity: function whitelistedRewardTokens(address ) view returns(bool)
func (_Contract *ContractSession) WhitelistedRewardTokens(arg0 common.Address) (bool, error) {
	return _Contract.Contract.WhitelistedRewardTokens(&_Contract.CallOpts, arg0)
}

// WhitelistedRewardTokens is a free data retrieval call binding the contract method 0x5225f987.
//
// Solidity: function whitelistedRewardTokens(address ) view returns(bool)
func (_Contract *ContractCallerSession) WhitelistedRewardTokens(arg0 common.Address) (bool, error) {
	return _Contract.Contract.WhitelistedRewardTokens(&_Contract.CallOpts, arg0)
}

// AddValidators is a paid mutator transaction binding the contract method 0x70223952.
//
// Solidity: function addValidators(address[] _validators) returns()
func (_Contract *ContractTransactor) AddValidators(opts *bind.TransactOpts, _validators []common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "addValidators", _validators)
}

// AddValidators is a paid mutator transaction binding the contract method 0x70223952.
//
// Solidity: function addValidators(address[] _validators) returns()
func (_Contract *ContractSession) AddValidators(_validators []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.AddValidators(&_Contract.TransactOpts, _validators)
}

// AddValidators is a paid mutator transaction binding the contract method 0x70223952.
//
// Solidity: function addValidators(address[] _validators) returns()
func (_Contract *ContractTransactorSession) AddValidators(_validators []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.AddValidators(&_Contract.TransactOpts, _validators)
}

// BeginRedelegate is a paid mutator transaction binding the contract method 0xb3a8ae3b.
//
// Solidity: function beginRedelegate(address _from, address _to, uint256 _amt) returns()
func (_Contract *ContractTransactor) BeginRedelegate(opts *bind.TransactOpts, _from common.Address, _to common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "beginRedelegate", _from, _to, _amt)
}

// BeginRedelegate is a paid mutator transaction binding the contract method 0xb3a8ae3b.
//
// Solidity: function beginRedelegate(address _from, address _to, uint256 _amt) returns()
func (_Contract *ContractSession) BeginRedelegate(_from common.Address, _to common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.BeginRedelegate(&_Contract.TransactOpts, _from, _to, _amt)
}

// BeginRedelegate is a paid mutator transaction binding the contract method 0xb3a8ae3b.
//
// Solidity: function beginRedelegate(address _from, address _to, uint256 _amt) returns()
func (_Contract *ContractTransactorSession) BeginRedelegate(_from common.Address, _to common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.BeginRedelegate(&_Contract.TransactOpts, _from, _to, _amt)
}

// CancelUnbondingDelegation is a paid mutator transaction binding the contract method 0x69a2f536.
//
// Solidity: function cancelUnbondingDelegation(address _validator, uint256 _amt, int64 _creationHeight) returns()
func (_Contract *ContractTransactor) CancelUnbondingDelegation(opts *bind.TransactOpts, _validator common.Address, _amt *big.Int, _creationHeight int64) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "cancelUnbondingDelegation", _validator, _amt, _creationHeight)
}

// CancelUnbondingDelegation is a paid mutator transaction binding the contract method 0x69a2f536.
//
// Solidity: function cancelUnbondingDelegation(address _validator, uint256 _amt, int64 _creationHeight) returns()
func (_Contract *ContractSession) CancelUnbondingDelegation(_validator common.Address, _amt *big.Int, _creationHeight int64) (*types.Transaction, error) {
	return _Contract.Contract.CancelUnbondingDelegation(&_Contract.TransactOpts, _validator, _amt, _creationHeight)
}

// CancelUnbondingDelegation is a paid mutator transaction binding the contract method 0x69a2f536.
//
// Solidity: function cancelUnbondingDelegation(address _validator, uint256 _amt, int64 _creationHeight) returns()
func (_Contract *ContractTransactorSession) CancelUnbondingDelegation(_validator common.Address, _amt *big.Int, _creationHeight int64) (*types.Transaction, error) {
	return _Contract.Contract.CancelUnbondingDelegation(&_Contract.TransactOpts, _validator, _amt, _creationHeight)
}

// Delegate is a paid mutator transaction binding the contract method 0x026e402b.
//
// Solidity: function delegate(address _validator, uint256 _amt) returns()
func (_Contract *ContractTransactor) Delegate(opts *bind.TransactOpts, _validator common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "delegate", _validator, _amt)
}

// Delegate is a paid mutator transaction binding the contract method 0x026e402b.
//
// Solidity: function delegate(address _validator, uint256 _amt) returns()
func (_Contract *ContractSession) Delegate(_validator common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Delegate(&_Contract.TransactOpts, _validator, _amt)
}

// Delegate is a paid mutator transaction binding the contract method 0x026e402b.
//
// Solidity: function delegate(address _validator, uint256 _amt) returns()
func (_Contract *ContractTransactorSession) Delegate(_validator common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Delegate(&_Contract.TransactOpts, _validator, _amt)
}

// GrantRole is a paid mutator transaction binding the contract method 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (_Contract *ContractTransactor) GrantRole(opts *bind.TransactOpts, role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "grantRole", role, account)
}

// GrantRole is a paid mutator transaction binding the contract method 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (_Contract *ContractSession) GrantRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Contract.Contract.GrantRole(&_Contract.TransactOpts, role, account)
}

// GrantRole is a paid mutator transaction binding the contract method 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (_Contract *ContractTransactorSession) GrantRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Contract.Contract.GrantRole(&_Contract.TransactOpts, role, account)
}

// HarvestValidator is a paid mutator transaction binding the contract method 0x9b2bc48a.
//
// Solidity: function harvestValidator(address _validator) returns()
func (_Contract *ContractTransactor) HarvestValidator(opts *bind.TransactOpts, _validator common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "harvestValidator", _validator)
}

// HarvestValidator is a paid mutator transaction binding the contract method 0x9b2bc48a.
//
// Solidity: function harvestValidator(address _validator) returns()
func (_Contract *ContractSession) HarvestValidator(_validator common.Address) (*types.Transaction, error) {
	return _Contract.Contract.HarvestValidator(&_Contract.TransactOpts, _validator)
}

// HarvestValidator is a paid mutator transaction binding the contract method 0x9b2bc48a.
//
// Solidity: function harvestValidator(address _validator) returns()
func (_Contract *ContractTransactorSession) HarvestValidator(_validator common.Address) (*types.Transaction, error) {
	return _Contract.Contract.HarvestValidator(&_Contract.TransactOpts, _validator)
}

// HarvestVault is a paid mutator transaction binding the contract method 0x0a2f023e.
//
// Solidity: function harvestVault(address _pool) returns()
func (_Contract *ContractTransactor) HarvestVault(opts *bind.TransactOpts, _pool common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "harvestVault", _pool)
}

// HarvestVault is a paid mutator transaction binding the contract method 0x0a2f023e.
//
// Solidity: function harvestVault(address _pool) returns()
func (_Contract *ContractSession) HarvestVault(_pool common.Address) (*types.Transaction, error) {
	return _Contract.Contract.HarvestVault(&_Contract.TransactOpts, _pool)
}

// HarvestVault is a paid mutator transaction binding the contract method 0x0a2f023e.
//
// Solidity: function harvestVault(address _pool) returns()
func (_Contract *ContractTransactorSession) HarvestVault(_pool common.Address) (*types.Transaction, error) {
	return _Contract.Contract.HarvestVault(&_Contract.TransactOpts, _pool)
}

// Initialize is a paid mutator transaction binding the contract method 0x94733041.
//
// Solidity: function initialize(address _admin, address _ibgt, address _erc20BankPrecompile, address _distributionPrecompile, address _wbera, address _stakingPrecompile, address _rewardsPrecompile, address _ired, uint256 _rewardsDuration, address _bankModulePrecompile) returns()
func (_Contract *ContractTransactor) Initialize(opts *bind.TransactOpts, _admin common.Address, _ibgt common.Address, _erc20BankPrecompile common.Address, _distributionPrecompile common.Address, _wbera common.Address, _stakingPrecompile common.Address, _rewardsPrecompile common.Address, _ired common.Address, _rewardsDuration *big.Int, _bankModulePrecompile common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "initialize", _admin, _ibgt, _erc20BankPrecompile, _distributionPrecompile, _wbera, _stakingPrecompile, _rewardsPrecompile, _ired, _rewardsDuration, _bankModulePrecompile)
}

// Initialize is a paid mutator transaction binding the contract method 0x94733041.
//
// Solidity: function initialize(address _admin, address _ibgt, address _erc20BankPrecompile, address _distributionPrecompile, address _wbera, address _stakingPrecompile, address _rewardsPrecompile, address _ired, uint256 _rewardsDuration, address _bankModulePrecompile) returns()
func (_Contract *ContractSession) Initialize(_admin common.Address, _ibgt common.Address, _erc20BankPrecompile common.Address, _distributionPrecompile common.Address, _wbera common.Address, _stakingPrecompile common.Address, _rewardsPrecompile common.Address, _ired common.Address, _rewardsDuration *big.Int, _bankModulePrecompile common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Initialize(&_Contract.TransactOpts, _admin, _ibgt, _erc20BankPrecompile, _distributionPrecompile, _wbera, _stakingPrecompile, _rewardsPrecompile, _ired, _rewardsDuration, _bankModulePrecompile)
}

// Initialize is a paid mutator transaction binding the contract method 0x94733041.
//
// Solidity: function initialize(address _admin, address _ibgt, address _erc20BankPrecompile, address _distributionPrecompile, address _wbera, address _stakingPrecompile, address _rewardsPrecompile, address _ired, uint256 _rewardsDuration, address _bankModulePrecompile) returns()
func (_Contract *ContractTransactorSession) Initialize(_admin common.Address, _ibgt common.Address, _erc20BankPrecompile common.Address, _distributionPrecompile common.Address, _wbera common.Address, _stakingPrecompile common.Address, _rewardsPrecompile common.Address, _ired common.Address, _rewardsDuration *big.Int, _bankModulePrecompile common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Initialize(&_Contract.TransactOpts, _admin, _ibgt, _erc20BankPrecompile, _distributionPrecompile, _wbera, _stakingPrecompile, _rewardsPrecompile, _ired, _rewardsDuration, _bankModulePrecompile)
}

// RecoverERC20 is a paid mutator transaction binding the contract method 0x1171bda9.
//
// Solidity: function recoverERC20(address _to, address _token, uint256 _amount) returns()
func (_Contract *ContractTransactor) RecoverERC20(opts *bind.TransactOpts, _to common.Address, _token common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "recoverERC20", _to, _token, _amount)
}

// RecoverERC20 is a paid mutator transaction binding the contract method 0x1171bda9.
//
// Solidity: function recoverERC20(address _to, address _token, uint256 _amount) returns()
func (_Contract *ContractSession) RecoverERC20(_to common.Address, _token common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.RecoverERC20(&_Contract.TransactOpts, _to, _token, _amount)
}

// RecoverERC20 is a paid mutator transaction binding the contract method 0x1171bda9.
//
// Solidity: function recoverERC20(address _to, address _token, uint256 _amount) returns()
func (_Contract *ContractTransactorSession) RecoverERC20(_to common.Address, _token common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.RecoverERC20(&_Contract.TransactOpts, _to, _token, _amount)
}

// RegisterVault is a paid mutator transaction binding the contract method 0x6bb417dd.
//
// Solidity: function registerVault(address _asset, address[] _rewardTokens, address _poolAddress) returns(address)
func (_Contract *ContractTransactor) RegisterVault(opts *bind.TransactOpts, _asset common.Address, _rewardTokens []common.Address, _poolAddress common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "registerVault", _asset, _rewardTokens, _poolAddress)
}

// RegisterVault is a paid mutator transaction binding the contract method 0x6bb417dd.
//
// Solidity: function registerVault(address _asset, address[] _rewardTokens, address _poolAddress) returns(address)
func (_Contract *ContractSession) RegisterVault(_asset common.Address, _rewardTokens []common.Address, _poolAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RegisterVault(&_Contract.TransactOpts, _asset, _rewardTokens, _poolAddress)
}

// RegisterVault is a paid mutator transaction binding the contract method 0x6bb417dd.
//
// Solidity: function registerVault(address _asset, address[] _rewardTokens, address _poolAddress) returns(address)
func (_Contract *ContractTransactorSession) RegisterVault(_asset common.Address, _rewardTokens []common.Address, _poolAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RegisterVault(&_Contract.TransactOpts, _asset, _rewardTokens, _poolAddress)
}

// RemoveValidators is a paid mutator transaction binding the contract method 0x1d40f0d8.
//
// Solidity: function removeValidators(address[] _validators) returns()
func (_Contract *ContractTransactor) RemoveValidators(opts *bind.TransactOpts, _validators []common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "removeValidators", _validators)
}

// RemoveValidators is a paid mutator transaction binding the contract method 0x1d40f0d8.
//
// Solidity: function removeValidators(address[] _validators) returns()
func (_Contract *ContractSession) RemoveValidators(_validators []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RemoveValidators(&_Contract.TransactOpts, _validators)
}

// RemoveValidators is a paid mutator transaction binding the contract method 0x1d40f0d8.
//
// Solidity: function removeValidators(address[] _validators) returns()
func (_Contract *ContractTransactorSession) RemoveValidators(_validators []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RemoveValidators(&_Contract.TransactOpts, _validators)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Contract *ContractTransactor) RenounceOwnership(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "renounceOwnership")
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Contract *ContractSession) RenounceOwnership() (*types.Transaction, error) {
	return _Contract.Contract.RenounceOwnership(&_Contract.TransactOpts)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Contract *ContractTransactorSession) RenounceOwnership() (*types.Transaction, error) {
	return _Contract.Contract.RenounceOwnership(&_Contract.TransactOpts)
}

// RenounceRole is a paid mutator transaction binding the contract method 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (_Contract *ContractTransactor) RenounceRole(opts *bind.TransactOpts, role [32]byte, callerConfirmation common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "renounceRole", role, callerConfirmation)
}

// RenounceRole is a paid mutator transaction binding the contract method 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (_Contract *ContractSession) RenounceRole(role [32]byte, callerConfirmation common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RenounceRole(&_Contract.TransactOpts, role, callerConfirmation)
}

// RenounceRole is a paid mutator transaction binding the contract method 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (_Contract *ContractTransactorSession) RenounceRole(role [32]byte, callerConfirmation common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RenounceRole(&_Contract.TransactOpts, role, callerConfirmation)
}

// ReplaceValidator is a paid mutator transaction binding the contract method 0x53149d72.
//
// Solidity: function replaceValidator(address _current, address _new) returns()
func (_Contract *ContractTransactor) ReplaceValidator(opts *bind.TransactOpts, _current common.Address, _new common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "replaceValidator", _current, _new)
}

// ReplaceValidator is a paid mutator transaction binding the contract method 0x53149d72.
//
// Solidity: function replaceValidator(address _current, address _new) returns()
func (_Contract *ContractSession) ReplaceValidator(_current common.Address, _new common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ReplaceValidator(&_Contract.TransactOpts, _current, _new)
}

// ReplaceValidator is a paid mutator transaction binding the contract method 0x53149d72.
//
// Solidity: function replaceValidator(address _current, address _new) returns()
func (_Contract *ContractTransactorSession) ReplaceValidator(_current common.Address, _new common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ReplaceValidator(&_Contract.TransactOpts, _current, _new)
}

// RevokeRole is a paid mutator transaction binding the contract method 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (_Contract *ContractTransactor) RevokeRole(opts *bind.TransactOpts, role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "revokeRole", role, account)
}

// RevokeRole is a paid mutator transaction binding the contract method 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (_Contract *ContractSession) RevokeRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RevokeRole(&_Contract.TransactOpts, role, account)
}

// RevokeRole is a paid mutator transaction binding the contract method 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (_Contract *ContractTransactorSession) RevokeRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RevokeRole(&_Contract.TransactOpts, role, account)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Contract *ContractTransactor) TransferOwnership(opts *bind.TransactOpts, newOwner common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "transferOwnership", newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Contract *ContractSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _Contract.Contract.TransferOwnership(&_Contract.TransactOpts, newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Contract *ContractTransactorSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _Contract.Contract.TransferOwnership(&_Contract.TransactOpts, newOwner)
}

// Undelegate is a paid mutator transaction binding the contract method 0x4d99dd16.
//
// Solidity: function undelegate(address _validator, uint256 _amt) returns()
func (_Contract *ContractTransactor) Undelegate(opts *bind.TransactOpts, _validator common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "undelegate", _validator, _amt)
}

// Undelegate is a paid mutator transaction binding the contract method 0x4d99dd16.
//
// Solidity: function undelegate(address _validator, uint256 _amt) returns()
func (_Contract *ContractSession) Undelegate(_validator common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Undelegate(&_Contract.TransactOpts, _validator, _amt)
}

// Undelegate is a paid mutator transaction binding the contract method 0x4d99dd16.
//
// Solidity: function undelegate(address _validator, uint256 _amt) returns()
func (_Contract *ContractTransactorSession) Undelegate(_validator common.Address, _amt *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Undelegate(&_Contract.TransactOpts, _validator, _amt)
}

// UpdateIbgt is a paid mutator transaction binding the contract method 0x86e8dc45.
//
// Solidity: function updateIbgt(address _newIbgt) returns()
func (_Contract *ContractTransactor) UpdateIbgt(opts *bind.TransactOpts, _newIbgt common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "updateIbgt", _newIbgt)
}

// UpdateIbgt is a paid mutator transaction binding the contract method 0x86e8dc45.
//
// Solidity: function updateIbgt(address _newIbgt) returns()
func (_Contract *ContractSession) UpdateIbgt(_newIbgt common.Address) (*types.Transaction, error) {
	return _Contract.Contract.UpdateIbgt(&_Contract.TransactOpts, _newIbgt)
}

// UpdateIbgt is a paid mutator transaction binding the contract method 0x86e8dc45.
//
// Solidity: function updateIbgt(address _newIbgt) returns()
func (_Contract *ContractTransactorSession) UpdateIbgt(_newIbgt common.Address) (*types.Transaction, error) {
	return _Contract.Contract.UpdateIbgt(&_Contract.TransactOpts, _newIbgt)
}

// UpdateIbgtVault is a paid mutator transaction binding the contract method 0x4958bb65.
//
// Solidity: function updateIbgtVault(address _newIbgtVault) returns()
func (_Contract *ContractTransactor) UpdateIbgtVault(opts *bind.TransactOpts, _newIbgtVault common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "updateIbgtVault", _newIbgtVault)
}

// UpdateIbgtVault is a paid mutator transaction binding the contract method 0x4958bb65.
//
// Solidity: function updateIbgtVault(address _newIbgtVault) returns()
func (_Contract *ContractSession) UpdateIbgtVault(_newIbgtVault common.Address) (*types.Transaction, error) {
	return _Contract.Contract.UpdateIbgtVault(&_Contract.TransactOpts, _newIbgtVault)
}

// UpdateIbgtVault is a paid mutator transaction binding the contract method 0x4958bb65.
//
// Solidity: function updateIbgtVault(address _newIbgtVault) returns()
func (_Contract *ContractTransactorSession) UpdateIbgtVault(_newIbgtVault common.Address) (*types.Transaction, error) {
	return _Contract.Contract.UpdateIbgtVault(&_Contract.TransactOpts, _newIbgtVault)
}

// UpdateRewardsDuration is a paid mutator transaction binding the contract method 0xd94ef29d.
//
// Solidity: function updateRewardsDuration(uint256 _rewardsDuration) returns()
func (_Contract *ContractTransactor) UpdateRewardsDuration(opts *bind.TransactOpts, _rewardsDuration *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "updateRewardsDuration", _rewardsDuration)
}

// UpdateRewardsDuration is a paid mutator transaction binding the contract method 0xd94ef29d.
//
// Solidity: function updateRewardsDuration(uint256 _rewardsDuration) returns()
func (_Contract *ContractSession) UpdateRewardsDuration(_rewardsDuration *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.UpdateRewardsDuration(&_Contract.TransactOpts, _rewardsDuration)
}

// UpdateRewardsDuration is a paid mutator transaction binding the contract method 0xd94ef29d.
//
// Solidity: function updateRewardsDuration(uint256 _rewardsDuration) returns()
func (_Contract *ContractTransactorSession) UpdateRewardsDuration(_rewardsDuration *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.UpdateRewardsDuration(&_Contract.TransactOpts, _rewardsDuration)
}

// UpdateWhiteListedRewardTokens is a paid mutator transaction binding the contract method 0x5787077d.
//
// Solidity: function updateWhiteListedRewardTokens(address _token, bool _whitelisted) returns()
func (_Contract *ContractTransactor) UpdateWhiteListedRewardTokens(opts *bind.TransactOpts, _token common.Address, _whitelisted bool) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "updateWhiteListedRewardTokens", _token, _whitelisted)
}

// UpdateWhiteListedRewardTokens is a paid mutator transaction binding the contract method 0x5787077d.
//
// Solidity: function updateWhiteListedRewardTokens(address _token, bool _whitelisted) returns()
func (_Contract *ContractSession) UpdateWhiteListedRewardTokens(_token common.Address, _whitelisted bool) (*types.Transaction, error) {
	return _Contract.Contract.UpdateWhiteListedRewardTokens(&_Contract.TransactOpts, _token, _whitelisted)
}

// UpdateWhiteListedRewardTokens is a paid mutator transaction binding the contract method 0x5787077d.
//
// Solidity: function updateWhiteListedRewardTokens(address _token, bool _whitelisted) returns()
func (_Contract *ContractTransactorSession) UpdateWhiteListedRewardTokens(_token common.Address, _whitelisted bool) (*types.Transaction, error) {
	return _Contract.Contract.UpdateWhiteListedRewardTokens(&_Contract.TransactOpts, _token, _whitelisted)
}

// UpgradeToAndCall is a paid mutator transaction binding the contract method 0x4f1ef286.
//
// Solidity: function upgradeToAndCall(address newImplementation, bytes data) payable returns()
func (_Contract *ContractTransactor) UpgradeToAndCall(opts *bind.TransactOpts, newImplementation common.Address, data []byte) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "upgradeToAndCall", newImplementation, data)
}

// UpgradeToAndCall is a paid mutator transaction binding the contract method 0x4f1ef286.
//
// Solidity: function upgradeToAndCall(address newImplementation, bytes data) payable returns()
func (_Contract *ContractSession) UpgradeToAndCall(newImplementation common.Address, data []byte) (*types.Transaction, error) {
	return _Contract.Contract.UpgradeToAndCall(&_Contract.TransactOpts, newImplementation, data)
}

// UpgradeToAndCall is a paid mutator transaction binding the contract method 0x4f1ef286.
//
// Solidity: function upgradeToAndCall(address newImplementation, bytes data) payable returns()
func (_Contract *ContractTransactorSession) UpgradeToAndCall(newImplementation common.Address, data []byte) (*types.Transaction, error) {
	return _Contract.Contract.UpgradeToAndCall(&_Contract.TransactOpts, newImplementation, data)
}

// ContractDelegatedIterator is returned from FilterDelegated and is used to iterate over the raw logs and unpacked data for Delegated events raised by the Contract contract.
type ContractDelegatedIterator struct {
	Event *ContractDelegated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractDelegatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractDelegated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractDelegated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractDelegatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractDelegatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractDelegated represents a Delegated event raised by the Contract contract.
type ContractDelegated struct {
	Sender    common.Address
	Validator common.Address
	Amt       *big.Int
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterDelegated is a free log retrieval operation binding the contract event 0xe5541a6b6103d4fa7e021ed54fad39c66f27a76bd13d374cf6240ae6bd0bb72b.
//
// Solidity: event Delegated(address _sender, address _validator, uint256 _amt)
func (_Contract *ContractFilterer) FilterDelegated(opts *bind.FilterOpts) (*ContractDelegatedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Delegated")
	if err != nil {
		return nil, err
	}
	return &ContractDelegatedIterator{contract: _Contract.contract, event: "Delegated", logs: logs, sub: sub}, nil
}

// WatchDelegated is a free log subscription operation binding the contract event 0xe5541a6b6103d4fa7e021ed54fad39c66f27a76bd13d374cf6240ae6bd0bb72b.
//
// Solidity: event Delegated(address _sender, address _validator, uint256 _amt)
func (_Contract *ContractFilterer) WatchDelegated(opts *bind.WatchOpts, sink chan<- *ContractDelegated) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Delegated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractDelegated)
				if err := _Contract.contract.UnpackLog(event, "Delegated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseDelegated is a log parse operation binding the contract event 0xe5541a6b6103d4fa7e021ed54fad39c66f27a76bd13d374cf6240ae6bd0bb72b.
//
// Solidity: event Delegated(address _sender, address _validator, uint256 _amt)
func (_Contract *ContractFilterer) ParseDelegated(log types.Log) (*ContractDelegated, error) {
	event := new(ContractDelegated)
	if err := _Contract.contract.UnpackLog(event, "Delegated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractIBGTSuppliedIterator is returned from FilterIBGTSupplied and is used to iterate over the raw logs and unpacked data for IBGTSupplied events raised by the Contract contract.
type ContractIBGTSuppliedIterator struct {
	Event *ContractIBGTSupplied // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractIBGTSuppliedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractIBGTSupplied)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractIBGTSupplied)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractIBGTSuppliedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractIBGTSuppliedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractIBGTSupplied represents a IBGTSupplied event raised by the Contract contract.
type ContractIBGTSupplied struct {
	Vault common.Address
	Amt   *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterIBGTSupplied is a free log retrieval operation binding the contract event 0x037146eb3fc443d699b74fae8d5371c6abb236703351dc20fecf98477bf22386.
//
// Solidity: event IBGTSupplied(address indexed _vault, uint256 _amt)
func (_Contract *ContractFilterer) FilterIBGTSupplied(opts *bind.FilterOpts, _vault []common.Address) (*ContractIBGTSuppliedIterator, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "IBGTSupplied", _vaultRule)
	if err != nil {
		return nil, err
	}
	return &ContractIBGTSuppliedIterator{contract: _Contract.contract, event: "IBGTSupplied", logs: logs, sub: sub}, nil
}

// WatchIBGTSupplied is a free log subscription operation binding the contract event 0x037146eb3fc443d699b74fae8d5371c6abb236703351dc20fecf98477bf22386.
//
// Solidity: event IBGTSupplied(address indexed _vault, uint256 _amt)
func (_Contract *ContractFilterer) WatchIBGTSupplied(opts *bind.WatchOpts, sink chan<- *ContractIBGTSupplied, _vault []common.Address) (event.Subscription, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "IBGTSupplied", _vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractIBGTSupplied)
				if err := _Contract.contract.UnpackLog(event, "IBGTSupplied", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseIBGTSupplied is a log parse operation binding the contract event 0x037146eb3fc443d699b74fae8d5371c6abb236703351dc20fecf98477bf22386.
//
// Solidity: event IBGTSupplied(address indexed _vault, uint256 _amt)
func (_Contract *ContractFilterer) ParseIBGTSupplied(log types.Log) (*ContractIBGTSupplied, error) {
	event := new(ContractIBGTSupplied)
	if err := _Contract.contract.UnpackLog(event, "IBGTSupplied", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractIBGTUpdatedIterator is returned from FilterIBGTUpdated and is used to iterate over the raw logs and unpacked data for IBGTUpdated events raised by the Contract contract.
type ContractIBGTUpdatedIterator struct {
	Event *ContractIBGTUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractIBGTUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractIBGTUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractIBGTUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractIBGTUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractIBGTUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractIBGTUpdated represents a IBGTUpdated event raised by the Contract contract.
type ContractIBGTUpdated struct {
	Sender  common.Address
	OldIbgt common.Address
	NewIbgt common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterIBGTUpdated is a free log retrieval operation binding the contract event 0x76cb03422a6c706350d73171c85864ad4a42a93350960a4593a1a2c443419bd6.
//
// Solidity: event IBGTUpdated(address _sender, address _oldIbgt, address _newIbgt)
func (_Contract *ContractFilterer) FilterIBGTUpdated(opts *bind.FilterOpts) (*ContractIBGTUpdatedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "IBGTUpdated")
	if err != nil {
		return nil, err
	}
	return &ContractIBGTUpdatedIterator{contract: _Contract.contract, event: "IBGTUpdated", logs: logs, sub: sub}, nil
}

// WatchIBGTUpdated is a free log subscription operation binding the contract event 0x76cb03422a6c706350d73171c85864ad4a42a93350960a4593a1a2c443419bd6.
//
// Solidity: event IBGTUpdated(address _sender, address _oldIbgt, address _newIbgt)
func (_Contract *ContractFilterer) WatchIBGTUpdated(opts *bind.WatchOpts, sink chan<- *ContractIBGTUpdated) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "IBGTUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractIBGTUpdated)
				if err := _Contract.contract.UnpackLog(event, "IBGTUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseIBGTUpdated is a log parse operation binding the contract event 0x76cb03422a6c706350d73171c85864ad4a42a93350960a4593a1a2c443419bd6.
//
// Solidity: event IBGTUpdated(address _sender, address _oldIbgt, address _newIbgt)
func (_Contract *ContractFilterer) ParseIBGTUpdated(log types.Log) (*ContractIBGTUpdated, error) {
	event := new(ContractIBGTUpdated)
	if err := _Contract.contract.UnpackLog(event, "IBGTUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractIBGTVaultUpdatedIterator is returned from FilterIBGTVaultUpdated and is used to iterate over the raw logs and unpacked data for IBGTVaultUpdated events raised by the Contract contract.
type ContractIBGTVaultUpdatedIterator struct {
	Event *ContractIBGTVaultUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractIBGTVaultUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractIBGTVaultUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractIBGTVaultUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractIBGTVaultUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractIBGTVaultUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractIBGTVaultUpdated represents a IBGTVaultUpdated event raised by the Contract contract.
type ContractIBGTVaultUpdated struct {
	Sender       common.Address
	OldIbgtVault common.Address
	NewIbgtVault common.Address
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterIBGTVaultUpdated is a free log retrieval operation binding the contract event 0x62723fd3793f1af735f6965f17e0160d127724d8b3715e477532fb1317e4d6d6.
//
// Solidity: event IBGTVaultUpdated(address _sender, address _oldIbgtVault, address _newIbgtVault)
func (_Contract *ContractFilterer) FilterIBGTVaultUpdated(opts *bind.FilterOpts) (*ContractIBGTVaultUpdatedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "IBGTVaultUpdated")
	if err != nil {
		return nil, err
	}
	return &ContractIBGTVaultUpdatedIterator{contract: _Contract.contract, event: "IBGTVaultUpdated", logs: logs, sub: sub}, nil
}

// WatchIBGTVaultUpdated is a free log subscription operation binding the contract event 0x62723fd3793f1af735f6965f17e0160d127724d8b3715e477532fb1317e4d6d6.
//
// Solidity: event IBGTVaultUpdated(address _sender, address _oldIbgtVault, address _newIbgtVault)
func (_Contract *ContractFilterer) WatchIBGTVaultUpdated(opts *bind.WatchOpts, sink chan<- *ContractIBGTVaultUpdated) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "IBGTVaultUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractIBGTVaultUpdated)
				if err := _Contract.contract.UnpackLog(event, "IBGTVaultUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseIBGTVaultUpdated is a log parse operation binding the contract event 0x62723fd3793f1af735f6965f17e0160d127724d8b3715e477532fb1317e4d6d6.
//
// Solidity: event IBGTVaultUpdated(address _sender, address _oldIbgtVault, address _newIbgtVault)
func (_Contract *ContractFilterer) ParseIBGTVaultUpdated(log types.Log) (*ContractIBGTVaultUpdated, error) {
	event := new(ContractIBGTVaultUpdated)
	if err := _Contract.contract.UnpackLog(event, "IBGTVaultUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractInitializedIterator is returned from FilterInitialized and is used to iterate over the raw logs and unpacked data for Initialized events raised by the Contract contract.
type ContractInitializedIterator struct {
	Event *ContractInitialized // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractInitializedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractInitialized)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractInitialized)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractInitializedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractInitializedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractInitialized represents a Initialized event raised by the Contract contract.
type ContractInitialized struct {
	Version uint64
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterInitialized is a free log retrieval operation binding the contract event 0xc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d2.
//
// Solidity: event Initialized(uint64 version)
func (_Contract *ContractFilterer) FilterInitialized(opts *bind.FilterOpts) (*ContractInitializedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Initialized")
	if err != nil {
		return nil, err
	}
	return &ContractInitializedIterator{contract: _Contract.contract, event: "Initialized", logs: logs, sub: sub}, nil
}

// WatchInitialized is a free log subscription operation binding the contract event 0xc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d2.
//
// Solidity: event Initialized(uint64 version)
func (_Contract *ContractFilterer) WatchInitialized(opts *bind.WatchOpts, sink chan<- *ContractInitialized) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Initialized")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractInitialized)
				if err := _Contract.contract.UnpackLog(event, "Initialized", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseInitialized is a log parse operation binding the contract event 0xc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d2.
//
// Solidity: event Initialized(uint64 version)
func (_Contract *ContractFilterer) ParseInitialized(log types.Log) (*ContractInitialized, error) {
	event := new(ContractInitialized)
	if err := _Contract.contract.UnpackLog(event, "Initialized", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractNewVaultIterator is returned from FilterNewVault and is used to iterate over the raw logs and unpacked data for NewVault events raised by the Contract contract.
type ContractNewVaultIterator struct {
	Event *ContractNewVault // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractNewVaultIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractNewVault)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractNewVault)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractNewVaultIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractNewVaultIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractNewVault represents a NewVault event raised by the Contract contract.
type ContractNewVault struct {
	Sender       common.Address
	Pool         common.Address
	Vault        common.Address
	Asset        common.Address
	RewardTokens []common.Address
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterNewVault is a free log retrieval operation binding the contract event 0x83f2ca6c8a1ab5dc2b5b57303dd6e25cc4c584fd8336c53312a4662024e8bfa6.
//
// Solidity: event NewVault(address _sender, address indexed _pool, address indexed _vault, address _asset, address[] _rewardTokens)
func (_Contract *ContractFilterer) FilterNewVault(opts *bind.FilterOpts, _pool []common.Address, _vault []common.Address) (*ContractNewVaultIterator, error) {

	var _poolRule []interface{}
	for _, _poolItem := range _pool {
		_poolRule = append(_poolRule, _poolItem)
	}
	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "NewVault", _poolRule, _vaultRule)
	if err != nil {
		return nil, err
	}
	return &ContractNewVaultIterator{contract: _Contract.contract, event: "NewVault", logs: logs, sub: sub}, nil
}

// WatchNewVault is a free log subscription operation binding the contract event 0x83f2ca6c8a1ab5dc2b5b57303dd6e25cc4c584fd8336c53312a4662024e8bfa6.
//
// Solidity: event NewVault(address _sender, address indexed _pool, address indexed _vault, address _asset, address[] _rewardTokens)
func (_Contract *ContractFilterer) WatchNewVault(opts *bind.WatchOpts, sink chan<- *ContractNewVault, _pool []common.Address, _vault []common.Address) (event.Subscription, error) {

	var _poolRule []interface{}
	for _, _poolItem := range _pool {
		_poolRule = append(_poolRule, _poolItem)
	}
	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "NewVault", _poolRule, _vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractNewVault)
				if err := _Contract.contract.UnpackLog(event, "NewVault", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseNewVault is a log parse operation binding the contract event 0x83f2ca6c8a1ab5dc2b5b57303dd6e25cc4c584fd8336c53312a4662024e8bfa6.
//
// Solidity: event NewVault(address _sender, address indexed _pool, address indexed _vault, address _asset, address[] _rewardTokens)
func (_Contract *ContractFilterer) ParseNewVault(log types.Log) (*ContractNewVault, error) {
	event := new(ContractNewVault)
	if err := _Contract.contract.UnpackLog(event, "NewVault", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractOwnershipTransferredIterator is returned from FilterOwnershipTransferred and is used to iterate over the raw logs and unpacked data for OwnershipTransferred events raised by the Contract contract.
type ContractOwnershipTransferredIterator struct {
	Event *ContractOwnershipTransferred // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractOwnershipTransferredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractOwnershipTransferred)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractOwnershipTransferred)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractOwnershipTransferredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractOwnershipTransferredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractOwnershipTransferred represents a OwnershipTransferred event raised by the Contract contract.
type ContractOwnershipTransferred struct {
	PreviousOwner common.Address
	NewOwner      common.Address
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterOwnershipTransferred is a free log retrieval operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Contract *ContractFilterer) FilterOwnershipTransferred(opts *bind.FilterOpts, previousOwner []common.Address, newOwner []common.Address) (*ContractOwnershipTransferredIterator, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return &ContractOwnershipTransferredIterator{contract: _Contract.contract, event: "OwnershipTransferred", logs: logs, sub: sub}, nil
}

// WatchOwnershipTransferred is a free log subscription operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Contract *ContractFilterer) WatchOwnershipTransferred(opts *bind.WatchOpts, sink chan<- *ContractOwnershipTransferred, previousOwner []common.Address, newOwner []common.Address) (event.Subscription, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractOwnershipTransferred)
				if err := _Contract.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseOwnershipTransferred is a log parse operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Contract *ContractFilterer) ParseOwnershipTransferred(log types.Log) (*ContractOwnershipTransferred, error) {
	event := new(ContractOwnershipTransferred)
	if err := _Contract.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRecoveredIterator is returned from FilterRecovered and is used to iterate over the raw logs and unpacked data for Recovered events raised by the Contract contract.
type ContractRecoveredIterator struct {
	Event *ContractRecovered // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRecoveredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRecovered)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRecovered)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRecoveredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRecoveredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRecovered represents a Recovered event raised by the Contract contract.
type ContractRecovered struct {
	Sender common.Address
	Token  common.Address
	Amount *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterRecovered is a free log retrieval operation binding the contract event 0xfff3b3844276f57024e0b42afec1a37f75db36511e43819a4f2a63ab7862b648.
//
// Solidity: event Recovered(address _sender, address indexed _token, uint256 _amount)
func (_Contract *ContractFilterer) FilterRecovered(opts *bind.FilterOpts, _token []common.Address) (*ContractRecoveredIterator, error) {

	var _tokenRule []interface{}
	for _, _tokenItem := range _token {
		_tokenRule = append(_tokenRule, _tokenItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Recovered", _tokenRule)
	if err != nil {
		return nil, err
	}
	return &ContractRecoveredIterator{contract: _Contract.contract, event: "Recovered", logs: logs, sub: sub}, nil
}

// WatchRecovered is a free log subscription operation binding the contract event 0xfff3b3844276f57024e0b42afec1a37f75db36511e43819a4f2a63ab7862b648.
//
// Solidity: event Recovered(address _sender, address indexed _token, uint256 _amount)
func (_Contract *ContractFilterer) WatchRecovered(opts *bind.WatchOpts, sink chan<- *ContractRecovered, _token []common.Address) (event.Subscription, error) {

	var _tokenRule []interface{}
	for _, _tokenItem := range _token {
		_tokenRule = append(_tokenRule, _tokenItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Recovered", _tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRecovered)
				if err := _Contract.contract.UnpackLog(event, "Recovered", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRecovered is a log parse operation binding the contract event 0xfff3b3844276f57024e0b42afec1a37f75db36511e43819a4f2a63ab7862b648.
//
// Solidity: event Recovered(address _sender, address indexed _token, uint256 _amount)
func (_Contract *ContractFilterer) ParseRecovered(log types.Log) (*ContractRecovered, error) {
	event := new(ContractRecovered)
	if err := _Contract.contract.UnpackLog(event, "Recovered", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRedelegateStartedIterator is returned from FilterRedelegateStarted and is used to iterate over the raw logs and unpacked data for RedelegateStarted events raised by the Contract contract.
type ContractRedelegateStartedIterator struct {
	Event *ContractRedelegateStarted // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRedelegateStartedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRedelegateStarted)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRedelegateStarted)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRedelegateStartedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRedelegateStartedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRedelegateStarted represents a RedelegateStarted event raised by the Contract contract.
type ContractRedelegateStarted struct {
	Sender common.Address
	From   common.Address
	To     common.Address
	Amt    *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterRedelegateStarted is a free log retrieval operation binding the contract event 0x9b962edd2f58563e42e9bbcd7f7e2062e70d2c6677fcfc12dc04c4982294af6a.
//
// Solidity: event RedelegateStarted(address _sender, address _from, address _to, uint256 _amt)
func (_Contract *ContractFilterer) FilterRedelegateStarted(opts *bind.FilterOpts) (*ContractRedelegateStartedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RedelegateStarted")
	if err != nil {
		return nil, err
	}
	return &ContractRedelegateStartedIterator{contract: _Contract.contract, event: "RedelegateStarted", logs: logs, sub: sub}, nil
}

// WatchRedelegateStarted is a free log subscription operation binding the contract event 0x9b962edd2f58563e42e9bbcd7f7e2062e70d2c6677fcfc12dc04c4982294af6a.
//
// Solidity: event RedelegateStarted(address _sender, address _from, address _to, uint256 _amt)
func (_Contract *ContractFilterer) WatchRedelegateStarted(opts *bind.WatchOpts, sink chan<- *ContractRedelegateStarted) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RedelegateStarted")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRedelegateStarted)
				if err := _Contract.contract.UnpackLog(event, "RedelegateStarted", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRedelegateStarted is a log parse operation binding the contract event 0x9b962edd2f58563e42e9bbcd7f7e2062e70d2c6677fcfc12dc04c4982294af6a.
//
// Solidity: event RedelegateStarted(address _sender, address _from, address _to, uint256 _amt)
func (_Contract *ContractFilterer) ParseRedelegateStarted(log types.Log) (*ContractRedelegateStarted, error) {
	event := new(ContractRedelegateStarted)
	if err := _Contract.contract.UnpackLog(event, "RedelegateStarted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRewardSuppliedIterator is returned from FilterRewardSupplied and is used to iterate over the raw logs and unpacked data for RewardSupplied events raised by the Contract contract.
type ContractRewardSuppliedIterator struct {
	Event *ContractRewardSupplied // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRewardSuppliedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRewardSupplied)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRewardSupplied)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRewardSuppliedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRewardSuppliedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRewardSupplied represents a RewardSupplied event raised by the Contract contract.
type ContractRewardSupplied struct {
	Vault common.Address
	Token common.Address
	Amt   *big.Int
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterRewardSupplied is a free log retrieval operation binding the contract event 0x75f899a4c93beaef4ceef04dcf09b52b95c2f6d76cc2f366b059f3f6ab165909.
//
// Solidity: event RewardSupplied(address indexed _vault, address indexed _token, uint256 _amt)
func (_Contract *ContractFilterer) FilterRewardSupplied(opts *bind.FilterOpts, _vault []common.Address, _token []common.Address) (*ContractRewardSuppliedIterator, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}
	var _tokenRule []interface{}
	for _, _tokenItem := range _token {
		_tokenRule = append(_tokenRule, _tokenItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RewardSupplied", _vaultRule, _tokenRule)
	if err != nil {
		return nil, err
	}
	return &ContractRewardSuppliedIterator{contract: _Contract.contract, event: "RewardSupplied", logs: logs, sub: sub}, nil
}

// WatchRewardSupplied is a free log subscription operation binding the contract event 0x75f899a4c93beaef4ceef04dcf09b52b95c2f6d76cc2f366b059f3f6ab165909.
//
// Solidity: event RewardSupplied(address indexed _vault, address indexed _token, uint256 _amt)
func (_Contract *ContractFilterer) WatchRewardSupplied(opts *bind.WatchOpts, sink chan<- *ContractRewardSupplied, _vault []common.Address, _token []common.Address) (event.Subscription, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}
	var _tokenRule []interface{}
	for _, _tokenItem := range _token {
		_tokenRule = append(_tokenRule, _tokenItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RewardSupplied", _vaultRule, _tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRewardSupplied)
				if err := _Contract.contract.UnpackLog(event, "RewardSupplied", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRewardSupplied is a log parse operation binding the contract event 0x75f899a4c93beaef4ceef04dcf09b52b95c2f6d76cc2f366b059f3f6ab165909.
//
// Solidity: event RewardSupplied(address indexed _vault, address indexed _token, uint256 _amt)
func (_Contract *ContractFilterer) ParseRewardSupplied(log types.Log) (*ContractRewardSupplied, error) {
	event := new(ContractRewardSupplied)
	if err := _Contract.contract.UnpackLog(event, "RewardSupplied", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRewardTokenNotSupportedIterator is returned from FilterRewardTokenNotSupported and is used to iterate over the raw logs and unpacked data for RewardTokenNotSupported events raised by the Contract contract.
type ContractRewardTokenNotSupportedIterator struct {
	Event *ContractRewardTokenNotSupported // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRewardTokenNotSupportedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRewardTokenNotSupported)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRewardTokenNotSupported)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRewardTokenNotSupportedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRewardTokenNotSupportedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRewardTokenNotSupported represents a RewardTokenNotSupported event raised by the Contract contract.
type ContractRewardTokenNotSupported struct {
	Token common.Address
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterRewardTokenNotSupported is a free log retrieval operation binding the contract event 0x97ae829a24746c7eadb50a0698ad54133086676ad079ea8a06dee26fc2ef29a3.
//
// Solidity: event RewardTokenNotSupported(address _token)
func (_Contract *ContractFilterer) FilterRewardTokenNotSupported(opts *bind.FilterOpts) (*ContractRewardTokenNotSupportedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RewardTokenNotSupported")
	if err != nil {
		return nil, err
	}
	return &ContractRewardTokenNotSupportedIterator{contract: _Contract.contract, event: "RewardTokenNotSupported", logs: logs, sub: sub}, nil
}

// WatchRewardTokenNotSupported is a free log subscription operation binding the contract event 0x97ae829a24746c7eadb50a0698ad54133086676ad079ea8a06dee26fc2ef29a3.
//
// Solidity: event RewardTokenNotSupported(address _token)
func (_Contract *ContractFilterer) WatchRewardTokenNotSupported(opts *bind.WatchOpts, sink chan<- *ContractRewardTokenNotSupported) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RewardTokenNotSupported")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRewardTokenNotSupported)
				if err := _Contract.contract.UnpackLog(event, "RewardTokenNotSupported", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRewardTokenNotSupported is a log parse operation binding the contract event 0x97ae829a24746c7eadb50a0698ad54133086676ad079ea8a06dee26fc2ef29a3.
//
// Solidity: event RewardTokenNotSupported(address _token)
func (_Contract *ContractFilterer) ParseRewardTokenNotSupported(log types.Log) (*ContractRewardTokenNotSupported, error) {
	event := new(ContractRewardTokenNotSupported)
	if err := _Contract.contract.UnpackLog(event, "RewardTokenNotSupported", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRewardsDurationUpdatedIterator is returned from FilterRewardsDurationUpdated and is used to iterate over the raw logs and unpacked data for RewardsDurationUpdated events raised by the Contract contract.
type ContractRewardsDurationUpdatedIterator struct {
	Event *ContractRewardsDurationUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRewardsDurationUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRewardsDurationUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRewardsDurationUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRewardsDurationUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRewardsDurationUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRewardsDurationUpdated represents a RewardsDurationUpdated event raised by the Contract contract.
type ContractRewardsDurationUpdated struct {
	Sender      common.Address
	OldDuration *big.Int
	NewDuration *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterRewardsDurationUpdated is a free log retrieval operation binding the contract event 0x5010042fbbde5830368b15f9875f904d7611dcd3f3efaa3f4469398250c84aaa.
//
// Solidity: event RewardsDurationUpdated(address _sender, uint256 _oldDuration, uint256 _newDuration)
func (_Contract *ContractFilterer) FilterRewardsDurationUpdated(opts *bind.FilterOpts) (*ContractRewardsDurationUpdatedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RewardsDurationUpdated")
	if err != nil {
		return nil, err
	}
	return &ContractRewardsDurationUpdatedIterator{contract: _Contract.contract, event: "RewardsDurationUpdated", logs: logs, sub: sub}, nil
}

// WatchRewardsDurationUpdated is a free log subscription operation binding the contract event 0x5010042fbbde5830368b15f9875f904d7611dcd3f3efaa3f4469398250c84aaa.
//
// Solidity: event RewardsDurationUpdated(address _sender, uint256 _oldDuration, uint256 _newDuration)
func (_Contract *ContractFilterer) WatchRewardsDurationUpdated(opts *bind.WatchOpts, sink chan<- *ContractRewardsDurationUpdated) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RewardsDurationUpdated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRewardsDurationUpdated)
				if err := _Contract.contract.UnpackLog(event, "RewardsDurationUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRewardsDurationUpdated is a log parse operation binding the contract event 0x5010042fbbde5830368b15f9875f904d7611dcd3f3efaa3f4469398250c84aaa.
//
// Solidity: event RewardsDurationUpdated(address _sender, uint256 _oldDuration, uint256 _newDuration)
func (_Contract *ContractFilterer) ParseRewardsDurationUpdated(log types.Log) (*ContractRewardsDurationUpdated, error) {
	event := new(ContractRewardsDurationUpdated)
	if err := _Contract.contract.UnpackLog(event, "RewardsDurationUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRoleAdminChangedIterator is returned from FilterRoleAdminChanged and is used to iterate over the raw logs and unpacked data for RoleAdminChanged events raised by the Contract contract.
type ContractRoleAdminChangedIterator struct {
	Event *ContractRoleAdminChanged // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRoleAdminChangedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRoleAdminChanged)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRoleAdminChanged)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRoleAdminChangedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRoleAdminChangedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRoleAdminChanged represents a RoleAdminChanged event raised by the Contract contract.
type ContractRoleAdminChanged struct {
	Role              [32]byte
	PreviousAdminRole [32]byte
	NewAdminRole      [32]byte
	Raw               types.Log // Blockchain specific contextual infos
}

// FilterRoleAdminChanged is a free log retrieval operation binding the contract event 0xbd79b86ffe0ab8e8776151514217cd7cacd52c909f66475c3af44e129f0b00ff.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (_Contract *ContractFilterer) FilterRoleAdminChanged(opts *bind.FilterOpts, role [][32]byte, previousAdminRole [][32]byte, newAdminRole [][32]byte) (*ContractRoleAdminChangedIterator, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var previousAdminRoleRule []interface{}
	for _, previousAdminRoleItem := range previousAdminRole {
		previousAdminRoleRule = append(previousAdminRoleRule, previousAdminRoleItem)
	}
	var newAdminRoleRule []interface{}
	for _, newAdminRoleItem := range newAdminRole {
		newAdminRoleRule = append(newAdminRoleRule, newAdminRoleItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RoleAdminChanged", roleRule, previousAdminRoleRule, newAdminRoleRule)
	if err != nil {
		return nil, err
	}
	return &ContractRoleAdminChangedIterator{contract: _Contract.contract, event: "RoleAdminChanged", logs: logs, sub: sub}, nil
}

// WatchRoleAdminChanged is a free log subscription operation binding the contract event 0xbd79b86ffe0ab8e8776151514217cd7cacd52c909f66475c3af44e129f0b00ff.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (_Contract *ContractFilterer) WatchRoleAdminChanged(opts *bind.WatchOpts, sink chan<- *ContractRoleAdminChanged, role [][32]byte, previousAdminRole [][32]byte, newAdminRole [][32]byte) (event.Subscription, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var previousAdminRoleRule []interface{}
	for _, previousAdminRoleItem := range previousAdminRole {
		previousAdminRoleRule = append(previousAdminRoleRule, previousAdminRoleItem)
	}
	var newAdminRoleRule []interface{}
	for _, newAdminRoleItem := range newAdminRole {
		newAdminRoleRule = append(newAdminRoleRule, newAdminRoleItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RoleAdminChanged", roleRule, previousAdminRoleRule, newAdminRoleRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRoleAdminChanged)
				if err := _Contract.contract.UnpackLog(event, "RoleAdminChanged", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRoleAdminChanged is a log parse operation binding the contract event 0xbd79b86ffe0ab8e8776151514217cd7cacd52c909f66475c3af44e129f0b00ff.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (_Contract *ContractFilterer) ParseRoleAdminChanged(log types.Log) (*ContractRoleAdminChanged, error) {
	event := new(ContractRoleAdminChanged)
	if err := _Contract.contract.UnpackLog(event, "RoleAdminChanged", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRoleGrantedIterator is returned from FilterRoleGranted and is used to iterate over the raw logs and unpacked data for RoleGranted events raised by the Contract contract.
type ContractRoleGrantedIterator struct {
	Event *ContractRoleGranted // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRoleGrantedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRoleGranted)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRoleGranted)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRoleGrantedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRoleGrantedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRoleGranted represents a RoleGranted event raised by the Contract contract.
type ContractRoleGranted struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterRoleGranted is a free log retrieval operation binding the contract event 0x2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (_Contract *ContractFilterer) FilterRoleGranted(opts *bind.FilterOpts, role [][32]byte, account []common.Address, sender []common.Address) (*ContractRoleGrantedIterator, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RoleGranted", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return &ContractRoleGrantedIterator{contract: _Contract.contract, event: "RoleGranted", logs: logs, sub: sub}, nil
}

// WatchRoleGranted is a free log subscription operation binding the contract event 0x2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (_Contract *ContractFilterer) WatchRoleGranted(opts *bind.WatchOpts, sink chan<- *ContractRoleGranted, role [][32]byte, account []common.Address, sender []common.Address) (event.Subscription, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RoleGranted", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRoleGranted)
				if err := _Contract.contract.UnpackLog(event, "RoleGranted", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRoleGranted is a log parse operation binding the contract event 0x2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (_Contract *ContractFilterer) ParseRoleGranted(log types.Log) (*ContractRoleGranted, error) {
	event := new(ContractRoleGranted)
	if err := _Contract.contract.UnpackLog(event, "RoleGranted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRoleRevokedIterator is returned from FilterRoleRevoked and is used to iterate over the raw logs and unpacked data for RoleRevoked events raised by the Contract contract.
type ContractRoleRevokedIterator struct {
	Event *ContractRoleRevoked // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractRoleRevokedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRoleRevoked)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractRoleRevoked)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractRoleRevokedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRoleRevokedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRoleRevoked represents a RoleRevoked event raised by the Contract contract.
type ContractRoleRevoked struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterRoleRevoked is a free log retrieval operation binding the contract event 0xf6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (_Contract *ContractFilterer) FilterRoleRevoked(opts *bind.FilterOpts, role [][32]byte, account []common.Address, sender []common.Address) (*ContractRoleRevokedIterator, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RoleRevoked", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return &ContractRoleRevokedIterator{contract: _Contract.contract, event: "RoleRevoked", logs: logs, sub: sub}, nil
}

// WatchRoleRevoked is a free log subscription operation binding the contract event 0xf6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (_Contract *ContractFilterer) WatchRoleRevoked(opts *bind.WatchOpts, sink chan<- *ContractRoleRevoked, role [][32]byte, account []common.Address, sender []common.Address) (event.Subscription, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RoleRevoked", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRoleRevoked)
				if err := _Contract.contract.UnpackLog(event, "RoleRevoked", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRoleRevoked is a log parse operation binding the contract event 0xf6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (_Contract *ContractFilterer) ParseRoleRevoked(log types.Log) (*ContractRoleRevoked, error) {
	event := new(ContractRoleRevoked)
	if err := _Contract.contract.UnpackLog(event, "RoleRevoked", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractUnbondingDelegationCancelledIterator is returned from FilterUnbondingDelegationCancelled and is used to iterate over the raw logs and unpacked data for UnbondingDelegationCancelled events raised by the Contract contract.
type ContractUnbondingDelegationCancelledIterator struct {
	Event *ContractUnbondingDelegationCancelled // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractUnbondingDelegationCancelledIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractUnbondingDelegationCancelled)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractUnbondingDelegationCancelled)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractUnbondingDelegationCancelledIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractUnbondingDelegationCancelledIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractUnbondingDelegationCancelled represents a UnbondingDelegationCancelled event raised by the Contract contract.
type ContractUnbondingDelegationCancelled struct {
	Sender         common.Address
	Validator      common.Address
	Amt            *big.Int
	CreationHeight int64
	Raw            types.Log // Blockchain specific contextual infos
}

// FilterUnbondingDelegationCancelled is a free log retrieval operation binding the contract event 0xe3ecf9843321274e58a21dbefb22b3e4c9f3a2a2351bdcd762c48f4c20fc9e05.
//
// Solidity: event UnbondingDelegationCancelled(address _sender, address indexed _validator, uint256 _amt, int64 _creationHeight)
func (_Contract *ContractFilterer) FilterUnbondingDelegationCancelled(opts *bind.FilterOpts, _validator []common.Address) (*ContractUnbondingDelegationCancelledIterator, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "UnbondingDelegationCancelled", _validatorRule)
	if err != nil {
		return nil, err
	}
	return &ContractUnbondingDelegationCancelledIterator{contract: _Contract.contract, event: "UnbondingDelegationCancelled", logs: logs, sub: sub}, nil
}

// WatchUnbondingDelegationCancelled is a free log subscription operation binding the contract event 0xe3ecf9843321274e58a21dbefb22b3e4c9f3a2a2351bdcd762c48f4c20fc9e05.
//
// Solidity: event UnbondingDelegationCancelled(address _sender, address indexed _validator, uint256 _amt, int64 _creationHeight)
func (_Contract *ContractFilterer) WatchUnbondingDelegationCancelled(opts *bind.WatchOpts, sink chan<- *ContractUnbondingDelegationCancelled, _validator []common.Address) (event.Subscription, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "UnbondingDelegationCancelled", _validatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractUnbondingDelegationCancelled)
				if err := _Contract.contract.UnpackLog(event, "UnbondingDelegationCancelled", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseUnbondingDelegationCancelled is a log parse operation binding the contract event 0xe3ecf9843321274e58a21dbefb22b3e4c9f3a2a2351bdcd762c48f4c20fc9e05.
//
// Solidity: event UnbondingDelegationCancelled(address _sender, address indexed _validator, uint256 _amt, int64 _creationHeight)
func (_Contract *ContractFilterer) ParseUnbondingDelegationCancelled(log types.Log) (*ContractUnbondingDelegationCancelled, error) {
	event := new(ContractUnbondingDelegationCancelled)
	if err := _Contract.contract.UnpackLog(event, "UnbondingDelegationCancelled", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractUndelegatedIterator is returned from FilterUndelegated and is used to iterate over the raw logs and unpacked data for Undelegated events raised by the Contract contract.
type ContractUndelegatedIterator struct {
	Event *ContractUndelegated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractUndelegatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractUndelegated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractUndelegated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractUndelegatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractUndelegatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractUndelegated represents a Undelegated event raised by the Contract contract.
type ContractUndelegated struct {
	Sender    common.Address
	Validator common.Address
	Amt       *big.Int
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterUndelegated is a free log retrieval operation binding the contract event 0x4d10bd049775c77bd7f255195afba5088028ecb3c7c277d393ccff7934f2f92c.
//
// Solidity: event Undelegated(address _sender, address _validator, uint256 _amt)
func (_Contract *ContractFilterer) FilterUndelegated(opts *bind.FilterOpts) (*ContractUndelegatedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Undelegated")
	if err != nil {
		return nil, err
	}
	return &ContractUndelegatedIterator{contract: _Contract.contract, event: "Undelegated", logs: logs, sub: sub}, nil
}

// WatchUndelegated is a free log subscription operation binding the contract event 0x4d10bd049775c77bd7f255195afba5088028ecb3c7c277d393ccff7934f2f92c.
//
// Solidity: event Undelegated(address _sender, address _validator, uint256 _amt)
func (_Contract *ContractFilterer) WatchUndelegated(opts *bind.WatchOpts, sink chan<- *ContractUndelegated) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Undelegated")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractUndelegated)
				if err := _Contract.contract.UnpackLog(event, "Undelegated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseUndelegated is a log parse operation binding the contract event 0x4d10bd049775c77bd7f255195afba5088028ecb3c7c277d393ccff7934f2f92c.
//
// Solidity: event Undelegated(address _sender, address _validator, uint256 _amt)
func (_Contract *ContractFilterer) ParseUndelegated(log types.Log) (*ContractUndelegated, error) {
	event := new(ContractUndelegated)
	if err := _Contract.contract.UnpackLog(event, "Undelegated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractUpgradedIterator is returned from FilterUpgraded and is used to iterate over the raw logs and unpacked data for Upgraded events raised by the Contract contract.
type ContractUpgradedIterator struct {
	Event *ContractUpgraded // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractUpgradedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractUpgraded)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractUpgraded)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractUpgradedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractUpgradedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractUpgraded represents a Upgraded event raised by the Contract contract.
type ContractUpgraded struct {
	Implementation common.Address
	Raw            types.Log // Blockchain specific contextual infos
}

// FilterUpgraded is a free log retrieval operation binding the contract event 0xbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b.
//
// Solidity: event Upgraded(address indexed implementation)
func (_Contract *ContractFilterer) FilterUpgraded(opts *bind.FilterOpts, implementation []common.Address) (*ContractUpgradedIterator, error) {

	var implementationRule []interface{}
	for _, implementationItem := range implementation {
		implementationRule = append(implementationRule, implementationItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Upgraded", implementationRule)
	if err != nil {
		return nil, err
	}
	return &ContractUpgradedIterator{contract: _Contract.contract, event: "Upgraded", logs: logs, sub: sub}, nil
}

// WatchUpgraded is a free log subscription operation binding the contract event 0xbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b.
//
// Solidity: event Upgraded(address indexed implementation)
func (_Contract *ContractFilterer) WatchUpgraded(opts *bind.WatchOpts, sink chan<- *ContractUpgraded, implementation []common.Address) (event.Subscription, error) {

	var implementationRule []interface{}
	for _, implementationItem := range implementation {
		implementationRule = append(implementationRule, implementationItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Upgraded", implementationRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractUpgraded)
				if err := _Contract.contract.UnpackLog(event, "Upgraded", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseUpgraded is a log parse operation binding the contract event 0xbc7cd75a20ee27fd9adebab32041f755214dbc6bffa90cc0225b39da2e5c2d3b.
//
// Solidity: event Upgraded(address indexed implementation)
func (_Contract *ContractFilterer) ParseUpgraded(log types.Log) (*ContractUpgraded, error) {
	event := new(ContractUpgraded)
	if err := _Contract.contract.UnpackLog(event, "Upgraded", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractValidatorHarvestedIterator is returned from FilterValidatorHarvested and is used to iterate over the raw logs and unpacked data for ValidatorHarvested events raised by the Contract contract.
type ContractValidatorHarvestedIterator struct {
	Event *ContractValidatorHarvested // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractValidatorHarvestedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractValidatorHarvested)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractValidatorHarvested)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractValidatorHarvestedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractValidatorHarvestedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractValidatorHarvested represents a ValidatorHarvested event raised by the Contract contract.
type ContractValidatorHarvested struct {
	Sender    common.Address
	Validator common.Address
	BgtAmt    *big.Int
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterValidatorHarvested is a free log retrieval operation binding the contract event 0xef1d70cf11a4435cc90aa72c3fdca697323d02cfa4f78630a27183bb7c85f747.
//
// Solidity: event ValidatorHarvested(address _sender, address indexed _validator, uint256 _bgtAmt)
func (_Contract *ContractFilterer) FilterValidatorHarvested(opts *bind.FilterOpts, _validator []common.Address) (*ContractValidatorHarvestedIterator, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorHarvested", _validatorRule)
	if err != nil {
		return nil, err
	}
	return &ContractValidatorHarvestedIterator{contract: _Contract.contract, event: "ValidatorHarvested", logs: logs, sub: sub}, nil
}

// WatchValidatorHarvested is a free log subscription operation binding the contract event 0xef1d70cf11a4435cc90aa72c3fdca697323d02cfa4f78630a27183bb7c85f747.
//
// Solidity: event ValidatorHarvested(address _sender, address indexed _validator, uint256 _bgtAmt)
func (_Contract *ContractFilterer) WatchValidatorHarvested(opts *bind.WatchOpts, sink chan<- *ContractValidatorHarvested, _validator []common.Address) (event.Subscription, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorHarvested", _validatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractValidatorHarvested)
				if err := _Contract.contract.UnpackLog(event, "ValidatorHarvested", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseValidatorHarvested is a log parse operation binding the contract event 0xef1d70cf11a4435cc90aa72c3fdca697323d02cfa4f78630a27183bb7c85f747.
//
// Solidity: event ValidatorHarvested(address _sender, address indexed _validator, uint256 _bgtAmt)
func (_Contract *ContractFilterer) ParseValidatorHarvested(log types.Log) (*ContractValidatorHarvested, error) {
	event := new(ContractValidatorHarvested)
	if err := _Contract.contract.UnpackLog(event, "ValidatorHarvested", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractValidatorReplacedIterator is returned from FilterValidatorReplaced and is used to iterate over the raw logs and unpacked data for ValidatorReplaced events raised by the Contract contract.
type ContractValidatorReplacedIterator struct {
	Event *ContractValidatorReplaced // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractValidatorReplacedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractValidatorReplaced)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractValidatorReplaced)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractValidatorReplacedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractValidatorReplacedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractValidatorReplaced represents a ValidatorReplaced event raised by the Contract contract.
type ContractValidatorReplaced struct {
	Sender  common.Address
	Current common.Address
	New     common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterValidatorReplaced is a free log retrieval operation binding the contract event 0x1f423afc69fd97f334c3f2d61d3807dde8a49fdd952c66b5f894a470359350ba.
//
// Solidity: event ValidatorReplaced(address _sender, address _current, address _new)
func (_Contract *ContractFilterer) FilterValidatorReplaced(opts *bind.FilterOpts) (*ContractValidatorReplacedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorReplaced")
	if err != nil {
		return nil, err
	}
	return &ContractValidatorReplacedIterator{contract: _Contract.contract, event: "ValidatorReplaced", logs: logs, sub: sub}, nil
}

// WatchValidatorReplaced is a free log subscription operation binding the contract event 0x1f423afc69fd97f334c3f2d61d3807dde8a49fdd952c66b5f894a470359350ba.
//
// Solidity: event ValidatorReplaced(address _sender, address _current, address _new)
func (_Contract *ContractFilterer) WatchValidatorReplaced(opts *bind.WatchOpts, sink chan<- *ContractValidatorReplaced) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorReplaced")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractValidatorReplaced)
				if err := _Contract.contract.UnpackLog(event, "ValidatorReplaced", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseValidatorReplaced is a log parse operation binding the contract event 0x1f423afc69fd97f334c3f2d61d3807dde8a49fdd952c66b5f894a470359350ba.
//
// Solidity: event ValidatorReplaced(address _sender, address _current, address _new)
func (_Contract *ContractFilterer) ParseValidatorReplaced(log types.Log) (*ContractValidatorReplaced, error) {
	event := new(ContractValidatorReplaced)
	if err := _Contract.contract.UnpackLog(event, "ValidatorReplaced", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractValidatorSetUpdatedIterator is returned from FilterValidatorSetUpdated and is used to iterate over the raw logs and unpacked data for ValidatorSetUpdated events raised by the Contract contract.
type ContractValidatorSetUpdatedIterator struct {
	Event *ContractValidatorSetUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractValidatorSetUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractValidatorSetUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractValidatorSetUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractValidatorSetUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractValidatorSetUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractValidatorSetUpdated represents a ValidatorSetUpdated event raised by the Contract contract.
type ContractValidatorSetUpdated struct {
	Old    common.Address
	New    common.Address
	Action uint8
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterValidatorSetUpdated is a free log retrieval operation binding the contract event 0x5205f12cc78458feadf5eb48b4f94bf636b337e3d4508e6ff6ec7b97c5b9d869.
//
// Solidity: event ValidatorSetUpdated(address indexed _old, address indexed _new, uint8 _action)
func (_Contract *ContractFilterer) FilterValidatorSetUpdated(opts *bind.FilterOpts, _old []common.Address, _new []common.Address) (*ContractValidatorSetUpdatedIterator, error) {

	var _oldRule []interface{}
	for _, _oldItem := range _old {
		_oldRule = append(_oldRule, _oldItem)
	}
	var _newRule []interface{}
	for _, _newItem := range _new {
		_newRule = append(_newRule, _newItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorSetUpdated", _oldRule, _newRule)
	if err != nil {
		return nil, err
	}
	return &ContractValidatorSetUpdatedIterator{contract: _Contract.contract, event: "ValidatorSetUpdated", logs: logs, sub: sub}, nil
}

// WatchValidatorSetUpdated is a free log subscription operation binding the contract event 0x5205f12cc78458feadf5eb48b4f94bf636b337e3d4508e6ff6ec7b97c5b9d869.
//
// Solidity: event ValidatorSetUpdated(address indexed _old, address indexed _new, uint8 _action)
func (_Contract *ContractFilterer) WatchValidatorSetUpdated(opts *bind.WatchOpts, sink chan<- *ContractValidatorSetUpdated, _old []common.Address, _new []common.Address) (event.Subscription, error) {

	var _oldRule []interface{}
	for _, _oldItem := range _old {
		_oldRule = append(_oldRule, _oldItem)
	}
	var _newRule []interface{}
	for _, _newItem := range _new {
		_newRule = append(_newRule, _newItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorSetUpdated", _oldRule, _newRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractValidatorSetUpdated)
				if err := _Contract.contract.UnpackLog(event, "ValidatorSetUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseValidatorSetUpdated is a log parse operation binding the contract event 0x5205f12cc78458feadf5eb48b4f94bf636b337e3d4508e6ff6ec7b97c5b9d869.
//
// Solidity: event ValidatorSetUpdated(address indexed _old, address indexed _new, uint8 _action)
func (_Contract *ContractFilterer) ParseValidatorSetUpdated(log types.Log) (*ContractValidatorSetUpdated, error) {
	event := new(ContractValidatorSetUpdated)
	if err := _Contract.contract.UnpackLog(event, "ValidatorSetUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractValidatorsAddedIterator is returned from FilterValidatorsAdded and is used to iterate over the raw logs and unpacked data for ValidatorsAdded events raised by the Contract contract.
type ContractValidatorsAddedIterator struct {
	Event *ContractValidatorsAdded // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractValidatorsAddedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractValidatorsAdded)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractValidatorsAdded)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractValidatorsAddedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractValidatorsAddedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractValidatorsAdded represents a ValidatorsAdded event raised by the Contract contract.
type ContractValidatorsAdded struct {
	Sender     common.Address
	Validators []common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterValidatorsAdded is a free log retrieval operation binding the contract event 0x00068ca4f443319b0b9c7888d3d1f628efbb2fe31efe99becc338bffb6d35483.
//
// Solidity: event ValidatorsAdded(address _sender, address[] _validators)
func (_Contract *ContractFilterer) FilterValidatorsAdded(opts *bind.FilterOpts) (*ContractValidatorsAddedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorsAdded")
	if err != nil {
		return nil, err
	}
	return &ContractValidatorsAddedIterator{contract: _Contract.contract, event: "ValidatorsAdded", logs: logs, sub: sub}, nil
}

// WatchValidatorsAdded is a free log subscription operation binding the contract event 0x00068ca4f443319b0b9c7888d3d1f628efbb2fe31efe99becc338bffb6d35483.
//
// Solidity: event ValidatorsAdded(address _sender, address[] _validators)
func (_Contract *ContractFilterer) WatchValidatorsAdded(opts *bind.WatchOpts, sink chan<- *ContractValidatorsAdded) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorsAdded")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractValidatorsAdded)
				if err := _Contract.contract.UnpackLog(event, "ValidatorsAdded", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseValidatorsAdded is a log parse operation binding the contract event 0x00068ca4f443319b0b9c7888d3d1f628efbb2fe31efe99becc338bffb6d35483.
//
// Solidity: event ValidatorsAdded(address _sender, address[] _validators)
func (_Contract *ContractFilterer) ParseValidatorsAdded(log types.Log) (*ContractValidatorsAdded, error) {
	event := new(ContractValidatorsAdded)
	if err := _Contract.contract.UnpackLog(event, "ValidatorsAdded", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractValidatorsRemovedIterator is returned from FilterValidatorsRemoved and is used to iterate over the raw logs and unpacked data for ValidatorsRemoved events raised by the Contract contract.
type ContractValidatorsRemovedIterator struct {
	Event *ContractValidatorsRemoved // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractValidatorsRemovedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractValidatorsRemoved)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractValidatorsRemoved)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractValidatorsRemovedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractValidatorsRemovedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractValidatorsRemoved represents a ValidatorsRemoved event raised by the Contract contract.
type ContractValidatorsRemoved struct {
	Sender     common.Address
	Validators []common.Address
	Raw        types.Log // Blockchain specific contextual infos
}

// FilterValidatorsRemoved is a free log retrieval operation binding the contract event 0xe2321af6849f29db00de5f46d1aeeab2f5f9fb5818195ee180aa8c2bc5b4b498.
//
// Solidity: event ValidatorsRemoved(address _sender, address[] _validators)
func (_Contract *ContractFilterer) FilterValidatorsRemoved(opts *bind.FilterOpts) (*ContractValidatorsRemovedIterator, error) {

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorsRemoved")
	if err != nil {
		return nil, err
	}
	return &ContractValidatorsRemovedIterator{contract: _Contract.contract, event: "ValidatorsRemoved", logs: logs, sub: sub}, nil
}

// WatchValidatorsRemoved is a free log subscription operation binding the contract event 0xe2321af6849f29db00de5f46d1aeeab2f5f9fb5818195ee180aa8c2bc5b4b498.
//
// Solidity: event ValidatorsRemoved(address _sender, address[] _validators)
func (_Contract *ContractFilterer) WatchValidatorsRemoved(opts *bind.WatchOpts, sink chan<- *ContractValidatorsRemoved) (event.Subscription, error) {

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorsRemoved")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractValidatorsRemoved)
				if err := _Contract.contract.UnpackLog(event, "ValidatorsRemoved", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseValidatorsRemoved is a log parse operation binding the contract event 0xe2321af6849f29db00de5f46d1aeeab2f5f9fb5818195ee180aa8c2bc5b4b498.
//
// Solidity: event ValidatorsRemoved(address _sender, address[] _validators)
func (_Contract *ContractFilterer) ParseValidatorsRemoved(log types.Log) (*ContractValidatorsRemoved, error) {
	event := new(ContractValidatorsRemoved)
	if err := _Contract.contract.UnpackLog(event, "ValidatorsRemoved", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractVaultHarvestedIterator is returned from FilterVaultHarvested and is used to iterate over the raw logs and unpacked data for VaultHarvested events raised by the Contract contract.
type ContractVaultHarvestedIterator struct {
	Event *ContractVaultHarvested // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractVaultHarvestedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractVaultHarvested)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractVaultHarvested)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractVaultHarvestedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractVaultHarvestedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractVaultHarvested represents a VaultHarvested event raised by the Contract contract.
type ContractVaultHarvested struct {
	Sender common.Address
	Pool   common.Address
	Vault  common.Address
	BgtAmt *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterVaultHarvested is a free log retrieval operation binding the contract event 0x546659bfb7e6ea18193d3711c72bc25c799442cc60749bb9d98bd4c56ca36f27.
//
// Solidity: event VaultHarvested(address _sender, address indexed _pool, address indexed _vault, uint256 _bgtAmt)
func (_Contract *ContractFilterer) FilterVaultHarvested(opts *bind.FilterOpts, _pool []common.Address, _vault []common.Address) (*ContractVaultHarvestedIterator, error) {

	var _poolRule []interface{}
	for _, _poolItem := range _pool {
		_poolRule = append(_poolRule, _poolItem)
	}
	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "VaultHarvested", _poolRule, _vaultRule)
	if err != nil {
		return nil, err
	}
	return &ContractVaultHarvestedIterator{contract: _Contract.contract, event: "VaultHarvested", logs: logs, sub: sub}, nil
}

// WatchVaultHarvested is a free log subscription operation binding the contract event 0x546659bfb7e6ea18193d3711c72bc25c799442cc60749bb9d98bd4c56ca36f27.
//
// Solidity: event VaultHarvested(address _sender, address indexed _pool, address indexed _vault, uint256 _bgtAmt)
func (_Contract *ContractFilterer) WatchVaultHarvested(opts *bind.WatchOpts, sink chan<- *ContractVaultHarvested, _pool []common.Address, _vault []common.Address) (event.Subscription, error) {

	var _poolRule []interface{}
	for _, _poolItem := range _pool {
		_poolRule = append(_poolRule, _poolItem)
	}
	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "VaultHarvested", _poolRule, _vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractVaultHarvested)
				if err := _Contract.contract.UnpackLog(event, "VaultHarvested", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseVaultHarvested is a log parse operation binding the contract event 0x546659bfb7e6ea18193d3711c72bc25c799442cc60749bb9d98bd4c56ca36f27.
//
// Solidity: event VaultHarvested(address _sender, address indexed _pool, address indexed _vault, uint256 _bgtAmt)
func (_Contract *ContractFilterer) ParseVaultHarvested(log types.Log) (*ContractVaultHarvested, error) {
	event := new(ContractVaultHarvested)
	if err := _Contract.contract.UnpackLog(event, "VaultHarvested", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractVaultWithdrawAddressUpdatedIterator is returned from FilterVaultWithdrawAddressUpdated and is used to iterate over the raw logs and unpacked data for VaultWithdrawAddressUpdated events raised by the Contract contract.
type ContractVaultWithdrawAddressUpdatedIterator struct {
	Event *ContractVaultWithdrawAddressUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractVaultWithdrawAddressUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractVaultWithdrawAddressUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractVaultWithdrawAddressUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractVaultWithdrawAddressUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractVaultWithdrawAddressUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractVaultWithdrawAddressUpdated represents a VaultWithdrawAddressUpdated event raised by the Contract contract.
type ContractVaultWithdrawAddressUpdated struct {
	Sender             common.Address
	RedVault           common.Address
	NewWithdrawAddress common.Address
	Raw                types.Log // Blockchain specific contextual infos
}

// FilterVaultWithdrawAddressUpdated is a free log retrieval operation binding the contract event 0x3f8c1733cb042ed4bca5a7398126a9978ab12de9b1d1ddaf35c3b107b1e7bf21.
//
// Solidity: event VaultWithdrawAddressUpdated(address _sender, address indexed _redVault, address _newWithdrawAddress)
func (_Contract *ContractFilterer) FilterVaultWithdrawAddressUpdated(opts *bind.FilterOpts, _redVault []common.Address) (*ContractVaultWithdrawAddressUpdatedIterator, error) {

	var _redVaultRule []interface{}
	for _, _redVaultItem := range _redVault {
		_redVaultRule = append(_redVaultRule, _redVaultItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "VaultWithdrawAddressUpdated", _redVaultRule)
	if err != nil {
		return nil, err
	}
	return &ContractVaultWithdrawAddressUpdatedIterator{contract: _Contract.contract, event: "VaultWithdrawAddressUpdated", logs: logs, sub: sub}, nil
}

// WatchVaultWithdrawAddressUpdated is a free log subscription operation binding the contract event 0x3f8c1733cb042ed4bca5a7398126a9978ab12de9b1d1ddaf35c3b107b1e7bf21.
//
// Solidity: event VaultWithdrawAddressUpdated(address _sender, address indexed _redVault, address _newWithdrawAddress)
func (_Contract *ContractFilterer) WatchVaultWithdrawAddressUpdated(opts *bind.WatchOpts, sink chan<- *ContractVaultWithdrawAddressUpdated, _redVault []common.Address) (event.Subscription, error) {

	var _redVaultRule []interface{}
	for _, _redVaultItem := range _redVault {
		_redVaultRule = append(_redVaultRule, _redVaultItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "VaultWithdrawAddressUpdated", _redVaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractVaultWithdrawAddressUpdated)
				if err := _Contract.contract.UnpackLog(event, "VaultWithdrawAddressUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseVaultWithdrawAddressUpdated is a log parse operation binding the contract event 0x3f8c1733cb042ed4bca5a7398126a9978ab12de9b1d1ddaf35c3b107b1e7bf21.
//
// Solidity: event VaultWithdrawAddressUpdated(address _sender, address indexed _redVault, address _newWithdrawAddress)
func (_Contract *ContractFilterer) ParseVaultWithdrawAddressUpdated(log types.Log) (*ContractVaultWithdrawAddressUpdated, error) {
	event := new(ContractVaultWithdrawAddressUpdated)
	if err := _Contract.contract.UnpackLog(event, "VaultWithdrawAddressUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractWhiteListedRewardTokensUpdatedIterator is returned from FilterWhiteListedRewardTokensUpdated and is used to iterate over the raw logs and unpacked data for WhiteListedRewardTokensUpdated events raised by the Contract contract.
type ContractWhiteListedRewardTokensUpdatedIterator struct {
	Event *ContractWhiteListedRewardTokensUpdated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *ContractWhiteListedRewardTokensUpdatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractWhiteListedRewardTokensUpdated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(ContractWhiteListedRewardTokensUpdated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *ContractWhiteListedRewardTokensUpdatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractWhiteListedRewardTokensUpdatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractWhiteListedRewardTokensUpdated represents a WhiteListedRewardTokensUpdated event raised by the Contract contract.
type ContractWhiteListedRewardTokensUpdated struct {
	Sender         common.Address
	Token          common.Address
	WasWhitelisted bool
	IsWhitelisted  bool
	Raw            types.Log // Blockchain specific contextual infos
}

// FilterWhiteListedRewardTokensUpdated is a free log retrieval operation binding the contract event 0xdd01adaecf9dc9676b6096c7f319855230d8501da40b7b53c83f3c23d976f67f.
//
// Solidity: event WhiteListedRewardTokensUpdated(address _sender, address indexed _token, bool _wasWhitelisted, bool _isWhitelisted)
func (_Contract *ContractFilterer) FilterWhiteListedRewardTokensUpdated(opts *bind.FilterOpts, _token []common.Address) (*ContractWhiteListedRewardTokensUpdatedIterator, error) {

	var _tokenRule []interface{}
	for _, _tokenItem := range _token {
		_tokenRule = append(_tokenRule, _tokenItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "WhiteListedRewardTokensUpdated", _tokenRule)
	if err != nil {
		return nil, err
	}
	return &ContractWhiteListedRewardTokensUpdatedIterator{contract: _Contract.contract, event: "WhiteListedRewardTokensUpdated", logs: logs, sub: sub}, nil
}

// WatchWhiteListedRewardTokensUpdated is a free log subscription operation binding the contract event 0xdd01adaecf9dc9676b6096c7f319855230d8501da40b7b53c83f3c23d976f67f.
//
// Solidity: event WhiteListedRewardTokensUpdated(address _sender, address indexed _token, bool _wasWhitelisted, bool _isWhitelisted)
func (_Contract *ContractFilterer) WatchWhiteListedRewardTokensUpdated(opts *bind.WatchOpts, sink chan<- *ContractWhiteListedRewardTokensUpdated, _token []common.Address) (event.Subscription, error) {

	var _tokenRule []interface{}
	for _, _tokenItem := range _token {
		_tokenRule = append(_tokenRule, _tokenItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "WhiteListedRewardTokensUpdated", _tokenRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractWhiteListedRewardTokensUpdated)
				if err := _Contract.contract.UnpackLog(event, "WhiteListedRewardTokensUpdated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseWhiteListedRewardTokensUpdated is a log parse operation binding the contract event 0xdd01adaecf9dc9676b6096c7f319855230d8501da40b7b53c83f3c23d976f67f.
//
// Solidity: event WhiteListedRewardTokensUpdated(address _sender, address indexed _token, bool _wasWhitelisted, bool _isWhitelisted)
func (_Contract *ContractFilterer) ParseWhiteListedRewardTokensUpdated(log types.Log) (*ContractWhiteListedRewardTokensUpdated, error) {
	event := new(ContractWhiteListedRewardTokensUpdated)
	if err := _Contract.contract.UnpackLog(event, "WhiteListedRewardTokensUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
