package jobs

import (
	"context"
	"crypto/ecdsa"
	"math/big"
	"time"

	"github.com/berachain/offchain-sdk/job"
	"github.com/berachain/offchain-sdk/log"
	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/rewards"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"
	"github.com/infrared-dao/infrared-mono-repo/pkg/tools"
	util "github.com/infrared-dao/infrared-mono-repo/services/keepers/utils"
)

// ==============================================================================
//  Dependencies & constants
// ==============================================================================

// VaultHarvesterDB is the interface for the vault harvester database.
type VaultHarvesterDB interface {
	GetVaults(ctx context.Context) ([]*db.Vault, error)
	SetCheckpoint(ctx context.Context, checkpoint *db.CheckPoint) error
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
	_ job.Polling  = &VaultHarvester{}
	_ job.Basic    = &VaultHarvester{}
	_ job.HasSetup = &VaultHarvester{}
)

// VaultHarvester is the job that harvests the vault.
type VaultHarvester struct {
	// db is the database for the vault harvester job.
	db VaultHarvesterDB
	// interval is the interval at which the job runs.
	interval *time.Duration
	// pubKey is the public key of the vault harvester.
	pubKey common.Address
	// privKey is the private key of the vault harvester.
	privKey *ecdsa.PrivateKey
	// minBGT is the minimum amount of BGT to harvest.
	minBGT *big.Int
	// rewardsPrecompileAddress is the address of the rewards precompile.
	rewardsPrecompileAddress common.Address
	// rewardsPrecompileContract is the contract of the rewards precompile.
	rewardsPrecompileContract *rewards.Contract
	// infraredContractAddress is the address of the infrared contract.
	infraredContractAddress common.Address
	// infraredBoundContract is the contract of the infrared contract.
	infraredBoundContract *bind.BoundContract
	// infraredContract is the contract of the infrared contract used to query state.
	infraredContract *infrared.Contract
	// gasLimit is the gas limit for the transaction.
	gasLimit uint64
}

// NewVaultHarvester creates a new vault harvester job.
func NewVaultHarvester(
	db VaultHarvesterDB,
	interval *time.Duration,
	pubKey common.Address,
	privKey *ecdsa.PrivateKey,
	minBGT *big.Int,
	rewardsPrecompileAddress common.Address,
	infraredContractAddress common.Address,
	gasLimit uint64,
) *VaultHarvester {
	return &VaultHarvester{
		db:                       db,
		interval:                 interval,
		pubKey:                   pubKey,
		privKey:                  privKey,
		minBGT:                   minBGT,
		rewardsPrecompileAddress: rewardsPrecompileAddress,
		infraredContractAddress:  infraredContractAddress,
		gasLimit:                 gasLimit,
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

	// Setup the infrared bound contract.
	infraredAbi, err := infrared.ContractMetaData.GetAbi()
	if err != nil {
		logger.Error("❌ Failed to get infrared abi", "Error", err)
		return err
	}
	vh.infraredBoundContract = bind.NewBoundContract(
		vh.infraredContractAddress,
		*infraredAbi,
		ethClient,
		ethClient,
		ethClient,
	)

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

		// Sleep for 1 second to avoid any nonce issues.
		time.Sleep(1 * time.Second)
	}

	// Get the block number after the harvest.
	blockNumber, err := sCtx.Chain().BlockNumber(sCtx)
	if err != nil {
		logger.Error("⚠️  Failed to get block number", "Error", err)
		return nil, err
	}

	// Set the checkpoint in the database.
	if err := vh.db.SetCheckpoint(sCtx, db.NewCheckPoint(blockNumber)); err != nil {
		logger.Error("⚠️  Failed to set checkpoint", "Error", err)
		return nil, err
	}

	return nil, nil
}

// ==============================================================================
//  Helpers
// ==============================================================================

// harvestVault is a helper method to publish the harvest vault transaction and handle the response.
func (vh *VaultHarvester) harvestVault(sCtx *sdk.Context, vault *db.Vault, logger log.Logger) error {
	// Generate the transaction options.
	txOpts, err := util.GenerateTransactionOps(sCtx, vh.pubKey, vh.privKey, vh.gasLimit)
	if err != nil {
		logger.Error("❌ Failed to generate transaction options", "Error", err)
		return err
	}

	// Generate the transaction.
	tx, err := vh.infraredBoundContract.Transact(
		txOpts,
		vaultHarvestCallName,
		common.HexToAddress(vault.VaultHexAddress),
	)
	if err != nil {
		logger.Error("❌ Failed to generate transaction", "Error", err)
		return err
	}

	// Handle the transaction response in a separate goroutine.
	go tools.HandleTxResponse(sCtx, sCtx.Chain(), vh.pubKey, tx, logger)

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
