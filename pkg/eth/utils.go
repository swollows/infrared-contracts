package eth

import (
	"math/big"

	sdk "github.com/berachain/offchain-sdk/types"
)

const (
	BaseFeeMultiplier = 1
)

// GetGasTipCap returns the suggested gas tip cap from the chain.
func GetGasTipCap(sCtx *sdk.Context) (*big.Int, error) {
	gtc, err := sCtx.Chain().SuggestGasTipCap(sCtx)
	if err != nil {
		sCtx.Logger().Error("❌ Failed to get gas tip cap", "Error", err)
		return nil, err
	}

	return gtc, nil
}

// GetGasFeeCap returns the suggested gas fee cap from the chain.
func GetGasFeeCap(sCtx *sdk.Context) (*big.Int, error) {
	height, err := sCtx.Chain().BlockNumber(sCtx)
	if err != nil {
		sCtx.Logger().Error("❌ Failed to get block number", "Error", err)
		return nil, err
	}

	header, err := sCtx.Chain().HeaderByNumber(sCtx, new(big.Int).SetUint64(height))
	if err != nil {
		sCtx.Logger().Error("❌ Failed to get header by number", "Error", err)
		return nil, err
	}

	// gasFeeCap = baseFee + (baseFee * BaseFeeMultiplier)
	gfc := new(big.Int).Mul(header.BaseFee, big.NewInt(BaseFeeMultiplier))

	return gfc, nil
}

// GetMaxGasLimit returns the suggested gas limit from the chain.
func GetMaxGasLimit(sCtx *sdk.Context) (uint64, error) {
	height, err := sCtx.Chain().BlockNumber(sCtx)
	if err != nil {
		sCtx.Logger().Error("❌ Failed to get block number", "Error", err)
		return 0, err
	}

	header, err := sCtx.Chain().HeaderByNumber(sCtx, new(big.Int).SetUint64(height))
	if err != nil {
		sCtx.Logger().Error("❌ Failed to get header by number", "Error", err)
		return 0, err
	}

	return header.GasLimit, nil
}
