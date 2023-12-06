package app

import (
	"math/big"

	"github.com/berachain/offchain-sdk/baseapp"
	coreapp "github.com/berachain/offchain-sdk/core/app"
	"github.com/berachain/offchain-sdk/log"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"
	"github.com/infrared-dao/infrared-mono-repo/services/keepers/config"
	"github.com/infrared-dao/infrared-mono-repo/services/keepers/jobs"
	util "github.com/infrared-dao/infrared-mono-repo/services/keepers/utils"
	"github.com/redis/go-redis/v9"
)

// We must conform to the `App` interface.
var _ coreapp.App[config.Config] = &KeeperApp{}

// KeeperApp polls at intervals and does actions on the system.
type KeeperApp struct {
	*baseapp.BaseApp
}

// Name implements the `App` interface.
func (app *KeeperApp) Name() string {
	return "keeper"
}

// Setup implements the `App` interface.
func (app *KeeperApp) Setup(builder coreapp.Builder, config config.Config, logger log.Logger) {
	logger.Info("Setting up keeper app...")

	// Populate the config with secrets.
	PopulateKeeperAppConfig(&config, logger)

	// Parse the database connection url.
	options, err := redis.ParseURL(config.DB.ConnectionURL)
	if err != nil {
		logger.Error("Could not parse database connection url", "error", err)
		panic(err)
	}

	// Create the db repository.
	db, err := db.NewRepository(options, logger)
	if err != nil {
		logger.Error("Could not create database repository", "error", err)
		panic(err)
	}

	// Get the public and private keys.
	privKey, pubKey, err := util.GetKeys(config.Signer.PrivateKey, config.Signer.PublicKey)
	if err != nil {
		logger.Error("Could not get keys", "error", err)
		panic(err)
	}

	// Get the addresses of the contracts.
	infraredContractAddress := common.HexToAddress(config.ContractsConfig.InfraredContractAddress)
	rewardsPrecompileAddress := common.HexToAddress(config.ContractsConfig.RewardsPrecompileAddress)
	distributionPrecompileAddress := common.HexToAddress(config.ContractsConfig.DistributionPrecompileAddress)

	// Create the vault harvester job.
	vaultHarvesterJob := jobs.NewVaultHarvester(
		db,
		&config.Interval.VaultHarvesterInterval,
		pubKey,
		privKey,
		new(big.Int).SetUint64(config.VaultHarvester.MinBGT),
		rewardsPrecompileAddress,
		infraredContractAddress,
		config.VaultHarvester.GasLimit,
	)

	// Create the validator harvester job.
	validatorHarvesterJob := jobs.NewValidatorHarvester(
		db,
		&config.Interval.ValidatorHarvesterInterval,
		pubKey,
		privKey,
		new(big.Int).SetUint64(config.ValidatorHarvester.MinBera),
		distributionPrecompileAddress,
		infraredContractAddress,
		config.ValidatorHarvester.GasLimit,
	)

	// Register the jobs.
	builder.RegisterJob(vaultHarvesterJob)
	builder.RegisterJob(validatorHarvesterJob)

	app.BaseApp = builder.BuildApp(logger)
}

// Stop implemets the `App` interface.
func (app *KeeperApp) Stop() {
	app.BaseApp.Stop()
}
