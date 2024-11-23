// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ConfigTypes {
    /**
     * @notice Weight type enum for determining how much to weight reward distribution amongst recipients
     */
    enum WeightType {
        HarvestBaseIberaVault,
        CollectBribesIberaVault
    }

    /// @notice Fee type enum for determining rates to charge on reward distribution.
    enum FeeType {
        HarvestBaseFeeRate,
        HarvestBaseProtocolRate,
        HarvestVaultFeeRate,
        HarvestVaultProtocolRate,
        HarvestBribesFeeRate,
        HarvestBribesProtocolRate,
        HarvestBoostFeeRate,
        HarvestBoostProtocolRate
    }
}
