package eth

import (
	"context"
	"crypto/ecdsa"
	"math/big"

	"github.com/berachain/offchain-sdk/types/kms/types"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
)

// Signer is a private struct that holds the address and private key of the signer and is used to sign transactions.
type signer struct {
	address    common.Address
	privateKey *ecdsa.PrivateKey
}

// NewSigner returns a new instance of the Signer.
func NewSigner(privateKey string) types.TxSigner { // Implement the TxSigner interface
	pk, err := crypto.ToECDSA(common.FromHex(privateKey))
	if err != nil {
		panic(err)
	}

	return &signer{
		address:    crypto.PubkeyToAddress(pk.PublicKey),
		privateKey: pk,
	}
}

// Address returns the address of the signer.
func (s *signer) Address() common.Address {
	return s.address
}

// SignerFunc returns a function that can be used to sign transactions.
func (s *signer) SignerFunc(_ context.Context, chainID *big.Int) (bind.SignerFn, error) {
	txOpts, err := bind.NewKeyedTransactorWithChainID(s.privateKey, chainID)
	if err != nil {
		return nil, err
	}

	return txOpts.Signer, nil
}
