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
