package util

import (
	"context"
	"crypto/ecdsa"
	"errors"
	"math/big"

	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	common "github.com/ethereum/go-ethereum/common"
)

// GenerateTransactionOps generates the transaction options for a transaction.
func GenerateTransactionOps(
	sCtx *sdk.Context,
	pubKey common.Address,
	privKey *ecdsa.PrivateKey,
	gasLimit uint64,
) (*bind.TransactOpts, error) {
	// Check that the context is not nil.
	if sCtx == nil {
		return nil, errors.New("context is nil")
	}

	// Check that the private key is not nil.
	if privKey == nil {
		return nil, errors.New("private key is nil")
	}

	nonce, err := sCtx.Chain().PendingNonceAt(context.Background(), pubKey)
	if err != nil {
		return nil, err
	}

	chainID, err := sCtx.Chain().ChainID(context.Background())
	if err != nil {
		return nil, err
	}

	txOpts, err := bind.NewKeyedTransactorWithChainID(privKey, chainID)
	if err != nil {
		return nil, err
	}

	// Configure the transaction options.
	txOpts.Nonce = big.NewInt(int64(nonce))
	txOpts.GasLimit = gasLimit

	return txOpts, nil
}
