// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package vault

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
	ABI: "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_asset\",\"type\":\"address\"},{\"internalType\":\"string\",\"name\":\"_name\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"_symbol\",\"type\":\"string\"},{\"internalType\":\"address[]\",\"name\":\"_rewardTokens\",\"type\":\"address[]\"},{\"internalType\":\"address\",\"name\":\"_infrared\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_poolAddress\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_rewardsPrecompile\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_distributionPrecompile\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"_admin\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[],\"name\":\"AccessControlBadConfirmation\",\"type\":\"error\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"internalType\":\"bytes32\",\"name\":\"neededRole\",\"type\":\"bytes32\"}],\"name\":\"AccessControlUnauthorizedAccount\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"SetWithdrawAddressFailed\",\"type\":\"error\"},{\"inputs\":[],\"name\":\"ZeroAddress\",\"type\":\"error\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"claimer\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"ClaimApproval\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"caller\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"Claimed\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"caller\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"}],\"name\":\"Deposit\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"previousAdminRole\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"newAdminRole\",\"type\":\"bytes32\"}],\"name\":\"RoleAdminChanged\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"sender\",\"type\":\"address\"}],\"name\":\"RoleGranted\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"sender\",\"type\":\"address\"}],\"name\":\"RoleRevoked\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"caller\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"supplier\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"Supplied\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"caller\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"},{\"indexed\":false,\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"}],\"name\":\"Withdraw\",\"type\":\"event\"},{\"inputs\":[],\"name\":\"DEFAULT_ADMIN_ROLE\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"DISTRIBUTION_PRECOMPILE\",\"outputs\":[{\"internalType\":\"contractIDistributionModule\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"DOMAIN_SEPARATOR\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"INFRARED\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"POOL_ADDRESS\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"REWARDS_PRECOMPILE\",\"outputs\":[{\"internalType\":\"contractIRewardsModule\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"supplier\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint96\",\"name\":\"partition\",\"type\":\"uint96\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"_supply\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"_rewardTokens\",\"type\":\"address[]\"}],\"name\":\"addRewardTokens\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"claimer\",\"type\":\"address\"}],\"name\":\"approveClaim\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"success\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"asset\",\"outputs\":[{\"internalType\":\"contractERC20\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_withdrawAddress\",\"type\":\"address\"}],\"name\":\"changeDistributionWithdrawAddress\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_withdrawAddress\",\"type\":\"address\"}],\"name\":\"changeRewardsWithdrawAddress\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"},{\"internalType\":\"uint96\",\"name\":\"partition\",\"type\":\"uint96\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"}],\"name\":\"claim\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"success\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"}],\"name\":\"claim\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"success\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"claimAllowance\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"}],\"name\":\"claimFor\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"success\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint96\",\"name\":\"partition\",\"type\":\"uint96\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"}],\"name\":\"claimFor\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"success\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"}],\"name\":\"convertToAssets\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"}],\"name\":\"convertToShares\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"internalType\":\"uint8\",\"name\":\"\",\"type\":\"uint8\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"}],\"name\":\"deposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"}],\"name\":\"getRoleAdmin\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"grantRole\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"hasRole\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"name\":\"keyToRewardsContainer\",\"outputs\":[{\"internalType\":\"uint96\",\"name\":\"partition\",\"type\":\"uint96\"},{\"internalType\":\"uint208\",\"name\":\"suppliedSinceLastUpdate\",\"type\":\"uint208\"},{\"internalType\":\"uint208\",\"name\":\"currentSupplyError\",\"type\":\"uint208\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint96\",\"name\":\"id\",\"type\":\"uint96\"},{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"maxClaimable\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"maxClaimable\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"maxDeposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"maxMint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"maxRedeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"maxWithdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"}],\"name\":\"mint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"nonces\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"spender\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"deadline\",\"type\":\"uint256\"},{\"internalType\":\"uint8\",\"name\":\"v\",\"type\":\"uint8\"},{\"internalType\":\"bytes32\",\"name\":\"r\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"s\",\"type\":\"bytes32\"}],\"name\":\"permit\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"claimer\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"value\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"deadline\",\"type\":\"uint256\"},{\"internalType\":\"uint8\",\"name\":\"v\",\"type\":\"uint8\"},{\"internalType\":\"bytes32\",\"name\":\"r\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"s\",\"type\":\"bytes32\"}],\"name\":\"permitClaim\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"poolAddress\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"_poolAddress\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"}],\"name\":\"previewDeposit\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"}],\"name\":\"previewMint\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"}],\"name\":\"previewRedeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"}],\"name\":\"previewWithdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"redeem\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"callerConfirmation\",\"type\":\"address\"}],\"name\":\"renounceRole\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes32\",\"name\":\"role\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"account\",\"type\":\"address\"}],\"name\":\"revokeRole\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"rewardKeys\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"name\":\"rewardKeysOf\",\"outputs\":[{\"internalType\":\"bytes32[]\",\"name\":\"_rk\",\"type\":\"bytes32[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"rewardTokens\",\"outputs\":[{\"internalType\":\"address[]\",\"name\":\"_rewardTokens\",\"type\":\"address[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"supplier\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"supply\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"supplier\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"reward\",\"type\":\"address\"},{\"internalType\":\"uint96\",\"name\":\"partition\",\"type\":\"uint96\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"supply\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes4\",\"name\":\"interfaceId\",\"type\":\"bytes4\"}],\"name\":\"supportsInterface\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"totalAssets\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"_assets\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint96\",\"name\":\"\",\"type\":\"uint96\"}],\"name\":\"totalWeight\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"_tw\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"totalWeight\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"from\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"to\",\"type\":\"address\"},{\"internalType\":\"uint256\",\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"_user\",\"type\":\"address\"},{\"internalType\":\"uint96\",\"name\":\"\",\"type\":\"uint96\"}],\"name\":\"weightOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"_wo\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"weightOf\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"\",\"type\":\"uint256\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint256\",\"name\":\"assets\",\"type\":\"uint256\"},{\"internalType\":\"address\",\"name\":\"receiver\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"owner\",\"type\":\"address\"}],\"name\":\"withdraw\",\"outputs\":[{\"internalType\":\"uint256\",\"name\":\"shares\",\"type\":\"uint256\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]",
	Bin: "0x61018080604052346200090757620037b780380380916200002182856200090b565b833981016101208282031262000907576200003c826200092f565b60208301516001600160401b0381116200090757826200005e91850162000944565b60408401519091906001600160401b0381116200090757836200008391860162000944565b60608501516001600160401b038111620009075785019380601f8601121562000907578451946001600160401b03861162000433578560051b9060405196620000d060208401896200090b565b87526020808801928201019283116200090757602001905b828210620008ec5750505062000101608086016200092f565b906200011060a087016200092f565b926200011f60c088016200092f565b946200013d6101006200013560e08b016200092f565b99016200092f565b60405163313ce56760e01b8152909390916020836004816001600160a01b0388165afa928315620005bc575f936200089e575b508051906001600160401b03821162000433578190620001915f54620009d3565b601f811162000841575b50602090601f8311600114620007cd575f92620007c1575b50508160011b915f199060031b1c1916175f555b8051906001600160401b03821162000433578190620001e8600154620009d3565b601f811162000763575b50602090601f8311600114620006e8575f92620006dc575b50508160011b915f199060031b1c1916176001555b6080524660a0526040515f818154916200023983620009d3565b8083529260018116908115620006bb57506001146200066c575b62000261925003826200090b565b60208151910120906040519160208301907f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f825260408401527fc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc660608401524660808401523060a084015260a0835260c083019280841060018060401b038511176200043357604084905251902060c0526001600160a01b031660e0819052156200065d57506001600160a01b0382161562000639576001600160a01b0383161562000639576001600160a01b038416159283806200064b575b62000639575f5b86518110156200045957600581901b8701602090810151604080515f8185015260609290921b6001600160601b031916602c830152918152906001600160401b039082019081119082111762000433576040810160405260208151910151906020811062000447575b50906006549168010000000000000000831015620004335760018301806006558310156200041f577ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f9092018290555f9182526008602052604090912080546001600160601b031916905560010162000342565b634e487b7160e01b5f52603260045260245ffd5b634e487b7160e01b5f52604160045260245ffd5b5f199060200360031b1b165f620003ab565b506001600160a01b0387169384620005c7575b1562000531575b6200049a9261010052610120526101609283526101409360018060a01b0316845262000a0e565b5060405190612cd7928362000aa08439608051836115c7015260a05183612234015260c0518361225b015260e051838181610b2501528181610c3c015281816111a701528181611369015281816114e101528181611a3d0152818161257a0152612c3e0152610100518361034001526101205183611e390152518281816103b901526107020152518181816107de01526119ac0152f35b6040516356c4d0db60e01b81526001600160a01b038481166004830152602090829060249082905f908b165af1908115620005bc575f9162000586575b506200047357604051631a8e7ecb60e01b8152600490fd5b620005ad915060203d602011620005b4575b620005a481836200090b565b810190620009b9565b866200056e565b503d62000598565b6040513d5f823e3d90fd5b604051630eac692560e21b81526001600160a01b03851660048201526020816024815f8a5af1908115620005bc575f9162000615575b506200046c57604051631a8e7ecb60e01b8152600490fd5b62000632915060203d602011620005b457620005a481836200090b565b87620005fd565b60405163d92e233d60e01b8152600490fd5b506001600160a01b038716156200033b565b63d92e233d60e01b8152600490fd5b505f80805290915f80516020620037778339815191525b8183106200069e575050906020620002619282010162000253565b602091935080600191548385880101520191019091839262000683565b602092506200026194915060ff191682840152151560051b82010162000253565b015190505f806200020a565b60015f90815293505f805160206200379783398151915291905b601f198416851062000747576001945083601f198116106200072e575b505050811b016001556200021f565b01515f1960f88460031b161c191690555f80806200071f565b8181015183556020948501946001909301929091019062000702565b60015f529091505f8051602062003797833981519152601f840160051c810160208510620007b9575b90849392915b601f830160051c82018110620007aa575050620001f2565b5f815585945060010162000792565b50806200078c565b015190505f80620001b3565b5f8080525f80516020620037778339815191529350601f198516905b8181106200082857509084600195949392106200080f575b505050811b015f55620001c7565b01515f1960f88460031b161c191690555f808062000801565b92936020600181928786015181550195019301620007e9565b5f80529091505f8051602062003777833981519152601f840160051c81016020851062000896575b90849392915b601f830160051c82018110620008875750506200019b565b5f81558594506001016200086f565b508062000869565b6020939193813d602011620008e3575b81620008bd602093836200090b565b81010312620008df57519060ff82168203620008dc5750915f62000170565b80fd5b5080fd5b3d9150620008ae565b60208091620008fb846200092f565b815201910190620000e8565b5f80fd5b601f909101601f19168101906001600160401b038211908210176200043357604052565b51906001600160a01b03821682036200090757565b919080601f8401121562000907578251906001600160401b03821162000433576040519160209162000980601f8301601f19168401856200090b565b81845282828701011162000907575f5b818110620009a55750825f9394955001015290565b858101830151848201840152820162000990565b908160209103126200090757518015158103620009075790565b90600182811c9216801562000a03575b6020831014620009ef57565b634e487b7160e01b5f52602260045260245ffd5b91607f1691620009e3565b6001600160a01b03165f8181527fec8156718a8372b1db44bb411437d0870f3e3790d4a08526d024ce1b0b668f6b602052604081205490919060ff1662000a9b5781805260096020526040822081835260205260408220600160ff1982541617905533917f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d8180a4600190565b509056fe6080604052600480361015610012575f80fd5b5f3560e01c90816301e1d11414611c8057816301ffc9a714611c2c57816306fdde0314611b8c57816307a2d13a14611481578163095ea7b314611b175781630a28a47714611afa5781630c0a769b14611a0f57816314c5efb8146119db5781631755ff21146102d157816318160ddd146110825781632325b73114611997578163236c56221461195057816323b872dd1461188e578163248a9ca31461186357816325d12e531461181157816327b17240146116275781632f2ff15d146115eb578163313ce567146115ae57816333f7fc2d1461156d5781633644e5151461155357816336568abe1461151057816338d52e0f146114cc578163402d267d1461078857816347fa5f6b1461149e5781634cdad506146114815781635eda170b1461140b5781636e553f651461133157816370a08231146112f95781637ecebe00146112c1578163871c84c71461125f57816389d9268b1461081557816391d148541461121757816394bf804d1461117757816395d89b411461109f57816396c82e571461108257816398e390c614610f4e5781639e96a26014610ea0578163a1f8780914610d68578163a217fddf14610d4e578163a9059cbb14610cc7578163b3d7f6b914610caa578163b460af9414610bc8578163ba08765214610aa4578163ba42126b14610957578163be1f03ac146108f2578163c2b18aa01461082f578163c409075114610815578163c616416b1461078d578163c63d75b614610788578163c6e6f5921461030e578163ce2d80ad146106b1578163ce96cb7714610679578163d505accf146104a9578163d547741f1461046b578163d905777e14610433578163dd4bc10114610433578163dd62ed3e146103e8578163dfca03c9146103a4578163e229db931461036f578163e73cd1a31461032b578163ef8b30f71461030e57508063fae9e9c3146102d65763fe94df88146102d1575f80fd5b611e24565b3461030a57604036600319011261030a5760206103026102f4611d6b565b6102fc611dad565b90612643565b604051908152f35b5f80fd5b3461030a57602036600319011261030a576103026020913561212a565b3461030a575f36600319011261030a576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b3461030a57602036600319011261030a573560065481101561030a57610396602091611f3f565b90546040519160031b1c8152f35b3461030a575f36600319011261030a576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b3461030a57604036600319011261030a57610401611d6b565b610409611dad565b9160018060a01b038092165f5260205260405f2091165f52602052602060405f2054604051908152f35b3461030a57602036600319011261030a576020610302610451611d6b565b6001600160a01b03165f9081526003602052604090205490565b3461030a57604036600319011261030a576104a79035610489611dad565b90805f5260096020526104a2600160405f200154611ff4565b612094565b005b3461030a5760e036600319011261030a576104c2611d6b565b906104cb611dad565b9160443592606435936084359360ff8516850361030a576104ee428710156121a7565b6104f6612230565b9460018060a01b0380951695865f526020946005865260405f209889549960018b0190556040519088888301937f6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c985528b6040850152169a8b606084015287608084015260a083015260c082015260c0815260e081019181831067ffffffffffffffff84111761066657916105c95f94926105b78a9795846040528251902061010083019586909160429261190160f01b8352600283015260228201520190565b0360ff198101835260df190182611d02565b5190206040805191825260ff92909216602082015260a4359181019190915260c435606082015281805260809060015afa1561065b577f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925935f511680151580610652575b610636906121f3565b5f52825260405f20855f5282528060405f2055604051908152a3005b5080861461062d565b6040513d5f823e3d90fd5b604186634e487b7160e01b5f525260245ffd5b3461030a57602036600319011261030a576001600160a01b0361069a611d6b565b165f526003602052602061030260405f205461214c565b3461030a57602036600319011261030a576106ca611d6b565b6106d2611f9d565b6001600160a01b039081168015610777575f91602460209260405194859384926356c4d0db60e01b8452888401527f0000000000000000000000000000000000000000000000000000000000000000165af190811561065b575f91610749575b501561073a57005b604051631a8e7ecb60e01b8152fd5b61076a915060203d8111610770575b6107628183611d02565b810190612b7a565b82610732565b503d610758565b60405163d92e233d60e01b81528390fd5b611e68565b3461030a57602036600319011261030a576107a6611d6b565b6107ae611f9d565b6001600160a01b039081168015610777575f9160246020926040519485938492630eac692560e21b8452888401527f0000000000000000000000000000000000000000000000000000000000000000165af190811561065b575f9161074957501561073a57005b3461030a576104a761082636611ec1565b9291909161255c565b3461030a575f36600319011261030a5760065461084b81612b62565b6108586040519182611d02565b81815261086482612b62565b6020928383019291601f19013684375f5b8181106108c75750509060405192839281840190828552518091526040840192915f5b8281106108a757505050500390f35b83516001600160a01b031685528695509381019392810192600101610898565b806108d3600192611f3f565b838060a01b0391549060031b1c166108eb8286612a69565b5201610875565b3461030a5760208060031936011261030a5761090c611d6b565b50610915612bb6565b90604051918183928301818452825180915281604085019301915f5b82811061094057505050500390f35b835185528695509381019392810192600101610931565b3461030a5760a036600319011261030a57610970611d6b565b610978611dad565b610980611e0e565b60643592909160843591906001600160a01b0390818416840361030a57610a33867f4ccfdd58de1f86e31ebe8caec4f0202a1629eb9cdae4e5b0dfe40fabd81f4855948484165f526007602052610a2384610a1e60405f209a8885169b8c5f5260205260405f20335f5260205260405f2054865f198203610a71575b5050610a1060405193849260208401612508565b03601f198101835282611d02565b61253a565b5f52600860205260405f20612867565b610a40868584841661248b565b604080516001600160a01b03909516855260208501969096521693339290819081015b0390a4602060405160018152f35b610a7a91612109565b8984165f52600760205260405f208d5f5260205260405f20335f5260205260405f20558d866109fc565b3461030a57610ab236611f0a565b9092916001600160a01b038083169233849003610b7b575b610ad38361214c565b948515610b495750928260209692610aef879561030297612b14565b60405191858352888301528316907ffbde797d201c681b91056529119e0b02407c7bb96a4a2c75c01fc9667232c8db60403392a47f000000000000000000000000000000000000000000000000000000000000000061248b565b60649060206040519162461bcd60e51b8352820152600b60248201526a5a45524f5f41535345545360a81b6044820152fd5b835f528460205260405f20335f5260205260405f2054835f198203610ba2575b5050610aca565b610bab91612109565b845f528560205260405f20335f5260205260405f20558683610b9b565b3461030a57602090610302610bdc36611f0a565b93610be683612188565b94610c058660018060a01b039283811694853303610c60575b50612b14565b6040519084825286888301528316907ffbde797d201c681b91056529119e0b02407c7bb96a4a2c75c01fc9667232c8db60403392a47f000000000000000000000000000000000000000000000000000000000000000061248b565b855f52808b5260405f20335f528b5260405f2054835f198203610c85575b5050610bff565b610c8e91612109565b90865f528b5260405f20335f528b5260405f20558a8083610c7e565b3461030a57602036600319011261030a576103026020913561216a565b3461030a57604036600319011261030a57610ce0611d6b565b60243590610ced33612a7d565b610cf681612a7d565b335f52600360205260405f20610d0d838254612109565b905560018060a01b031690815f52600360205260405f208181540190556040519081525f80516020612cab83398151915260203392a3602060405160018152f35b3461030a575f36600319011261030a5760206040515f8152f35b3461030a576020908160031936011261030a5780359067ffffffffffffffff9283831161030a573660238401121561030a578282013593841161030a57602493848401938536918360051b01011161030a57610dc2611f9d565b5f5b818110610dcd57005b6001600160a01b03610de8610de3838589612b92565b612ba2565b1615610e8f57610dfc610de3828488612b92565b90610e286040515f868201526001600160601b0319809460601b16602c820152858152610a1e81611cd2565b916006928354600160401b811015610e7d57610e65610e4f83926001978882019055611f3f565b819391549060031b91821b915f19901b19161790565b90555f526008855260405f2090815416905501610dc4565b89604189634e487b7160e01b5f52525ffd5b60405163d92e233d60e01b81528490fd5b3461030a57610eae36611e8d565b91610edb6040515f60208201526001600160601b03198360601b16602c82015260208152610a1e81611cd2565b5f526008602052610ef18260405f203390612867565b6001600160a01b031691610f0682828561248b565b604080516001600160a01b0390921682526020820192909252339182917f4ccfdd58de1f86e31ebe8caec4f0202a1629eb9cdae4e5b0dfe40fabd81f48559181908101610a63565b3461030a57608036600319011261030a57610f67611d6b565b610f6f611dad565b90604435610f7b611d97565b7f4ccfdd58de1f86e31ebe8caec4f0202a1629eb9cdae4e5b0dfe40fabd81f485561104860018060a01b039361101a8186891697885f5261100b60209a60078c5260405f20998316998a5f528c5260405f20335f528c5260405f2054845f198203611054575b5050604051905f8d8301526001600160601b03199060601b16602c8201528b8152610a1e81611cd2565b5f5260088a5260405f20612867565b61102581858861248b565b604080516001600160a01b03909516855260208501919091523393918291820190565b0390a460405160018152f35b61105d91612109565b8b5f5260078d5260405f208b5f528d5260405f20335f528d5260405f20558c84610fe1565b3461030a575f36600319011261030a576020600254604051908152f35b3461030a575f36600319011261030a576040515f60018054906110c182611c9a565b8085529181811690811561115057506001146110f8575b6110f4846110e881860382611d02565b60405191829182611d24565b0390f35b5f81815292507fb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf65b8284106111385750505081016020016110e8826110d8565b80546020858701810191909152909301928101611120565b60ff191660208087019190915292151560051b850190920192506110e891508390506110d8565b3461030a57604036600319011261030a5760209035611194611dad565b9061119e8161216a565b916111cb8330337f0000000000000000000000000000000000000000000000000000000000000000612406565b6111d58282612ac7565b604051918383528483015260018060a01b0316907fdcbc1c05240f31ff3ad067ef1ee35ce4997762752e3a095284754544f4c709d760403392a3604051908152f35b3461030a57604036600319011261030a57611230611dad565b90355f52600960205260405f209060018060a01b03165f52602052602060ff60405f2054166040519015158152f35b3461030a57606036600319011261030a57611278611d6b565b611280611dad565b90611289611d81565b9160018060a01b038092165f5260076020528160405f2091165f5260205260405f2091165f52602052602060405f2054604051908152f35b3461030a57602036600319011261030a576001600160a01b036112e2611d6b565b165f526005602052602060405f2054604051908152f35b3461030a57602036600319011261030a576001600160a01b0361131a611d6b565b165f526003602052602060405f2054604051908152f35b3461030a57604036600319011261030a57803561134c611dad565b906113568161212a565b9182156113d9576020935061138d8230337f0000000000000000000000000000000000000000000000000000000000000000612406565b6113978382612ac7565b604051918252828483015260018060a01b0316907fdcbc1c05240f31ff3ad067ef1ee35ce4997762752e3a095284754544f4c709d760403392a3604051908152f35b60405162461bcd60e51b8152602081860152600b60248201526a5a45524f5f53484152455360a81b6044820152606490fd5b3461030a5761141936611e8d565b9060018060a01b0380931692835f52600760205260405f20335f5260205260405f20921691825f526020528060405f20556040519081527facaf04c4ff6035fb5bd7edb8b12e16c3f86718368f1af206dd3fa99e3d3b30ec60203392a4602060405160018152f35b3461030a57602036600319011261030a576103026020913561214c565b3461030a57602036600319011261030a57356001600160601b0381160361030a576020600254604051908152f35b3461030a575f36600319011261030a576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b3461030a57604036600319011261030a57611529611dad565b336001600160a01b03821603611543576104a79135612094565b5060405163334bd91960e11b8152fd5b3461030a575f36600319011261030a576020610302612230565b3461030a57604036600319011261030a57602061030261158b611d6b565b611593611df8565b506001600160a01b03165f9081526003602052604090205490565b3461030a575f36600319011261030a57602060405160ff7f0000000000000000000000000000000000000000000000000000000000000000168152f35b3461030a57604036600319011261030a576104a79035611609611dad565b90805f526009602052611622600160405f200154611ff4565b612016565b3461030a576101008060031936011261030a57611642611d6b565b61164a611dad565b92611653611d81565b90606435946084359160a4359060ff8216820361030a57611676428510156121a7565b61167e612230565b9060018060a01b0380941694855f526020976005895260405f20998a549a60018c0190556040519287808c8601947f6c84bb02c8c2b1ad0d07ea0dc9b20311461532af8da46a5db6a1c100bbcd1daf8652169a8b60408701528a6060870152169b8c60808601528d60a086015260c085015260e084015260e0835282019282841067ffffffffffffffff8511176117fe57509161175a5f94926117478b9795846040528251902061012083019586909160429261190160f01b8352600283015260228201520190565b0361011f198101835260ff190182611d02565b5190206040805191825260ff92909216602082015260c4359181019190915260e435606082015281805260809060015afa1561065b5782916117ab86925f51169182151590816117f4575b506121f3565b7facaf04c4ff6035fb5bd7edb8b12e16c3f86718368f1af206dd3fa99e3d3b30ec85604051898152a45f526007815260405f20335f52815260405f20915f525260405f20555f80f35b90508214896117a5565b604190634e487b7160e01b5f525260245ffd5b3461030a57602036600319011261030a57355f526008602052606060405f206001600160601b038154169060018060d01b03600281600184015416920154169060405192835260208301526040820152f35b3461030a57602036600319011261030a57355f5260096020526020600160405f200154604051908152f35b3461030a575f80516020612cab8339815191526118aa36611dc3565b9290936118b683612a7d565b6118bf85612a7d565b60018060a01b0380931692835f52602095828793845260405f20335f52845260405f2054875f19820361192b575b505050845f526003835260405f20611906878254612109565b90551693845f526003825260405f20818154019055604051908152a360405160018152f35b61193491612109565b90865f52845260405f20335f52845260405f20558780876118ed565b3461030a57608036600319011261030a57611969611d6b565b602435611974611e0e565b91610edb81610a1e611984611d97565b95610a1060405193849260208401612508565b3461030a575f36600319011261030a576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b3461030a57606036600319011261030a5760206103026119f9611d6b565b611a01611df8565b611a09611d81565b91612728565b3461030a57611a1d36611dc3565b6001600160a01b03808316939192909190611a3a84308488612406565b827f0000000000000000000000000000000000000000000000000000000000000000168503611a95575b5060405192835216907f50413727b37795d672f09d0997645a955fa227befaefdd4adb611542dea3fd8060203392a4005b611ac390604051905f60208301526001600160601b03199060601b16602c82015260208152610a1e81611cd2565b5f90815260086020526040902060010180546001600160d01b0385811681831601166001600160d01b031990911617905584611a64565b3461030a57602036600319011261030a5761030260209135612188565b3461030a57604036600319011261030a57611b30611d6b565b9060243590335f5260205260405f209160018060a01b031691825f526020528060405f20556040519081527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b92560203392a3602060405160018152f35b3461030a575f36600319011261030a576040515f8054611bab81611c9a565b808452906001908181169081156111505750600114611bd4576110f4846110e881860382611d02565b5f80805292507f290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e5635b828410611c145750505081016020016110e8826110d8565b80546020858701810191909152909301928101611bfc565b3461030a57602036600319011261030a573563ffffffff60e01b811680910361030a57602090637965db0b60e01b8114908115611c6f575b506040519015158152f35b6301ffc9a760e01b14905082611c64565b3461030a575f36600319011261030a576020610302612c23565b90600182811c92168015611cc8575b6020831014611cb457565b634e487b7160e01b5f52602260045260245ffd5b91607f1691611ca9565b6040810190811067ffffffffffffffff821117611cee57604052565b634e487b7160e01b5f52604160045260245ffd5b90601f8019910116810190811067ffffffffffffffff821117611cee57604052565b602080825282518183018190529093925f5b828110611d5757505060409293505f838284010152601f8019910116010190565b818101860151848201604001528501611d36565b600435906001600160a01b038216820361030a57565b604435906001600160a01b038216820361030a57565b606435906001600160a01b038216820361030a57565b602435906001600160a01b038216820361030a57565b606090600319011261030a576001600160a01b0390600435828116810361030a5791602435908116810361030a579060443590565b602435906001600160601b038216820361030a57565b604435906001600160601b038216820361030a57565b3461030a575f36600319011261030a576040517f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03168152602090f35b3461030a57602036600319011261030a57611e81611d6b565b5060206040515f198152f35b606090600319011261030a576001600160a01b03600435818116810361030a579160243591604435908116810361030a5790565b608090600319011261030a576001600160a01b0390600435828116810361030a5791602435908116810361030a57906044356001600160601b038116810361030a579060643590565b606090600319011261030a57600435906001600160a01b0390602435828116810361030a5791604435908116810361030a5790565b600654811015611f745760065f527ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f01905f90565b634e487b7160e01b5f52603260045260245ffd5b8054821015611f74575f5260205f2001905f90565b335f9081527fec8156718a8372b1db44bb411437d0870f3e3790d4a08526d024ce1b0b668f6b602052604081205460ff1615611fd65750565b6044906040519063e2517d3f60e01b82523360048301526024820152fd5b805f52600960205260405f20335f5260205260ff60405f20541615611fd65750565b905f918083526009602052604083209160018060a01b03169182845260205260ff604084205416155f1461208f5780835260096020526040832082845260205260408320600160ff198254161790557f2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d339380a4600190565b505090565b905f918083526009602052604083209160018060a01b03169182845260205260ff6040842054165f1461208f578083526009602052604083208284526020526040832060ff1981541690557ff6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b339380a4600190565b9190820391821161211657565b634e487b7160e01b5f52601160045260245ffd5b60025480612136575090565b9061214991612143612c23565b916123d4565b90565b60025480612158575090565b61214991612164612c23565b906123d4565b60025480612176575090565b61214991612182612c23565b906123e9565b60025480612194575090565b90612149916121a1612c23565b916123e9565b156121ae57565b60405162461bcd60e51b815260206004820152601760248201527f5045524d49545f444541444c494e455f455850495245440000000000000000006044820152606490fd5b156121fa57565b60405162461bcd60e51b815260206004820152600e60248201526d24a72b20a624a22fa9a4a3a722a960911b6044820152606490fd5b5f467f00000000000000000000000000000000000000000000000000000000000000000361227d57507f000000000000000000000000000000000000000000000000000000000000000090565b6040518154829161228d82611c9a565b80825281602094858201946001908782821691825f146123b657505060011461235d575b506122be92500382611d02565b51902091604051918201927f8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f845260408301527fc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc660608301524660808301523060a083015260a0825260c082019082821067ffffffffffffffff831117612349575060405251902090565b634e487b7160e01b81526041600452602490fd5b87805286915087907f290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e5635b85831061239e5750506122be93508201015f6122b1565b80548388018501528694508893909201918101612387565b60ff191688526122be95151560051b85010192505f91506122b19050565b815f1904811182021583021561030a57020490565b815f1904811182021583021561030a570290808204910615150190565b915f8093602095606494604051946323b872dd60e01b865260018060a01b03809216600487015216602485015260448401525af13d15601f3d1160015f51141617161561244f57565b60405162461bcd60e51b81526020600482015260146024820152731514905394d1915497d19493d357d1905253115160621b6044820152606490fd5b60405163a9059cbb60e01b81526001600160a01b03909216600483015260248201929092526020915f9160449183905af13d15601f3d1160015f5114161716156124d157565b60405162461bcd60e51b815260206004820152600f60248201526e1514905394d1915497d19052531151608a1b6044820152606490fd5b60a09190911b6001600160a01b031916815260609190911b6bffffffffffffffffffffffff1916600c82015260200190565b60208151910151906020811061254e575090565b5f199060200360031b1b1690565b6001600160a01b038083169493909261257785308589612406565b837f00000000000000000000000000000000000000000000000000000000000000001686036125d3575b505060405192835216907f50413727b37795d672f09d0997645a955fa227befaefdd4adb611542dea3fd8060203392a4565b610a1e6125ec92610a1060405193849260208401612508565b5f90815260086020526040812060010180546001600160d01b0386811681831601166001600160d01b0319909116179055806125a1565b8181029291811591840414171561211657565b9190820180921161211657565b906b033b2e3c9fd0803ce800000091604051906126825f9260209284848301526001600160601b03199060601b16602c820152828152610a1e81611cd2565b82526008815260408083206001600160a01b0385165f90815260036020529190912054801561270e57916005826126fc6040956126f76126c661270a9a99976127e3565b509860018060a01b0316988988526004850187526126ea8989205460038701611f88565b90549060031b1c90612109565b612623565b958452019052205490612636565b0490565b5060059060409460018060a01b0316845201905220540490565b61275090610a1e6b033b2e3c9fd0803ce80000009493610a1060405193849260208401612508565b5f9081526008602090815260408083206001600160a01b0385168452600390925282205480156127c857916005826127b961270a96956126f76127946040976127e3565b509760018060a01b031697888752600485016020526126ea8888205460038701611f88565b94835201602052205490612636565b5060059060409360018060a01b031683520160205220540490565b90600254801561285f5760018301546b033b2e3c9fd0803ce80000006001600160d01b03918216818102929181159184041417156121165760039161282e9160028701541690612636565b930180545f198101919082116121165761285a9161284b91611f88565b90548386049160031b1c612636565b920690565b505f91508190565b9091600582019160018060a01b038416925f94848652816020526040862054926b033b2e3c9fd0803ce800000094858102958187041490151715612931578484106128bd575b5050604093855260205203912055565b6128d19293506128cc81612945565b61299e565b828452806020526040842054908282106128ec575f806128ad565b60405162461bcd60e51b815260206004820152601b60248201527f496e737566666963656e742070617961626c65207265776172647300000000006044820152606490fd5b634e487b7160e01b87526011600452602487fd5b61294e816127e3565b9160038101918254600160401b811015611cee57610e4f816001958661297694018155611f88565b90556002810165ffffffffffff60d01b93838060d01b03168482541617905501908154169055565b6001600160a01b039091165f8181526004830160208181526040808420546003909252832054939492939192919081612a21575050600390835b858552600582016020526129f160408620918254612636565b905501545f19810193908411612a0d5782526020526040902055565b634e487b7160e01b83526011600452602483fd5b600383019081545f1981019081116129315782612a586003969593612a4c6126f794612a6497611f88565b905490891b1c92611f88565b905490871b1c90612109565b6129d8565b8051821015611f745760209160051b010190565b612a85612bb6565b908151915f90815b848110612a9b575050505050565b80612aa860019284612a69565b5184526008602052612ac185604086206128cc81612945565b01612a8d565b5f80516020612cab83398151915260205f92612ae281612a7d565b612aee85600254612636565b6002556001600160a01b03168084526003825260408085208054870190555194855293a3565b905f80516020612cab83398151915260205f93612b3081612a7d565b60018060a01b0316928385526003825260408520612b4f828254612109565b90558060025403600255604051908152a3565b67ffffffffffffffff8111611cee5760051b60200190565b9081602091031261030a5751801515810361030a5790565b9190811015611f745760051b0190565b356001600160a01b038116810361030a5790565b60405190600654808352826020918282019060065f527ff652222313e28459528d920b65115c16c04f3efc82aaedc97be59f3f377c0d3f935f905b828210612c0957505050612c0792500383611d02565b565b855484526001958601958895509381019390910190612bf1565b6040516370a0823160e01b81523060048201526020816024817f00000000000000000000000000000000000000000000000000000000000000006001600160a01b03165afa90811561065b575f91612c79575090565b906020823d8211612ca2575b81612c9260209383611d02565b81010312612c9f57505190565b80fd5b3d9150612c8556feddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3efa164736f6c6343000814000a290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563b10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6",
}

// ContractABI is the input ABI used to generate the binding from.
// Deprecated: Use ContractMetaData.ABI instead.
var ContractABI = ContractMetaData.ABI

// ContractBin is the compiled bytecode used for deploying new contracts.
// Deprecated: Use ContractMetaData.Bin instead.
var ContractBin = ContractMetaData.Bin

// DeployContract deploys a new Ethereum contract, binding an instance of Contract to it.
func DeployContract(auth *bind.TransactOpts, backend bind.ContractBackend, _asset common.Address, _name string, _symbol string, _rewardTokens []common.Address, _infrared common.Address, _poolAddress common.Address, _rewardsPrecompile common.Address, _distributionPrecompile common.Address, _admin common.Address) (common.Address, *types.Transaction, *Contract, error) {
	parsed, err := ContractMetaData.GetAbi()
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	if parsed == nil {
		return common.Address{}, nil, nil, errors.New("GetABI returned nil")
	}

	address, tx, contract, err := bind.DeployContract(auth, *parsed, common.FromHex(ContractBin), backend, _asset, _name, _symbol, _rewardTokens, _infrared, _poolAddress, _rewardsPrecompile, _distributionPrecompile, _admin)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &Contract{ContractCaller: ContractCaller{contract: contract}, ContractTransactor: ContractTransactor{contract: contract}, ContractFilterer: ContractFilterer{contract: contract}}, nil
}

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

// DOMAINSEPARATOR is a free data retrieval call binding the contract method 0x3644e515.
//
// Solidity: function DOMAIN_SEPARATOR() view returns(bytes32)
func (_Contract *ContractCaller) DOMAINSEPARATOR(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "DOMAIN_SEPARATOR")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// DOMAINSEPARATOR is a free data retrieval call binding the contract method 0x3644e515.
//
// Solidity: function DOMAIN_SEPARATOR() view returns(bytes32)
func (_Contract *ContractSession) DOMAINSEPARATOR() ([32]byte, error) {
	return _Contract.Contract.DOMAINSEPARATOR(&_Contract.CallOpts)
}

// DOMAINSEPARATOR is a free data retrieval call binding the contract method 0x3644e515.
//
// Solidity: function DOMAIN_SEPARATOR() view returns(bytes32)
func (_Contract *ContractCallerSession) DOMAINSEPARATOR() ([32]byte, error) {
	return _Contract.Contract.DOMAINSEPARATOR(&_Contract.CallOpts)
}

// INFRARED is a free data retrieval call binding the contract method 0xe73cd1a3.
//
// Solidity: function INFRARED() view returns(address)
func (_Contract *ContractCaller) INFRARED(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "INFRARED")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// INFRARED is a free data retrieval call binding the contract method 0xe73cd1a3.
//
// Solidity: function INFRARED() view returns(address)
func (_Contract *ContractSession) INFRARED() (common.Address, error) {
	return _Contract.Contract.INFRARED(&_Contract.CallOpts)
}

// INFRARED is a free data retrieval call binding the contract method 0xe73cd1a3.
//
// Solidity: function INFRARED() view returns(address)
func (_Contract *ContractCallerSession) INFRARED() (common.Address, error) {
	return _Contract.Contract.INFRARED(&_Contract.CallOpts)
}

// POOLADDRESS is a free data retrieval call binding the contract method 0xfe94df88.
//
// Solidity: function POOL_ADDRESS() view returns(address)
func (_Contract *ContractCaller) POOLADDRESS(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "POOL_ADDRESS")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// POOLADDRESS is a free data retrieval call binding the contract method 0xfe94df88.
//
// Solidity: function POOL_ADDRESS() view returns(address)
func (_Contract *ContractSession) POOLADDRESS() (common.Address, error) {
	return _Contract.Contract.POOLADDRESS(&_Contract.CallOpts)
}

// POOLADDRESS is a free data retrieval call binding the contract method 0xfe94df88.
//
// Solidity: function POOL_ADDRESS() view returns(address)
func (_Contract *ContractCallerSession) POOLADDRESS() (common.Address, error) {
	return _Contract.Contract.POOLADDRESS(&_Contract.CallOpts)
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

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address , address ) view returns(uint256)
func (_Contract *ContractCaller) Allowance(opts *bind.CallOpts, arg0 common.Address, arg1 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "allowance", arg0, arg1)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address , address ) view returns(uint256)
func (_Contract *ContractSession) Allowance(arg0 common.Address, arg1 common.Address) (*big.Int, error) {
	return _Contract.Contract.Allowance(&_Contract.CallOpts, arg0, arg1)
}

// Allowance is a free data retrieval call binding the contract method 0xdd62ed3e.
//
// Solidity: function allowance(address , address ) view returns(uint256)
func (_Contract *ContractCallerSession) Allowance(arg0 common.Address, arg1 common.Address) (*big.Int, error) {
	return _Contract.Contract.Allowance(&_Contract.CallOpts, arg0, arg1)
}

// Asset is a free data retrieval call binding the contract method 0x38d52e0f.
//
// Solidity: function asset() view returns(address)
func (_Contract *ContractCaller) Asset(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "asset")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Asset is a free data retrieval call binding the contract method 0x38d52e0f.
//
// Solidity: function asset() view returns(address)
func (_Contract *ContractSession) Asset() (common.Address, error) {
	return _Contract.Contract.Asset(&_Contract.CallOpts)
}

// Asset is a free data retrieval call binding the contract method 0x38d52e0f.
//
// Solidity: function asset() view returns(address)
func (_Contract *ContractCallerSession) Asset() (common.Address, error) {
	return _Contract.Contract.Asset(&_Contract.CallOpts)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address ) view returns(uint256)
func (_Contract *ContractCaller) BalanceOf(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "balanceOf", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address ) view returns(uint256)
func (_Contract *ContractSession) BalanceOf(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.BalanceOf(&_Contract.CallOpts, arg0)
}

// BalanceOf is a free data retrieval call binding the contract method 0x70a08231.
//
// Solidity: function balanceOf(address ) view returns(uint256)
func (_Contract *ContractCallerSession) BalanceOf(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.BalanceOf(&_Contract.CallOpts, arg0)
}

// ClaimAllowance is a free data retrieval call binding the contract method 0x871c84c7.
//
// Solidity: function claimAllowance(address , address , address ) view returns(uint256)
func (_Contract *ContractCaller) ClaimAllowance(opts *bind.CallOpts, arg0 common.Address, arg1 common.Address, arg2 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "claimAllowance", arg0, arg1, arg2)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ClaimAllowance is a free data retrieval call binding the contract method 0x871c84c7.
//
// Solidity: function claimAllowance(address , address , address ) view returns(uint256)
func (_Contract *ContractSession) ClaimAllowance(arg0 common.Address, arg1 common.Address, arg2 common.Address) (*big.Int, error) {
	return _Contract.Contract.ClaimAllowance(&_Contract.CallOpts, arg0, arg1, arg2)
}

// ClaimAllowance is a free data retrieval call binding the contract method 0x871c84c7.
//
// Solidity: function claimAllowance(address , address , address ) view returns(uint256)
func (_Contract *ContractCallerSession) ClaimAllowance(arg0 common.Address, arg1 common.Address, arg2 common.Address) (*big.Int, error) {
	return _Contract.Contract.ClaimAllowance(&_Contract.CallOpts, arg0, arg1, arg2)
}

// ConvertToAssets is a free data retrieval call binding the contract method 0x07a2d13a.
//
// Solidity: function convertToAssets(uint256 shares) view returns(uint256)
func (_Contract *ContractCaller) ConvertToAssets(opts *bind.CallOpts, shares *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "convertToAssets", shares)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ConvertToAssets is a free data retrieval call binding the contract method 0x07a2d13a.
//
// Solidity: function convertToAssets(uint256 shares) view returns(uint256)
func (_Contract *ContractSession) ConvertToAssets(shares *big.Int) (*big.Int, error) {
	return _Contract.Contract.ConvertToAssets(&_Contract.CallOpts, shares)
}

// ConvertToAssets is a free data retrieval call binding the contract method 0x07a2d13a.
//
// Solidity: function convertToAssets(uint256 shares) view returns(uint256)
func (_Contract *ContractCallerSession) ConvertToAssets(shares *big.Int) (*big.Int, error) {
	return _Contract.Contract.ConvertToAssets(&_Contract.CallOpts, shares)
}

// ConvertToShares is a free data retrieval call binding the contract method 0xc6e6f592.
//
// Solidity: function convertToShares(uint256 assets) view returns(uint256)
func (_Contract *ContractCaller) ConvertToShares(opts *bind.CallOpts, assets *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "convertToShares", assets)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// ConvertToShares is a free data retrieval call binding the contract method 0xc6e6f592.
//
// Solidity: function convertToShares(uint256 assets) view returns(uint256)
func (_Contract *ContractSession) ConvertToShares(assets *big.Int) (*big.Int, error) {
	return _Contract.Contract.ConvertToShares(&_Contract.CallOpts, assets)
}

// ConvertToShares is a free data retrieval call binding the contract method 0xc6e6f592.
//
// Solidity: function convertToShares(uint256 assets) view returns(uint256)
func (_Contract *ContractCallerSession) ConvertToShares(assets *big.Int) (*big.Int, error) {
	return _Contract.Contract.ConvertToShares(&_Contract.CallOpts, assets)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_Contract *ContractCaller) Decimals(opts *bind.CallOpts) (uint8, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "decimals")

	if err != nil {
		return *new(uint8), err
	}

	out0 := *abi.ConvertType(out[0], new(uint8)).(*uint8)

	return out0, err

}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_Contract *ContractSession) Decimals() (uint8, error) {
	return _Contract.Contract.Decimals(&_Contract.CallOpts)
}

// Decimals is a free data retrieval call binding the contract method 0x313ce567.
//
// Solidity: function decimals() view returns(uint8)
func (_Contract *ContractCallerSession) Decimals() (uint8, error) {
	return _Contract.Contract.Decimals(&_Contract.CallOpts)
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

// KeyToRewardsContainer is a free data retrieval call binding the contract method 0x25d12e53.
//
// Solidity: function keyToRewardsContainer(bytes32 ) view returns(uint96 partition, uint208 suppliedSinceLastUpdate, uint208 currentSupplyError)
func (_Contract *ContractCaller) KeyToRewardsContainer(opts *bind.CallOpts, arg0 [32]byte) (struct {
	Partition               *big.Int
	SuppliedSinceLastUpdate *big.Int
	CurrentSupplyError      *big.Int
}, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "keyToRewardsContainer", arg0)

	outstruct := new(struct {
		Partition               *big.Int
		SuppliedSinceLastUpdate *big.Int
		CurrentSupplyError      *big.Int
	})
	if err != nil {
		return *outstruct, err
	}

	outstruct.Partition = *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)
	outstruct.SuppliedSinceLastUpdate = *abi.ConvertType(out[1], new(*big.Int)).(**big.Int)
	outstruct.CurrentSupplyError = *abi.ConvertType(out[2], new(*big.Int)).(**big.Int)

	return *outstruct, err

}

// KeyToRewardsContainer is a free data retrieval call binding the contract method 0x25d12e53.
//
// Solidity: function keyToRewardsContainer(bytes32 ) view returns(uint96 partition, uint208 suppliedSinceLastUpdate, uint208 currentSupplyError)
func (_Contract *ContractSession) KeyToRewardsContainer(arg0 [32]byte) (struct {
	Partition               *big.Int
	SuppliedSinceLastUpdate *big.Int
	CurrentSupplyError      *big.Int
}, error) {
	return _Contract.Contract.KeyToRewardsContainer(&_Contract.CallOpts, arg0)
}

// KeyToRewardsContainer is a free data retrieval call binding the contract method 0x25d12e53.
//
// Solidity: function keyToRewardsContainer(bytes32 ) view returns(uint96 partition, uint208 suppliedSinceLastUpdate, uint208 currentSupplyError)
func (_Contract *ContractCallerSession) KeyToRewardsContainer(arg0 [32]byte) (struct {
	Partition               *big.Int
	SuppliedSinceLastUpdate *big.Int
	CurrentSupplyError      *big.Int
}, error) {
	return _Contract.Contract.KeyToRewardsContainer(&_Contract.CallOpts, arg0)
}

// MaxClaimable is a free data retrieval call binding the contract method 0x14c5efb8.
//
// Solidity: function maxClaimable(address reward, uint96 id, address owner) view returns(uint256 amount)
func (_Contract *ContractCaller) MaxClaimable(opts *bind.CallOpts, reward common.Address, id *big.Int, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "maxClaimable", reward, id, owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxClaimable is a free data retrieval call binding the contract method 0x14c5efb8.
//
// Solidity: function maxClaimable(address reward, uint96 id, address owner) view returns(uint256 amount)
func (_Contract *ContractSession) MaxClaimable(reward common.Address, id *big.Int, owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxClaimable(&_Contract.CallOpts, reward, id, owner)
}

// MaxClaimable is a free data retrieval call binding the contract method 0x14c5efb8.
//
// Solidity: function maxClaimable(address reward, uint96 id, address owner) view returns(uint256 amount)
func (_Contract *ContractCallerSession) MaxClaimable(reward common.Address, id *big.Int, owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxClaimable(&_Contract.CallOpts, reward, id, owner)
}

// MaxClaimable0 is a free data retrieval call binding the contract method 0xfae9e9c3.
//
// Solidity: function maxClaimable(address reward, address owner) view returns(uint256 amount)
func (_Contract *ContractCaller) MaxClaimable0(opts *bind.CallOpts, reward common.Address, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "maxClaimable0", reward, owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxClaimable0 is a free data retrieval call binding the contract method 0xfae9e9c3.
//
// Solidity: function maxClaimable(address reward, address owner) view returns(uint256 amount)
func (_Contract *ContractSession) MaxClaimable0(reward common.Address, owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxClaimable0(&_Contract.CallOpts, reward, owner)
}

// MaxClaimable0 is a free data retrieval call binding the contract method 0xfae9e9c3.
//
// Solidity: function maxClaimable(address reward, address owner) view returns(uint256 amount)
func (_Contract *ContractCallerSession) MaxClaimable0(reward common.Address, owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxClaimable0(&_Contract.CallOpts, reward, owner)
}

// MaxDeposit is a free data retrieval call binding the contract method 0x402d267d.
//
// Solidity: function maxDeposit(address ) view returns(uint256)
func (_Contract *ContractCaller) MaxDeposit(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "maxDeposit", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxDeposit is a free data retrieval call binding the contract method 0x402d267d.
//
// Solidity: function maxDeposit(address ) view returns(uint256)
func (_Contract *ContractSession) MaxDeposit(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxDeposit(&_Contract.CallOpts, arg0)
}

// MaxDeposit is a free data retrieval call binding the contract method 0x402d267d.
//
// Solidity: function maxDeposit(address ) view returns(uint256)
func (_Contract *ContractCallerSession) MaxDeposit(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxDeposit(&_Contract.CallOpts, arg0)
}

// MaxMint is a free data retrieval call binding the contract method 0xc63d75b6.
//
// Solidity: function maxMint(address ) view returns(uint256)
func (_Contract *ContractCaller) MaxMint(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "maxMint", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxMint is a free data retrieval call binding the contract method 0xc63d75b6.
//
// Solidity: function maxMint(address ) view returns(uint256)
func (_Contract *ContractSession) MaxMint(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxMint(&_Contract.CallOpts, arg0)
}

// MaxMint is a free data retrieval call binding the contract method 0xc63d75b6.
//
// Solidity: function maxMint(address ) view returns(uint256)
func (_Contract *ContractCallerSession) MaxMint(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxMint(&_Contract.CallOpts, arg0)
}

// MaxRedeem is a free data retrieval call binding the contract method 0xd905777e.
//
// Solidity: function maxRedeem(address owner) view returns(uint256)
func (_Contract *ContractCaller) MaxRedeem(opts *bind.CallOpts, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "maxRedeem", owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxRedeem is a free data retrieval call binding the contract method 0xd905777e.
//
// Solidity: function maxRedeem(address owner) view returns(uint256)
func (_Contract *ContractSession) MaxRedeem(owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxRedeem(&_Contract.CallOpts, owner)
}

// MaxRedeem is a free data retrieval call binding the contract method 0xd905777e.
//
// Solidity: function maxRedeem(address owner) view returns(uint256)
func (_Contract *ContractCallerSession) MaxRedeem(owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxRedeem(&_Contract.CallOpts, owner)
}

// MaxWithdraw is a free data retrieval call binding the contract method 0xce96cb77.
//
// Solidity: function maxWithdraw(address owner) view returns(uint256)
func (_Contract *ContractCaller) MaxWithdraw(opts *bind.CallOpts, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "maxWithdraw", owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// MaxWithdraw is a free data retrieval call binding the contract method 0xce96cb77.
//
// Solidity: function maxWithdraw(address owner) view returns(uint256)
func (_Contract *ContractSession) MaxWithdraw(owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxWithdraw(&_Contract.CallOpts, owner)
}

// MaxWithdraw is a free data retrieval call binding the contract method 0xce96cb77.
//
// Solidity: function maxWithdraw(address owner) view returns(uint256)
func (_Contract *ContractCallerSession) MaxWithdraw(owner common.Address) (*big.Int, error) {
	return _Contract.Contract.MaxWithdraw(&_Contract.CallOpts, owner)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_Contract *ContractCaller) Name(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "name")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_Contract *ContractSession) Name() (string, error) {
	return _Contract.Contract.Name(&_Contract.CallOpts)
}

// Name is a free data retrieval call binding the contract method 0x06fdde03.
//
// Solidity: function name() view returns(string)
func (_Contract *ContractCallerSession) Name() (string, error) {
	return _Contract.Contract.Name(&_Contract.CallOpts)
}

// Nonces is a free data retrieval call binding the contract method 0x7ecebe00.
//
// Solidity: function nonces(address ) view returns(uint256)
func (_Contract *ContractCaller) Nonces(opts *bind.CallOpts, arg0 common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "nonces", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// Nonces is a free data retrieval call binding the contract method 0x7ecebe00.
//
// Solidity: function nonces(address ) view returns(uint256)
func (_Contract *ContractSession) Nonces(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.Nonces(&_Contract.CallOpts, arg0)
}

// Nonces is a free data retrieval call binding the contract method 0x7ecebe00.
//
// Solidity: function nonces(address ) view returns(uint256)
func (_Contract *ContractCallerSession) Nonces(arg0 common.Address) (*big.Int, error) {
	return _Contract.Contract.Nonces(&_Contract.CallOpts, arg0)
}

// PoolAddress is a free data retrieval call binding the contract method 0x1755ff21.
//
// Solidity: function poolAddress() view returns(address _poolAddress)
func (_Contract *ContractCaller) PoolAddress(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "poolAddress")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// PoolAddress is a free data retrieval call binding the contract method 0x1755ff21.
//
// Solidity: function poolAddress() view returns(address _poolAddress)
func (_Contract *ContractSession) PoolAddress() (common.Address, error) {
	return _Contract.Contract.PoolAddress(&_Contract.CallOpts)
}

// PoolAddress is a free data retrieval call binding the contract method 0x1755ff21.
//
// Solidity: function poolAddress() view returns(address _poolAddress)
func (_Contract *ContractCallerSession) PoolAddress() (common.Address, error) {
	return _Contract.Contract.PoolAddress(&_Contract.CallOpts)
}

// PreviewDeposit is a free data retrieval call binding the contract method 0xef8b30f7.
//
// Solidity: function previewDeposit(uint256 assets) view returns(uint256)
func (_Contract *ContractCaller) PreviewDeposit(opts *bind.CallOpts, assets *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "previewDeposit", assets)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewDeposit is a free data retrieval call binding the contract method 0xef8b30f7.
//
// Solidity: function previewDeposit(uint256 assets) view returns(uint256)
func (_Contract *ContractSession) PreviewDeposit(assets *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewDeposit(&_Contract.CallOpts, assets)
}

// PreviewDeposit is a free data retrieval call binding the contract method 0xef8b30f7.
//
// Solidity: function previewDeposit(uint256 assets) view returns(uint256)
func (_Contract *ContractCallerSession) PreviewDeposit(assets *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewDeposit(&_Contract.CallOpts, assets)
}

// PreviewMint is a free data retrieval call binding the contract method 0xb3d7f6b9.
//
// Solidity: function previewMint(uint256 shares) view returns(uint256)
func (_Contract *ContractCaller) PreviewMint(opts *bind.CallOpts, shares *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "previewMint", shares)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewMint is a free data retrieval call binding the contract method 0xb3d7f6b9.
//
// Solidity: function previewMint(uint256 shares) view returns(uint256)
func (_Contract *ContractSession) PreviewMint(shares *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewMint(&_Contract.CallOpts, shares)
}

// PreviewMint is a free data retrieval call binding the contract method 0xb3d7f6b9.
//
// Solidity: function previewMint(uint256 shares) view returns(uint256)
func (_Contract *ContractCallerSession) PreviewMint(shares *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewMint(&_Contract.CallOpts, shares)
}

// PreviewRedeem is a free data retrieval call binding the contract method 0x4cdad506.
//
// Solidity: function previewRedeem(uint256 shares) view returns(uint256)
func (_Contract *ContractCaller) PreviewRedeem(opts *bind.CallOpts, shares *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "previewRedeem", shares)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewRedeem is a free data retrieval call binding the contract method 0x4cdad506.
//
// Solidity: function previewRedeem(uint256 shares) view returns(uint256)
func (_Contract *ContractSession) PreviewRedeem(shares *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewRedeem(&_Contract.CallOpts, shares)
}

// PreviewRedeem is a free data retrieval call binding the contract method 0x4cdad506.
//
// Solidity: function previewRedeem(uint256 shares) view returns(uint256)
func (_Contract *ContractCallerSession) PreviewRedeem(shares *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewRedeem(&_Contract.CallOpts, shares)
}

// PreviewWithdraw is a free data retrieval call binding the contract method 0x0a28a477.
//
// Solidity: function previewWithdraw(uint256 assets) view returns(uint256)
func (_Contract *ContractCaller) PreviewWithdraw(opts *bind.CallOpts, assets *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "previewWithdraw", assets)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// PreviewWithdraw is a free data retrieval call binding the contract method 0x0a28a477.
//
// Solidity: function previewWithdraw(uint256 assets) view returns(uint256)
func (_Contract *ContractSession) PreviewWithdraw(assets *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewWithdraw(&_Contract.CallOpts, assets)
}

// PreviewWithdraw is a free data retrieval call binding the contract method 0x0a28a477.
//
// Solidity: function previewWithdraw(uint256 assets) view returns(uint256)
func (_Contract *ContractCallerSession) PreviewWithdraw(assets *big.Int) (*big.Int, error) {
	return _Contract.Contract.PreviewWithdraw(&_Contract.CallOpts, assets)
}

// RewardKeys is a free data retrieval call binding the contract method 0xe229db93.
//
// Solidity: function rewardKeys(uint256 ) view returns(bytes32)
func (_Contract *ContractCaller) RewardKeys(opts *bind.CallOpts, arg0 *big.Int) ([32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "rewardKeys", arg0)

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// RewardKeys is a free data retrieval call binding the contract method 0xe229db93.
//
// Solidity: function rewardKeys(uint256 ) view returns(bytes32)
func (_Contract *ContractSession) RewardKeys(arg0 *big.Int) ([32]byte, error) {
	return _Contract.Contract.RewardKeys(&_Contract.CallOpts, arg0)
}

// RewardKeys is a free data retrieval call binding the contract method 0xe229db93.
//
// Solidity: function rewardKeys(uint256 ) view returns(bytes32)
func (_Contract *ContractCallerSession) RewardKeys(arg0 *big.Int) ([32]byte, error) {
	return _Contract.Contract.RewardKeys(&_Contract.CallOpts, arg0)
}

// RewardKeysOf is a free data retrieval call binding the contract method 0xbe1f03ac.
//
// Solidity: function rewardKeysOf(address ) view returns(bytes32[] _rk)
func (_Contract *ContractCaller) RewardKeysOf(opts *bind.CallOpts, arg0 common.Address) ([][32]byte, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "rewardKeysOf", arg0)

	if err != nil {
		return *new([][32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([][32]byte)).(*[][32]byte)

	return out0, err

}

// RewardKeysOf is a free data retrieval call binding the contract method 0xbe1f03ac.
//
// Solidity: function rewardKeysOf(address ) view returns(bytes32[] _rk)
func (_Contract *ContractSession) RewardKeysOf(arg0 common.Address) ([][32]byte, error) {
	return _Contract.Contract.RewardKeysOf(&_Contract.CallOpts, arg0)
}

// RewardKeysOf is a free data retrieval call binding the contract method 0xbe1f03ac.
//
// Solidity: function rewardKeysOf(address ) view returns(bytes32[] _rk)
func (_Contract *ContractCallerSession) RewardKeysOf(arg0 common.Address) ([][32]byte, error) {
	return _Contract.Contract.RewardKeysOf(&_Contract.CallOpts, arg0)
}

// RewardTokens is a free data retrieval call binding the contract method 0xc2b18aa0.
//
// Solidity: function rewardTokens() view returns(address[] _rewardTokens)
func (_Contract *ContractCaller) RewardTokens(opts *bind.CallOpts) ([]common.Address, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "rewardTokens")

	if err != nil {
		return *new([]common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new([]common.Address)).(*[]common.Address)

	return out0, err

}

// RewardTokens is a free data retrieval call binding the contract method 0xc2b18aa0.
//
// Solidity: function rewardTokens() view returns(address[] _rewardTokens)
func (_Contract *ContractSession) RewardTokens() ([]common.Address, error) {
	return _Contract.Contract.RewardTokens(&_Contract.CallOpts)
}

// RewardTokens is a free data retrieval call binding the contract method 0xc2b18aa0.
//
// Solidity: function rewardTokens() view returns(address[] _rewardTokens)
func (_Contract *ContractCallerSession) RewardTokens() ([]common.Address, error) {
	return _Contract.Contract.RewardTokens(&_Contract.CallOpts)
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

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_Contract *ContractCaller) Symbol(opts *bind.CallOpts) (string, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "symbol")

	if err != nil {
		return *new(string), err
	}

	out0 := *abi.ConvertType(out[0], new(string)).(*string)

	return out0, err

}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_Contract *ContractSession) Symbol() (string, error) {
	return _Contract.Contract.Symbol(&_Contract.CallOpts)
}

// Symbol is a free data retrieval call binding the contract method 0x95d89b41.
//
// Solidity: function symbol() view returns(string)
func (_Contract *ContractCallerSession) Symbol() (string, error) {
	return _Contract.Contract.Symbol(&_Contract.CallOpts)
}

// TotalAssets is a free data retrieval call binding the contract method 0x01e1d114.
//
// Solidity: function totalAssets() view returns(uint256 _assets)
func (_Contract *ContractCaller) TotalAssets(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "totalAssets")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalAssets is a free data retrieval call binding the contract method 0x01e1d114.
//
// Solidity: function totalAssets() view returns(uint256 _assets)
func (_Contract *ContractSession) TotalAssets() (*big.Int, error) {
	return _Contract.Contract.TotalAssets(&_Contract.CallOpts)
}

// TotalAssets is a free data retrieval call binding the contract method 0x01e1d114.
//
// Solidity: function totalAssets() view returns(uint256 _assets)
func (_Contract *ContractCallerSession) TotalAssets() (*big.Int, error) {
	return _Contract.Contract.TotalAssets(&_Contract.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_Contract *ContractCaller) TotalSupply(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "totalSupply")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_Contract *ContractSession) TotalSupply() (*big.Int, error) {
	return _Contract.Contract.TotalSupply(&_Contract.CallOpts)
}

// TotalSupply is a free data retrieval call binding the contract method 0x18160ddd.
//
// Solidity: function totalSupply() view returns(uint256)
func (_Contract *ContractCallerSession) TotalSupply() (*big.Int, error) {
	return _Contract.Contract.TotalSupply(&_Contract.CallOpts)
}

// TotalWeight is a free data retrieval call binding the contract method 0x47fa5f6b.
//
// Solidity: function totalWeight(uint96 ) view returns(uint256 _tw)
func (_Contract *ContractCaller) TotalWeight(opts *bind.CallOpts, arg0 *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "totalWeight", arg0)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalWeight is a free data retrieval call binding the contract method 0x47fa5f6b.
//
// Solidity: function totalWeight(uint96 ) view returns(uint256 _tw)
func (_Contract *ContractSession) TotalWeight(arg0 *big.Int) (*big.Int, error) {
	return _Contract.Contract.TotalWeight(&_Contract.CallOpts, arg0)
}

// TotalWeight is a free data retrieval call binding the contract method 0x47fa5f6b.
//
// Solidity: function totalWeight(uint96 ) view returns(uint256 _tw)
func (_Contract *ContractCallerSession) TotalWeight(arg0 *big.Int) (*big.Int, error) {
	return _Contract.Contract.TotalWeight(&_Contract.CallOpts, arg0)
}

// TotalWeight0 is a free data retrieval call binding the contract method 0x96c82e57.
//
// Solidity: function totalWeight() view returns(uint256)
func (_Contract *ContractCaller) TotalWeight0(opts *bind.CallOpts) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "totalWeight0")

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// TotalWeight0 is a free data retrieval call binding the contract method 0x96c82e57.
//
// Solidity: function totalWeight() view returns(uint256)
func (_Contract *ContractSession) TotalWeight0() (*big.Int, error) {
	return _Contract.Contract.TotalWeight0(&_Contract.CallOpts)
}

// TotalWeight0 is a free data retrieval call binding the contract method 0x96c82e57.
//
// Solidity: function totalWeight() view returns(uint256)
func (_Contract *ContractCallerSession) TotalWeight0() (*big.Int, error) {
	return _Contract.Contract.TotalWeight0(&_Contract.CallOpts)
}

// WeightOf is a free data retrieval call binding the contract method 0x33f7fc2d.
//
// Solidity: function weightOf(address _user, uint96 ) view returns(uint256 _wo)
func (_Contract *ContractCaller) WeightOf(opts *bind.CallOpts, _user common.Address, arg1 *big.Int) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "weightOf", _user, arg1)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// WeightOf is a free data retrieval call binding the contract method 0x33f7fc2d.
//
// Solidity: function weightOf(address _user, uint96 ) view returns(uint256 _wo)
func (_Contract *ContractSession) WeightOf(_user common.Address, arg1 *big.Int) (*big.Int, error) {
	return _Contract.Contract.WeightOf(&_Contract.CallOpts, _user, arg1)
}

// WeightOf is a free data retrieval call binding the contract method 0x33f7fc2d.
//
// Solidity: function weightOf(address _user, uint96 ) view returns(uint256 _wo)
func (_Contract *ContractCallerSession) WeightOf(_user common.Address, arg1 *big.Int) (*big.Int, error) {
	return _Contract.Contract.WeightOf(&_Contract.CallOpts, _user, arg1)
}

// WeightOf0 is a free data retrieval call binding the contract method 0xdd4bc101.
//
// Solidity: function weightOf(address owner) view returns(uint256)
func (_Contract *ContractCaller) WeightOf0(opts *bind.CallOpts, owner common.Address) (*big.Int, error) {
	var out []interface{}
	err := _Contract.contract.Call(opts, &out, "weightOf0", owner)

	if err != nil {
		return *new(*big.Int), err
	}

	out0 := *abi.ConvertType(out[0], new(*big.Int)).(**big.Int)

	return out0, err

}

// WeightOf0 is a free data retrieval call binding the contract method 0xdd4bc101.
//
// Solidity: function weightOf(address owner) view returns(uint256)
func (_Contract *ContractSession) WeightOf0(owner common.Address) (*big.Int, error) {
	return _Contract.Contract.WeightOf0(&_Contract.CallOpts, owner)
}

// WeightOf0 is a free data retrieval call binding the contract method 0xdd4bc101.
//
// Solidity: function weightOf(address owner) view returns(uint256)
func (_Contract *ContractCallerSession) WeightOf0(owner common.Address) (*big.Int, error) {
	return _Contract.Contract.WeightOf0(&_Contract.CallOpts, owner)
}

// Supply1 is a paid mutator transaction binding the contract method 0x89d9268b.
//
// Solidity: function _supply(address supplier, address reward, uint96 partition, uint256 amount) returns()
func (_Contract *ContractTransactor) Supply1(opts *bind.TransactOpts, supplier common.Address, reward common.Address, partition *big.Int, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "_supply", supplier, reward, partition, amount)
}

// Supply1 is a paid mutator transaction binding the contract method 0x89d9268b.
//
// Solidity: function _supply(address supplier, address reward, uint96 partition, uint256 amount) returns()
func (_Contract *ContractSession) Supply1(supplier common.Address, reward common.Address, partition *big.Int, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Supply1(&_Contract.TransactOpts, supplier, reward, partition, amount)
}

// Supply1 is a paid mutator transaction binding the contract method 0x89d9268b.
//
// Solidity: function _supply(address supplier, address reward, uint96 partition, uint256 amount) returns()
func (_Contract *ContractTransactorSession) Supply1(supplier common.Address, reward common.Address, partition *big.Int, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Supply1(&_Contract.TransactOpts, supplier, reward, partition, amount)
}

// AddRewardTokens is a paid mutator transaction binding the contract method 0xa1f87809.
//
// Solidity: function addRewardTokens(address[] _rewardTokens) returns()
func (_Contract *ContractTransactor) AddRewardTokens(opts *bind.TransactOpts, _rewardTokens []common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "addRewardTokens", _rewardTokens)
}

// AddRewardTokens is a paid mutator transaction binding the contract method 0xa1f87809.
//
// Solidity: function addRewardTokens(address[] _rewardTokens) returns()
func (_Contract *ContractSession) AddRewardTokens(_rewardTokens []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.AddRewardTokens(&_Contract.TransactOpts, _rewardTokens)
}

// AddRewardTokens is a paid mutator transaction binding the contract method 0xa1f87809.
//
// Solidity: function addRewardTokens(address[] _rewardTokens) returns()
func (_Contract *ContractTransactorSession) AddRewardTokens(_rewardTokens []common.Address) (*types.Transaction, error) {
	return _Contract.Contract.AddRewardTokens(&_Contract.TransactOpts, _rewardTokens)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_Contract *ContractTransactor) Approve(opts *bind.TransactOpts, spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "approve", spender, amount)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_Contract *ContractSession) Approve(spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Approve(&_Contract.TransactOpts, spender, amount)
}

// Approve is a paid mutator transaction binding the contract method 0x095ea7b3.
//
// Solidity: function approve(address spender, uint256 amount) returns(bool)
func (_Contract *ContractTransactorSession) Approve(spender common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Approve(&_Contract.TransactOpts, spender, amount)
}

// ApproveClaim is a paid mutator transaction binding the contract method 0x5eda170b.
//
// Solidity: function approveClaim(address reward, uint256 amount, address claimer) returns(bool success)
func (_Contract *ContractTransactor) ApproveClaim(opts *bind.TransactOpts, reward common.Address, amount *big.Int, claimer common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "approveClaim", reward, amount, claimer)
}

// ApproveClaim is a paid mutator transaction binding the contract method 0x5eda170b.
//
// Solidity: function approveClaim(address reward, uint256 amount, address claimer) returns(bool success)
func (_Contract *ContractSession) ApproveClaim(reward common.Address, amount *big.Int, claimer common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ApproveClaim(&_Contract.TransactOpts, reward, amount, claimer)
}

// ApproveClaim is a paid mutator transaction binding the contract method 0x5eda170b.
//
// Solidity: function approveClaim(address reward, uint256 amount, address claimer) returns(bool success)
func (_Contract *ContractTransactorSession) ApproveClaim(reward common.Address, amount *big.Int, claimer common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ApproveClaim(&_Contract.TransactOpts, reward, amount, claimer)
}

// ChangeDistributionWithdrawAddress is a paid mutator transaction binding the contract method 0xc616416b.
//
// Solidity: function changeDistributionWithdrawAddress(address _withdrawAddress) returns()
func (_Contract *ContractTransactor) ChangeDistributionWithdrawAddress(opts *bind.TransactOpts, _withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "changeDistributionWithdrawAddress", _withdrawAddress)
}

// ChangeDistributionWithdrawAddress is a paid mutator transaction binding the contract method 0xc616416b.
//
// Solidity: function changeDistributionWithdrawAddress(address _withdrawAddress) returns()
func (_Contract *ContractSession) ChangeDistributionWithdrawAddress(_withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ChangeDistributionWithdrawAddress(&_Contract.TransactOpts, _withdrawAddress)
}

// ChangeDistributionWithdrawAddress is a paid mutator transaction binding the contract method 0xc616416b.
//
// Solidity: function changeDistributionWithdrawAddress(address _withdrawAddress) returns()
func (_Contract *ContractTransactorSession) ChangeDistributionWithdrawAddress(_withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ChangeDistributionWithdrawAddress(&_Contract.TransactOpts, _withdrawAddress)
}

// ChangeRewardsWithdrawAddress is a paid mutator transaction binding the contract method 0xce2d80ad.
//
// Solidity: function changeRewardsWithdrawAddress(address _withdrawAddress) returns()
func (_Contract *ContractTransactor) ChangeRewardsWithdrawAddress(opts *bind.TransactOpts, _withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "changeRewardsWithdrawAddress", _withdrawAddress)
}

// ChangeRewardsWithdrawAddress is a paid mutator transaction binding the contract method 0xce2d80ad.
//
// Solidity: function changeRewardsWithdrawAddress(address _withdrawAddress) returns()
func (_Contract *ContractSession) ChangeRewardsWithdrawAddress(_withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ChangeRewardsWithdrawAddress(&_Contract.TransactOpts, _withdrawAddress)
}

// ChangeRewardsWithdrawAddress is a paid mutator transaction binding the contract method 0xce2d80ad.
//
// Solidity: function changeRewardsWithdrawAddress(address _withdrawAddress) returns()
func (_Contract *ContractTransactorSession) ChangeRewardsWithdrawAddress(_withdrawAddress common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ChangeRewardsWithdrawAddress(&_Contract.TransactOpts, _withdrawAddress)
}

// Claim is a paid mutator transaction binding the contract method 0x236c5622.
//
// Solidity: function claim(address reward, uint256 amount, uint96 partition, address receiver) returns(bool success)
func (_Contract *ContractTransactor) Claim(opts *bind.TransactOpts, reward common.Address, amount *big.Int, partition *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "claim", reward, amount, partition, receiver)
}

// Claim is a paid mutator transaction binding the contract method 0x236c5622.
//
// Solidity: function claim(address reward, uint256 amount, uint96 partition, address receiver) returns(bool success)
func (_Contract *ContractSession) Claim(reward common.Address, amount *big.Int, partition *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Claim(&_Contract.TransactOpts, reward, amount, partition, receiver)
}

// Claim is a paid mutator transaction binding the contract method 0x236c5622.
//
// Solidity: function claim(address reward, uint256 amount, uint96 partition, address receiver) returns(bool success)
func (_Contract *ContractTransactorSession) Claim(reward common.Address, amount *big.Int, partition *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Claim(&_Contract.TransactOpts, reward, amount, partition, receiver)
}

// Claim0 is a paid mutator transaction binding the contract method 0x9e96a260.
//
// Solidity: function claim(address reward, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractTransactor) Claim0(opts *bind.TransactOpts, reward common.Address, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "claim0", reward, amount, receiver)
}

// Claim0 is a paid mutator transaction binding the contract method 0x9e96a260.
//
// Solidity: function claim(address reward, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractSession) Claim0(reward common.Address, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Claim0(&_Contract.TransactOpts, reward, amount, receiver)
}

// Claim0 is a paid mutator transaction binding the contract method 0x9e96a260.
//
// Solidity: function claim(address reward, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractTransactorSession) Claim0(reward common.Address, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Claim0(&_Contract.TransactOpts, reward, amount, receiver)
}

// ClaimFor is a paid mutator transaction binding the contract method 0x98e390c6.
//
// Solidity: function claimFor(address owner, address reward, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractTransactor) ClaimFor(opts *bind.TransactOpts, owner common.Address, reward common.Address, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "claimFor", owner, reward, amount, receiver)
}

// ClaimFor is a paid mutator transaction binding the contract method 0x98e390c6.
//
// Solidity: function claimFor(address owner, address reward, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractSession) ClaimFor(owner common.Address, reward common.Address, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ClaimFor(&_Contract.TransactOpts, owner, reward, amount, receiver)
}

// ClaimFor is a paid mutator transaction binding the contract method 0x98e390c6.
//
// Solidity: function claimFor(address owner, address reward, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractTransactorSession) ClaimFor(owner common.Address, reward common.Address, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ClaimFor(&_Contract.TransactOpts, owner, reward, amount, receiver)
}

// ClaimFor0 is a paid mutator transaction binding the contract method 0xba42126b.
//
// Solidity: function claimFor(address owner, address reward, uint96 partition, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractTransactor) ClaimFor0(opts *bind.TransactOpts, owner common.Address, reward common.Address, partition *big.Int, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "claimFor0", owner, reward, partition, amount, receiver)
}

// ClaimFor0 is a paid mutator transaction binding the contract method 0xba42126b.
//
// Solidity: function claimFor(address owner, address reward, uint96 partition, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractSession) ClaimFor0(owner common.Address, reward common.Address, partition *big.Int, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ClaimFor0(&_Contract.TransactOpts, owner, reward, partition, amount, receiver)
}

// ClaimFor0 is a paid mutator transaction binding the contract method 0xba42126b.
//
// Solidity: function claimFor(address owner, address reward, uint96 partition, uint256 amount, address receiver) returns(bool success)
func (_Contract *ContractTransactorSession) ClaimFor0(owner common.Address, reward common.Address, partition *big.Int, amount *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.ClaimFor0(&_Contract.TransactOpts, owner, reward, partition, amount, receiver)
}

// Deposit is a paid mutator transaction binding the contract method 0x6e553f65.
//
// Solidity: function deposit(uint256 assets, address receiver) returns(uint256 shares)
func (_Contract *ContractTransactor) Deposit(opts *bind.TransactOpts, assets *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "deposit", assets, receiver)
}

// Deposit is a paid mutator transaction binding the contract method 0x6e553f65.
//
// Solidity: function deposit(uint256 assets, address receiver) returns(uint256 shares)
func (_Contract *ContractSession) Deposit(assets *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Deposit(&_Contract.TransactOpts, assets, receiver)
}

// Deposit is a paid mutator transaction binding the contract method 0x6e553f65.
//
// Solidity: function deposit(uint256 assets, address receiver) returns(uint256 shares)
func (_Contract *ContractTransactorSession) Deposit(assets *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Deposit(&_Contract.TransactOpts, assets, receiver)
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

// Mint is a paid mutator transaction binding the contract method 0x94bf804d.
//
// Solidity: function mint(uint256 shares, address receiver) returns(uint256 assets)
func (_Contract *ContractTransactor) Mint(opts *bind.TransactOpts, shares *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "mint", shares, receiver)
}

// Mint is a paid mutator transaction binding the contract method 0x94bf804d.
//
// Solidity: function mint(uint256 shares, address receiver) returns(uint256 assets)
func (_Contract *ContractSession) Mint(shares *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Mint(&_Contract.TransactOpts, shares, receiver)
}

// Mint is a paid mutator transaction binding the contract method 0x94bf804d.
//
// Solidity: function mint(uint256 shares, address receiver) returns(uint256 assets)
func (_Contract *ContractTransactorSession) Mint(shares *big.Int, receiver common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Mint(&_Contract.TransactOpts, shares, receiver)
}

// Permit is a paid mutator transaction binding the contract method 0xd505accf.
//
// Solidity: function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_Contract *ContractTransactor) Permit(opts *bind.TransactOpts, owner common.Address, spender common.Address, value *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "permit", owner, spender, value, deadline, v, r, s)
}

// Permit is a paid mutator transaction binding the contract method 0xd505accf.
//
// Solidity: function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_Contract *ContractSession) Permit(owner common.Address, spender common.Address, value *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.Permit(&_Contract.TransactOpts, owner, spender, value, deadline, v, r, s)
}

// Permit is a paid mutator transaction binding the contract method 0xd505accf.
//
// Solidity: function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_Contract *ContractTransactorSession) Permit(owner common.Address, spender common.Address, value *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.Permit(&_Contract.TransactOpts, owner, spender, value, deadline, v, r, s)
}

// PermitClaim is a paid mutator transaction binding the contract method 0x27b17240.
//
// Solidity: function permitClaim(address reward, address owner, address claimer, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_Contract *ContractTransactor) PermitClaim(opts *bind.TransactOpts, reward common.Address, owner common.Address, claimer common.Address, value *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "permitClaim", reward, owner, claimer, value, deadline, v, r, s)
}

// PermitClaim is a paid mutator transaction binding the contract method 0x27b17240.
//
// Solidity: function permitClaim(address reward, address owner, address claimer, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_Contract *ContractSession) PermitClaim(reward common.Address, owner common.Address, claimer common.Address, value *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.PermitClaim(&_Contract.TransactOpts, reward, owner, claimer, value, deadline, v, r, s)
}

// PermitClaim is a paid mutator transaction binding the contract method 0x27b17240.
//
// Solidity: function permitClaim(address reward, address owner, address claimer, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) returns()
func (_Contract *ContractTransactorSession) PermitClaim(reward common.Address, owner common.Address, claimer common.Address, value *big.Int, deadline *big.Int, v uint8, r [32]byte, s [32]byte) (*types.Transaction, error) {
	return _Contract.Contract.PermitClaim(&_Contract.TransactOpts, reward, owner, claimer, value, deadline, v, r, s)
}

// Redeem is a paid mutator transaction binding the contract method 0xba087652.
//
// Solidity: function redeem(uint256 shares, address receiver, address owner) returns(uint256 assets)
func (_Contract *ContractTransactor) Redeem(opts *bind.TransactOpts, shares *big.Int, receiver common.Address, owner common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "redeem", shares, receiver, owner)
}

// Redeem is a paid mutator transaction binding the contract method 0xba087652.
//
// Solidity: function redeem(uint256 shares, address receiver, address owner) returns(uint256 assets)
func (_Contract *ContractSession) Redeem(shares *big.Int, receiver common.Address, owner common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Redeem(&_Contract.TransactOpts, shares, receiver, owner)
}

// Redeem is a paid mutator transaction binding the contract method 0xba087652.
//
// Solidity: function redeem(uint256 shares, address receiver, address owner) returns(uint256 assets)
func (_Contract *ContractTransactorSession) Redeem(shares *big.Int, receiver common.Address, owner common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Redeem(&_Contract.TransactOpts, shares, receiver, owner)
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

// Supply is a paid mutator transaction binding the contract method 0x0c0a769b.
//
// Solidity: function supply(address supplier, address reward, uint256 amount) returns()
func (_Contract *ContractTransactor) Supply(opts *bind.TransactOpts, supplier common.Address, reward common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "supply", supplier, reward, amount)
}

// Supply is a paid mutator transaction binding the contract method 0x0c0a769b.
//
// Solidity: function supply(address supplier, address reward, uint256 amount) returns()
func (_Contract *ContractSession) Supply(supplier common.Address, reward common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Supply(&_Contract.TransactOpts, supplier, reward, amount)
}

// Supply is a paid mutator transaction binding the contract method 0x0c0a769b.
//
// Solidity: function supply(address supplier, address reward, uint256 amount) returns()
func (_Contract *ContractTransactorSession) Supply(supplier common.Address, reward common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Supply(&_Contract.TransactOpts, supplier, reward, amount)
}

// Supply0 is a paid mutator transaction binding the contract method 0xc4090751.
//
// Solidity: function supply(address supplier, address reward, uint96 partition, uint256 amount) returns()
func (_Contract *ContractTransactor) Supply0(opts *bind.TransactOpts, supplier common.Address, reward common.Address, partition *big.Int, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "supply0", supplier, reward, partition, amount)
}

// Supply0 is a paid mutator transaction binding the contract method 0xc4090751.
//
// Solidity: function supply(address supplier, address reward, uint96 partition, uint256 amount) returns()
func (_Contract *ContractSession) Supply0(supplier common.Address, reward common.Address, partition *big.Int, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Supply0(&_Contract.TransactOpts, supplier, reward, partition, amount)
}

// Supply0 is a paid mutator transaction binding the contract method 0xc4090751.
//
// Solidity: function supply(address supplier, address reward, uint96 partition, uint256 amount) returns()
func (_Contract *ContractTransactorSession) Supply0(supplier common.Address, reward common.Address, partition *big.Int, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Supply0(&_Contract.TransactOpts, supplier, reward, partition, amount)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_Contract *ContractTransactor) Transfer(opts *bind.TransactOpts, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "transfer", to, amount)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_Contract *ContractSession) Transfer(to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Transfer(&_Contract.TransactOpts, to, amount)
}

// Transfer is a paid mutator transaction binding the contract method 0xa9059cbb.
//
// Solidity: function transfer(address to, uint256 amount) returns(bool)
func (_Contract *ContractTransactorSession) Transfer(to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.Transfer(&_Contract.TransactOpts, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_Contract *ContractTransactor) TransferFrom(opts *bind.TransactOpts, from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "transferFrom", from, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_Contract *ContractSession) TransferFrom(from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.TransferFrom(&_Contract.TransactOpts, from, to, amount)
}

// TransferFrom is a paid mutator transaction binding the contract method 0x23b872dd.
//
// Solidity: function transferFrom(address from, address to, uint256 amount) returns(bool)
func (_Contract *ContractTransactorSession) TransferFrom(from common.Address, to common.Address, amount *big.Int) (*types.Transaction, error) {
	return _Contract.Contract.TransferFrom(&_Contract.TransactOpts, from, to, amount)
}

// Withdraw is a paid mutator transaction binding the contract method 0xb460af94.
//
// Solidity: function withdraw(uint256 assets, address receiver, address owner) returns(uint256 shares)
func (_Contract *ContractTransactor) Withdraw(opts *bind.TransactOpts, assets *big.Int, receiver common.Address, owner common.Address) (*types.Transaction, error) {
	return _Contract.contract.Transact(opts, "withdraw", assets, receiver, owner)
}

// Withdraw is a paid mutator transaction binding the contract method 0xb460af94.
//
// Solidity: function withdraw(uint256 assets, address receiver, address owner) returns(uint256 shares)
func (_Contract *ContractSession) Withdraw(assets *big.Int, receiver common.Address, owner common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Withdraw(&_Contract.TransactOpts, assets, receiver, owner)
}

// Withdraw is a paid mutator transaction binding the contract method 0xb460af94.
//
// Solidity: function withdraw(uint256 assets, address receiver, address owner) returns(uint256 shares)
func (_Contract *ContractTransactorSession) Withdraw(assets *big.Int, receiver common.Address, owner common.Address) (*types.Transaction, error) {
	return _Contract.Contract.Withdraw(&_Contract.TransactOpts, assets, receiver, owner)
}

// ContractApprovalIterator is returned from FilterApproval and is used to iterate over the raw logs and unpacked data for Approval events raised by the Contract contract.
type ContractApprovalIterator struct {
	Event *ContractApproval // Event containing the contract specifics and raw log

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
func (it *ContractApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractApproval)
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
		it.Event = new(ContractApproval)
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
func (it *ContractApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractApproval represents a Approval event raised by the Contract contract.
type ContractApproval struct {
	Owner   common.Address
	Spender common.Address
	Amount  *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterApproval is a free log retrieval operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 amount)
func (_Contract *ContractFilterer) FilterApproval(opts *bind.FilterOpts, owner []common.Address, spender []common.Address) (*ContractApprovalIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return &ContractApprovalIterator{contract: _Contract.contract, event: "Approval", logs: logs, sub: sub}, nil
}

// WatchApproval is a free log subscription operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 amount)
func (_Contract *ContractFilterer) WatchApproval(opts *bind.WatchOpts, sink chan<- *ContractApproval, owner []common.Address, spender []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var spenderRule []interface{}
	for _, spenderItem := range spender {
		spenderRule = append(spenderRule, spenderItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Approval", ownerRule, spenderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractApproval)
				if err := _Contract.contract.UnpackLog(event, "Approval", log); err != nil {
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

// ParseApproval is a log parse operation binding the contract event 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925.
//
// Solidity: event Approval(address indexed owner, address indexed spender, uint256 amount)
func (_Contract *ContractFilterer) ParseApproval(log types.Log) (*ContractApproval, error) {
	event := new(ContractApproval)
	if err := _Contract.contract.UnpackLog(event, "Approval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractClaimApprovalIterator is returned from FilterClaimApproval and is used to iterate over the raw logs and unpacked data for ClaimApproval events raised by the Contract contract.
type ContractClaimApprovalIterator struct {
	Event *ContractClaimApproval // Event containing the contract specifics and raw log

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
func (it *ContractClaimApprovalIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractClaimApproval)
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
		it.Event = new(ContractClaimApproval)
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
func (it *ContractClaimApprovalIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractClaimApprovalIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractClaimApproval represents a ClaimApproval event raised by the Contract contract.
type ContractClaimApproval struct {
	Owner   common.Address
	Claimer common.Address
	Reward  common.Address
	Amount  *big.Int
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterClaimApproval is a free log retrieval operation binding the contract event 0xacaf04c4ff6035fb5bd7edb8b12e16c3f86718368f1af206dd3fa99e3d3b30ec.
//
// Solidity: event ClaimApproval(address indexed owner, address indexed claimer, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) FilterClaimApproval(opts *bind.FilterOpts, owner []common.Address, claimer []common.Address, reward []common.Address) (*ContractClaimApprovalIterator, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var claimerRule []interface{}
	for _, claimerItem := range claimer {
		claimerRule = append(claimerRule, claimerItem)
	}
	var rewardRule []interface{}
	for _, rewardItem := range reward {
		rewardRule = append(rewardRule, rewardItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "ClaimApproval", ownerRule, claimerRule, rewardRule)
	if err != nil {
		return nil, err
	}
	return &ContractClaimApprovalIterator{contract: _Contract.contract, event: "ClaimApproval", logs: logs, sub: sub}, nil
}

// WatchClaimApproval is a free log subscription operation binding the contract event 0xacaf04c4ff6035fb5bd7edb8b12e16c3f86718368f1af206dd3fa99e3d3b30ec.
//
// Solidity: event ClaimApproval(address indexed owner, address indexed claimer, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) WatchClaimApproval(opts *bind.WatchOpts, sink chan<- *ContractClaimApproval, owner []common.Address, claimer []common.Address, reward []common.Address) (event.Subscription, error) {

	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}
	var claimerRule []interface{}
	for _, claimerItem := range claimer {
		claimerRule = append(claimerRule, claimerItem)
	}
	var rewardRule []interface{}
	for _, rewardItem := range reward {
		rewardRule = append(rewardRule, rewardItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "ClaimApproval", ownerRule, claimerRule, rewardRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractClaimApproval)
				if err := _Contract.contract.UnpackLog(event, "ClaimApproval", log); err != nil {
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

// ParseClaimApproval is a log parse operation binding the contract event 0xacaf04c4ff6035fb5bd7edb8b12e16c3f86718368f1af206dd3fa99e3d3b30ec.
//
// Solidity: event ClaimApproval(address indexed owner, address indexed claimer, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) ParseClaimApproval(log types.Log) (*ContractClaimApproval, error) {
	event := new(ContractClaimApproval)
	if err := _Contract.contract.UnpackLog(event, "ClaimApproval", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractClaimedIterator is returned from FilterClaimed and is used to iterate over the raw logs and unpacked data for Claimed events raised by the Contract contract.
type ContractClaimedIterator struct {
	Event *ContractClaimed // Event containing the contract specifics and raw log

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
func (it *ContractClaimedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractClaimed)
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
		it.Event = new(ContractClaimed)
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
func (it *ContractClaimedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractClaimedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractClaimed represents a Claimed event raised by the Contract contract.
type ContractClaimed struct {
	Caller   common.Address
	Owner    common.Address
	Receiver common.Address
	Reward   common.Address
	Amount   *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterClaimed is a free log retrieval operation binding the contract event 0x4ccfdd58de1f86e31ebe8caec4f0202a1629eb9cdae4e5b0dfe40fabd81f4855.
//
// Solidity: event Claimed(address indexed caller, address indexed owner, address receiver, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) FilterClaimed(opts *bind.FilterOpts, caller []common.Address, owner []common.Address, reward []common.Address) (*ContractClaimedIterator, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}

	var rewardRule []interface{}
	for _, rewardItem := range reward {
		rewardRule = append(rewardRule, rewardItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Claimed", callerRule, ownerRule, rewardRule)
	if err != nil {
		return nil, err
	}
	return &ContractClaimedIterator{contract: _Contract.contract, event: "Claimed", logs: logs, sub: sub}, nil
}

// WatchClaimed is a free log subscription operation binding the contract event 0x4ccfdd58de1f86e31ebe8caec4f0202a1629eb9cdae4e5b0dfe40fabd81f4855.
//
// Solidity: event Claimed(address indexed caller, address indexed owner, address receiver, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) WatchClaimed(opts *bind.WatchOpts, sink chan<- *ContractClaimed, caller []common.Address, owner []common.Address, reward []common.Address) (event.Subscription, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}

	var rewardRule []interface{}
	for _, rewardItem := range reward {
		rewardRule = append(rewardRule, rewardItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Claimed", callerRule, ownerRule, rewardRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractClaimed)
				if err := _Contract.contract.UnpackLog(event, "Claimed", log); err != nil {
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

// ParseClaimed is a log parse operation binding the contract event 0x4ccfdd58de1f86e31ebe8caec4f0202a1629eb9cdae4e5b0dfe40fabd81f4855.
//
// Solidity: event Claimed(address indexed caller, address indexed owner, address receiver, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) ParseClaimed(log types.Log) (*ContractClaimed, error) {
	event := new(ContractClaimed)
	if err := _Contract.contract.UnpackLog(event, "Claimed", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractDepositIterator is returned from FilterDeposit and is used to iterate over the raw logs and unpacked data for Deposit events raised by the Contract contract.
type ContractDepositIterator struct {
	Event *ContractDeposit // Event containing the contract specifics and raw log

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
func (it *ContractDepositIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractDeposit)
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
		it.Event = new(ContractDeposit)
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
func (it *ContractDepositIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractDepositIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractDeposit represents a Deposit event raised by the Contract contract.
type ContractDeposit struct {
	Caller common.Address
	Owner  common.Address
	Assets *big.Int
	Shares *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterDeposit is a free log retrieval operation binding the contract event 0xdcbc1c05240f31ff3ad067ef1ee35ce4997762752e3a095284754544f4c709d7.
//
// Solidity: event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares)
func (_Contract *ContractFilterer) FilterDeposit(opts *bind.FilterOpts, caller []common.Address, owner []common.Address) (*ContractDepositIterator, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Deposit", callerRule, ownerRule)
	if err != nil {
		return nil, err
	}
	return &ContractDepositIterator{contract: _Contract.contract, event: "Deposit", logs: logs, sub: sub}, nil
}

// WatchDeposit is a free log subscription operation binding the contract event 0xdcbc1c05240f31ff3ad067ef1ee35ce4997762752e3a095284754544f4c709d7.
//
// Solidity: event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares)
func (_Contract *ContractFilterer) WatchDeposit(opts *bind.WatchOpts, sink chan<- *ContractDeposit, caller []common.Address, owner []common.Address) (event.Subscription, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Deposit", callerRule, ownerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractDeposit)
				if err := _Contract.contract.UnpackLog(event, "Deposit", log); err != nil {
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

// ParseDeposit is a log parse operation binding the contract event 0xdcbc1c05240f31ff3ad067ef1ee35ce4997762752e3a095284754544f4c709d7.
//
// Solidity: event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares)
func (_Contract *ContractFilterer) ParseDeposit(log types.Log) (*ContractDeposit, error) {
	event := new(ContractDeposit)
	if err := _Contract.contract.UnpackLog(event, "Deposit", log); err != nil {
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

// ContractSuppliedIterator is returned from FilterSupplied and is used to iterate over the raw logs and unpacked data for Supplied events raised by the Contract contract.
type ContractSuppliedIterator struct {
	Event *ContractSupplied // Event containing the contract specifics and raw log

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
func (it *ContractSuppliedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractSupplied)
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
		it.Event = new(ContractSupplied)
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
func (it *ContractSuppliedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractSuppliedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractSupplied represents a Supplied event raised by the Contract contract.
type ContractSupplied struct {
	Caller   common.Address
	Supplier common.Address
	Reward   common.Address
	Amount   *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterSupplied is a free log retrieval operation binding the contract event 0x50413727b37795d672f09d0997645a955fa227befaefdd4adb611542dea3fd80.
//
// Solidity: event Supplied(address indexed caller, address indexed supplier, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) FilterSupplied(opts *bind.FilterOpts, caller []common.Address, supplier []common.Address, reward []common.Address) (*ContractSuppliedIterator, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var supplierRule []interface{}
	for _, supplierItem := range supplier {
		supplierRule = append(supplierRule, supplierItem)
	}
	var rewardRule []interface{}
	for _, rewardItem := range reward {
		rewardRule = append(rewardRule, rewardItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Supplied", callerRule, supplierRule, rewardRule)
	if err != nil {
		return nil, err
	}
	return &ContractSuppliedIterator{contract: _Contract.contract, event: "Supplied", logs: logs, sub: sub}, nil
}

// WatchSupplied is a free log subscription operation binding the contract event 0x50413727b37795d672f09d0997645a955fa227befaefdd4adb611542dea3fd80.
//
// Solidity: event Supplied(address indexed caller, address indexed supplier, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) WatchSupplied(opts *bind.WatchOpts, sink chan<- *ContractSupplied, caller []common.Address, supplier []common.Address, reward []common.Address) (event.Subscription, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var supplierRule []interface{}
	for _, supplierItem := range supplier {
		supplierRule = append(supplierRule, supplierItem)
	}
	var rewardRule []interface{}
	for _, rewardItem := range reward {
		rewardRule = append(rewardRule, rewardItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Supplied", callerRule, supplierRule, rewardRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractSupplied)
				if err := _Contract.contract.UnpackLog(event, "Supplied", log); err != nil {
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

// ParseSupplied is a log parse operation binding the contract event 0x50413727b37795d672f09d0997645a955fa227befaefdd4adb611542dea3fd80.
//
// Solidity: event Supplied(address indexed caller, address indexed supplier, address indexed reward, uint256 amount)
func (_Contract *ContractFilterer) ParseSupplied(log types.Log) (*ContractSupplied, error) {
	event := new(ContractSupplied)
	if err := _Contract.contract.UnpackLog(event, "Supplied", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractTransferIterator is returned from FilterTransfer and is used to iterate over the raw logs and unpacked data for Transfer events raised by the Contract contract.
type ContractTransferIterator struct {
	Event *ContractTransfer // Event containing the contract specifics and raw log

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
func (it *ContractTransferIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractTransfer)
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
		it.Event = new(ContractTransfer)
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
func (it *ContractTransferIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractTransferIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractTransfer represents a Transfer event raised by the Contract contract.
type ContractTransfer struct {
	From   common.Address
	To     common.Address
	Amount *big.Int
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterTransfer is a free log retrieval operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 amount)
func (_Contract *ContractFilterer) FilterTransfer(opts *bind.FilterOpts, from []common.Address, to []common.Address) (*ContractTransferIterator, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return &ContractTransferIterator{contract: _Contract.contract, event: "Transfer", logs: logs, sub: sub}, nil
}

// WatchTransfer is a free log subscription operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 amount)
func (_Contract *ContractFilterer) WatchTransfer(opts *bind.WatchOpts, sink chan<- *ContractTransfer, from []common.Address, to []common.Address) (event.Subscription, error) {

	var fromRule []interface{}
	for _, fromItem := range from {
		fromRule = append(fromRule, fromItem)
	}
	var toRule []interface{}
	for _, toItem := range to {
		toRule = append(toRule, toItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Transfer", fromRule, toRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractTransfer)
				if err := _Contract.contract.UnpackLog(event, "Transfer", log); err != nil {
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

// ParseTransfer is a log parse operation binding the contract event 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef.
//
// Solidity: event Transfer(address indexed from, address indexed to, uint256 amount)
func (_Contract *ContractFilterer) ParseTransfer(log types.Log) (*ContractTransfer, error) {
	event := new(ContractTransfer)
	if err := _Contract.contract.UnpackLog(event, "Transfer", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// ContractWithdrawIterator is returned from FilterWithdraw and is used to iterate over the raw logs and unpacked data for Withdraw events raised by the Contract contract.
type ContractWithdrawIterator struct {
	Event *ContractWithdraw // Event containing the contract specifics and raw log

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
func (it *ContractWithdrawIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(ContractWithdraw)
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
		it.Event = new(ContractWithdraw)
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
func (it *ContractWithdrawIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *ContractWithdrawIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// ContractWithdraw represents a Withdraw event raised by the Contract contract.
type ContractWithdraw struct {
	Caller   common.Address
	Receiver common.Address
	Owner    common.Address
	Assets   *big.Int
	Shares   *big.Int
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterWithdraw is a free log retrieval operation binding the contract event 0xfbde797d201c681b91056529119e0b02407c7bb96a4a2c75c01fc9667232c8db.
//
// Solidity: event Withdraw(address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares)
func (_Contract *ContractFilterer) FilterWithdraw(opts *bind.FilterOpts, caller []common.Address, receiver []common.Address, owner []common.Address) (*ContractWithdrawIterator, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var receiverRule []interface{}
	for _, receiverItem := range receiver {
		receiverRule = append(receiverRule, receiverItem)
	}
	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}

	logs, sub, err := _Contract.contract.FilterLogs(opts, "Withdraw", callerRule, receiverRule, ownerRule)
	if err != nil {
		return nil, err
	}
	return &ContractWithdrawIterator{contract: _Contract.contract, event: "Withdraw", logs: logs, sub: sub}, nil
}

// WatchWithdraw is a free log subscription operation binding the contract event 0xfbde797d201c681b91056529119e0b02407c7bb96a4a2c75c01fc9667232c8db.
//
// Solidity: event Withdraw(address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares)
func (_Contract *ContractFilterer) WatchWithdraw(opts *bind.WatchOpts, sink chan<- *ContractWithdraw, caller []common.Address, receiver []common.Address, owner []common.Address) (event.Subscription, error) {

	var callerRule []interface{}
	for _, callerItem := range caller {
		callerRule = append(callerRule, callerItem)
	}
	var receiverRule []interface{}
	for _, receiverItem := range receiver {
		receiverRule = append(receiverRule, receiverItem)
	}
	var ownerRule []interface{}
	for _, ownerItem := range owner {
		ownerRule = append(ownerRule, ownerItem)
	}

	logs, sub, err := _Contract.contract.WatchLogs(opts, "Withdraw", callerRule, receiverRule, ownerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(ContractWithdraw)
				if err := _Contract.contract.UnpackLog(event, "Withdraw", log); err != nil {
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

// ParseWithdraw is a log parse operation binding the contract event 0xfbde797d201c681b91056529119e0b02407c7bb96a4a2c75c01fc9667232c8db.
//
// Solidity: event Withdraw(address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares)
func (_Contract *ContractFilterer) ParseWithdraw(log types.Log) (*ContractWithdraw, error) {
	event := new(ContractWithdraw)
	if err := _Contract.contract.UnpackLog(event, "Withdraw", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
