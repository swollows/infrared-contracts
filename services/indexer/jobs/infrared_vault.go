package jobs

import (
	"context"

	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/common"
	bindings "github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
	"github.com/infrared-dao/infrared-mono-repo/services/indexer/db"
)

// VaultDB is the interface for the vault database.
type VaultDB interface {
	SetVault(ctx context.Context, vault *db.Vault) error
}

// VaultWatcher watches the vaults events and updates the statistics in the database.
type VaultWatcher struct {
	db               VaultDB
	infraredAddress  common.Address
	infraredContract *bindings.Contract
}

// NewVaultWatcher creates a new vault watcher and returns a pointer to it.
func NewVaultWatcher(db VaultDB, infraredAddress common.Address) *VaultWatcher {
	return &VaultWatcher{db: db, infraredAddress: infraredAddress}
}

// RegistryKey implements the `Job` interface.
func (w *VaultWatcher) RegistryKey() string {
	return "vault_watcher"
}

// Setup implements the `Job` interface.
func (w *VaultWatcher) Setup(ctx context.Context) error {
	sCtx := sdk.UnwrapCancelContext(ctx)
	ethClient := sCtx.Chain()
	if ethClient == nil {
		panic("ethClient is nil")
	}

	// Setup the contract bindings.
	contract, err := bindings.NewContract(w.infraredAddress, ethClient)
	if err != nil {
		return err
	}

	// Set the contract bindings.
	w.infraredContract = contract

	return nil
}

// Execute implements the `Job` interface.
func (w *VaultWatcher) Execute(ctx context.Context, args any) (any, error) {
	return nil, nil
}
