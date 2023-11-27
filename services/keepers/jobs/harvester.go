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
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/rewards"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"
)

// ==============================================================================
//  Dependencies
// ==============================================================================

// HarvesterDB is the interface for the harvester database.
type HarvesterDB interface {
	GetVaults(ctx context.Context) ([]*db.Vault, error)
}

// ==============================================================================
//  Harvester
// ==============================================================================

// Compile time check to ensure this type implements the Job interface.
var (
	_ job.Polling = &Harvester{}
	_ job.Basic   = &Harvester{}
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
}

// NewHarvester returns a pointer to a new Harvester.
func NewHarvester(db HarvesterDB, interval *time.Duration, pubKey common.Address, privKey *ecdsa.PrivateKey, minBGT *big.Int, rewardsPrecompileAddress common.Address) *Harvester {
	return &Harvester{
		db:                       db,
		interval:                 interval,
		pubKey:                   pubKey,
		privKey:                  privKey,
		minBGT:                   minBGT,
		rewardsPrecompileAddress: rewardsPrecompileAddress,
	}
}

// RegistryKey implements job.Basic.
func (h *Harvester) RegistryKey() string {
	return "harvester"
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

	// Get the vaults from the database.
	vaults, err := h.db.GetVaults(ctx)
	if err != nil {
		logger.Error("failed to get vaults from database", "error", err)
		return nil, err
	}

	// Filter the vaults based on the minimum BGT amount.
	filteredVaults, err := h.filterVaults(vaults, sCtx.Chain(), logger)
	if err != nil {
		logger.Error("failed to filter vaults", "error", err)
		return nil, err
	}

	logger.Info("filtered vaults", "vaults", filteredVaults)

	return nil, nil
}

// filterVaults filters the vaults based on the minimum BGT amount.
func (h *Harvester) filterVaults(vaults []*db.Vault, ethClient eth.Client, logger log.Logger) ([]*db.Vault, error) {
	// Load the rewards precompile contract.
	rewardsPrecompile, err := rewards.NewContract(h.rewardsPrecompileAddress, ethClient)
	if err != nil {
		logger.Error("failed to load rewards precompile contract", "error", err)
		return nil, err
	}

	// Filter the vaults.
	filteredVaults := make([]*db.Vault, 0)
	for _, vault := range vaults {
		// Get the BGT receivable for the vault.
		res, err := rewardsPrecompile.GetCurrentRewards(
			nil,
			common.HexToAddress(vault.VaultHexAddress),
			common.HexToAddress(vault.PoolHexAddress),
		)
		if err != nil {
			logger.Error("failed to get BGT receivable for vault", "error", err)
			return nil, err
		}

		// Check if the BGT reward is greater than the minimum.
		if isEnoughBGT(h.minBGT, res) {
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
		if reward.Denom == "bgt" {
			bgt = reward.Amount
		}
	}

	// Check if the BGT reward is greater than the minimum.
	return bgt.Cmp(min) == 1
}
