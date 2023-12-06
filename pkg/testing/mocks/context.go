package mocks

import (
	"github.com/berachain/offchain-sdk/client/eth"
	"github.com/berachain/offchain-sdk/log"
	"github.com/ethereum/go-ethereum/ethdb"
)

// EthClient mimics the eth.Client interface, so that we can mock it.
type EthClient interface {
	eth.Client
}

// Logger mimics the log.Logger interface, so that we can mock it.
type Logger interface {
	log.Logger
}

// KeyValueStore mimics the ethdb.KeyValueStore interface, so that we can mock it.
type KeyValueStore interface {
	ethdb.KeyValueStore
}

// Generate mocks for the EthClient interface.
//go:generate moq -out ./context.mock.go -pkg mocks ./ EthClient Logger KeyValueStore

// NewEthClient creates a new mock EthClient and returns a pointer to it.
func NewEthClient() *EthClientMock {
	return &EthClientMock{}
}

// NewLogger creates a new mock Logger and returns a pointer to it.
func NewLogger() *LoggerMock {
	return &LoggerMock{}
}

// NewKeyValueStore creates a new mock KeyValueStore and returns a pointer to it.
func NewKeyValueStore() *KeyValueStoreMock {
	return &KeyValueStoreMock{}
}
