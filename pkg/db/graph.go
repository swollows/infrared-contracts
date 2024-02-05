package db

import (
	"context"

	"github.com/berachain/offchain-sdk/log"
	"github.com/hasura/go-graphql-client"
)

// GraphAPI is the struct for the graph API.
type GraphAPI struct {
	client *graphql.Client
	logger log.Logger
}

// NewGraphAPI returns a new graph API.
func NewGraphAPI(url string, logger log.Logger) *GraphAPI {
	c := graphql.NewClient(url, nil)
	return &GraphAPI{client: c, logger: logger.With("graph db")}
}

// GetVaults gets the vaults from the graph api.
func (g *GraphAPI) GetVaults(ctx context.Context) ([]*Vault, error) {
	var query VaultsQuery
	if err := g.client.Query(ctx, &query, nil); err != nil {
		return nil, err
	}

	// Transform the graph data structure to the db data structure.
	vaults := make([]*Vault, len(query.Vaults))
	for i, v := range query.Vaults {
		r := make([]string, len(v.RewardTokens))
		for i, rt := range v.RewardTokens {
			r[i] = rt.ID
		}

		vaults[i] = &Vault{
			VaultHexAddress:        v.ID,
			StakingAssetHexAddress: v.StakingToken.ID,
			RewardTokensHexAddress: r,
			PoolHexAddress:         v.Pool,
		}
	}

	return vaults, nil
}

// ==============================================================================
//  Queries
// ==============================================================================

// VaultData is the struct for vault graph data structure.
type VaultData struct {
	ID           string
	StakingToken struct {
		ID string
	}
	RewardTokens []struct {
		ID string
	}
	Pool string
}

type VaultsQuery struct {
	Vaults []VaultData
}
