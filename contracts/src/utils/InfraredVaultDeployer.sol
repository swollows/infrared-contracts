// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {InfraredVault} from "@core/InfraredVault.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

library InfraredVaultDeployer {
    /**
     * @notice Deploys a new `InfraredVault` contract.
     * @param _admin address The address of the admin.
     * @param _stakingToken address The address of the staking token.
     * @param _infrared address The address of the INFRARED.
     * @param _pool address The address of the pool.
     * @param _rewardsModule address The address of the rewards module.
     * @param _distributionModule address The address of the distribution module.
     * @return _new address The address of the new `InfraredVault` contract.
     */
    function deploy(
        address _admin,
        address _stakingToken,
        address _infrared,
        address _pool,
        address _rewardsModule,
        address _distributionModule,
        address[] memory _rewardTokens,
        uint256 _rewardsDuration
    ) public returns (address _new) {
        return address(
            new InfraredVault(
                _admin,
                _stakingToken,
                _infrared,
                _pool,
                _rewardsModule,
                _distributionModule,
                _rewardTokens,
                _rewardsDuration
            )
        );
    }
}
