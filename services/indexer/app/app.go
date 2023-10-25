package app

import (
	"github.com/berachain/offchain-sdk/baseapp"
	coreapp "github.com/berachain/offchain-sdk/core/app"
	"github.com/berachain/offchain-sdk/log"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/services/indexer/config"

	jobs "github.com/berachain/offchain-sdk/x/jobs"
	indexerjobs "github.com/infrared-dao/infrared-mono-repo/services/indexer/jobs"
)

// We must conform to the `App` interface.
var _ coreapp.App[config.Config] = &IndexerApp{}

// IndexerApp listenes to multiple contracts and events and indexes them for the backend API.
type IndexerApp struct {
	*baseapp.BaseApp
}

// Name implements the `App` interface.
func (app *IndexerApp) Name() string {
	return "indexer"
}

// Setup implements the `App` interface.
func (app *IndexerApp) Setup(builder coreapp.Builder, config config.Config, logger log.Logger) {
	logger.Info("Setting up indexer app")
	logger.Info("Configuring indexer app", "config", config)

	// Parse the address of the Infrared contract.
	infraredAddress := common.HexToAddress(config.Contracts.InfraredContractAddress)

	// Reigster the Vault Watcher job.
	builder.RegisterJob(
		jobs.NewBlockHeaderWatcher(
			indexerjobs.NewVaultsWatcher(
				infraredAddress,
			),
		),
	)

	// Build the application.
	app.BaseApp = builder.BuildApp(logger)
}

// Start implements the `App` interface.
func (app *IndexerApp) Stop() {
	app.BaseApp.Stop()
}
