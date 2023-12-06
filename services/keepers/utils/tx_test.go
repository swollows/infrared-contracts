package util

import (
	"crypto/ecdsa"
	"reflect"
	"testing"

	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	common "github.com/ethereum/go-ethereum/common"
)

func TestGenerateTransactionOps(t *testing.T) {
	type args struct {
		sCtx     *sdk.Context
		pubKey   common.Address
		privKey  *ecdsa.PrivateKey
		gasLimit uint64
	}
	tests := []struct {
		name    string
		args    args
		want    *bind.TransactOpts
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GenerateTransactionOps(tt.args.sCtx, tt.args.pubKey, tt.args.privKey, tt.args.gasLimit)
			if (err != nil) != tt.wantErr {
				t.Errorf("GenerateTransactionOps() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GenerateTransactionOps() = %v, want %v", got, tt.want)
			}
		})
	}
}
