package app

import (
	"math/big"

	"github.com/berachain/offchain-sdk/baseapp"
	coreapp "github.com/berachain/offchain-sdk/core/app"
	"github.com/berachain/offchain-sdk/core/transactor"
	"github.com/berachain/offchain-sdk/core/transactor/types"
	"github.com/berachain/offchain-sdk/log"
	"github.com/berachain/offchain-sdk/types/queue/mem"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"
	"github.com/infrared-dao/infrared-mono-repo/pkg/eth"
	"github.com/infrared-dao/infrared-mono-repo/services/keepers/config"
	"github.com/infrared-dao/infrared-mono-repo/services/keepers/jobs"
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

	// Create the db from the config.
	db := db.NewGraphAPI(config.DB.ConnectionURL, logger)

	// Create the keeper signer and transaction manager.
	signer := eth.NewSigner(config.Signer.PrivateKey)
	txMgr := transactor.NewTransactor(config.Transactor, mem.NewQueue[*types.TxRequest](), signer)
	builder.RegisterJob(txMgr)

	// Get the addresses of the contracts.
	infraredContractAddress := common.HexToAddress(config.ContractsConfig.InfraredContractAddress)
	rewardsPrecompileAddress := common.HexToAddress(config.ContractsConfig.RewardsPrecompileAddress)
	distributionPrecompileAddress := common.HexToAddress(config.ContractsConfig.DistributionPrecompileAddress)

	// Create the vault harvester job.
	vaultHarvesterJob := jobs.NewVaultHarvester(
		db,
		&config.Interval.VaultHarvesterInterval,
		new(big.Int).SetUint64(config.VaultHarvester.MinBGT),
		rewardsPrecompileAddress,
		infraredContractAddress,
		txMgr,
	)

	// Create the validator harvester job.
	validatorHarvesterJob := jobs.NewValidatorHarvester(
		&config.Interval.ValidatorHarvesterInterval,
		new(big.Int).SetUint64(config.ValidatorHarvester.MinBera),
		distributionPrecompileAddress,
		infraredContractAddress,
		txMgr,
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
