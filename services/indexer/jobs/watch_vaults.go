package jobs

import (
	"context"

	"github.com/berachain/offchain-sdk/job"
	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/common"
	coretypes "github.com/ethereum/go-ethereum/core/types"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
)

// Make sure that the VaultWatcher implements these interfaces.
var (
	_ job.Basic    = (*VaultsWatcher)(nil)
	_ job.HasSetup = (*VaultsWatcher)(nil)
)

// ==============================================================================
// VaultsWatcher
// ==============================================================================

// VaultsWatcher is a struct that contains the necessary data to watch for new vaults.
type VaultsWatcher struct {
	infraredAddress  common.Address
	infraredContract *infrared.Contract
}

// NewVaultsWatcher creates a new instance of VaultsWatcher and returns a pointer to it.
func NewVaultsWatcher(infraredAddress common.Address) *VaultsWatcher {
	return &VaultsWatcher{
		infraredAddress: infraredAddress,
	}
}

// RegisterKey returns an identifier for this jobtype.
func (w *VaultsWatcher) RegistryKey() string {
	return "vaults-watcher"
}

// Setup implements job.basic.
func (w *VaultsWatcher) Setup(ctx context.Context) error {
	sCtx := sdk.UnwrapContext(ctx)
	ethClient := sCtx.Chain()
	if ethClient == nil {
		panic("ethClient is nil")
	}

	// Store all errors in one variable
	var err error

	// Setup the bindings to the Infrared Contract.
	w.infraredContract, err = infrared.NewContract(w.infraredAddress, ethClient)
	if err != nil {
		return err
	}

	return nil
}

// Execute implements job.basic.
func (w *VaultsWatcher) Execute(ctx context.Context, args any) (any, error) {
	newHead, ok := args.(*coretypes.Header)
	if newHead == nil || !ok {
		return nil, nil
	}

	sCtx := sdk.UnwrapContext(ctx)
	if sCtx.Chain() == nil {
		panic("ethClient is nil")
	}

	// Log the block header.
	sCtx.Logger().Info("New block header", "number", newHead.Number.String(), "hash", newHead.Hash().String())

	// Get the current block number.
	block, err := sCtx.Chain().GetBlockByNumber(ctx, newHead.Number.Uint64())
	if err != nil || block == nil {
		sCtx.Logger().Error("Failed to retrieve block", "number", newHead.Number.Uint64(), "err", err)
		return nil, err
	}

	// Check if there are transactions in the block.
	if len(block.Transactions()) == 0 {
		sCtx.Logger().Info("No transactions in block", "number", newHead.Number.Uint64())
		return nil, nil
	}

	// Get the reciepts from the relevant transactions.
	receipts := make([]*coretypes.Receipt, 0)
	for _, tx := range block.Transactions() {
		r, err := sCtx.Chain().TransactionReceipt(ctx, tx.Hash())
		if err != nil {
			sCtx.Logger().Error("Failed to retrieve transaction receipt", "hash", tx.Hash().String(), "err", err)
			continue
		}

		// Only append to the receipt if the transaction was successful.
		if r.Status == 1 {
			receipts = append(receipts, r)
		}
	}

	// Check if there are any receipts.
	if len(receipts) == 0 {
		sCtx.Logger().Info("No receipts in block", "number", newHead.Number.Uint64())
		return nil, nil
	}

	// Handle the receipts.
	if err = w.handleReceipt(sCtx, receipts, newHead.Time); err != nil {
		sCtx.Logger().Error("Failed to handle receipts", "err", err)
		return nil, err
	}

	return nil, nil
}

// handleReceipt handles the receipts and parses the logs and executes any necessary actions.
func (w *VaultsWatcher) handleReceipt(sCtx *sdk.Context, receipts []*coretypes.Receipt, timestamp uint64) error {
	// Logs to be parsed.
	infraredContractLogs := make([]*coretypes.Log, 0)

	// Loop through all the receipts and their logs to find relevant logs.
	for _, r := range receipts {
		for _, l := range r.Logs {
			switch l.Address {
			case w.infraredAddress:
				infraredContractLogs = append(infraredContractLogs, l)
			default:
				continue
			}
		}
	}

	// Log out the number of logs found.
	sCtx.Logger().Info("Found logs", "count", len(infraredContractLogs))
	return nil
}
