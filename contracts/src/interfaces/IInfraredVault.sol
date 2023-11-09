// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Cosmos} from "@polaris/CosmosTypes.sol";

interface IInfraredVault {
    function rewardTokens()
        external
        view
        returns (address[] memory _rewardTokens);

    /**
     * @notice The address of the pool.
     * @return _poolAddress address The reward tokens.
     */
    function poolAddress() external view returns (address _poolAddress);

    /*//////////////////////////////////////////////////////////////
                             ADMIN
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Allows the admin of this contract to set a different withdraw
     * address for the rewards precompile.
     * @param _withdrawAddress address The new withdraw address.
     */
    function changeRewardsWithdrawAddress(address _withdrawAddress) external;

    /**
     * @dev Allows the admin of this contract to set a different withdraw
     * address for the distribution precompile.
     * @param _withdrawAddress address The new withdraw address.
     */
    function changeDistributionWithdrawAddress(address _withdrawAddress)
        external;

    /**
     * @dev Allows the admin of this contract to add reward tokens.
     * @param _rewardTokens address[] The reward tokens to add.
     */
    function addRewardTokens(address[] calldata _rewardTokens) external;

    /**
     * @dev The Infrared contract can claim the rewards in behalf of the vault.
     * @dev Since withdraw address set in constructor, it will be credited to
     * that address.
     * @return _rewards Cosmos.Coin[] The rewards.
     */
    function claimRewardsPrecompile()
        external
        returns (Cosmos.Coin[] memory _rewards);

    /*//////////////////////////////////////////////////////////////
                      EIP5XXX functions
    //////////////////////////////////////////////////////////////*/

    function supply(address supplier, address reward, uint256 amount)
        external;

    function supply(
        address supplier,
        address reward,
        uint96 partition,
        uint256 amount
    ) external;

    /*//////////////////////////////////////////////////////////////
                      ERC4626 functions
    //////////////////////////////////////////////////////////////*/

    function deposit(uint256 assets, address receiver)
        external
        returns (uint256 shares);

    function mint(uint256 shares, address receiver)
        external
        returns (uint256 assets);

    function withdraw(uint256 assets, address receiver, address owner)
        external
        returns (uint256 shares);

    function redeem(uint256 shares, address receiver, address owner)
        external
        returns (uint256 assets);

    function asset() external view returns (address asset);

    /*//////////////////////////////////////////////////////////////
                      EIP5XXX OVERRIDES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the current epoch per week for a reward token.
     * @return _rk  bytes32[]  The reward token to get the current epoch per
     * week for.
     */
    function rewardKeysOf(address)
        external
        view
        returns (bytes32[] memory _rk);

    /**
     * @notice Returns the total amount of assets held by the vault.
     * @return _assets uint256 The total amount of assets held by the vault.
     */
    function totalAssets() external view returns (uint256 _assets);

    /**
     * @notice Returns the total weight of a partition, in this vault it is the
     * total supply of the vault.
     * @return _tw uint256 The total weight of the partition.
     */
    function totalWeight(uint96) external view returns (uint256 _tw);

    /**
     * @notice Returns the weight of a user, in this vault it is the balance of
     * the users shares of the vault.
     * @param _user address The user to get the weight of.
     * @return _wo  uint256 The eight of the user in the partition.
     */
    function weightOf(address _user, uint96)
        external
        view
        returns (uint256 _wo);
}
