package config

import "time"

type ContractConfig struct {
	InfraredContractAddress string
}

type DBConfig struct {
	RedisURL string
}

type GlobalParamsRefresherConfig struct {
	Interval time.Duration
}

type BlockIndexerConfig struct {
	Interval time.Duration
}

type JobsConfig struct {
	GlobalParamsRefresher GlobalParamsRefresherConfig
}

type Config struct {
	Contracts ContractConfig
	Jobs      JobsConfig
	DB        DBConfig
}
