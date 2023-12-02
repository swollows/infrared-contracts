// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {InfraredVault} from "@core/InfraredVault.sol";

// library to deploy InfraredVault.sol
library InfraredVaultDeployer {
    function deployInfraredVault(
        address _asset,
        string memory _name,
        string memory _symbol,
        address[] memory _rewardTokens,
        address _infrared,
        address _poolAddress,
        address _rewardsPrecompile,
        address _distributionPrecompile,
        address _admin
    ) public returns (address) {
        return address(
            new InfraredVault(
                _asset,
                _name,
                _symbol,
                _rewardTokens,
                _infrared,
                _poolAddress,
                _rewardsPrecompile,
                _distributionPrecompile,
                _admin
            )
        );
    }
}
