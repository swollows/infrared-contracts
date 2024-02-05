package app

import (
	"github.com/berachain/offchain-sdk/log"
	"github.com/infrared-dao/infrared-mono-repo/pkg/tools"
	"github.com/infrared-dao/infrared-mono-repo/services/keepers/config"
)

// PopulateKeeperAppConfig populates the config struct with the env variables.
func PopulateKeeperAppConfig(config *config.Config, logger log.Logger) {
	populateSignerConfig(config)
	populateDBConfig(config)
	populateContractsConfig(config, logger)
}

// populateSignerConfig gets the signer info from the env and sets it in the config struct.
func populateSignerConfig(config *config.Config) {
	config.Signer.PrivateKey = tools.GetEnv("KEEPERS_PRIVATE_KEY", "")

	if config.Signer.PrivateKey == "" {
		panic("KEEPERS_PRIVATE_KEY is required")
	}
}

// populateContractsConfig gets the contract info from the env and sets it in the config struct.
func populateContractsConfig(config *config.Config, logger log.Logger) {
	config.ContractsConfig.InfraredContractAddress = tools.GetEnv("INFRARED_CONTRACT_ADDRESS", "")
	config.ContractsConfig.RewardsPrecompileAddress = tools.GetEnv("REWARDS_PRECOMPILE_ADDRESS", "")
	config.ContractsConfig.DistributionPrecompileAddress = tools.GetEnv("DISTRIBUTION_PRECOMPILE_ADDRESS", "")

	if config.ContractsConfig.InfraredContractAddress == "" {
		logger.Error("INFRARED_CONTRACT_ADDRESS is required")
		panic("INFRARED_CONTRACT_ADDRESS is required")
	}

	if config.ContractsConfig.RewardsPrecompileAddress == "" {
		logger.Error("REWARDS_PRECOMPILE_ADDRESS is required")
		panic("REWARDS_PRECOMPILE_ADDRESS is required")
	}

	if config.ContractsConfig.DistributionPrecompileAddress == "" {
		logger.Error("DISTRIBUTION_PRECOMPILE_ADDRESS is required")
		panic("DISTRIBUTION_PRECOMPILE_ADDRESS is required")
	}
}

// populateDBConfig gets the db info from the env and sets it in the config struct.
func populateDBConfig(config *config.Config) {
	config.DB.ConnectionURL = tools.GetEnv("DB_CONNECTION_URL", "")

	if config.DB.ConnectionURL == "" {
		panic("DB_CONNECTION_URL is required")
	}
}
