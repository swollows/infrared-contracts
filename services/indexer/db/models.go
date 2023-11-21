package db

// Vault is the struct for the vault.
type Vault struct {
	Name                   string   `json:"name"`
	Symbol                 string   `json:"symbol"`
	AssetHexAddress        string   `json:"assetHexAddress"`
	RewardTokensHexAddress []string `json:"rewardTokensHexAddress"`
	PoolHexAddress         string   `json:"poolHexAddress"`
}

type CheckPoint struct {
	LastBlock          uint64 `json:"lastBlock"`
	LastBlockTimeStamp uint64 `json:"lastBlockTimeStamp"`
}
