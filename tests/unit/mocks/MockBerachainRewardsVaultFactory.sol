// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IBerachainRewardsVaultFactory} from
    "@berachain/pol/interfaces/IBerachainRewardsVaultFactory.sol";
import "./MockBerachainRewardsVault.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import "./MockERC20.sol";

/// @dev For testing InfraredVault.sol and Infrared.sol
contract MockBerachainRewardsVaultFactory is IBerachainRewardsVaultFactory {
    using SafeERC20 for MockERC20;

    bytes32 public constant VAULT_MANAGER_ROLE = keccak256("VAULT_MANAGER_ROLE");

    MockERC20 public immutable bgt;
    mapping(address => address) public getVault;
    uint256 public allVaultsLength;

    constructor(address _bgt) {
        bgt = MockERC20(_bgt);
    }

    function createRewardsVault(address stakingToken)
        external
        returns (address)
    {
        MockBerachainRewardsVault vault =
            new MockBerachainRewardsVault(stakingToken);

        allVaultsLength++;
        getVault[stakingToken] = address(vault);

        vault.initialize(address(bgt), address(this), 1 days);
        return address(vault);
    }

    function increaseRewardsForVault(address stakingAsset, uint256 amount)
        public
        returns (address beraVault)
    {
        mint(address(this), amount);
        // Increase rewards for a BerachainRewardsVault
        beraVault = getVault[stakingAsset];
        SafeERC20.safeIncreaseAllowance(IERC20(address(bgt)), beraVault, amount);
        MockBerachainRewardsVault(beraVault).notifyRewardAmount(amount);
    }

    function initializeRewardsVault(address _stakingAsset) public {
        address beraVault = getVault[_stakingAsset];
        MockBerachainRewardsVault(beraVault).initialize(
            address(bgt), address(this), 1 days
        );
    }

    function mint(address receiver, uint256 amount) public {
        bgt.mint(receiver, amount);
    }

    // TODO: fix
    function predictRewardsVaultAddress(address stakingToken)
        external
        view
        returns (address)
    {
        revert("not implemented");
    }
}
