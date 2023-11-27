package util

import (
	"context"
	"crypto/ecdsa"
	"math/big"

	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	common "github.com/ethereum/go-ethereum/common"
)

func GenerateTransactionOps(sCtx *sdk.Context, pubKey common.Address, privKey *ecdsa.PrivateKey) (*bind.TransactOpts, error) {
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
	txOpts.GasLimit = 1e6 // TODO: make this configurable // dynamic gas limit?

	return txOpts, nil
}
