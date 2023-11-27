package util

import (
	"crypto/ecdsa"

	common "github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
)

// GetPrivateKey returns the private key from the private key string.
func GetPrivateKey(privKey string) (*ecdsa.PrivateKey, error) {
	privateKey, err := crypto.ToECDSA(common.FromHex(privKey))
	if err != nil {
		return nil, err
	}
	return privateKey, nil
}

// GetPublicKey returns the public key from the private key string.
func GetPublicKey(pubKey string) common.Address {
	return common.HexToAddress(pubKey)
}

// GetKeys returns the public and private keys from the private key string.
func GetKeys(privKey string, pubKey string) (*ecdsa.PrivateKey, common.Address, error) {
	privateKey, err := GetPrivateKey(privKey)
	if err != nil {
		return nil, common.Address{}, err
	}

	return privateKey, GetPublicKey(pubKey), nil
}
