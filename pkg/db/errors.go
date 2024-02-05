package db

import (
	"errors"

	"github.com/infrared-dao/infrared-mono-repo/pkg/tools"
)

// All the errors that can be returned by the db package.
var (
	ErrEmptyVaultAddress        = tools.NewError("db", errors.New("empty vault address"))
	ErrEmptyVaultName           = tools.NewError("db", errors.New("empty vault name"))
	ErrEmptyVaultSymbol         = tools.NewError("db", errors.New("empty vault symbol"))
	ErrEmptyRewardAddress       = tools.NewError("db", errors.New("empty reward address"))
	ErrEmptyPoolAddress         = tools.NewError("db", errors.New("empty pool address"))
	ErrEmptyStakingAssetAddress = tools.NewError("db", errors.New("empty staking asset address"))
)
