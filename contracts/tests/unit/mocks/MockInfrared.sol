// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {IBerachainRewardsVaultFactory} from
    "@berachain/interfaces/IBerachainRewardsVaultFactory.sol";
import {IIBGT} from "@interfaces/IIBGT.sol";

/// @dev For testing InfraredVault.sol
contract MockInfrared {
    IIBGT public immutable ibgt;
    IBerachainRewardsVaultFactory public immutable rewardsFactory;

    event VaultHarvested(address vault);

    constructor(address _ibgt, address _rewardsFactory) {
        ibgt = IIBGT(_ibgt);
        rewardsFactory = IBerachainRewardsVaultFactory(_rewardsFactory);
    }

    function harvestVault(address vault) external {
        emit VaultHarvested(vault);
    }
}
