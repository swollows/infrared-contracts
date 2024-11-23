// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EnumerableSet} from
    "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";
import {Errors} from "@utils/Errors.sol";
import {InfraredVaultDeployer} from "@utils/InfraredVaultDeployer.sol";

library VaultManagerLib {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct VaultStorage {
        bool pausedVaultRegistration;
        mapping(address => IInfraredVault) vaultRegistry; // Maps asset to its vault
        EnumerableSet.AddressSet whitelistedRewardTokens; // Set of whitelisted reward tokens
        uint256 rewardsDuration; // Default duration for rewards
    }

    /**
     * @dev Ensures that new vaults can only be registered while the register vaults are not paused
     * Reverts if the caller is not the collector
     */
    modifier notPaused(VaultStorage storage $) {
        if ($.pausedVaultRegistration) {
            revert Errors.RegistrationPaused();
        }
        _;
    }

    /// @notice Registers a new vault for a specific asset with specified reward tokens.
    function registerVault(VaultStorage storage $, address asset)
        public
        notPaused($)
        returns (address)
    {
        if (asset == address(0)) revert Errors.ZeroAddress();

        // Check for duplicate staking asset address
        if (address($.vaultRegistry[asset]) != address(0)) {
            revert Errors.DuplicateAssetAddress();
        }

        address newVault =
            InfraredVaultDeployer.deploy(asset, $.rewardsDuration);
        $.vaultRegistry[asset] = IInfraredVault(newVault);
        return newVault;
    }

    /**
     * @notice Sets new vault registration paused or not
     * @param pause True to pause, False to un pause
     */
    function setVaultRegistrationPauseStatus(VaultStorage storage $, bool pause)
        internal
    {
        $.pausedVaultRegistration = pause;
    }

    /// @notice Toggles the pause status of a specific vault.
    function pauseVault(VaultStorage storage $, address asset) internal {
        IInfraredVault vault = $.vaultRegistry[asset];
        if (address(vault) == address(0)) revert Errors.NoRewardsVault();

        vault.togglePause();
    }

    /// @notice Updates the whitelist status of a reward token.
    function updateWhitelistedRewardTokens(
        VaultStorage storage $,
        address token,
        bool whitelisted
    ) internal {
        if (whitelisted) {
            $.whitelistedRewardTokens.add(token);
        } else {
            $.whitelistedRewardTokens.remove(token);
        }
    }

    function addReward(
        VaultStorage storage $,
        address _stakingToken,
        address _rewardsToken,
        uint256 _rewardsDuration
    ) internal {
        IInfraredVault vault = $.vaultRegistry[_stakingToken];
        vault.addReward(_rewardsToken, _rewardsDuration);
    }

    /// @notice Updates the rewards duration for vaults.
    function updateRewardsDuration(VaultStorage storage $, uint256 newDuration)
        internal
    {
        if (newDuration == 0) revert Errors.ZeroAmount();
        $.rewardsDuration = newDuration;
    }

    /// @notice Checks if a token is whitelisted as a reward token.
    function isWhitelisted(VaultStorage storage $, address token)
        public
        view
        returns (bool)
    {
        return $.whitelistedRewardTokens.contains(token);
    }
}
