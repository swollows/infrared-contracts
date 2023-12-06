package tools

import (
	"context"
	"time"

	"github.com/berachain/offchain-sdk/client/eth"
	"github.com/berachain/offchain-sdk/log"
	"github.com/ethereum/go-ethereum/common"

	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	coretypes "github.com/ethereum/go-ethereum/core/types"
)

// HandleTxResponse handles the response of a transaction, should be called in its own goroutine.
func HandleTxResponse(
	ctx *sdk.Context,
	ethClient eth.Client,
	caller common.Address,
	tx *coretypes.Transaction,
	logger log.Logger,
) {
	// Log the transaction hash.
	logger.Info("📝 Transaction Sent", "Hash", tx.Hash())

	// This context is used to cancel the transaction if it takes too long.
	ctxWithTimeOut, cancel := context.WithTimeout(ctx, 10*time.Second)

	// Wait for the transaction to be mined using the context with timeout.
	receipt, err := bind.WaitMined(ctxWithTimeOut, ethClient, tx)
	cancel()
	if err != nil {
		logger.Error("⏰ Transaction Failed", "Error", err)
		return
	}

	// Check if the transaction was not successful.
	if receipt.Status != 1 {
		// Check the contract for the call error.
		msg := ethereum.CallMsg{
			From:     caller,
			To:       tx.To(),
			Data:     tx.Data(),
			Gas:      tx.Gas(),
			GasPrice: tx.GasPrice(),
			Value:    tx.Value(),
		}
		res, err := ethClient.CallContract(context.Background(), msg, nil)
		if err != nil {
			logger.Error("❕ Transaction Failed", "Receipt", receipt)
			return
		}

		// Get the revert reason from the call return data.
		revert, err := abi.UnpackRevert(res)
		if err != nil {
			logger.Error("❕ Transaction Failed", "Receipt", receipt)
			return
		}

		// Log the revert reason.
		logger.Error("❌ Transaction Failed", "Receipt", receipt, "Revert", revert)

		return
	}

	logger.Info("✅ Transaction Successful", "Receipt", receipt)
}
