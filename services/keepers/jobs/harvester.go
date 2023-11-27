package jobs

import (
	"context"
	"crypto/ecdsa"

	"math/big"
	"time"

	"github.com/berachain/offchain-sdk/client/eth"
	"github.com/berachain/offchain-sdk/job"
	"github.com/berachain/offchain-sdk/log"
	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	coretypes "github.com/ethereum/go-ethereum/core/types"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/rewards"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"
	util "github.com/infrared-dao/infrared-mono-repo/services/keepers/utils"
)

// ==============================================================================
//  Dependencies
// ==============================================================================

// HarvesterDB is the interface for the harvester database.
type HarvesterDB interface {
	GetVaults(ctx context.Context) ([]*db.Vault, error)
}

// Constants used for the harvester job.
const (
	// The harvest vault contract call.
	harvestVaultCallName = "harvestVault"
)

// ==============================================================================
//  Harvester
// ==============================================================================

// Compile time check to ensure this type implements the Job interface.
var (
	_ job.Polling  = &Harvester{}
	_ job.Basic    = &Harvester{}
	_ job.HasSetup = &Harvester{}
)

// Harvester is the job responsible for harvesting block and bgt rewards for all the supported vaults.
type Harvester struct {
	// db can be any database that implements the HarvesterDB interface.
	db HarvesterDB
	// interval is the interval at which the job is run.
	interval *time.Duration
	// pubKey is the public key of the account that will be used to harvest the rewards.
	pubKey common.Address
	// privKey is the private key of the account that will be used to harvest the rewards.
	privKey *ecdsa.PrivateKey
	// minBGT is the minimum amount of BGT that must be present in the vault for the harvester to harvest the rewards.
	minBGT *big.Int
	// rewards precompile address.
	rewardsPrecompileAddress common.Address
	// rewardsPrecompileContract is the contract that will be used to get the current rewards.
	rewardsPrecompileContract *rewards.Contract
	// infraredContractAddress is the address of the infrared contract.
	infraredContractAddress common.Address
	// infraredContract is the contract that will be used to harvest the rewards.
	infraredContract *bind.BoundContract
}

// NewHarvester returns a pointer to a new Harvester.
func NewHarvester(db HarvesterDB, interval *time.Duration, pubKey common.Address, privKey *ecdsa.PrivateKey, minBGT *big.Int, rewardsPrecompileAddress, infraredContractAddress common.Address) *Harvester {
	return &Harvester{
		db:                       db,
		interval:                 interval,
		pubKey:                   pubKey,
		privKey:                  privKey,
		minBGT:                   minBGT,
		rewardsPrecompileAddress: rewardsPrecompileAddress,
		infraredContractAddress:  infraredContractAddress,
	}
}

// RegistryKey implements job.Basic.
func (h *Harvester) RegistryKey() string {
	return "harvester"
}

// Setup implements job.HasSetup.
func (h *Harvester) Setup(ctx context.Context) error {
	sCtx := sdk.UnwrapContext(ctx)
	ethClient := sCtx.Chain()

	// Parse the infrared contract abi.
	infraredAbi, err := infrared.ContractMetaData.GetAbi()
	if err != nil {
		sCtx.Logger().Error("failed to parse infrared abi", "error", err)
		return err
	}

	// Bind the contract to the struct.
	h.infraredContract = bind.NewBoundContract(
		h.infraredContractAddress,
		*infraredAbi,
		ethClient,
		ethClient,
		ethClient,
	)

	// Load the rewards precompile contract.
	rewardsPrecompileContract, err := rewards.NewContract(h.rewardsPrecompileAddress, ethClient)
	if err != nil {
		sCtx.Logger().Error("failed to parse rewards precompile abi", "error", err)
		return err
	}

	// Bind the contract to the struct.
	h.rewardsPrecompileContract = rewardsPrecompileContract

	return nil
}

// IntervalTime implements job.Polling.
func (h *Harvester) IntervalTime(ctx context.Context) time.Duration {
	return *h.interval
}

// Execute implements job.Basic.
func (h *Harvester) Execute(ctx context.Context, _ any) (any, error) {
	// Unwrap the context.
	sCtx := sdk.UnwrapContext(ctx)
	logger := sCtx.Logger().With("job", h.RegistryKey())

	// Check the vaults that are eligible for harvesting.
	filteredVaults, err := h.CheckVaults(sCtx, logger)
	if err != nil {
		logger.Error("failed to check vaults", "error", err)
		return nil, err
	}

	// If there are no vaults to harvest, return.
	if len(filteredVaults) == 0 {
		logger.Info("no vaults to harvest")
		return nil, nil
	}

	// Harvest the rewards for the vaults.
	for _, vault := range filteredVaults {
		err := h.Harvest(sCtx, vault, logger)
		if err != nil {
			logger.Error("failed to harvest vault", "error", err)
			return nil, err
		}
	}

	return nil, nil
}

// ==============================================================================
//  Helpers
// ==============================================================================

// CheckVaults checks if the vaults have enough BGT to be harvested and returns the ones that do.
func (h *Harvester) CheckVaults(ctx *sdk.Context, logger log.Logger) ([]*db.Vault, error) {
	// Get all the vaults from the database.
	vaults, err := h.db.GetVaults(ctx)
	if err != nil {
		logger.Error("failed to get vaults from database", "error", err)
		return nil, err
	}

	// Filter the vaults based on the minimum BGT amount.
	filteredVaults := make([]*db.Vault, 0)
	for _, vault := range vaults {
		cr, err := h.rewardsPrecompileContract.GetCurrentRewards(
			nil,
			common.HexToAddress(vault.VaultHexAddress),
			common.HexToAddress(vault.PoolHexAddress),
		)
		if err != nil {
			logger.Error("failed to get current rewards", "error", err)
			return nil, err
		}

		// Check if the BGT reward is greater than the minimum.
		if isEnoughBGT(h.minBGT, cr) {
			filteredVaults = append(filteredVaults, vault)
		}
	}

	return filteredVaults, nil
}

// isEnoughBGT checks if the BGT reward is greater than the minimum.
func isEnoughBGT(min *big.Int, rewards []rewards.CosmosCoin) bool {
	// Check if the rewards are empty.
	if len(rewards) == 0 {
		return false
	}

	// Get the BGT reward.
	bgt := new(big.Int)
	for _, reward := range rewards {
		if reward.Denom == "abgt" {
			bgt = reward.Amount
		}
	}

	// Check if the BGT reward is greater than the minimum.
	return bgt.Cmp(min) == 1
}

// HarvestRewards harvests the rewards for the vaults.
func (h *Harvester) Harvest(sCtx *sdk.Context, vault *db.Vault, logger log.Logger) error {
	// Generate the transaction options.
	txOpts, err := util.GenerateTransactionOps(sCtx, h.pubKey, h.privKey)
	if err != nil {
		logger.Error("❌ Failed to generate transaction options", "error", err)
		return err
	}

	// Generate the transaction.
	tx, err := h.infraredContract.Transact(txOpts, harvestVaultCallName, common.HexToAddress(vault.VaultHexAddress))
	if err != nil {
		logger.Error("❌ Failed to generate harvest vault transaction", "error", err)
		return err
	}

	// Handle the transaction response in a goroutine.
	go h.handleTxResponse(sCtx, sCtx.Chain(), tx, logger)

	return nil
}

// handleTxResponse handles the response of a transaction.
func (h *Harvester) handleTxResponse(ctx *sdk.Context, ethClient eth.Client, tx *coretypes.Transaction, logger log.Logger) {
	ctxWithTimeOut, cancel := context.WithTimeout(ctx, 5*time.Second) // TODO: Set a proper timeout.

	// Wait for the transaction to be mined.
	receipt, err := bind.WaitMined(ctxWithTimeOut, ethClient, tx)
	cancel() // Cancel the context if the transaction takes too long to be mined.
	if err != nil {
		logger.Error("❕ Failed to wait for transaction to be mined", "error", err)
		return
	}

	// Check if the transaction was not successful.
	if receipt.Status == 0 {
		// Check the contract for a call error.
		res, err := ethClient.CallContract(
			context.Background(),
			ethereum.CallMsg{
				From:     h.pubKey,
				To:       tx.To(),
				Data:     tx.Data(),
				Gas:      tx.Gas(),
				GasPrice: tx.GasPrice(),
				Value:    tx.Value(),
			},
			nil,
		)
		if err != nil {
			logger.Error("❕ Failed to call contract", "error", err)
			return
		}

		// Get the revert reason from the call.
		revert, err := abi.UnpackRevert(res)
		if err != nil {
			logger.Error("❕ Failed to unpack revert", "error", err)
			return
		}

		logger.Error("❌ Transaction failed", "status", receipt.Status, "revert", revert)

		return // return here to avoid logging the transaction hash.
	}

	// Log the transaction hash of the successful transaction.
	logger.Info("✅ Transaction mined", "txHash", tx.Hash().Hex())
}
