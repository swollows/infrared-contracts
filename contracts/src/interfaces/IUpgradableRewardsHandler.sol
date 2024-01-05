// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {DataTypes} from "@utils/DataTypes.sol";
import {Cosmos} from "@polaris/CosmosTypes.sol";

interface IUpgradableRewardsHandler {
    function REWARDS_PRECOMPILE() external view returns (address);

    function DISTRIBUTION_PRECOMPILE() external view returns (address);

    /**
     * @notice Sets the withdraw address for the rewards/distribution module.
     * @param _contract        DataTypes.RewardContract The contract to set the withdraw address for.
     * @param _withdrawAddress address                  The address to set as the withdraw address.
     * @return _success        bool                     Whether the call was successful or not.
     */
    function setWithdrawAddress(
        DataTypes.RewardContract _contract,
        address _withdrawAddress,
        address _storageAddress
    ) external returns (bool _success);

    /**
     * @notice Returns the withdraw address for the rewards.
     * @param  _depositor       address The depositor address.
     * @return _withdrawAddress address The withdraw address.
     */
    function getWithdrawAddress(address _depositor, address _storageAddress)
        external
        view
        returns (address _withdrawAddress);

    /**
     * @notice Redeems rewards from the rewards module, which will be in the form of abgt.
     * @param _storageAddress address The address of the storage contract.
     * @return _bgtAmt uint256 The amount of bgt that was redeemed.
     */
    function claimRewardsPrecompile(address _storageAddress)
        external
        returns (uint256 _bgtAmt);

    /**
     * @notice Redeems rewards from the distribution module, and returns the tokens that were redeemed.
     * @dev    The tokens that are returned have been swapped from sdk.Coins to DataTypes.Token, expecpt for bgt.
     * @return _tokens DataTypes.Token[] memory The list of tokens that were redeemed to the msg.sender (the delegate caller)
     * @return _bgtAmt uint256                  The amount of bgt that was redeemed.
     */
    function claimDistrPrecompile(address _validator, address _storageAddress)
        external
        returns (DataTypes.Token[] memory _tokens, uint256 _bgtAmt);
}
