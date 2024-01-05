// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

interface IInfraredVault {
    /**
     * @notice Changes the withdraw address for the rewards module.
     * @dev    This function can only be called by the admin.
     * @dev    We only care about the rewards module since there is no BGT in this vault.
     * @param _withdrawAddress  address  The address to set as the withdraw address.
     */
    function changeWithdrawAddress(address _withdrawAddress) external;

    /**
     * @notice Claims all the rewards for this vault.
     * @dev    This function can only be called by the INFRARED.
     * @return _amt uint256 The amount of `abgt` that was claimed to the withdraw address.
     */
    function claimRewardsPrecompile() external returns (uint256 _amt);

    /**
     * @notice Supply rewards to distributor to depositors
     *     @param supplier The address where the incoming tokens are coming from
     *     @param reward The asset being supplied
     *     @param amount The amount of said asset
     */
    function supply(address supplier, address reward, uint256 amount)
        external;
}
