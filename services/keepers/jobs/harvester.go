package jobs

import (
	"context"
	"crypto/ecdsa"
	"math/big"
	"time"

	"github.com/berachain/offchain-sdk/job"
	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/common"
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
}

// NewHarvester returns a pointer to a new Harvester.
func NewHarvester(db HarvesterDB, interval *time.Duration, pubKey common.Address, privKey *ecdsa.PrivateKey, minBGT *big.Int) *Harvester {
	return &Harvester{
		db:       db,
		interval: interval,
		pubKey:   pubKey,
		privKey:  privKey,
		minBGT:   minBGT,
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

	// TODO: Remove this.
	logger.Info("harvesting rewards")

	return nil, nil
}

// filterVaults filters the vaults based on the minimum BGT amount.
