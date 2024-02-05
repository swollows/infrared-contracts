// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package rewards

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

// ContractMetaData contains all meta data concerning the Contract contract.
var ContractMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"function\",\"name\":\"getCurrentRewards\",\"inputs\":[{\"name\":\"depositor\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"receiver\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getDepositorWithdrawAddress\",\"inputs\":[{\"name\":\"depositor\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getOutstandingRewards\",\"inputs\":[{\"name\":\"receiver\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"setDepositorWithdrawAddress\",\"inputs\":[{\"name\":\"withdrawAddress\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"withdrawAllDepositorRewards\",\"inputs\":[{\"name\":\"receiver\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"withdrawDepositorRewards\",\"inputs\":[{\"name\":\"receiver\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"withdrawDepositorRewardsTo\",\"inputs\":[{\"name\":\"receiver\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"recipient\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple[]\",\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"InitializeDeposit\",\"inputs\":[{\"name\":\"caller\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"depositor\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"assets\",\"type\":\"tuple[]\",\"indexed\":false,\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"shares\",\"type\":\"tuple\",\"indexed\":false,\"internalType\":\"structCosmos.Coin\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"SetDepositorWithdrawAddress\",\"inputs\":[{\"name\":\"depositor\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"withdrawAddress\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"WithdrawDepositRewards\",\"inputs\":[{\"name\":\"rewardReceiver\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"withdrawer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"rewardRecipient\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"rewardAmount\",\"type\":\"tuple[]\",\"indexed\":false,\"internalType\":\"structCosmos.Coin[]\",\"components\":[{\"name\":\"amount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"denom\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"anonymous\":false}]",
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

// GetCurrentRewards is a free data retrieval call binding the contract method 0x8cb3ca0b.
//
// Solidity: function getCurrentRewards(address depositor, address receiver) view returns((uint256,string)[])
func (_Contract *ContractCaller) GetCurrentRewards(opts *bind.CallOpts, depositor common.Address, receiver common.Address) ([]CosmosCoin, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getCurrentRewards", depositor, receiver)

	if err != nil {
		return *new([]CosmosCoin), err
	}

	out0 := *abi.ConvertType(out[0], new([]CosmosCoin)).(*[]CosmosCoin)

	return out0, err

}

// GetCurrentRewards is a free data retrieval call binding the contract method 0x8cb3ca0b.
//
// Solidity: function getCurrentRewards(address depositor, address receiver) view returns((uint256,string)[])
func (_Contract *ContractSession) GetCurrentRewards(depositor common.Address, receiver common.Address) ([]CosmosCoin, error) {
	return _Contract.Contract.GetCurrentRewards(&_Contract.CallOpts, depositor, receiver)
}

// GetCurrentRewards is a free data retrieval call binding the contract method 0x8cb3ca0b.
//
// Solidity: function getCurrentRewards(address depositor, address receiver) view returns((uint256,string)[])
func (_Contract *ContractCallerSession) GetCurrentRewards(depositor common.Address, receiver common.Address) ([]CosmosCoin, error) {
	return _Contract.Contract.GetCurrentRewards(&_Contract.CallOpts, depositor, receiver)
}

// GetDepositorWithdrawAddress is a free data retrieval call binding the contract method 0x54abed38.
//
// Solidity: function getDepositorWithdrawAddress(address depositor) view returns(address)
func (_Contract *ContractCaller) GetDepositorWithdrawAddress(opts *bind.CallOpts, depositor common.Address) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getDepositorWithdrawAddress", depositor)

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// GetDepositorWithdrawAddress is a free data retrieval call binding the contract method 0x54abed38.
//
// Solidity: function getDepositorWithdrawAddress(address depositor) view returns(address)
func (_Contract *ContractSession) GetDepositorWithdrawAddress(depositor common.Address) (common.Address, error) {
	return _Contract.Contract.GetDepositorWithdrawAddress(&_Contract.CallOpts, depositor)
}

// GetDepositorWithdrawAddress is a free data retrieval call binding the contract method 0x54abed38.
//
// Solidity: function getDepositorWithdrawAddress(address depositor) view returns(address)
func (_Contract *ContractCallerSession) GetDepositorWithdrawAddress(depositor common.Address) (common.Address, error) {
	return _Contract.Contract.GetDepositorWithdrawAddress(&_Contract.CallOpts, depositor)
}

// GetOutstandingRewards is a free data retrieval call binding the contract method 0xbce3b836.
//
// Solidity: function getOutstandingRewards(address receiver) view returns((uint256,string)[])
func (_Contract *ContractCaller) GetOutstandingRewards(opts *bind.CallOpts, receiver common.Address) ([]CosmosCoin, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "getOutstandingRewards", receiver)

	if err != nil {
		return *new([]CosmosCoin), err
	}

	out0 := *abi.ConvertType(out[0], new([]CosmosCoin)).(*[]CosmosCoin)

	return out0, err

}

// GetOutstandingRewards is a free data retrieval call binding the contract method 0xbce3b836.
//
// Solidity: function getOutstandingRewards(address receiver) view returns((uint256,string)[])
func (_Contract *ContractSession) GetOutstandingRewards(receiver common.Address) ([]CosmosCoin, error) {
	return _Contract.Contract.GetOutstandingRewards(&_Contract.CallOpts, receiver)
}

// GetOutstandingRewards is a free data retrieval call binding the contract method 0xbce3b836.
//
// Solidity: function getOutstandingRewards(address receiver) view returns((uint256,string)[])
func (_Contract *ContractCallerSession) GetOutstandingRewards(receiver common.Address) ([]CosmosCoin, error) {
	return _Contract.Contract.GetOutstandingRewards(&_Contract.CallOpts, receiver)
}

// SetDepositorWithdrawAddress is a paid mutator transaction binding the contract method 0x56c4d0db.
//
// Solidity: function setDepositorWithdrawAddress(address withdrawAddress) returns(bool)
func (_Contract *ContractTransactor) SetDepositorWithdrawAddress(opts *bind.TransactOpts, withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "setDepositorWithdrawAddress", withdrawAddress)
}

// SetDepositorWithdrawAddress is a paid mutator transaction binding the contract method 0x56c4d0db.
//
// Solidity: function setDepositorWithdrawAddress(address withdrawAddress) returns(bool)
func (_Contract *ContractSession) SetDepositorWithdrawAddress(withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.SetDepositorWithdrawAddress(&_Contract.TransactOpts, withdrawAddress)
}

// SetDepositorWithdrawAddress is a paid mutator transaction binding the contract method 0x56c4d0db.
//
// Solidity: function setDepositorWithdrawAddress(address withdrawAddress) returns(bool)
func (_Contract *ContractTransactorSession) SetDepositorWithdrawAddress(withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.SetDepositorWithdrawAddress(&_Contract.TransactOpts, withdrawAddress)
}

// WithdrawAllDepositorRewards is a paid mutator transaction binding the contract method 0xc02e8929.
//
// Solidity: function withdrawAllDepositorRewards(address receiver) returns((uint256,string)[])
func (_Contract *ContractTransactor) WithdrawAllDepositorRewards(opts *bind.TransactOpts, receiver common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "withdrawAllDepositorRewards", receiver)
}

// WithdrawAllDepositorRewards is a paid mutator transaction binding the contract method 0xc02e8929.
//
// Solidity: function withdrawAllDepositorRewards(address receiver) returns((uint256,string)[])
func (_Contract *ContractSession) WithdrawAllDepositorRewards(receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawAllDepositorRewards(&_Contract.TransactOpts, receiver)
}

// WithdrawAllDepositorRewards is a paid mutator transaction binding the contract method 0xc02e8929.
//
// Solidity: function withdrawAllDepositorRewards(address receiver) returns((uint256,string)[])
func (_Contract *ContractTransactorSession) WithdrawAllDepositorRewards(receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawAllDepositorRewards(&_Contract.TransactOpts, receiver)
}

// WithdrawDepositorRewards is a paid mutator transaction binding the contract method 0x0d2c9ec8.
//
// Solidity: function withdrawDepositorRewards(address receiver, uint256 amount) returns((uint256,string)[])
func (_Contract *ContractTransactor) WithdrawDepositorRewards(opts *bind.TransactOpts, receiver common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "withdrawDepositorRewards", receiver, amount)
}

// WithdrawDepositorRewards is a paid mutator transaction binding the contract method 0x0d2c9ec8.
//
// Solidity: function withdrawDepositorRewards(address receiver, uint256 amount) returns((uint256,string)[])
func (_Contract *ContractSession) WithdrawDepositorRewards(receiver common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawDepositorRewards(&_Contract.TransactOpts, receiver, amount)
}

// WithdrawDepositorRewards is a paid mutator transaction binding the contract method 0x0d2c9ec8.
//
// Solidity: function withdrawDepositorRewards(address receiver, uint256 amount) returns((uint256,string)[])
func (_Contract *ContractTransactorSession) WithdrawDepositorRewards(receiver common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawDepositorRewards(&_Contract.TransactOpts, receiver, amount)
}

// WithdrawDepositorRewardsTo is a paid mutator transaction binding the contract method 0x3771f642.
//
// Solidity: function withdrawDepositorRewardsTo(address receiver, address recipient, uint256 amount) returns((uint256,string)[])
func (_Contract *ContractTransactor) WithdrawDepositorRewardsTo(opts *bind.TransactOpts, receiver common.Address, recipient common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "withdrawDepositorRewardsTo", receiver, recipient, amount)
}

// WithdrawDepositorRewardsTo is a paid mutator transaction binding the contract method 0x3771f642.
//
// Solidity: function withdrawDepositorRewardsTo(address receiver, address recipient, uint256 amount) returns((uint256,string)[])
func (_Contract *ContractSession) WithdrawDepositorRewardsTo(receiver common.Address, recipient common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawDepositorRewardsTo(&_Contract.TransactOpts, receiver, recipient, amount)
}

// WithdrawDepositorRewardsTo is a paid mutator transaction binding the contract method 0x3771f642.
//
// Solidity: function withdrawDepositorRewardsTo(address receiver, address recipient, uint256 amount) returns((uint256,string)[])
func (_Contract *ContractTransactorSession) WithdrawDepositorRewardsTo(receiver common.Address, recipient common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.WithdrawDepositorRewardsTo(&_Contract.TransactOpts, receiver, recipient, amount)
}

// ContractInitializeDepositIterator is returned from FilterInitializeDeposit and is used to iterate over the raw logs and unpacked data for InitializeDeposit events raised by the Contract contract.
type ContractInitializeDepositIterator struct {
	Event *ContractInitializeDeposit // Event containing the contract specifics and raw log

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
func (it *ContractInitializeDepositIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractInitializeDeposit)
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
		it.Event = new(ContractInitializeDeposit)
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
func (it *ContractInitializeDepositIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractInitializeDepositIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractInitializeDeposit represents a InitializeDeposit event raised by the Contract contract.
type ContractInitializeDeposit struct {
	Caller    common.Address
	Depositor common.Address
	Assets    []CosmosCoin
	Shares    CosmosCoin
	Raw       types.Log // Blockchain specific contextual infos
}

// FilterInitializeDeposit is a free log retrieval operation binding the contract event 0xd924fa351aaddb8d643abd0e9649dba91fe2ea3597e3d50ea5b35c5b590504cc.
//
// Solidity: event InitializeDeposit(address indexed caller, address indexed depositor, (uint256,string)[] assets, (uint256,string) shares)
func (_Contract *ContractFilterer) FilterInitializeDeposit(opts *bind.FilterOpts, caller []common.Address, depositor []common.Address) (*ContractInitializeDepositIterator, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var depositorRule []interface{}
	for _, depositorItem := range depositor {
		depositorRule = append(depositorRule, depositorItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "InitializeDeposit", callerRule, depositorRule)
	if err != nil {
		return nil, err
	}
	return &ContractInitializeDepositIterator{contract: _Contract.contract, event: "InitializeDeposit", logs: logs, sub: sub}, nil
}

// WatchInitializeDeposit is a free log subscription operation binding the contract event 0xd924fa351aaddb8d643abd0e9649dba91fe2ea3597e3d50ea5b35c5b590504cc.
//
// Solidity: event InitializeDeposit(address indexed caller, address indexed depositor, (uint256,string)[] assets, (uint256,string) shares)
func (_Contract *ContractFilterer) WatchInitializeDeposit(opts *bind.WatchOpts, sink chan<- *ContractInitializeDeposit, caller []common.Address, depositor []common.Address) (event.Subscription, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var depositorRule []interface{}
	for _, depositorItem := range depositor {
		depositorRule = append(depositorRule, depositorItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "InitializeDeposit", callerRule, depositorRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractInitializeDeposit)
				if err := _Contract.contract.UnpackLog(event, "InitializeDeposit", log); err != nil {
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

// ParseInitializeDeposit is a log parse operation binding the contract event 0xd924fa351aaddb8d643abd0e9649dba91fe2ea3597e3d50ea5b35c5b590504cc.
//
// Solidity: event InitializeDeposit(address indexed caller, address indexed depositor, (uint256,string)[] assets, (uint256,string) shares)
func (_Contract *ContractFilterer) ParseInitializeDeposit(log types.Log) (*ContractInitializeDeposit, error) {
	event := new(ContractInitializeDeposit)
	if err := _Contract.contract.UnpackLog(event, "InitializeDeposit", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractSetDepositorWithdrawAddressIterator is returned from FilterSetDepositorWithdrawAddress and is used to iterate over the raw logs and unpacked data for SetDepositorWithdrawAddress events raised by the Contract contract.
type ContractSetDepositorWithdrawAddressIterator struct {
	Event *ContractSetDepositorWithdrawAddress // Event containing the contract specifics and raw log

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
func (it *ContractSetDepositorWithdrawAddressIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractSetDepositorWithdrawAddress)
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
		it.Event = new(ContractSetDepositorWithdrawAddress)
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
func (it *ContractSetDepositorWithdrawAddressIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractSetDepositorWithdrawAddressIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractSetDepositorWithdrawAddress represents a SetDepositorWithdrawAddress event raised by the Contract contract.
type ContractSetDepositorWithdrawAddress struct {
	Depositor       common.Address
	WithdrawAddress common.Address
	Raw             types.Log // Blockchain specific contextual infos
}

// FilterSetDepositorWithdrawAddress is a free log retrieval operation binding the contract event 0x0de02018d2d8e05a493bcec83d64d09b0bbe4320855afc0b410c0af84f3b6241.
//
// Solidity: event SetDepositorWithdrawAddress(address indexed depositor, address indexed withdrawAddress)
func (_Contract *ContractFilterer) FilterSetDepositorWithdrawAddress(opts *bind.FilterOpts, depositor []common.Address, withdrawAddress []common.Address) (*ContractSetDepositorWithdrawAddressIterator, error) {

	var depositorRule []interface{}
	for _, depositorItem := range depositor {
		depositorRule = append(depositorRule, depositorItem)
	}
	var withdrawAddressRule []interface{}
	for _, withdrawAddressItem := range withdrawAddress {
		withdrawAddressRule = append(withdrawAddressRule, withdrawAddressItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "SetDepositorWithdrawAddress", depositorRule, withdrawAddressRule)
	if err != nil {
		return nil, err
	}
	return &ContractSetDepositorWithdrawAddressIterator{contract: _Contract.contract, event: "SetDepositorWithdrawAddress", logs: logs, sub: sub}, nil
}

// WatchSetDepositorWithdrawAddress is a free log subscription operation binding the contract event 0x0de02018d2d8e05a493bcec83d64d09b0bbe4320855afc0b410c0af84f3b6241.
//
// Solidity: event SetDepositorWithdrawAddress(address indexed depositor, address indexed withdrawAddress)
func (_Contract *ContractFilterer) WatchSetDepositorWithdrawAddress(opts *bind.WatchOpts, sink chan<- *ContractSetDepositorWithdrawAddress, depositor []common.Address, withdrawAddress []common.Address) (event.Subscription, error) {

	var depositorRule []interface{}
	for _, depositorItem := range depositor {
		depositorRule = append(depositorRule, depositorItem)
	}
	var withdrawAddressRule []interface{}
	for _, withdrawAddressItem := range withdrawAddress {
		withdrawAddressRule = append(withdrawAddressRule, withdrawAddressItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "SetDepositorWithdrawAddress", depositorRule, withdrawAddressRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractSetDepositorWithdrawAddress)
				if err := _Contract.contract.UnpackLog(event, "SetDepositorWithdrawAddress", log); err != nil {
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

// ParseSetDepositorWithdrawAddress is a log parse operation binding the contract event 0x0de02018d2d8e05a493bcec83d64d09b0bbe4320855afc0b410c0af84f3b6241.
//
// Solidity: event SetDepositorWithdrawAddress(address indexed depositor, address indexed withdrawAddress)
func (_Contract *ContractFilterer) ParseSetDepositorWithdrawAddress(log types.Log) (*ContractSetDepositorWithdrawAddress, error) {
	event := new(ContractSetDepositorWithdrawAddress)
	if err := _Contract.contract.UnpackLog(event, "SetDepositorWithdrawAddress", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractWithdrawDepositRewardsIterator is returned from FilterWithdrawDepositRewards and is used to iterate over the raw logs and unpacked data for WithdrawDepositRewards events raised by the Contract contract.
type ContractWithdrawDepositRewardsIterator struct {
	Event *ContractWithdrawDepositRewards // Event containing the contract specifics and raw log

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
func (it *ContractWithdrawDepositRewardsIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractWithdrawDepositRewards)
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
		it.Event = new(ContractWithdrawDepositRewards)
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
func (it *ContractWithdrawDepositRewardsIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractWithdrawDepositRewardsIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractWithdrawDepositRewards represents a WithdrawDepositRewards event raised by the Contract contract.
type ContractWithdrawDepositRewards struct {
	RewardReceiver  common.Address
	Withdrawer      common.Address
	RewardRecipient common.Address
	RewardAmount    []CosmosCoin
	Raw             types.Log // Blockchain specific contextual infos
}

// FilterWithdrawDepositRewards is a free log retrieval operation binding the contract event 0xeaf9ad68989c4779cdb8274ed825acd8dd664e333e1168e03e7fb4766bc514a4.
//
// Solidity: event WithdrawDepositRewards(address indexed rewardReceiver, address indexed withdrawer, address indexed rewardRecipient, (uint256,string)[] rewardAmount)
func (_Contract *ContractFilterer) FilterWithdrawDepositRewards(opts *bind.FilterOpts, rewardReceiver []common.Address, withdrawer []common.Address, rewardRecipient []common.Address) (*ContractWithdrawDepositRewardsIterator, error) {

	var rewardReceiverRule []interface{}
	for _, rewardReceiverItem := range rewardReceiver {
		rewardReceiverRule = append(rewardReceiverRule, rewardReceiverItem)
	}
	var withdrawerRule []interface{}
	for _, withdrawerItem := range withdrawer {
		withdrawerRule = append(withdrawerRule, withdrawerItem)
	}
	var rewardRecipientRule []interface{}
	for _, rewardRecipientItem := range rewardRecipient {
		rewardRecipientRule = append(rewardRecipientRule, rewardRecipientItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "WithdrawDepositRewards", rewardReceiverRule, withdrawerRule, rewardRecipientRule)
	if err != nil {
		return nil, err
	}
	return &ContractWithdrawDepositRewardsIterator{contract: _Contract.contract, event: "WithdrawDepositRewards", logs: logs, sub: sub}, nil
}

// WatchWithdrawDepositRewards is a free log subscription operation binding the contract event 0xeaf9ad68989c4779cdb8274ed825acd8dd664e333e1168e03e7fb4766bc514a4.
//
// Solidity: event WithdrawDepositRewards(address indexed rewardReceiver, address indexed withdrawer, address indexed rewardRecipient, (uint256,string)[] rewardAmount)
func (_Contract *ContractFilterer) WatchWithdrawDepositRewards(opts *bind.WatchOpts, sink chan<- *ContractWithdrawDepositRewards, rewardReceiver []common.Address, withdrawer []common.Address, rewardRecipient []common.Address) (event.Subscription, error) {

	var rewardReceiverRule []interface{}
	for _, rewardReceiverItem := range rewardReceiver {
		rewardReceiverRule = append(rewardReceiverRule, rewardReceiverItem)
	}
	var withdrawerRule []interface{}
	for _, withdrawerItem := range withdrawer {
		withdrawerRule = append(withdrawerRule, withdrawerItem)
	}
	var rewardRecipientRule []interface{}
	for _, rewardRecipientItem := range rewardRecipient {
		rewardRecipientRule = append(rewardRecipientRule, rewardRecipientItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "WithdrawDepositRewards", rewardReceiverRule, withdrawerRule, rewardRecipientRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractWithdrawDepositRewards)
				if err := _Contract.contract.UnpackLog(event, "WithdrawDepositRewards", log); err != nil {
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

// ParseWithdrawDepositRewards is a log parse operation binding the contract event 0xeaf9ad68989c4779cdb8274ed825acd8dd664e333e1168e03e7fb4766bc514a4.
//
// Solidity: event WithdrawDepositRewards(address indexed rewardReceiver, address indexed withdrawer, address indexed rewardRecipient, (uint256,string)[] rewardAmount)
func (_Contract *ContractFilterer) ParseWithdrawDepositRewards(log types.Log) (*ContractWithdrawDepositRewards, error) {
	event := new(ContractWithdrawDepositRewards)
	if err := _Contract.contract.UnpackLog(event, "WithdrawDepositRewards", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
