package jobs

import (
	"context"

	"github.com/berachain/offchain-sdk/log"
	sdk "github.com/berachain/offchain-sdk/types"
	coretypes "github.com/ethereum/go-ethereum/core/types"
	crypto "github.com/ethereum/go-ethereum/crypto"

	"github.com/berachain/offchain-sdk/job"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
)

// Make sure that the VaultWatcher implements these interfaces.
var (
	_ job.Basic    = (*VaultsWatcher)(nil)
	_ job.HasSetup = (*VaultsWatcher)(nil)
)

// ==============================================================================
// VaultsWatcherDB
// ==============================================================================

type VaultsWatcherDB struct{}

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

	block, err := sCtx.Chain().GetBlockByNumber(ctx, newHead.Number.Uint64())
	if err != nil || block == nil {
		sCtx.Logger().Error("Failed to retrieve block", "number", newHead.Number.Uint64(), "err", err)
		return nil, err
	}

	receipts, err := w.filterReceipts(sCtx, block)
	if err != nil {
		return nil, err
	}

	for _, receipt := range receipts {
		if err := w.handleReceipt(receipt, sCtx.Logger()); err != nil {
			return nil, err
		}
	}

	return nil, nil
}

// filterReceipts filters unnecessary receipts and returns only the relevant ones.
func (w *VaultsWatcher) filterReceipts(sCtx *sdk.Context, block *coretypes.Block) ([]*coretypes.Receipt, error) {
	// Check if there are transactions in the block and return if there are none.
	if len(block.Transactions()) == 0 {
		sCtx.Logger().Info("No transactions in block", "number", block.Number().Uint64())
		return []*coretypes.Receipt{}, nil
	}

	// Get the relevant receipts from the block.
	relevantReceipts := make([]*coretypes.Receipt, 0)
	for _, tx := range block.Transactions() {
		// Get the receipt for the transaction.
		receipt, err := sCtx.Chain().TransactionReceipt(sCtx.Context, tx.Hash())
		if err != nil {
			sCtx.Logger().Error("Failed to retrieve transaction receipt", "hash", tx.Hash().String(), "err", err)
			return []*coretypes.Receipt{}, err
		}

		// If the transaction was not successful, skip it.
		if receipt.Status != 1 {
			continue
		}

		// If the transaction was successful, append it to the relevant receipts.
		relevantReceipts = append(relevantReceipts, receipt)

	}

	return relevantReceipts, nil
}

// handleReceipt handles the receipts and parses the logs and executes any necessary actions.
func (w *VaultsWatcher) handleReceipt(receipt *coretypes.Receipt, logger log.Logger) error {
	for _, log := range receipt.Logs {
		// Check if the log is a NewVault event.
		if w.isVaultCreated(log) {
			if err := w.handleVaultCreated(log, logger); err != nil {
				return err
			}
		}

		// Check if the log is an IBGTSupplied event.
		if w.isIBGTSupplied(log) {
			if err := w.handleIBGTSupplied(log, logger); err != nil {
				return err
			}
		}

		// Continue to the next log if the log is not relevant.
		continue
	}

	return nil
}

// ==============================================================================
// Event Handlers
// ==============================================================================

// handleVaultCreated handles the NewVault event.
func (w *VaultsWatcher) handleVaultCreated(log *coretypes.Log, logger log.Logger) error {
	// Parse the log into the NewVault event.
	newVaultEvent, err := w.infraredContract.ParseNewVault(*log)
	if err != nil {
		logger.Error("Failed to parse NewVault event", "err", err)
		return err
	}

	// Log the event. (TODO: This will be removed in the future).
	logger.Info("NewVault Event", "Vault: ", newVaultEvent.Vault.String(), "Pool: ", newVaultEvent.Pool.String())

	return nil
}

// handleIBGTSupplied handles the IBGTSupplied event.
func (w *VaultsWatcher) handleIBGTSupplied(log *coretypes.Log, logger log.Logger) error {
	// Parse the log into the IBGTSupplied event.
	ibgtSuppliedEvent, err := w.infraredContract.ParseIBGTSupplied(*log)
	if err != nil {
		logger.Error("Failed to parse IBGTSupplied event", "err", err)
		return err
	}

	// Log the event. (TODO: This will be removed in the future).
	logger.Info("IBGTSupplied Event", "Vault: ", ibgtSuppliedEvent.Vault.String(), "Amount: ", ibgtSuppliedEvent.Amount.String())

	return nil
}

// ==============================================================================
// Event Helpers
// ==============================================================================

// IsVaultCreated checks the log against the NewVault event signature.
func (w *VaultsWatcher) isVaultCreated(log *coretypes.Log) bool {
	return crypto.Keccak256Hash([]byte("NewVault(address,address)")).Cmp(log.Topics[0]) == 0
}

// IsIBGTSupplied checks the log against the IBGTSupplied event signature.
func (w *VaultsWatcher) isIBGTSupplied(log *coretypes.Log) bool {
	return crypto.Keccak256Hash([]byte("IBGTSupplied(address,uint256)")).Cmp(log.Topics[0]) == 0
}
