package config

import "time"

// DBConfig contains the configuration for the database.
type DBConfig struct {
	ConnectionURL string
}

// IntervalConfig contains the configuration for the interval.
type IntervalConfig struct {
	// HarvestInterval is the interval at which the harvester will harvest the rewards.
	HarvestInterval time.Duration
}

// SignerConfig contains the configuration for the signer.
type SignerConfig struct {
	// PublicKey is the public key of the signer.
	PublicKey string
	// PrivateKey is the private key of the signer.
	PrivateKey string
}

// HarvestConfig contains the configuration for the harvester.
type HarvestConfig struct {
	// MinBGT is the minimum amount of BGT that the harvester will harvest.
	MinBGT uint64
	// The rewards precompile address.
	RewardsPrecompileAddress string
	// The infrared contract address.
	InfraredContractAddress string
	// The GasLimit for the harvest transaction.
	GasLimit uint64
}

// Config contains the configuration for the keepers.
type Config struct {
	DB       DBConfig
	Interval IntervalConfig
	Signer   SignerConfig
	Harvest  HarvestConfig
}
