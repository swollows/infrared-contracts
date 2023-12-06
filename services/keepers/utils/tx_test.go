package util

import (
	"context"
	"crypto/ecdsa"
	"crypto/rand"
	"math/big"
	"testing"

	sdk "github.com/berachain/offchain-sdk/types"
	common "github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/infrared-dao/infrared-mono-repo/pkg/testing/mocks"
)

// setup returns all the dependencies for the tests.
func setup() (*sdk.Context, common.Address, *ecdsa.PrivateKey) {
	// Create the dependencies.
	ethClient := mocks.NewEthClient()
	logger := mocks.NewLogger()
	db := mocks.NewKeyValueStore()
	sCtx := sdk.NewContext(context.TODO(), ethClient, logger, db)

	// Mock the eth client.
	ethClient.PendingNonceAtFunc = func(ctx context.Context, account common.Address) (uint64, error) {
		return 0, nil
	}
	ethClient.ChainIDFunc = func(ctx context.Context) (*big.Int, error) {
		return big.NewInt(0), nil
	}

	// Create the public and private keys.
	privKey, _ := ecdsa.GenerateKey(crypto.S256(), rand.Reader)
	pubKey := privKey.PublicKey

	return sCtx, common.BytesToAddress(pubKey.X.Bytes()), privKey
}

func TestGenerateTransactionOps(t *testing.T) {
	// Setup the dependencies.
	sCtx, pubKey, privKey := setup()

	type args struct {
		sCtx     *sdk.Context
		pubKey   common.Address
		privKey  *ecdsa.PrivateKey
		gasLimit uint64
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			name: "success",
			args: args{
				sCtx:     sCtx,
				pubKey:   pubKey,
				privKey:  privKey,
				gasLimit: 0,
			},
		},
		{
			name: "empty context",
			args: args{
				sCtx:     nil,
				pubKey:   pubKey,
				privKey:  privKey,
				gasLimit: 0,
			},
			wantErr: true,
		},
		{
			name: "empty private key",
			args: args{
				sCtx:     sCtx,
				pubKey:   pubKey,
				privKey:  nil,
				gasLimit: 0,
			},
			wantErr: true,
		},
		{
			name: "empty public key",
			args: args{
				sCtx:     sCtx,
				pubKey:   common.Address{},
				privKey:  privKey,
				gasLimit: 0,
			},
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			_, err := GenerateTransactionOps(tt.args.sCtx, tt.args.privKey, tt.args.pubKey, tt.args.gasLimit)
			if (err != nil) != tt.wantErr {
				t.Errorf("GenerateTransactionOps() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
		})
	}
}
