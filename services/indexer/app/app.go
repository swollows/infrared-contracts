package app

import (
	"github.com/berachain/offchain-sdk/baseapp"
	coreapp "github.com/berachain/offchain-sdk/core/app"
	"github.com/berachain/offchain-sdk/log"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/services/indexer/config"
	"github.com/infrared-dao/infrared-mono-repo/services/indexer/db"
	"github.com/infrared-dao/infrared-mono-repo/services/indexer/jobs"
	"github.com/redis/go-redis/v9"
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
	logger.Info("Setting up indexer app...")

	// Parse the database connection url.
	options, err := redis.ParseURL(config.DB.ConnectionURL)
	if err != nil {
		logger.Error("Could not parse database connection url", "error", err)
		panic(err)
	}

	// Create the database repository.
	db, err := db.NewRepository(options, logger)
	if err != nil {
		logger.Error("Could not create database repository", "error", err)
		panic(err)
	}

	// Create the new vault subscriber job.
	vaultsJob := jobs.NewVaultsSubscriber(
		db,
		common.HexToAddress(config.Contracts.InfraredContractAddress),
		config.Checkpoint.LatestBlock,
	)

	// Register the jobs.
	builder.RegisterJob(vaultsJob)

	app.BaseApp = builder.BuildApp(logger)
}

// Start implements the `App` interface.
func (app *IndexerApp) Stop() {
	app.BaseApp.Stop()
}
