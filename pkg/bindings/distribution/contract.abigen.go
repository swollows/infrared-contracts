// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package distribution

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

// CosmosCoin is an auto generated low-level Go binding around an user-defined struct.
type CosmosCoin struct {
	Amount *big.Int
	Denom  string
}

// IDistributionModuleValidatorReward is an auto generated low-level Go binding around an user-defined struct.
type IDistributionModuleValidatorReward struct {
	Validator common.Address
	Rewards   []CosmosCoin
}

// ContractMetaData contains all meta data concerning the Contract contract.
var ContractMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"getAllDelegatorRewards\",\"inputs\":[{\"name\":\"delegator\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structIDistributionModule.ValidatorReward[]\",\"components\":[{\"name\":\"validator\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"rewards\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getTotalDelegatorReward\",\"inputs\":[{\"name\":\"delegator\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getWithdrawAddress\",\"inputs\":[{\"name\":\"delegator\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getWithdrawEnabled\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"setWithdrawAddress\",\"inputs\":[{\"name\":\"withdrawAddress\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"withdrawDelegatorReward\",\"inputs\":[{\"name\":\"delegator\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"validator\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"SetWithdrawAddress\",\"inputs\":[{\"name\":\"withdrawAddress\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"WithdrawRewards\",\"inputs\":[{\"name\":\"validator\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"tuple[]\",\"indexed\":false,\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"anonymous\":false}]",
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

// GetAllDelegatorRewards is a free data retrieval call binding the contract method 0x36e22c98.
//
// Solidity: function getAllDelegatorRewards(address delegator) view returns((address,(uint256,string)[])[])
func (_Contract *ContractCaller) GetAllDelegatorRewards(opts *bind.CallOpts, delegator common.Address) ([]IDistributionModuleValidatorReward, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getAllDelegatorRewards", delegator)

	if err != nil {
		return *new([]IDistributionModuleValidatorReward), err
	}

	out0 := *abi.ConvertType(out[0], new([]IDistributionModuleValidatorReward)).(*[]IDistributionModuleValidatorReward)

	return out0, err

}

// GetAllDelegatorRewards is a free data retrieval call binding the contract method 0x36e22c98.
//
// Solidity: function getAllDelegatorRewards(address delegator) view returns((address,(uint256,string)[])[])
func (_Contract *ContractSession) GetAllDelegatorRewards(delegator common.Address) ([]IDistributionModuleValidatorReward, error) {
	return _Contract.Contract.GetAllDelegatorRewards(&_Contract.CallOpts, delegator)
}

// GetAllDelegatorRewards is a free data retrieval call binding the contract method 0x36e22c98.
//
// Solidity: function getAllDelegatorRewards(address delegator) view returns((address,(uint256,string)[])[])
func (_Contract *ContractCallerSession) GetAllDelegatorRewards(delegator common.Address) ([]IDistributionModuleValidatorReward, error) {
	return _Contract.Contract.GetAllDelegatorRewards(&_Contract.CallOpts, delegator)
}

// GetTotalDelegatorReward is a free data retrieval call binding the contract method 0xce3341b4.
//
// Solidity: function getTotalDelegatorReward(address delegator) view returns((uint256,string)[])
func (_Contract *ContractCaller) GetTotalDelegatorReward(opts *bind.CallOpts, delegator common.Address) ([]CosmosCoin, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getTotalDelegatorReward", delegator)

	if err != nil {
		return *new([]CosmosCoin), err
	}

	out0 := *abi.ConvertType(out[0], new([]CosmosCoin)).(*[]CosmosCoin)

	return out0, err

}

// GetTotalDelegatorReward is a free data retrieval call binding the contract method 0xce3341b4.
//
// Solidity: function getTotalDelegatorReward(address delegator) view returns((uint256,string)[])
func (_Contract *ContractSession) GetTotalDelegatorReward(delegator common.Address) ([]CosmosCoin, error) {
	return _Contract.Contract.GetTotalDelegatorReward(&_Contract.CallOpts, delegator)
}

// GetTotalDelegatorReward is a free data retrieval call binding the contract method 0xce3341b4.
//
// Solidity: function getTotalDelegatorReward(address delegator) view returns((uint256,string)[])
func (_Contract *ContractCallerSession) GetTotalDelegatorReward(delegator common.Address) ([]CosmosCoin, error) {
	return _Contract.Contract.GetTotalDelegatorReward(&_Contract.CallOpts, delegator)
}

// GetWithdrawAddress is a free data retrieval call binding the contract method 0xafe46ea2.
//
// Solidity: function getWithdrawAddress(address delegator) view returns(address)
func (_Contract *ContractCaller) GetWithdrawAddress(opts *bind.CallOpts, delegator common.Address) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getWithdrawAddress", delegator)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetWithdrawAddress is a free data retrieval call binding the contract method 0xafe46ea2.
//
// Solidity: function getWithdrawAddress(address delegator) view returns(address)
func (_Contract *ContractSession) GetWithdrawAddress(delegator common.Address) (common.Address, error) {
	return _Contract.Contract.GetWithdrawAddress(&_Contract.CallOpts, delegator)
}

// GetWithdrawAddress is a free data retrieval call binding the contract method 0xafe46ea2.
//
// Solidity: function getWithdrawAddress(address delegator) view returns(address)
func (_Contract *ContractCallerSession) GetWithdrawAddress(delegator common.Address) (common.Address, error) {
	return _Contract.Contract.GetWithdrawAddress(&_Contract.CallOpts, delegator)
}

// GetWithdrawEnabled is a free data retrieval call binding the contract method 0x39cc4c86.
//
// Solidity: function getWithdrawEnabled() view returns(bool)
func (_Contract *ContractCaller) GetWithdrawEnabled(opts *bind.CallOpts) (bool, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getWithdrawEnabled")

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// GetWithdrawEnabled is a free data retrieval call binding the contract method 0x39cc4c86.
//
// Solidity: function getWithdrawEnabled() view returns(bool)
func (_Contract *ContractSession) GetWithdrawEnabled() (bool, error) {
	return _Contract.Contract.GetWithdrawEnabled(&_Contract.CallOpts)
}

// GetWithdrawEnabled is a free data retrieval call binding the contract method 0x39cc4c86.
//
// Solidity: function getWithdrawEnabled() view returns(bool)
func (_Contract *ContractCallerSession) GetWithdrawEnabled() (bool, error) {
	return _Contract.Contract.GetWithdrawEnabled(&_Contract.CallOpts)
}

// SetWithdrawAddress is a paid mutator transaction binding the contract method 0x3ab1a494.
//
// Solidity: function setWithdrawAddress(address withdrawAddress) returns(bool)
func (_Contract *ContractTransactor) SetWithdrawAddress(opts *bind.TransactOpts, withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "setWithdrawAddress", withdrawAddress)
}

// SetWithdrawAddress is a paid mutator transaction binding the contract method 0x3ab1a494.
//
// Solidity: function setWithdrawAddress(address withdrawAddress) returns(bool)
func (_Contract *ContractSession) SetWithdrawAddress(withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.SetWithdrawAddress(&_Contract.TransactOpts, withdrawAddress)
}

// SetWithdrawAddress is a paid mutator transaction binding the contract method 0x3ab1a494.
//
// Solidity: function setWithdrawAddress(address withdrawAddress) returns(bool)
func (_Contract *ContractTransactorSession) SetWithdrawAddress(withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.SetWithdrawAddress(&_Contract.TransactOpts, withdrawAddress)
}

// WithdrawDelegatorReward is a paid mutator transaction binding the contract method 0x562c67a4.
//
// Solidity: function withdrawDelegatorReward(address delegator, address validator) returns((uint256,string)[])
func (_Contract *ContractTransactor) WithdrawDelegatorReward(opts *bind.TransactOpts, delegator common.Address, validator common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "withdrawDelegatorReward", delegator, validator)
}

// WithdrawDelegatorReward is a paid mutator transaction binding the contract method 0x562c67a4.
//
// Solidity: function withdrawDelegatorReward(address delegator, address validator) returns((uint256,string)[])
func (_Contract *ContractSession) WithdrawDelegatorReward(delegator common.Address, validator common.Address) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawDelegatorReward(&_Contract.TransactOpts, delegator, validator)
}

// WithdrawDelegatorReward is a paid mutator transaction binding the contract method 0x562c67a4.
//
// Solidity: function withdrawDelegatorReward(address delegator, address validator) returns((uint256,string)[])
func (_Contract *ContractTransactorSession) WithdrawDelegatorReward(delegator common.Address, validator common.Address) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawDelegatorReward(&_Contract.TransactOpts, delegator, validator)
}

// ContractSetWithdrawAddressIterator is returned from FilterSetWithdrawAddress and is used to iterate over the raw logs and unpacked data for SetWithdrawAddress events raised by the Contract contract.
type ContractSetWithdrawAddressIterator struct {
	Event *ContractSetWithdrawAddress // Event containing the contract specifics and raw log

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
func (it *ContractSetWithdrawAddressIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractSetWithdrawAddress)
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
		it.Event = new(ContractSetWithdrawAddress)
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
func (it *ContractSetWithdrawAddressIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractSetWithdrawAddressIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractSetWithdrawAddress represents a SetWithdrawAddress event raised by the Contract contract.
type ContractSetWithdrawAddress struct {
	WithdrawAddress common.Address
	Raw             types.Log // Blockchain specific contextual infos
}

// FilterSetWithdrawAddress is a free log retrieval operation binding the contract event 0xb13cf87e0a7b64f90565a1b68b63ae634d746fa785450bbdef7cbd281997cfb0.
//
// Solidity: event SetWithdrawAddress(address indexed withdrawAddress)
func (_Contract *ContractFilterer) FilterSetWithdrawAddress(opts *bind.FilterOpts, withdrawAddress []common.Address) (*ContractSetWithdrawAddressIterator, error) {

	var withdrawAddressRule []interface{}
	for _, withdrawAddressItem := range withdrawAddress {
		withdrawAddressRule = append(withdrawAddressRule, withdrawAddressItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "SetWithdrawAddress", withdrawAddressRule)
	if err != nil {
		return nil, err
	}
	return &ContractSetWithdrawAddressIterator{contract: _Contract.contract, event: "SetWithdrawAddress", logs: logs, sub: sub}, nil
}

// WatchSetWithdrawAddress is a free log subscription operation binding the contract event 0xb13cf87e0a7b64f90565a1b68b63ae634d746fa785450bbdef7cbd281997cfb0.
//
// Solidity: event SetWithdrawAddress(address indexed withdrawAddress)
func (_Contract *ContractFilterer) WatchSetWithdrawAddress(opts *bind.WatchOpts, sink chan<- *ContractSetWithdrawAddress, withdrawAddress []common.Address) (event.Subscription, error) {

	var withdrawAddressRule []interface{}
	for _, withdrawAddressItem := range withdrawAddress {
		withdrawAddressRule = append(withdrawAddressRule, withdrawAddressItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "SetWithdrawAddress", withdrawAddressRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractSetWithdrawAddress)
				if err := _Contract.contract.UnpackLog(event, "SetWithdrawAddress", log); err != nil {
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

// ParseSetWithdrawAddress is a log parse operation binding the contract event 0xb13cf87e0a7b64f90565a1b68b63ae634d746fa785450bbdef7cbd281997cfb0.
//
// Solidity: event SetWithdrawAddress(address indexed withdrawAddress)
func (_Contract *ContractFilterer) ParseSetWithdrawAddress(log types.Log) (*ContractSetWithdrawAddress, error) {
	event := new(ContractSetWithdrawAddress)
	if err := _Contract.contract.UnpackLog(event, "SetWithdrawAddress", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractWithdrawRewardsIterator is returned from FilterWithdrawRewards and is used to iterate over the raw logs and unpacked data for WithdrawRewards events raised by the Contract contract.
type ContractWithdrawRewardsIterator struct {
	Event *ContractWithdrawRewards // Event containing the contract specifics and raw log

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
func (it *ContractWithdrawRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractWithdrawRewards)
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
		it.Event = new(ContractWithdrawRewards)
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
func (it *ContractWithdrawRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractWithdrawRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractWithdrawRewards represents a WithdrawRewards event raised by the Contract contract.
type ContractWithdrawRewards struct {
	Validator common.Address
	Amount    []CosmosCoin
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterWithdrawRewards is a free log retrieval operation binding the contract event 0x68e5a74be48fc61c2ca4536b8819962850d1d39d7aa32ca670914f8b10aa6e5b.
//
// Solidity: event WithdrawRewards(address indexed validator, (uint256,string)[] amount)
func (_Contract *ContractFilterer) FilterWithdrawRewards(opts *bind.FilterOpts, validator []common.Address) (*ContractWithdrawRewardsIterator, error) {

	var validatorRule []interface{}
	for _, validatorItem := range validator {
		validatorRule = append(validatorRule, validatorItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "WithdrawRewards", validatorRule)
	if err != nil {
		return nil, err
	}
	return &ContractWithdrawRewardsIterator{contract: _Contract.contract, event: "WithdrawRewards", logs: logs, sub: sub}, nil
}

// WatchWithdrawRewards is a free log subscription operation binding the contract event 0x68e5a74be48fc61c2ca4536b8819962850d1d39d7aa32ca670914f8b10aa6e5b.
//
// Solidity: event WithdrawRewards(address indexed validator, (uint256,string)[] amount)
func (_Contract *ContractFilterer) WatchWithdrawRewards(opts *bind.WatchOpts, sink chan<- *ContractWithdrawRewards, validator []common.Address) (event.Subscription, error) {

	var validatorRule []interface{}
	for _, validatorItem := range validator {
		validatorRule = append(validatorRule, validatorItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "WithdrawRewards", validatorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractWithdrawRewards)
				if err := _Contract.contract.UnpackLog(event, "WithdrawRewards", log); err != nil {
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

// ParseWithdrawRewards is a log parse operation binding the contract event 0x68e5a74be48fc61c2ca4536b8819962850d1d39d7aa32ca670914f8b10aa6e5b.
//
// Solidity: event WithdrawRewards(address indexed validator, (uint256,string)[] amount)
func (_Contract *ContractFilterer) ParseWithdrawRewards(log types.Log) (*ContractWithdrawRewards, error) {
	event := new(ContractWithdrawRewards)
	if err := _Contract.contract.UnpackLog(event, "WithdrawRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
