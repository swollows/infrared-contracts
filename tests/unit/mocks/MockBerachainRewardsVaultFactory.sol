// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {SafeERC20} from
    "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IRewardVaultFactory as IBerachainRewardsVaultFactory} from
    "@berachain/pol/interfaces/IRewardVaultFactory.sol";
import "@berachain/../test/mock/pol/MockRewardVault.sol";
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

    function createRewardVault(address stakingToken)
        external
        returns (address)
    {
        MockRewardVault vault = new MockRewardVault();

        allVaultsLength++;
        getVault[stakingToken] = address(vault);

        vault.initialize(address(bgt), stakingToken);
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
        // notify not yet in bera mock
        // MockRewardVault(beraVault).notifyRewardAmount(amount);
    }

    function initializeRewardsVault(address _stakingAsset) public {
        address beraVault = getVault[_stakingAsset];
        MockRewardVault(beraVault).initialize(address(bgt), _stakingAsset);
    }

    function mint(address receiver, uint256 amount) public {
        bgt.mint(receiver, amount);
    }

    // TODO: fix
    function predictRewardVaultAddress(address stakingToken)
        external
        view
        returns (address)
    {
        revert("not implemented");
    }
}
