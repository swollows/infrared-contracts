package db

import (
	"context"
	"encoding/json"

	"github.com/berachain/offchain-sdk/log"
	redis "github.com/redis/go-redis/v9"
)

// Repository is the struct for the database repository.
type Repository struct {
	db     *redis.Client
	logger log.Logger
}

// NewRepository returns a new database repository.
func NewRepository(options *redis.Options, logger log.Logger) (*Repository, error) {
	// Create the database client.
	db := redis.NewClient(options)

	// Ping the database to make sure it is up and running.
	status := db.Ping(context.Background())
	if status.Err() != nil {
		logger.Error("Could not connect to database", "error", status.Err())
		return nil, status.Err()
	}

	return &Repository{db, logger}, nil
}

// SetCheckpoint sets the checkpoint in the database.
func (r *Repository) SetCheckpoint(ctx context.Context, checkpoint *CheckPoint) error {
	// Marshal the checkpoint.
	checkpointBytes, err := json.Marshal(checkpoint)
	if err != nil {
		r.logger.Error("Could not marshal checkpoint", "error", err)
		return err
	}

	// Set the checkpoint in the database.
	status := r.db.Set(ctx, "checkpoint", checkpointBytes, 0)
	if status.Err() != nil {
		r.logger.Error("Could not set checkpoint", "error", status.Err())
		return status.Err()
	}

	return nil
}

// GetCheckpoint gets the checkpoint from the database.
func (r *Repository) GetCheckpoint(ctx context.Context) (*CheckPoint, error) {
	// Get the checkpoint from the database.
	status := r.db.Get(ctx, "checkpoint")
	if status.Err() != nil {
		r.logger.Error("Could not get checkpoint", "error", status.Err())
		return nil, status.Err()
	}

	// Unmarshal the checkpoint.
	var checkpoint CheckPoint
	err := json.Unmarshal([]byte(status.Val()), &checkpoint)
	if err != nil {
		r.logger.Error("Could not unmarshal checkpoint", "error", err)
		return nil, err
	}

	return &checkpoint, nil
}

// SetVault sets the vault in the database. It appends the vault to the vaults array.
func (r *Repository) SetVault(ctx context.Context, vault *Vault) error {
	// Check if the 'vaults-list' key exists in the database.
	if r.db.Exists(ctx, "vaults-list").Val() == 0 {
		// Initialize 'vaults-list' as an empty JSON array at the root
		status := r.db.JSONSet(ctx, "vaults-list", "$", []Vault{})
		if status.Err() != nil {
			r.logger.Error("Could not initialize vaults-list", "error", status.Err())
			return status.Err()
		}
	}

	// Append the vault to the 'vaults-list' array.
	// Assuming your intention is to append to the root array
	status := r.db.JSONArrAppend(ctx, "vaults-list", "$", vault)

	// Check for errors.
	if status.Err() != nil {
		r.logger.Error("Could not set vault in vaults-list", "error", status.Err())
		return status.Err()
	}

	return nil
}

// GetVaults gets the vaults array from the database.
func (r *Repository) GetVaults(ctx context.Context) ([]*Vault, error) {
	// Get the vaults array from the database.
	status := r.db.JSONGet(ctx, "vaults-list", "$")

	// Check for errors.
	if status.Err() != nil {
		r.logger.Error("Could not get vaults-list", "error", status.Err())
		return nil, status.Err()
	}

	// Check for nil.
	val := status.Val()
	if val == "" {
		r.logger.Info("No vaults found in database")
		return nil, nil
	}

	// Unmarshal the vaults array.
	var vaults []*Vault
	if err := json.Unmarshal([]byte(val), &vaults); err != nil {
		r.logger.Error("Could not unmarshal vaults-list", "error", err)
		return nil, err
	}

	return vaults, nil
}
