// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {EnumerableSet} from "@openzeppelin/utils/structs/EnumerableSet.sol";
import {IBerachainRewardsVaultFactory} from
    "@berachain/interfaces/IBerachainRewardsVaultFactory.sol";
import {IIBGT} from "@interfaces/IIBGT.sol";

/// @dev For testing InfraredVault.sol
contract MockInfrared {
    using EnumerableSet for EnumerableSet.AddressSet;

    IIBGT public immutable ibgt;
    IBerachainRewardsVaultFactory public immutable rewardsFactory;

    EnumerableSet.AddressSet internal _infraredValidators;

    event VaultHarvested(address vault);

    constructor(address _ibgt, address _rewardsFactory) {
        ibgt = IIBGT(_ibgt);
        rewardsFactory = IBerachainRewardsVaultFactory(_rewardsFactory);
    }

    function harvestVault(address vault) external {
        emit VaultHarvested(vault);
    }

    function addValidator(address validator) external {
        _infraredValidators.add(validator);
    }

    function removeValidator(address validator) external {
        _infraredValidators.remove(validator);
    }

    function numInfraredValidators() external view returns (uint256) {
        return _infraredValidators.length();
    }
}
