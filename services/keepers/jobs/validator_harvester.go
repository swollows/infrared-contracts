package jobs

import (
	"context"
	"crypto/ecdsa"
	"math/big"
	"time"

	"github.com/berachain/offchain-sdk/job"
	"github.com/berachain/offchain-sdk/log"
	sdk "github.com/berachain/offchain-sdk/types"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/distribution"
	"github.com/infrared-dao/infrared-mono-repo/pkg/bindings/infrared"
	"github.com/infrared-dao/infrared-mono-repo/pkg/db"
	"github.com/infrared-dao/infrared-mono-repo/pkg/tools"
	util "github.com/infrared-dao/infrared-mono-repo/services/keepers/utils"
)

// ==============================================================================
//  Dependencies & constants
// ==============================================================================

// VaValidatorHarvestDB is the interface for the validator harvester database.
type ValidatorHarvestDB interface {
	SetCheckpoint(ctx context.Context, checkpoint *db.CheckPoint) error
}

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
	_ job.Polling  = &ValidatorHarvester{}
	_ job.Basic    = &ValidatorHarvester{}
	_ job.HasSetup = &ValidatorHarvester{}
)

// ValidatorHarvester is the job that harvests the validator.
type ValidatorHarvester struct {
	// db is the database for the validator harvester job.
	db ValidatorHarvestDB
	// interval is the interval at which the job runs.
	interval *time.Duration
	// pubKey is the public key of the validator harvester.
	pubKey common.Address
	// privKey is the private key of the validator harvester.
	privKey *ecdsa.PrivateKey
	// minBera is the minimum amount of Bera to harvest.
	minBera *big.Int
	// distributionPrecompileAddress is the address of the distribution precompile.
	distributionPrecompileAddress common.Address
	// distributionPrecompileContract is the contract of the distribution precompile.
	distributionPrecompileContract *distribution.Contract
	// infraredContractAddress is the address of the infrared contract.
	infraredContractAddress common.Address
	// infraredBoundContract is the contract of the infrared contract.
	infraredBoundContract *bind.BoundContract
	// infraredContract is the contract of the infrared contract used to query state.
	infraredContract *infrared.Contract
	// gasLimit is the gas limit for the transaction.
	gasLimit uint64
}

// NewValidatorHarvester returns a new validator harvester job.
func NewValidatorHarvester(
	db ValidatorHarvestDB,
	interval *time.Duration,
	pubKey common.Address,
	privKey *ecdsa.PrivateKey,
	minBera *big.Int,
	distributionPrecompileAddress common.Address,
	infraredContractAddress common.Address,
	gasLimit uint64,
) *ValidatorHarvester {
	return &ValidatorHarvester{
		db:                            db,
		interval:                      interval,
		pubKey:                        pubKey,
		privKey:                       privKey,
		minBera:                       minBera,
		distributionPrecompileAddress: distributionPrecompileAddress,
		infraredContractAddress:       infraredContractAddress,
		gasLimit:                      gasLimit,
	}
}

// RegistryKey implements the job.Basic interface.
func (vh *ValidatorHarvester) RegistryKey() string {
	return "valiator_harvester"
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

	// Setup the infrared bound contract.
	infraredAbi, err := infrared.ContractMetaData.GetAbi()
	if err != nil {
		logger.Error("❌ Failed to get infrared abi", "Error", err)
		return err
	}
	vh.infraredBoundContract = bind.NewBoundContract(
		vh.infraredContractAddress,
		*infraredAbi,
		ethClient,
		ethClient,
		ethClient,
	)

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

		// Sleep for 1 second to avoid spamming the node.
		time.Sleep(1 * time.Second)
	}

	// Get the block number after the harvest.
	blockNumber, err := sCtx.Chain().BlockNumber(sCtx)
	if err != nil {
		logger.Error("⚠️  Failed to get block number", "Error", err)
		return nil, err
	}

	// Set the checkpoint in the database.
	if err := vh.db.SetCheckpoint(sCtx, db.NewCheckPoint(blockNumber)); err != nil {
		logger.Error("⚠️  Failed to set checkpoint", "Error", err)
		return nil, err
	}

	return nil, nil
}

// ==============================================================================
//  Helpers
// ==============================================================================

// harvestValidators is a helper method that harvests the ripe the validators.
func (vh *ValidatorHarvester) harvestValidator(sCtx *sdk.Context, validator common.Address, logger log.Logger) error {
	// Generate the transaction opts.
	txOpts, err := util.GenerateTransactionOps(sCtx, vh.pubKey, vh.privKey, vh.gasLimit)
	if err != nil {
		logger.Error("❌ Failed to generate transaction options", "Error", err)
		return err
	}

	// Generate the transaction.
	tx, err := vh.infraredBoundContract.Transact(
		txOpts,
		validatorHarvestCallName,
		validator,
	)
	if err != nil {
		logger.Error("❌ Failed to generate transaction", "Error", err)
		return err
	}

	// Handle the transaction response in a seperate goroutine.
	go tools.HandleTxResponse(sCtx, sCtx.Chain(), vh.pubKey, tx, logger)

	return nil
}

func (vh *ValidatorHarvester) getRipe(ctx *sdk.Context, logger log.Logger) ([]common.Address, error) {
	// Get all the infrared validators on-chain.
	_, err := vh.infraredContract.InfraredValidators(nil)
	if err != nil {
		logger.Error("⚠️ Failed to get validators", "Error", err)
		return nil, err
	}

	// TODO: Chain needs to update (told Berachain core devs about the issue).
	// Issue: CurrentRewards sends tx rn, but should be a view method.
	// // Filter the ripe validators.
	// ripeValidators := make([]common.Address, 0)
	// for _, validator := range validators {
	// 	// Get the validators current rewards.
	// 	cr, err := vh.distributionPrecompileContract.GetCurrentRewards(
	// 		nil,
	// 		vh.infraredContractAddress,
	// 		validator,
	// 	)
	// 	if err != nil {
	// 		logger.Error("⚠️ Failed to get current rewards", "Error", err)
	// 		return nil, err
	// 	}

	// 	// Check if the validartor is ripe and add it to the list if it is.
	// 	if vh.isRipe(cr) {

	// 	}
	// }

	return []common.Address{}, nil // FOR NOW RETURNING EMPTY LIST.
}

// isRipe is a helper method that checks if the validator is ripe for harvesting.
//
//nolint:unused // TODO: Use method once chain is updated.
func (vh *ValidatorHarvester) isRipe(coins []distribution.CosmosCoin) bool {
	// If the rewards are empty, then the validator is not ripe.
	if len(coins) == 0 {
		return false
	}

	// Get the amount of Bera.
	amt := big.NewInt(0)
	for _, coin := range coins {
		if coin.Denom == "abera" {
			amt = coin.Amount
			break // Break early since we only care about Bera.
		}
	}

	return amt.Cmp(vh.minBera) >= 0
}
