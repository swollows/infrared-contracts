package config

import (
	"time"

	"github.com/berachain/offchain-sdk/core/transactor"
)

// DBConfig contains the configuration for the database.
type DBConfig struct {
	ConnectionURL string
}

// IntervalConfig contains the configuration for the interval.
type IntervalConfig struct {
	// VaultHarvestInterval is the interval at which the vault harvester will harvest the rewards.
	VaultHarvesterInterval time.Duration
	// ValidatorHarvesterInterval is the interval at which the validator harvester will harvest the rewards.
	ValidatorHarvesterInterval time.Duration
}

// SignerConfig contains the configuration for the signer.
type SignerConfig struct {
	// PrivateKey is the private key of the signer.
	PrivateKey string
}

// ValidatorHarvesterConfig contains the configuration for the validator harvester.
type ValidatorHarvesterConfig struct {
	// MinBera is the minimum amount of Bera that the harvester will harvest.
	MinBera uint64
	// GasLimit is the gas limit for the transaction.
	GasLimit uint64
}

type VaultHarvesterConfig struct {
	// MinBGT is the minimum amount of BGT that the harvester will harvest.
	MinBGT uint64
	// GasLimit is the gas limit for the transaction.
	GasLimit uint64
}

// ContractsConfig contains the configuration for the contracts.
type ContractsConfig struct {
	// The infrared contract address.
	InfraredContractAddress string
	// The rewards precompile address.
	RewardsPrecompileAddress string
	// The distribution precompile address.
	DistributionPrecompileAddress string
}

// Config contains the configuration for the keepers.
type Config struct {
	DB                 DBConfig
	Interval           IntervalConfig
	Signer             SignerConfig
	ContractsConfig    ContractsConfig
	VaultHarvester     VaultHarvesterConfig
	ValidatorHarvester ValidatorHarvesterConfig
	Transactor         transactor.Config
}
