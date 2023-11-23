package config

// ContractConfig contains the addresses of the contracts that the indexer will be watching.
type ContractConfig struct {
	InfraredContractAddress string
}

// DBConfig contains the configuration for the database.
type DBConfig struct {
	ConnectionURL string
}

// CheckpointConfig contains the configuration for the checkpointing system. (this will be set at runtime).
type CheckpointConfig struct {
	LatestBlock uint64
}

// Config contains the configuration for the indexer.
type Config struct {
	Contracts  ContractConfig
	DB         DBConfig
	Checkpoint CheckpointConfig
}
