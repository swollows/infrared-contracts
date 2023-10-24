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

// DataTypesToken is an auto generated low-level Go binding around an user-defined struct.
type DataTypesToken struct {
	TokenAddress common.Address
	Amount       *big.Int
}

// ContractMetaData contains all meta data concerning the Contract contract.
var ContractMetaData = &bind.MetaData{
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_rewardsPrecompileAddress\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_distributionPrecompileAddress\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_erc20PrecompileAddress\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_stakingPrecompileAddress\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"_bgtDenom\",\"type\":\"string\"},{\"internalType\":\"address\",\"name\":\"_admin\",\"type\":\"address\"},{\"internalType\":\"contractIERC20Mintable\",\"name\":\"_ibgt\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[],\"name\":\"AccessControlBadConfirmation\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"internalType\":\"bytes32\",\"name\":\"neededRole\",\"type\":\"bytes32\"}],\"name\":\"AccessControlUnauthorizedAccount\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"target\",\"type\":\"address\"}],\"name\":\"AddressEmptyCode\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"AddressInsufficientBalance\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"BeginRedelegateFailed\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"CancelUnbondingDelegationFailed\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"DelegationFailed\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"ERC20ModuleTransferFailed\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"FailedInnerCall\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"FailedToAddValidator\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"FaliedToRemoveValidator\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"token\",\"type\":\"address\"}],\"name\":\"SafeERC20FailedOperation\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"UndelegateFailed\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"}],\"name\":\"ValidatorAlreadyExists\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"}],\"name\":\"ValidatorDoesNotExist\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_vault\",\"type\":\"address\"}],\"name\":\"VaultNotSupported\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"ZeroAddress\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"ZeroAmount\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"ZeroString\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_vault\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"_amount\",\"type\":\"uint256\"}],\"name\":\"IBGTSupplied\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"}],\"name\":\"NewValidator\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_vault\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_pool\",\"type\":\"address\"}],\"name\":\"NewVault\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_vault\",\"type\":\"address\"}],\"name\":\"NewWrappedIBGTVault\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_vault\",\"type\":\"address\"},{\"components\":[{\"internalType\":\"address\",\"name\":\"tokenAddress\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"indexed\":false,\"internalType\":\"structDataTypes.Token[]\",\"name\":\"_rewardTokens\",\"type\":\"tuple[]\"}],\"name\":\"RewardsSupplied\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"previousAdminRole\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"newAdminRole\",\"type\":\"bytes32\"}],\"name\":\"RoleAdminChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"sender\",\"type\":\"address\"}],\"name\":\"RoleGranted\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"sender\",\"type\":\"address\"}],\"name\":\"RoleRevoked\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"}],\"name\":\"ValidatorRemoved\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_current\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_new\",\"type\":\"address\"}],\"name\":\"ValidatorReplaced\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"_old\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"_new\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"enumDataTypes.ValidatorSetAction\",\"name\":\"_action\",\"type\":\"uint8\"}],\"name\":\"ValidatorSetUpdated\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"DEFAULT_ADMIN_ROLE\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"DISTRIBUTION_PRECOMPILE\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"ERC20_PRECOMPILE\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"GOVERNANCE_ROLE\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"KEEPER_ROLE\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"REWARDS_PRECOMPILE\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"STAKING_PRECOMPILE_ADDRESS\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"_validators\",\"type\":\"address[]\"}],\"name\":\"addValidators\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_amount\",\"type\":\"uint256\"}],\"name\":\"beginRedelegate\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"bgtDenom\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_amount\",\"type\":\"uint256\"},{\"internalType\":\"int64\",\"name\":\"_creationHeigh\",\"type\":\"int64\"}],\"name\":\"cancelUnbondingDelegation\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_amount\",\"type\":\"uint256\"}],\"name\":\"delegate\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"}],\"name\":\"getRoleAdmin\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"grantRole\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"}],\"name\":\"harvestValidator\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_vaultAddress\",\"type\":\"address\"}],\"name\":\"harvestVault\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"hasRole\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"ibgt\",\"outputs\":[{\"internalType\":\"contractIERC20Mintable\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"infraredValidators\",\"outputs\":[{\"internalType\":\"address[]\",\"name\":\"_validators\",\"type\":\"address[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"}],\"name\":\"isInfraredValidator\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"_is\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_vault\",\"type\":\"address\"}],\"name\":\"isInfraredVault\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"_isVault\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_asset\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"_name\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"_symbol\",\"type\":\"string\"},{\"internalType\":\"address[]\",\"name\":\"_rewardTokens\",\"type\":\"address[]\"},{\"internalType\":\"address\",\"name\":\"_poolAddress\",\"type\":\"address\"}],\"name\":\"registerVault\",\"outputs\":[{\"internalType\":\"contractIInfraredVault\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"_validators\",\"type\":\"address[]\"}],\"name\":\"removeValidators\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"callerConfirmation\",\"type\":\"address\"}],\"name\":\"renounceRole\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_current\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_new\",\"type\":\"address\"}],\"name\":\"replaceValidator\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"revokeRole\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes4\",\"name\":\"interfaceId\",\"type\":\"bytes4\"}],\"name\":\"supportsInterface\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_validator\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"_amount\",\"type\":\"uint256\"}],\"name\":\"undelegate\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"contractIInfraredVault\",\"name\":\"_new\",\"type\":\"address\"},{\"internalType\":\"address[]\",\"name\":\"_rewardTokens\",\"type\":\"address[]\"}],\"name\":\"updateWIBGTVault\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_vaultAddress\",\"type\":\"address\"}],\"name\":\"vaultRegistry\",\"outputs\":[{\"internalType\":\"contractIInfraredVault\",\"name\":\"_vault\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"wrappedIBGTVault\",\"outputs\":[{\"internalType\":\"contractIInfraredVault\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]",
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

// DISTRIBUTIONPRECOMPILE is a free data retrieval call binding the contract method 0x2325b731.
//
// Solidity: function DISTRIBUTION_PRECOMPILE() view returns(address)
func (_Contract *ContractCaller) DISTRIBUTIONPRECOMPILE(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "DISTRIBUTION_PRECOMPILE")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// DISTRIBUTIONPRECOMPILE is a free data retrieval call binding the contract method 0x2325b731.
//
// Solidity: function DISTRIBUTION_PRECOMPILE() view returns(address)
func (_Contract *ContractSession) DISTRIBUTIONPRECOMPILE() (common.Address, error) {
	return _Contract.Contract.DISTRIBUTIONPRECOMPILE(&_Contract.CallOpts)
}

// DISTRIBUTIONPRECOMPILE is a free data retrieval call binding the contract method 0x2325b731.
//
// Solidity: function DISTRIBUTION_PRECOMPILE() view returns(address)
func (_Contract *ContractCallerSession) DISTRIBUTIONPRECOMPILE() (common.Address, error) {
	return _Contract.Contract.DISTRIBUTIONPRECOMPILE(&_Contract.CallOpts)
}

// ERC20PRECOMPILE is a free data retrieval call binding the contract method 0x8850c867.
//
// Solidity: function ERC20_PRECOMPILE() view returns(address)
func (_Contract *ContractCaller) ERC20PRECOMPILE(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "ERC20_PRECOMPILE")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// ERC20PRECOMPILE is a free data retrieval call binding the contract method 0x8850c867.
//
// Solidity: function ERC20_PRECOMPILE() view returns(address)
func (_Contract *ContractSession) ERC20PRECOMPILE() (common.Address, error) {
	return _Contract.Contract.ERC20PRECOMPILE(&_Contract.CallOpts)
}

// ERC20PRECOMPILE is a free data retrieval call binding the contract method 0x8850c867.
//
// Solidity: function ERC20_PRECOMPILE() view returns(address)
func (_Contract *ContractCallerSession) ERC20PRECOMPILE() (common.Address, error) {
	return _Contract.Contract.ERC20PRECOMPILE(&_Contract.CallOpts)
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

// REWARDSPRECOMPILE is a free data retrieval call binding the contract method 0xdfca03c9.
//
// Solidity: function REWARDS_PRECOMPILE() view returns(address)
func (_Contract *ContractCaller) REWARDSPRECOMPILE(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "REWARDS_PRECOMPILE")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// REWARDSPRECOMPILE is a free data retrieval call binding the contract method 0xdfca03c9.
//
// Solidity: function REWARDS_PRECOMPILE() view returns(address)
func (_Contract *ContractSession) REWARDSPRECOMPILE() (common.Address, error) {
	return _Contract.Contract.REWARDSPRECOMPILE(&_Contract.CallOpts)
}

// REWARDSPRECOMPILE is a free data retrieval call binding the contract method 0xdfca03c9.
//
// Solidity: function REWARDS_PRECOMPILE() view returns(address)
func (_Contract *ContractCallerSession) REWARDSPRECOMPILE() (common.Address, error) {
	return _Contract.Contract.REWARDSPRECOMPILE(&_Contract.CallOpts)
}

// STAKINGPRECOMPILEADDRESS is a free data retrieval call binding the contract method 0xabe412a5.
//
// Solidity: function STAKING_PRECOMPILE_ADDRESS() view returns(address)
func (_Contract *ContractCaller) STAKINGPRECOMPILEADDRESS(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "STAKING_PRECOMPILE_ADDRESS")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// STAKINGPRECOMPILEADDRESS is a free data retrieval call binding the contract method 0xabe412a5.
//
// Solidity: function STAKING_PRECOMPILE_ADDRESS() view returns(address)
func (_Contract *ContractSession) STAKINGPRECOMPILEADDRESS() (common.Address, error) {
	return _Contract.Contract.STAKINGPRECOMPILEADDRESS(&_Contract.CallOpts)
}

// STAKINGPRECOMPILEADDRESS is a free data retrieval call binding the contract method 0xabe412a5.
//
// Solidity: function STAKING_PRECOMPILE_ADDRESS() view returns(address)
func (_Contract *ContractCallerSession) STAKINGPRECOMPILEADDRESS() (common.Address, error) {
	return _Contract.Contract.STAKINGPRECOMPILEADDRESS(&_Contract.CallOpts)
}

// BgtDenom is a free data retrieval call binding the contract method 0x97d4171f.
//
// Solidity: function bgtDenom() view returns(string)
func (_Contract *ContractCaller) BgtDenom(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "bgtDenom")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// BgtDenom is a free data retrieval call binding the contract method 0x97d4171f.
//
// Solidity: function bgtDenom() view returns(string)
func (_Contract *ContractSession) BgtDenom() (string, error) {
	return _Contract.Contract.BgtDenom(&_Contract.CallOpts)
}

// BgtDenom is a free data retrieval call binding the contract method 0x97d4171f.
//
// Solidity: function bgtDenom() view returns(string)
func (_Contract *ContractCallerSession) BgtDenom() (string, error) {
	return _Contract.Contract.BgtDenom(&_Contract.CallOpts)
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

// IsInfraredValidator is a free data retrieval call binding the contract method 0x75f58651.
//
// Solidity: function isInfraredValidator(address _validator) view returns(bool _is)
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
// Solidity: function isInfraredValidator(address _validator) view returns(bool _is)
func (_Contract *ContractSession) IsInfraredValidator(_validator common.Address) (bool, error) {
	return _Contract.Contract.IsInfraredValidator(&_Contract.CallOpts, _validator)
}

// IsInfraredValidator is a free data retrieval call binding the contract method 0x75f58651.
//
// Solidity: function isInfraredValidator(address _validator) view returns(bool _is)
func (_Contract *ContractCallerSession) IsInfraredValidator(_validator common.Address) (bool, error) {
	return _Contract.Contract.IsInfraredValidator(&_Contract.CallOpts, _validator)
}

// IsInfraredVault is a free data retrieval call binding the contract method 0xbf988e27.
//
// Solidity: function isInfraredVault(address _vault) view returns(bool _isVault)
func (_Contract *ContractCaller) IsInfraredVault(opts *bind.CallOpts, _vault common.Address) (bool, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "isInfraredVault", _vault)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsInfraredVault is a free data retrieval call binding the contract method 0xbf988e27.
//
// Solidity: function isInfraredVault(address _vault) view returns(bool _isVault)
func (_Contract *ContractSession) IsInfraredVault(_vault common.Address) (bool, error) {
	return _Contract.Contract.IsInfraredVault(&_Contract.CallOpts, _vault)
}

// IsInfraredVault is a free data retrieval call binding the contract method 0xbf988e27.
//
// Solidity: function isInfraredVault(address _vault) view returns(bool _isVault)
func (_Contract *ContractCallerSession) IsInfraredVault(_vault common.Address) (bool, error) {
	return _Contract.Contract.IsInfraredVault(&_Contract.CallOpts, _vault)
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
// Solidity: function vaultRegistry(address _vaultAddress) view returns(address _vault)
func (_Contract *ContractCaller) VaultRegistry(opts *bind.CallOpts, _vaultAddress common.Address) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "vaultRegistry", _vaultAddress)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// VaultRegistry is a free data retrieval call binding the contract method 0x5487beb6.
//
// Solidity: function vaultRegistry(address _vaultAddress) view returns(address _vault)
func (_Contract *ContractSession) VaultRegistry(_vaultAddress common.Address) (common.Address, error) {
	return _Contract.Contract.VaultRegistry(&_Contract.CallOpts, _vaultAddress)
}

// VaultRegistry is a free data retrieval call binding the contract method 0x5487beb6.
//
// Solidity: function vaultRegistry(address _vaultAddress) view returns(address _vault)
func (_Contract *ContractCallerSession) VaultRegistry(_vaultAddress common.Address) (common.Address, error) {
	return _Contract.Contract.VaultRegistry(&_Contract.CallOpts, _vaultAddress)
}

// WrappedIBGTVault is a free data retrieval call binding the contract method 0x9c603236.
//
// Solidity: function wrappedIBGTVault() view returns(address)
func (_Contract *ContractCaller) WrappedIBGTVault(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "wrappedIBGTVault")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// WrappedIBGTVault is a free data retrieval call binding the contract method 0x9c603236.
//
// Solidity: function wrappedIBGTVault() view returns(address)
func (_Contract *ContractSession) WrappedIBGTVault() (common.Address, error) {
	return _Contract.Contract.WrappedIBGTVault(&_Contract.CallOpts)
}

// WrappedIBGTVault is a free data retrieval call binding the contract method 0x9c603236.
//
// Solidity: function wrappedIBGTVault() view returns(address)
func (_Contract *ContractCallerSession) WrappedIBGTVault() (common.Address, error) {
	return _Contract.Contract.WrappedIBGTVault(&_Contract.CallOpts)
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
// Solidity: function beginRedelegate(address _from, address _to, uint256 _amount) returns()
func (_Contract *ContractTransactor) BeginRedelegate(opts *bind.TransactOpts, _from common.Address, _to common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "beginRedelegate", _from, _to, _amount)
}

// BeginRedelegate is a paid mutator transaction binding the contract method 0xb3a8ae3b.
//
// Solidity: function beginRedelegate(address _from, address _to, uint256 _amount) returns()
func (_Contract *ContractSession) BeginRedelegate(_from common.Address, _to common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.BeginRedelegate(&_Contract.TransactOpts, _from, _to, _amount)
}

// BeginRedelegate is a paid mutator transaction binding the contract method 0xb3a8ae3b.
//
// Solidity: function beginRedelegate(address _from, address _to, uint256 _amount) returns()
func (_Contract *ContractTransactorSession) BeginRedelegate(_from common.Address, _to common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.BeginRedelegate(&_Contract.TransactOpts, _from, _to, _amount)
}

// CancelUnbondingDelegation is a paid mutator transaction binding the contract method 0x69a2f536.
//
// Solidity: function cancelUnbondingDelegation(address _validator, uint256 _amount, int64 _creationHeigh) returns()
func (_Contract *ContractTransactor) CancelUnbondingDelegation(opts *bind.TransactOpts, _validator common.Address, _amount *big.Int, _creationHeigh int64) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "cancelUnbondingDelegation", _validator, _amount, _creationHeigh)
}

// CancelUnbondingDelegation is a paid mutator transaction binding the contract method 0x69a2f536.
//
// Solidity: function cancelUnbondingDelegation(address _validator, uint256 _amount, int64 _creationHeigh) returns()
func (_Contract *ContractSession) CancelUnbondingDelegation(_validator common.Address, _amount *big.Int, _creationHeigh int64) (*types.Transaction, error) {
	return _Contract.Contract.CancelUnbondingDelegation(&_Contract.TransactOpts, _validator, _amount, _creationHeigh)
}

// CancelUnbondingDelegation is a paid mutator transaction binding the contract method 0x69a2f536.
//
// Solidity: function cancelUnbondingDelegation(address _validator, uint256 _amount, int64 _creationHeigh) returns()
func (_Contract *ContractTransactorSession) CancelUnbondingDelegation(_validator common.Address, _amount *big.Int, _creationHeigh int64) (*types.Transaction, error) {
	return _Contract.Contract.CancelUnbondingDelegation(&_Contract.TransactOpts, _validator, _amount, _creationHeigh)
}

// Delegate is a paid mutator transaction binding the contract method 0x026e402b.
//
// Solidity: function delegate(address _validator, uint256 _amount) returns()
func (_Contract *ContractTransactor) Delegate(opts *bind.TransactOpts, _validator common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "delegate", _validator, _amount)
}

// Delegate is a paid mutator transaction binding the contract method 0x026e402b.
//
// Solidity: function delegate(address _validator, uint256 _amount) returns()
func (_Contract *ContractSession) Delegate(_validator common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Delegate(&_Contract.TransactOpts, _validator, _amount)
}

// Delegate is a paid mutator transaction binding the contract method 0x026e402b.
//
// Solidity: function delegate(address _validator, uint256 _amount) returns()
func (_Contract *ContractTransactorSession) Delegate(_validator common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Delegate(&_Contract.TransactOpts, _validator, _amount)
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
// Solidity: function harvestVault(address _vaultAddress) returns()
func (_Contract *ContractTransactor) HarvestVault(opts *bind.TransactOpts, _vaultAddress common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "harvestVault", _vaultAddress)
}

// HarvestVault is a paid mutator transaction binding the contract method 0x0a2f023e.
//
// Solidity: function harvestVault(address _vaultAddress) returns()
func (_Contract *ContractSession) HarvestVault(_vaultAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.HarvestVault(&_Contract.TransactOpts, _vaultAddress)
}

// HarvestVault is a paid mutator transaction binding the contract method 0x0a2f023e.
//
// Solidity: function harvestVault(address _vaultAddress) returns()
func (_Contract *ContractTransactorSession) HarvestVault(_vaultAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.HarvestVault(&_Contract.TransactOpts, _vaultAddress)
}

// RegisterVault is a paid mutator transaction binding the contract method 0x186488c6.
//
// Solidity: function registerVault(address _asset, string _name, string _symbol, address[] _rewardTokens, address _poolAddress) returns(address)
func (_Contract *ContractTransactor) RegisterVault(opts *bind.TransactOpts, _asset common.Address, _name string, _symbol string, _rewardTokens []common.Address, _poolAddress common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "registerVault", _asset, _name, _symbol, _rewardTokens, _poolAddress)
}

// RegisterVault is a paid mutator transaction binding the contract method 0x186488c6.
//
// Solidity: function registerVault(address _asset, string _name, string _symbol, address[] _rewardTokens, address _poolAddress) returns(address)
func (_Contract *ContractSession) RegisterVault(_asset common.Address, _name string, _symbol string, _rewardTokens []common.Address, _poolAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RegisterVault(&_Contract.TransactOpts, _asset, _name, _symbol, _rewardTokens, _poolAddress)
}

// RegisterVault is a paid mutator transaction binding the contract method 0x186488c6.
//
// Solidity: function registerVault(address _asset, string _name, string _symbol, address[] _rewardTokens, address _poolAddress) returns(address)
func (_Contract *ContractTransactorSession) RegisterVault(_asset common.Address, _name string, _symbol string, _rewardTokens []common.Address, _poolAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.RegisterVault(&_Contract.TransactOpts, _asset, _name, _symbol, _rewardTokens, _poolAddress)
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

// Undelegate is a paid mutator transaction binding the contract method 0x4d99dd16.
//
// Solidity: function undelegate(address _validator, uint256 _amount) returns()
func (_Contract *ContractTransactor) Undelegate(opts *bind.TransactOpts, _validator common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "undelegate", _validator, _amount)
}

// Undelegate is a paid mutator transaction binding the contract method 0x4d99dd16.
//
// Solidity: function undelegate(address _validator, uint256 _amount) returns()
func (_Contract *ContractSession) Undelegate(_validator common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Undelegate(&_Contract.TransactOpts, _validator, _amount)
}

// Undelegate is a paid mutator transaction binding the contract method 0x4d99dd16.
//
// Solidity: function undelegate(address _validator, uint256 _amount) returns()
func (_Contract *ContractTransactorSession) Undelegate(_validator common.Address, _amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Undelegate(&_Contract.TransactOpts, _validator, _amount)
}

// UpdateWIBGTVault is a paid mutator transaction binding the contract method 0x709e6824.
//
// Solidity: function updateWIBGTVault(address _new, address[] _rewardTokens) returns()
func (_Contract *ContractTransactor) UpdateWIBGTVault(opts *bind.TransactOpts, _new common.Address, _rewardTokens []common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "updateWIBGTVault", _new, _rewardTokens)
}

// UpdateWIBGTVault is a paid mutator transaction binding the contract method 0x709e6824.
//
// Solidity: function updateWIBGTVault(address _new, address[] _rewardTokens) returns()
func (_Contract *ContractSession) UpdateWIBGTVault(_new common.Address, _rewardTokens []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.UpdateWIBGTVault(&_Contract.TransactOpts, _new, _rewardTokens)
}

// UpdateWIBGTVault is a paid mutator transaction binding the contract method 0x709e6824.
//
// Solidity: function updateWIBGTVault(address _new, address[] _rewardTokens) returns()
func (_Contract *ContractTransactorSession) UpdateWIBGTVault(_new common.Address, _rewardTokens []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.UpdateWIBGTVault(&_Contract.TransactOpts, _new, _rewardTokens)
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
	Vault  common.Address
	Amount *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterIBGTSupplied is a free log retrieval operation binding the contract event 0x037146eb3fc443d699b74fae8d5371c6abb236703351dc20fecf98477bf22386.
//
// Solidity: event IBGTSupplied(address indexed _vault, uint256 _amount)
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
// Solidity: event IBGTSupplied(address indexed _vault, uint256 _amount)
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
// Solidity: event IBGTSupplied(address indexed _vault, uint256 _amount)
func (_Contract *ContractFilterer) ParseIBGTSupplied(log types.Log) (*ContractIBGTSupplied, error) {
	event := new(ContractIBGTSupplied)
	if err := _Contract.contract.UnpackLog(event, "IBGTSupplied", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractNewValidatorIterator is returned from FilterNewValidator and is used to iterate over the raw logs and unpacked data for NewValidator events raised by the Contract contract.
type ContractNewValidatorIterator struct {
	Event *ContractNewValidator // Event containing the contract specifics and raw log

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
func (it *ContractNewValidatorIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractNewValidator)
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
		it.Event = new(ContractNewValidator)
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
func (it *ContractNewValidatorIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractNewValidatorIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractNewValidator represents a NewValidator event raised by the Contract contract.
type ContractNewValidator struct {
	Validator common.Address
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterNewValidator is a free log retrieval operation binding the contract event 0x29b4645f23b856eccf12b3b38e036c3221ca1b5a9afa2a83aea7ead34e47987c.
//
// Solidity: event NewValidator(address indexed _validator)
func (_Contract *ContractFilterer) FilterNewValidator(opts *bind.FilterOpts, _validator []common.Address) (*ContractNewValidatorIterator, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "NewValidator", _validatorRule)
	if err != nil {
		return nil, err
	}
	return &ContractNewValidatorIterator{contract: _Contract.contract, event: "NewValidator", logs: logs, sub: sub}, nil
}

// WatchNewValidator is a free log subscription operation binding the contract event 0x29b4645f23b856eccf12b3b38e036c3221ca1b5a9afa2a83aea7ead34e47987c.
//
// Solidity: event NewValidator(address indexed _validator)
func (_Contract *ContractFilterer) WatchNewValidator(opts *bind.WatchOpts, sink chan<- *ContractNewValidator, _validator []common.Address) (event.Subscription, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "NewValidator", _validatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractNewValidator)
				if err := _Contract.contract.UnpackLog(event, "NewValidator", log); err != nil {
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

// ParseNewValidator is a log parse operation binding the contract event 0x29b4645f23b856eccf12b3b38e036c3221ca1b5a9afa2a83aea7ead34e47987c.
//
// Solidity: event NewValidator(address indexed _validator)
func (_Contract *ContractFilterer) ParseNewValidator(log types.Log) (*ContractNewValidator, error) {
	event := new(ContractNewValidator)
	if err := _Contract.contract.UnpackLog(event, "NewValidator", log); err != nil {
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
	Vault common.Address
	Pool  common.Address
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterNewVault is a free log retrieval operation binding the contract event 0x4241302c393c713e690702c4a45a57e93cef59aa8c6e2358495853b3420551d8.
//
// Solidity: event NewVault(address indexed _vault, address indexed _pool)
func (_Contract *ContractFilterer) FilterNewVault(opts *bind.FilterOpts, _vault []common.Address, _pool []common.Address) (*ContractNewVaultIterator, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}
	var _poolRule []interface{}
	for _, _poolItem := range _pool {
		_poolRule = append(_poolRule, _poolItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "NewVault", _vaultRule, _poolRule)
	if err != nil {
		return nil, err
	}
	return &ContractNewVaultIterator{contract: _Contract.contract, event: "NewVault", logs: logs, sub: sub}, nil
}

// WatchNewVault is a free log subscription operation binding the contract event 0x4241302c393c713e690702c4a45a57e93cef59aa8c6e2358495853b3420551d8.
//
// Solidity: event NewVault(address indexed _vault, address indexed _pool)
func (_Contract *ContractFilterer) WatchNewVault(opts *bind.WatchOpts, sink chan<- *ContractNewVault, _vault []common.Address, _pool []common.Address) (event.Subscription, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}
	var _poolRule []interface{}
	for _, _poolItem := range _pool {
		_poolRule = append(_poolRule, _poolItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "NewVault", _vaultRule, _poolRule)
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

// ParseNewVault is a log parse operation binding the contract event 0x4241302c393c713e690702c4a45a57e93cef59aa8c6e2358495853b3420551d8.
//
// Solidity: event NewVault(address indexed _vault, address indexed _pool)
func (_Contract *ContractFilterer) ParseNewVault(log types.Log) (*ContractNewVault, error) {
	event := new(ContractNewVault)
	if err := _Contract.contract.UnpackLog(event, "NewVault", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractNewWrappedIBGTVaultIterator is returned from FilterNewWrappedIBGTVault and is used to iterate over the raw logs and unpacked data for NewWrappedIBGTVault events raised by the Contract contract.
type ContractNewWrappedIBGTVaultIterator struct {
	Event *ContractNewWrappedIBGTVault // Event containing the contract specifics and raw log

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
func (it *ContractNewWrappedIBGTVaultIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractNewWrappedIBGTVault)
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
		it.Event = new(ContractNewWrappedIBGTVault)
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
func (it *ContractNewWrappedIBGTVaultIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractNewWrappedIBGTVaultIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractNewWrappedIBGTVault represents a NewWrappedIBGTVault event raised by the Contract contract.
type ContractNewWrappedIBGTVault struct {
	Vault common.Address
	Raw   types.Log // Blockchain specific contextual infos
}

// FilterNewWrappedIBGTVault is a free log retrieval operation binding the contract event 0x865cce8d13e5efeff0985d1cb1e6fb69b9d89751977fa9ae0147b2968959f239.
//
// Solidity: event NewWrappedIBGTVault(address indexed _vault)
func (_Contract *ContractFilterer) FilterNewWrappedIBGTVault(opts *bind.FilterOpts, _vault []common.Address) (*ContractNewWrappedIBGTVaultIterator, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "NewWrappedIBGTVault", _vaultRule)
	if err != nil {
		return nil, err
	}
	return &ContractNewWrappedIBGTVaultIterator{contract: _Contract.contract, event: "NewWrappedIBGTVault", logs: logs, sub: sub}, nil
}

// WatchNewWrappedIBGTVault is a free log subscription operation binding the contract event 0x865cce8d13e5efeff0985d1cb1e6fb69b9d89751977fa9ae0147b2968959f239.
//
// Solidity: event NewWrappedIBGTVault(address indexed _vault)
func (_Contract *ContractFilterer) WatchNewWrappedIBGTVault(opts *bind.WatchOpts, sink chan<- *ContractNewWrappedIBGTVault, _vault []common.Address) (event.Subscription, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "NewWrappedIBGTVault", _vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractNewWrappedIBGTVault)
				if err := _Contract.contract.UnpackLog(event, "NewWrappedIBGTVault", log); err != nil {
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

// ParseNewWrappedIBGTVault is a log parse operation binding the contract event 0x865cce8d13e5efeff0985d1cb1e6fb69b9d89751977fa9ae0147b2968959f239.
//
// Solidity: event NewWrappedIBGTVault(address indexed _vault)
func (_Contract *ContractFilterer) ParseNewWrappedIBGTVault(log types.Log) (*ContractNewWrappedIBGTVault, error) {
	event := new(ContractNewWrappedIBGTVault)
	if err := _Contract.contract.UnpackLog(event, "NewWrappedIBGTVault", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractRewardsSuppliedIterator is returned from FilterRewardsSupplied and is used to iterate over the raw logs and unpacked data for RewardsSupplied events raised by the Contract contract.
type ContractRewardsSuppliedIterator struct {
	Event *ContractRewardsSupplied // Event containing the contract specifics and raw log

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
func (it *ContractRewardsSuppliedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractRewardsSupplied)
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
		it.Event = new(ContractRewardsSupplied)
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
func (it *ContractRewardsSuppliedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractRewardsSuppliedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractRewardsSupplied represents a RewardsSupplied event raised by the Contract contract.
type ContractRewardsSupplied struct {
	Vault        common.Address
	RewardTokens []DataTypesToken
	Raw          types.Log // Blockchain specific contextual infos
}

// FilterRewardsSupplied is a free log retrieval operation binding the contract event 0xf859dc9c014efe7ad97ea96d33f23a6809ae417e31e3409f027c739fc82c5059.
//
// Solidity: event RewardsSupplied(address indexed _vault, (address,uint256)[] _rewardTokens)
func (_Contract *ContractFilterer) FilterRewardsSupplied(opts *bind.FilterOpts, _vault []common.Address) (*ContractRewardsSuppliedIterator, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "RewardsSupplied", _vaultRule)
	if err != nil {
		return nil, err
	}
	return &ContractRewardsSuppliedIterator{contract: _Contract.contract, event: "RewardsSupplied", logs: logs, sub: sub}, nil
}

// WatchRewardsSupplied is a free log subscription operation binding the contract event 0xf859dc9c014efe7ad97ea96d33f23a6809ae417e31e3409f027c739fc82c5059.
//
// Solidity: event RewardsSupplied(address indexed _vault, (address,uint256)[] _rewardTokens)
func (_Contract *ContractFilterer) WatchRewardsSupplied(opts *bind.WatchOpts, sink chan<- *ContractRewardsSupplied, _vault []common.Address) (event.Subscription, error) {

	var _vaultRule []interface{}
	for _, _vaultItem := range _vault {
		_vaultRule = append(_vaultRule, _vaultItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "RewardsSupplied", _vaultRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractRewardsSupplied)
				if err := _Contract.contract.UnpackLog(event, "RewardsSupplied", log); err != nil {
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

// ParseRewardsSupplied is a log parse operation binding the contract event 0xf859dc9c014efe7ad97ea96d33f23a6809ae417e31e3409f027c739fc82c5059.
//
// Solidity: event RewardsSupplied(address indexed _vault, (address,uint256)[] _rewardTokens)
func (_Contract *ContractFilterer) ParseRewardsSupplied(log types.Log) (*ContractRewardsSupplied, error) {
	event := new(ContractRewardsSupplied)
	if err := _Contract.contract.UnpackLog(event, "RewardsSupplied", log); err != nil {
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

// ContractValidatorRemovedIterator is returned from FilterValidatorRemoved and is used to iterate over the raw logs and unpacked data for ValidatorRemoved events raised by the Contract contract.
type ContractValidatorRemovedIterator struct {
	Event *ContractValidatorRemoved // Event containing the contract specifics and raw log

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
func (it *ContractValidatorRemovedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractValidatorRemoved)
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
		it.Event = new(ContractValidatorRemoved)
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
func (it *ContractValidatorRemovedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractValidatorRemovedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractValidatorRemoved represents a ValidatorRemoved event raised by the Contract contract.
type ContractValidatorRemoved struct {
	Validator common.Address
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterValidatorRemoved is a free log retrieval operation binding the contract event 0xe1434e25d6611e0db941968fdc97811c982ac1602e951637d206f5fdda9dd8f1.
//
// Solidity: event ValidatorRemoved(address indexed _validator)
func (_Contract *ContractFilterer) FilterValidatorRemoved(opts *bind.FilterOpts, _validator []common.Address) (*ContractValidatorRemovedIterator, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorRemoved", _validatorRule)
	if err != nil {
		return nil, err
	}
	return &ContractValidatorRemovedIterator{contract: _Contract.contract, event: "ValidatorRemoved", logs: logs, sub: sub}, nil
}

// WatchValidatorRemoved is a free log subscription operation binding the contract event 0xe1434e25d6611e0db941968fdc97811c982ac1602e951637d206f5fdda9dd8f1.
//
// Solidity: event ValidatorRemoved(address indexed _validator)
func (_Contract *ContractFilterer) WatchValidatorRemoved(opts *bind.WatchOpts, sink chan<- *ContractValidatorRemoved, _validator []common.Address) (event.Subscription, error) {

	var _validatorRule []interface{}
	for _, _validatorItem := range _validator {
		_validatorRule = append(_validatorRule, _validatorItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorRemoved", _validatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractValidatorRemoved)
				if err := _Contract.contract.UnpackLog(event, "ValidatorRemoved", log); err != nil {
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

// ParseValidatorRemoved is a log parse operation binding the contract event 0xe1434e25d6611e0db941968fdc97811c982ac1602e951637d206f5fdda9dd8f1.
//
// Solidity: event ValidatorRemoved(address indexed _validator)
func (_Contract *ContractFilterer) ParseValidatorRemoved(log types.Log) (*ContractValidatorRemoved, error) {
	event := new(ContractValidatorRemoved)
	if err := _Contract.contract.UnpackLog(event, "ValidatorRemoved", log); err != nil {
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
	Current common.Address
	New     common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterValidatorReplaced is a free log retrieval operation binding the contract event 0xe6e72e54a4123b2dcda827c71019bc7135c6ed6d4a29a70bfb97a9d78bf8519e.
//
// Solidity: event ValidatorReplaced(address indexed _current, address indexed _new)
func (_Contract *ContractFilterer) FilterValidatorReplaced(opts *bind.FilterOpts, _current []common.Address, _new []common.Address) (*ContractValidatorReplacedIterator, error) {

	var _currentRule []interface{}
	for _, _currentItem := range _current {
		_currentRule = append(_currentRule, _currentItem)
	}
	var _newRule []interface{}
	for _, _newItem := range _new {
		_newRule = append(_newRule, _newItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorReplaced", _currentRule, _newRule)
	if err != nil {
		return nil, err
	}
	return &ContractValidatorReplacedIterator{contract: _Contract.contract, event: "ValidatorReplaced", logs: logs, sub: sub}, nil
}

// WatchValidatorReplaced is a free log subscription operation binding the contract event 0xe6e72e54a4123b2dcda827c71019bc7135c6ed6d4a29a70bfb97a9d78bf8519e.
//
// Solidity: event ValidatorReplaced(address indexed _current, address indexed _new)
func (_Contract *ContractFilterer) WatchValidatorReplaced(opts *bind.WatchOpts, sink chan<- *ContractValidatorReplaced, _current []common.Address, _new []common.Address) (event.Subscription, error) {

	var _currentRule []interface{}
	for _, _currentItem := range _current {
		_currentRule = append(_currentRule, _currentItem)
	}
	var _newRule []interface{}
	for _, _newItem := range _new {
		_newRule = append(_newRule, _newItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorReplaced", _currentRule, _newRule)
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

// ParseValidatorReplaced is a log parse operation binding the contract event 0xe6e72e54a4123b2dcda827c71019bc7135c6ed6d4a29a70bfb97a9d78bf8519e.
//
// Solidity: event ValidatorReplaced(address indexed _current, address indexed _new)
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
// Solidity: event ValidatorSetUpdated(address indexed _old, address _new, uint8 _action)
func (_Contract *ContractFilterer) FilterValidatorSetUpdated(opts *bind.FilterOpts, _old []common.Address) (*ContractValidatorSetUpdatedIterator, error) {

	var _oldRule []interface{}
	for _, _oldItem := range _old {
		_oldRule = append(_oldRule, _oldItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ValidatorSetUpdated", _oldRule)
	if err != nil {
		return nil, err
	}
	return &ContractValidatorSetUpdatedIterator{contract: _Contract.contract, event: "ValidatorSetUpdated", logs: logs, sub: sub}, nil
}

// WatchValidatorSetUpdated is a free log subscription operation binding the contract event 0x5205f12cc78458feadf5eb48b4f94bf636b337e3d4508e6ff6ec7b97c5b9d869.
//
// Solidity: event ValidatorSetUpdated(address indexed _old, address _new, uint8 _action)
func (_Contract *ContractFilterer) WatchValidatorSetUpdated(opts *bind.WatchOpts, sink chan<- *ContractValidatorSetUpdated, _old []common.Address) (event.Subscription, error) {

	var _oldRule []interface{}
	for _, _oldItem := range _old {
		_oldRule = append(_oldRule, _oldItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ValidatorSetUpdated", _oldRule)
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
// Solidity: event ValidatorSetUpdated(address indexed _old, address _new, uint8 _action)
func (_Contract *ContractFilterer) ParseValidatorSetUpdated(log types.Log) (*ContractValidatorSetUpdated, error) {
	event := new(ContractValidatorSetUpdated)
	if err := _Contract.contract.UnpackLog(event, "ValidatorSetUpdated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
