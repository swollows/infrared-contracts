package app

import (
	"github.com/infrared-dao/infrared-mono-repo/pkg/tools"
	"github.com/infrared-dao/infrared-mono-repo/services/indexer/config"
	"github.com/subosito/gotenv"
)

func PopulateConfig(config *config.Config) {
	// Load the .env file.
	gotenv.Load()

	config.DB.ConnectionURL = tools.GetEnv("DB_CONNECTION_URL", "")
	if config.DB.ConnectionURL == "" {
		panic("DB_CONNECTION_URL is required")
	}

	config.Contracts.InfraredContractAddress = tools.GetEnv("INFRARED_CONTRACT_ADDRESS", "")
	if config.Contracts.InfraredContractAddress == "" {
		panic("INFRARED_CONTRACT_ADDRESS is required")
	}
}
