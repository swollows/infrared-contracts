package jobs

import (
	"context"
	"math/big"
	"time"

	"github.com/berachain/offchain-sdk/core/transactor"
	"github.com/berachain/offchain-sdk/core/transactor/tracker"
	txrtypes "github.com/berachain/offchain-sdk/core/transactor/types"
	"github.com/berachain/offchain-sdk/job"
	"github.com/berachain/offchain-sdk/log"
	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/rewards"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"
)

// ==============================================================================
//  Dependencies & constants
// ==============================================================================

// VaultHarvesterDB is the interface for the vault harvester database.
type VaultHarvesterDB interface {
	GetVaults(ctx context.Context) ([]*db.Vault, error)
}

// The method names for this job.
const (
	// vaultHarvestCallName is the name of the method that harvests the vault.
	vaultHarvestCallName = "harvestVault"
)

// ==============================================================================
//  VaultHarvester
// ==============================================================================

// Compile time check to ensure this type implements the Job interface.
var (
	_ job.Polling        = &VaultHarvester{}
	_ job.Basic          = &VaultHarvester{}
	_ job.HasSetup       = &VaultHarvester{}
	_ tracker.Subscriber = &VaultHarvester{}
)

// VaultHarvester is the job that harvests the vault.
type VaultHarvester struct {
	// db is the database for the vault harvester job.
	db VaultHarvesterDB
	// interval is the interval at which the job runs.
	interval *time.Duration
	// minBGT is the minimum amount of BGT to harvest.
	minBGT *big.Int
	// rewardsPrecompileAddress is the address of the rewards precompile.
	rewardsPrecompileAddress common.Address
	// rewardsPrecompileContract is the contract of the rewards precompile.
	rewardsPrecompileContract *rewards.Contract
	// infraredContractAddress is the address of the infrared contract.
	infraredContractAddress common.Address
	// infraredContract is the contract of the infrared contract used to query state.
	infraredContract *infrared.Contract
	// txManager is the transaction manager for the job.
	txMgr *transactor.TxrV2
	// txPacker is the transaction packer for the job.
	txPacker *txrtypes.Packer
	// logger is the logger for the job.
	logger log.Logger
}

// NewVaultHarvester creates a new vault harvester job.
func NewVaultHarvester(
	db VaultHarvesterDB,
	interval *time.Duration,
	minBGT *big.Int,
	rewardsPrecompileAddress common.Address,
	infraredContractAddress common.Address,
	txMgr *transactor.TxrV2,
) *VaultHarvester {
	return &VaultHarvester{
		db:                       db,
		interval:                 interval,
		minBGT:                   minBGT,
		rewardsPrecompileAddress: rewardsPrecompileAddress,
		infraredContractAddress:  infraredContractAddress,
		txMgr:                    txMgr,
		txPacker:                 &txrtypes.Packer{MetaData: infrared.ContractMetaData},
	}
}

// RegistryKey implements the Job interface.
func (vh *VaultHarvester) RegistryKey() string {
	return "vault_harvester"
}

// Setup implements the HasSetup interface.
func (vh *VaultHarvester) Setup(ctx context.Context) error {
	sCtx := sdk.UnwrapContext(ctx)
	ethClient := sCtx.Chain()
	logger := sCtx.Logger().With("job", vh.RegistryKey())

	// Setup the rewards precompile contract.
	rp, err := rewards.NewContract(vh.rewardsPrecompileAddress, ethClient)
	if err != nil {
		logger.Error("❌ Failed create reward precompile contract object", "Error", err)
		return err
	}
	vh.rewardsPrecompileContract = rp

	// Setup the infrared contract.
	ic, err := infrared.NewContract(vh.infraredContractAddress, ethClient)
	if err != nil {
		logger.Error("❌ Failed create infrared contract object", "Error", err)
		return err
	}
	vh.infraredContract = ic

	// Handle the transaction results from the transaction manager.
	vh.txMgr.SubscribeTxResults(ctx, vh, make(chan *tracker.InFlightTx, 1024))

	// Set the logger.
	vh.logger = logger

	return nil
}

// IntervalTime implements the job.Polling interface.
func (vh *VaultHarvester) IntervalTime(_ context.Context) time.Duration {
	return *vh.interval
}

// Execute implements the job.Basic interface.
func (vh *VaultHarvester) Execute(ctx context.Context, _ any) (any, error) {
	sCtx := sdk.UnwrapContext(ctx)
	logger := sCtx.Logger().With("job", vh.RegistryKey())
	logger.Info("⏳ Polling Vault Harvester Job...")

	// Get the ripe vaults.
	vaults, err := vh.getRipe(sCtx, logger)
	if err != nil {
		return nil, err
	}

	// Harvest the rewards for each ripe vault.
	for _, vault := range vaults {
		err := vh.harvestVault(sCtx, vault, logger)
		if err != nil {
			return nil, err
		}
	}

	return nil, nil
}

// ==============================================================================
//  Transaction Subscriber
// ==============================================================================

// OnSuccess implements the tracker.Subscriber interface.
func (vh *VaultHarvester) OnSuccess(tx *tracker.InFlightTx, receipt *types.Receipt) error {
	// Check if the transaction is from the infrared contract.
	if receipt.ContractAddress != vh.infraredContractAddress {
		return nil
	}

	vh.logger.Info("✅ Successfully harvested vault", "TxHash", tx.Hash())
	return nil
}

// OnRevert is called when a transaction reverts.
func (vh *VaultHarvester) OnRevert(tx *tracker.InFlightTx, receipt *types.Receipt) error {
	// Check if the transaction is from the infrared contract.
	if receipt.ContractAddress != vh.infraredContractAddress {
		return nil
	}
	vh.logger.Info("❌ Failed to harvest vault", "TxHash", tx.Hash())
	return nil
}

// OnStale is called when a transaction becomes stale.
func (vh *VaultHarvester) OnStale(ctx context.Context, tx *tracker.InFlightTx) error {
	vh.logger.Info("⚠️ Stale transaction", "TxHash", tx.Hash())
	return nil
}

// OnError is called when a transaction errors.
func (vh *VaultHarvester) OnError(ctx context.Context, tx *tracker.InFlightTx, err error) {
	vh.logger.Error("❌ Transaction error", "TxHash", tx.Hash(), "Error", err)
}

// ==============================================================================
//  Helpers
// ==============================================================================

// harvestVault is a helper method to publish the harvest vault transaction and handle the response.
func (vh *VaultHarvester) harvestVault(sCtx *sdk.Context, vault *db.Vault, logger log.Logger) error {
	tx := &txrtypes.TxRequest{}

	// Create the transaction request.
	tx, err := vh.txPacker.CreateTxRequest(
		vh.infraredContractAddress, // to
		nil,                        // value
		nil,                        // gas tip cap
		nil,                        // gas fee cap
		0,                          // gas limit
		vaultHarvestCallName,       // method
		common.HexToAddress(vault.PoolHexAddress), // args
	)
	if err != nil {
		logger.Error("❌ Failed to create transaction request", "Error", err)
		return err
	}

	// Add the transaction to the transaction queue.
	_, err = vh.txMgr.SendTxRequest(tx)
	if err != nil {
		logger.Error("❌ Failed to send transaction request", "Error", err)
		return err
	}

	logger.Info("📡 Sent transaction request", "To", tx.To, "Vault", vault.VaultHexAddress, "Pool", vault.PoolHexAddress)

	return nil
}

// getRipe is a helper method to get the ripe vaults.
func (vh *VaultHarvester) getRipe(ctx *sdk.Context, logger log.Logger) ([]*db.Vault, error) {
	// Get all the vaults from the database.
	vaults, err := vh.db.GetVaults(ctx)
	if err != nil {
		logger.Error("⚠️ Failed to get vaults", "Error", err)
		return nil, err
	}

	// Filter the vaults to get the ripe ones.
	ripeVaults := make([]*db.Vault, 0)
	for _, vault := range vaults {
		cr, err := vh.rewardsPrecompileContract.GetCurrentRewards(
			nil,
			common.HexToAddress(vault.VaultHexAddress),
			common.HexToAddress(vault.PoolHexAddress),
		)
		if err != nil {
			logger.Error("⚠️ Failed to get current rewards", "Error", err)
			continue
		}

		if vh.isRipe(cr) {
			ripeVaults = append(ripeVaults, vault)
		}
	}

	return ripeVaults, nil
}

// isRipe is a helper method to check if the vault is ripe for a harvest call.
func (vh *VaultHarvester) isRipe(coins []rewards.CosmosCoin) bool {
	// If the rewards are empty, the vault is not ripe.
	if len(coins) == 0 {
		return false
	}

	// Check for the amount of BGT in the rewards.
	amt := big.NewInt(0)
	for _, coin := range coins {
		if coin.Denom == "abgt" {
			amt = coin.Amount
			break // Break early if we find the BGT amount.
		}
	}

	return amt.Cmp(vh.minBGT) >= 0 // Return true if the amount is greater than or equal to the minimum.
}
