package db

import (
	"encoding"
	"encoding/json"

	"github.com/ethereum/go-ethereum/common"
)

var (
	_ encoding.BinaryMarshaler = (*Vault)(nil)
)

// Vault is the struct for the vault.
type Vault struct {
	VaultHexAddress        string   `json:"vaultHexAddress"`
	StakingAssetHexAddress string   `json:"stakingAssetHexAddress"`
	RewardTokensHexAddress []string `json:"rewardTokensHexAddress"`
	PoolHexAddress         string   `json:"poolHexAddress"`
}

// NewVault creates a new vault and returns a pointer to it.
func NewVault(
	vault common.Address,
	stakingAsset common.Address,
	rewards []common.Address,
	pool common.Address,
) *Vault {
	// Convert `rewards` to a slice of strings.
	rewardTokensHexAddress := make([]string, len(rewards))
	for i, reward := range rewards {
		rewardTokensHexAddress[i] = reward.Hex()
	}

	return &Vault{
		VaultHexAddress:        vault.Hex(),
		StakingAssetHexAddress: stakingAsset.Hex(),
		RewardTokensHexAddress: rewardTokensHexAddress,
		PoolHexAddress:         pool.Hex(),
	}
}

// SafeNewVault creates a new vault and returns a pointer to it and an error.
func SafeNewVault(
	vault common.Address,
	stakingAsset common.Address,
	rewards []common.Address,
	pool common.Address,
) (*Vault, error) {
	// Check if the vault address is empty.
	if vault.Cmp(common.Address{}) == 0 {
		return nil, ErrEmptyVaultAddress
	}

	// Check if the staking asset address is empty.
	if stakingAsset.Cmp(common.Address{}) == 0 {
		return nil, ErrEmptyStakingAssetAddress
	}

	// Check if the asset address is empty.
	for _, reward := range rewards {
		if reward.Cmp(common.Address{}) == 0 {
			return nil, ErrEmptyRewardAddress
		}
	}

	// Check if the pool address is empty.
	if pool.Cmp(common.Address{}) == 0 {
		return nil, ErrEmptyPoolAddress
	}

	return NewVault(vault, stakingAsset, rewards, pool), nil
}

// MarshalBinary marshals the vault into bytes.
func (v *Vault) MarshalBinary() ([]byte, error) {
	return json.Marshal(v)
}

// CheckPoint is the struct for the checkpoint.
type CheckPoint struct {
	LastBlock uint64 `json:"lastBlock"`
}

// NewCheckPoint creates a new checkpoint and returns a pointer to it.
func NewCheckPoint(lastBlock uint64) *CheckPoint {
	return &CheckPoint{
		LastBlock: lastBlock,
	}
}
