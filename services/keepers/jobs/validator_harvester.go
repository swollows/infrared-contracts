package jobs

import (
	"context"
	"math/big"
	"time"

	"github.com/berachain/offchain-sdk/core/transactor"
	"github.com/berachain/offchain-sdk/core/transactor/tracker"
	txrtypes "github.com/berachain/offchain-sdk/core/transactor/types"
	"github.com/berachain/offchain-sdk/job"
	"github.com/berachain/offchain-sdk/log"
	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/distribution"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
)

// ==============================================================================
//  Dependencies & constants
// ==============================================================================

// The method names for this job.
const (
	// validatorHarvestCallName is the name of the method that harvests the validator.
	validatorHarvestCallName = "harvestValidator"
)

// ==============================================================================
//  ValidatorHarvester
// ==============================================================================

// Compile time check to ensure this type implements the Job interface.
var (
	_ job.Polling        = &ValidatorHarvester{}
	_ job.Basic          = &ValidatorHarvester{}
	_ job.HasSetup       = &ValidatorHarvester{}
	_ tracker.Subscriber = &VaultHarvester{}
)

// ValidatorHarvester is the job that harvests the validator.
type ValidatorHarvester struct {
	// interval is the interval at which the job runs.
	interval *time.Duration
	// minBera is the minimum amount of Bera to harvest.
	minBera *big.Int
	// distributionPrecompileAddress is the address of the distribution precompile.
	distributionPrecompileAddress common.Address
	// distributionPrecompileContract is the contract of the distribution precompile.
	distributionPrecompileContract *distribution.Contract
	// infraredContractAddress is the address of the infrared contract.
	infraredContractAddress common.Address
	// infraredContract is the contract of the infrared contract used to query state.
	infraredContract *infrared.Contract
	// txMgr is the transaction manager for the job.
	txMgr *transactor.TxrV2
	// txPacker is the transaction packer for the job.
	txPacker *txrtypes.Packer
	// logger is the logger for the job.
	logger log.Logger
}

// NewValidatorHarvester returns a new validator harvester job.
func NewValidatorHarvester(
	interval *time.Duration,
	minBera *big.Int,
	distributionPrecompileAddress common.Address,
	infraredContractAddress common.Address,
	txMgr *transactor.TxrV2,
) *ValidatorHarvester {
	return &ValidatorHarvester{
		interval:                      interval,
		minBera:                       minBera,
		distributionPrecompileAddress: distributionPrecompileAddress,
		infraredContractAddress:       infraredContractAddress,
		txMgr:                         txMgr,
		txPacker:                      &txrtypes.Packer{MetaData: infrared.ContractMetaData},
	}
}

// RegistryKey implements the job.Basic interface.
func (vh *ValidatorHarvester) RegistryKey() string {
	return "validator_harvester"
}

// Setup implements the job.HasSetup interface.
func (vh *ValidatorHarvester) Setup(ctx context.Context) error {
	sCtx := sdk.UnwrapContext(ctx)
	ethClient := sCtx.Chain()
	logger := sCtx.Logger().With("job", vh.RegistryKey())

	// Setup the distribution precompile contract.
	distributionPrecompileContract, err := distribution.NewContract(vh.distributionPrecompileAddress, ethClient)
	if err != nil {
		logger.Error("❌ Failed create distribution precompile contract object", "Error", err)
		return err
	}
	vh.distributionPrecompileContract = distributionPrecompileContract

	// Setup the infrared contract.
	infraredContract, err := infrared.NewContract(vh.infraredContractAddress, ethClient)
	if err != nil {
		logger.Error("❌ Failed create infrared contract object", "Error", err)
		return err
	}
	vh.infraredContract = infraredContract

	// Handle the transaction results from the transaction manager.
	vh.txMgr.SubscribeTxResults(ctx, vh, make(chan *tracker.InFlightTx, 1024))

	// Setup the logger.
	vh.logger = logger

	return nil
}

// IntervalTime implements the job.Polling interface.
func (vh *ValidatorHarvester) IntervalTime(_ context.Context) time.Duration {
	return *vh.interval
}

// Execute implements the job.Basic interface.
func (vh *ValidatorHarvester) Execute(ctx context.Context, _ any) (any, error) {
	sCtx := sdk.UnwrapContext(ctx)
	logger := sCtx.Logger().With("job", vh.RegistryKey())
	logger.Info("⏳ Polling Validator Harvester Job...")

	// Get the ripe validators.
	validators, err := vh.getRipe(sCtx, logger)
	if err != nil {
		return nil, err
	}

	// Harvest the ripe validators.
	for _, validator := range validators {
		err := vh.harvestValidator(sCtx, validator, logger)
		if err != nil {
			return nil, err
		}
	}

	return nil, nil
}

// ==============================================================================
//  Helpers
// ==============================================================================

// harvestValidators is a helper method that harvests the ripe the validators.
func (vh *ValidatorHarvester) harvestValidator(sCtx *sdk.Context, validator common.Address, logger log.Logger) error {
	tx := &txrtypes.TxRequest{}
	tx, err := vh.txPacker.CreateTxRequest(
		vh.infraredContractAddress,
		nil, // value
		nil, // gas tip cap
		nil, // gas fee cap
		0,   // Gas limit
		validatorHarvestCallName,
		validator,
	)
	if err != nil {
		logger.Error("❌ Failed to create transaction request", "Error", err)
		return err
	}

	_, err = vh.txMgr.SendTxRequest(tx)
	if err != nil {
		logger.Error("❌ Failed to send transaction request", "Error", err)
		return err
	}

	logger.Info("📡 Sent transaction request", "To", tx.To, "Validator", validator.Hex())

	return nil
}

// getRipe returns the ripe validators.
func (vh *ValidatorHarvester) getRipe(ctx *sdk.Context, logger log.Logger) ([]common.Address, error) {
	validators, err := vh.infraredContract.InfraredValidators(nil)
	if err != nil {
		logger.Error("⚠️ Failed to get validators", "Error", err)
		return nil, err
	}

	ripe := make([]common.Address, 0)
	for _, validator := range validators {
		cr, err := vh.distributionPrecompileContract.GetAllDelegatorRewards(nil, vh.infraredContractAddress)
		if err != nil {
			logger.Error("⚠️ Failed to get current rewards", "Error", err)
			return nil, err
		}

		if vh.isRipe(validator, cr) {
			ripe = append(ripe, validator)
		}
	}

	return ripe, nil
}

// isRipe returns true if the validator is ready to be harvested, false otherwise.
func (vh *ValidatorHarvester) isRipe(
	validator common.Address,
	validatorRewards []distribution.IDistributionModuleValidatorReward,
) bool {
	for _, vr := range validatorRewards {
		// Check if this is the validator we are looking for.
		if vr.Validator != validator {
			continue
		}

		// Check if the rewards are empty, then the validator is not ripe.
		if len(vr.Rewards) == 0 {
			return false
		}

		// Get the amount of Bera.
		amt := big.NewInt(0)
		for _, reward := range vr.Rewards {
			if reward.Denom == "abera" {
				amt = reward.Amount
				break // Break early since we only care about Bera.
			}
		}

		return amt.Cmp(vh.minBera) >= 0
	}

	// If we reach here, then the validator is not ripe.
	return false
}

// ==============================================================================
//  Transaction Subscriber
// ==============================================================================

// OnSuccess implements the tracker.Subscriber interface.
func (vh *ValidatorHarvester) OnSuccess(tx *tracker.InFlightTx, receipt *types.Receipt) error {
	// Check if the transaction is from the infrared contract.
	if receipt.ContractAddress != vh.infraredContractAddress {
		return nil
	}
	vh.logger.Info("✅ successfuly harvested validator", "TxHash", tx.Hash())
	return nil
}

// OnRevert is called when a transaction reverts.
func (vh *ValidatorHarvester) OnRevert(tx *tracker.InFlightTx, receipt *types.Receipt) error {
	// Check if the transaction is from the infrared contract.
	if receipt.ContractAddress != vh.infraredContractAddress {
		return nil
	}
	vh.logger.Info("❌ Failed to harvest validator", "TxHash", tx.Hash())
	return nil
}

// OnStale is called when a transaction becomes stale.
func (vh *ValidatorHarvester) OnStale(ctx context.Context, tx *tracker.InFlightTx) error {
	vh.logger.Info("⚠️ Stale transaction", "TxHash", tx.Hash())
	return nil
}

// OnError is called when a transaction errors.
func (vh *ValidatorHarvester) OnError(ctx context.Context, tx *tracker.InFlightTx, err error) {
	vh.logger.Error("❌ Transaction error", "TxHash", tx.Hash(), "Error", err)
}
