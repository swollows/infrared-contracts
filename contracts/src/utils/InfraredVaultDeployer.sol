// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {InfraredVault} from "@core/immutable/InfraredVault.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

library InfraredVaultDeployer {
    /**
     * @notice Deploys a new `InfraredVault` contract.
     * @param _asset                    address The address of the asset, e.g. Honey:Bera LP token.
     * @param _name                     string    memory The name of the vault.
     * @param _symbol                   string    memory The symbol of the vault.
     * @param _rewardTokens             address[] memory The reward tokens.
     * @param _infrared                 address          The address of the Infrared contract.
     * @param _poolAddress              address          The address of the pool.
     * @param upgradableRewardsHandler  address          The address of the upgradable Berachain handler.
     * @param _admin                    address          The address of the admin.
     * @return _new                     address          The address of the new `InfraredVault` contract.
     */
    function deploy(
        address _asset,
        string memory _name,
        string memory _symbol,
        address[] memory _rewardTokens,
        address _infrared,
        address _poolAddress,
        address upgradableRewardsHandler,
        address _admin
    ) public returns (address _new) {
        return address(
            new InfraredVault(
                _asset,
                _name,
                _symbol,
                _rewardTokens,
                _infrared,
                _poolAddress,
                upgradableRewardsHandler,
                _admin
            )
        );
    }
}
