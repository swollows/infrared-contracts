package jobs

import (
	"context"

	"github.com/berachain/offchain-sdk/client/eth"
	"github.com/berachain/offchain-sdk/job"
	"github.com/berachain/offchain-sdk/log"
	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/vault"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"

	sdk "github.com/berachain/offchain-sdk/types"
	coretypes "github.com/ethereum/go-ethereum/core/types"
)

// ==============================================================================
//  Dependencies
// ==============================================================================

// VaultDB is the interface for the vault database.
type VaultDB interface {
	SetVault(ctx context.Context, vault *db.Vault) error
	VaultExists(ctx context.Context, vaultHexAddress string) (bool, error)
	SetCheckpoint(ctx context.Context, checkpoint *db.CheckPoint) error
}

// ==============================================================================
//  VaultsSubscriber
// ==============================================================================

// Compile time check to ensure that VaultWatcher implements job.Basic and job.HasSetup.
var (
	_ job.Basic           = (*VaultsSubscriber)(nil)
	_ job.HasSetup        = (*VaultsSubscriber)(nil)
	_ job.EthSubscribable = (*VaultsSubscriber)(nil)
)

// VaultsSubscriber is the job that subscribes to vault events and updates the database.
type VaultsSubscriber struct {
	// db can be any database that implements the VaultDB interface.
	db VaultDB
	// infraredAddress is the address of the infrared contract.
	infraredAddress common.Address
	// infrared is the infrared contract that is used to subscribe to events.
	infrared *bind.BoundContract
	// fromBlock is the block number to start the subscription from.
	fromBlock uint64
	// sub is the subscription to the event.
	sub ethereum.Subscription
}

// NewVaultsSubscriber returns a pointer to a new VaultsSubscriber.
func NewVaultsSubscriber(db VaultDB, infraredAddress common.Address, fromBlock uint64) *VaultsSubscriber {
	return &VaultsSubscriber{
		db:              db,
		infraredAddress: infraredAddress,
		fromBlock:       fromBlock,
	}
}

// RegisterKey implements job.Basic.
func (v *VaultsSubscriber) RegistryKey() string {
	return "vaults-subscriber"
}

// Setup implements job.HasSetup.
func (v *VaultsSubscriber) Setup(ctx context.Context) error {
	// Get the ethereum client from the context.
	sCtx := sdk.UnwrapContext(ctx)
	client := sCtx.Chain()
	if client == nil {
		panic("ethereum client not found in context")
	}

	// Parse the infrared contract abi.
	infraredAbi, err := infrared.ContractMetaData.GetAbi()
	if err != nil {
		sCtx.Logger().Error("failed to get infrared abi", "error", err)
	}

	// Bind the infrared contract and set it on the struct.
	v.infrared = bind.NewBoundContract(v.infraredAddress, *infraredAbi, client, client, client)

	return nil
}

// Subscribe implements job.EthSubscribable.
func (v *VaultsSubscriber) Subscribe(ctx context.Context) (ethereum.Subscription, chan coretypes.Log, error) {
	// Get the ethereum client from the context.
	sCtx := sdk.UnwrapContext(ctx)
	client := sCtx.Chain()
	logger := sCtx.Logger()
	if client == nil {
		panic("ethereum client not found in context")
	}

	// Subscribe to the event.
	ch, sub, err := v.infrared.WatchLogs(
		&bind.WatchOpts{
			Start:   &v.fromBlock,
			Context: ctx,
		},
		"NewVault", // event name
		nil,        // query
	)

	if err != nil {
		logger.Error("failed to subscribe to vault events", "error", err)
		return nil, nil, err
	}

	// Set the subscription on the struct.
	v.sub = sub

	// Log that we have subscribed to the event.
	logger.Info("subscribed to vault events", "address", v.infraredAddress.Hex(), "fromBlock", v.fromBlock)

	// Return the subscription and the channel.
	return sub, ch, nil
}

// Unsubscribe implements job.EthSubscribable.
func (v *VaultsSubscriber) Unsubscribe(ctx context.Context) {
	v.sub.Unsubscribe()
}

// Execute implements job.Basic.
func (v *VaultsSubscriber) Execute(ctx context.Context, args any) (any, error) {
	sCtx := sdk.UnwrapContext(ctx)

	// Unwrap the event.
	event := new(infrared.ContractNewVault)
	if err := v.infrared.UnpackLog(event, "NewVault", args.(coretypes.Log)); err != nil {
		sCtx.Logger().Error("failed to unpack event", "error", err)
	}

	// Get the vault data.
	vault, err := GetVaultData(sCtx.Chain(), sCtx.Logger(), event.Vault)
	if err != nil {
		sCtx.Logger().Error("failed to get vault data", "error", err)
		return nil, err
	}

	// Get the block number from the ethereum client. // TODO: This could be faulty.
	blockNum, err := sCtx.Chain().BlockNumber(ctx)
	if err != nil {
		sCtx.Logger().Error("failed to get block number", "error", err)
		return nil, err
	}

	// Store the vault in the database.
	if err := v.Store(sCtx, blockNum, vault); err != nil {
		sCtx.Logger().Error("failed to store vault in database", "error", err)
		return nil, err
	}

	return nil, nil
}

// Store checks if the vault exists in the database and stores it if it doesn't. Also stores the checkpoint.
func (v *VaultsSubscriber) Store(ctx *sdk.Context, blockNum uint64, vault *db.Vault) error {
	// Check if the vault exists in the database.
	exists, err := v.db.VaultExists(ctx, vault.VaultHexAddress)
	if err != nil {
		ctx.Logger().Error("failed to check if vault exists in database", "error", err)
		return err
	}

	// If the vault exists, return.
	if exists {
		ctx.Logger().Info("vault already exists in database", "vault", vault.Name)
		return nil
	}

	// Set the vault in the database.
	if err := v.db.SetVault(ctx, vault); err != nil {
		ctx.Logger().Error("failed to set vault in database", "error", err)
		return err
	}

	// Log that the vault has been set in the database.
	ctx.Logger().Info("✅ Vault set in DB", "vault: ", vault.Name)

	// Set the checkpoint in the database.
	if err := v.db.SetCheckpoint(ctx, db.NewCheckPoint(blockNum)); err != nil {
		ctx.Logger().Error("failed to set checkpoint in database", "error", err)
		return err
	}

	// Log that the checkpoint has been set in the database.
	ctx.Logger().Info("✅ Checkpoint set in DB", "blockNum: ", blockNum)

	return nil
}

// ==============================================================================
// Contract Queries
// ==============================================================================

// Get vault data from the vault contract.
func GetVaultData(ethClient eth.Client, logger log.Logger, vaultAddress common.Address) (*db.Vault, error) {
	vault, err := vault.NewContract(vaultAddress, ethClient)
	if err != nil {
		logger.Error("failed to create vault contract", "error", err)
		return nil, err
	}

	name, err := vault.Name(nil)
	if err != nil {
		logger.Error("failed to get vault name", "error", err)
		return nil, err
	}

	symbol, err := vault.Symbol(nil)
	if err != nil {
		logger.Error("failed to get vault symbol", "error", err)
		return nil, err
	}

	asset, err := vault.Asset(nil)
	if err != nil {
		logger.Error("failed to get vault asset", "error", err)
		return nil, err
	}

	rewardTokens, err := vault.RewardTokens(nil)
	if err != nil {
		logger.Error("failed to get vault reward tokens", "error", err)
		return nil, err
	}

	pool, err := vault.PoolAddress(nil)
	if err != nil {
		logger.Error("failed to get vault pool address", "error", err)
		return nil, err
	}

	// Create the vault and check if it is valid.
	v, err := db.SafeNewVault(vaultAddress, name, symbol, asset, rewardTokens, pool)
	if err != nil {
		logger.Error("failed to create vault", "error", err)
		return nil, err
	}

	return v, nil
}
