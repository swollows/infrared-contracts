// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Errors} from "@utils/Errors.sol";
import {IERC20DexModule} from "@berachain/ERC20Dex.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

contract DexZapper {
    using SafeERC20 for IERC20;

    IERC20DexModule public immutable ERC20DEXMODULE;

    constructor(address _dexModuleAddrss) {
        if (_dexModuleAddrss == address(0)) {
            revert Errors.ZeroAddress();
        }

        ERC20DEXMODULE = IERC20DexModule(_dexModuleAddrss);
    }

    function zap(
        address pool,
        address receiver,
        address[] memory assetsIn,
        uint256[] memory amountsIn,
        address[] memory infraredVaults
    ) public {
        // not sure if this is already checked in the ERC20DexModule.sol
        // contract
        if (pool == address(0)) {
            revert Errors.ZeroAddress();
        }
        if (receiver == address(0)) {
            revert Errors.ZeroAddress();
        }
        if (assetsIn.length != amountsIn.length) {
            revert Errors.IncorrectArrayLength();
        }
        if (assetsIn.length == 0) {
            revert Errors.EmptyArray();
        }
        if (infraredVaults.length == 0) {
            revert Errors.EmptyArray();
        }

        for (uint256 i = 0; i < assetsIn.length; i++) {
            IERC20 token = IERC20(assetsIn[i]);
            // assuming amounts order matches assets order
            token.safeTransferFrom(msg.sender, address(this), amountsIn[i]);
            token.safeIncreaseAllowance(pool, amountsIn[i]);
        }
        (address[] memory lpTokens, uint256[] memory sharesAmounts,,) =
            ERC20DEXMODULE.addLiquidity(pool, address(this), assetsIn, amountsIn);

        uint256 successfulDeposits;

        // deposit the LP tokens into the vault
        // make sure to iterate through the vaults and deposit the correct LP
        // tokens
        for (uint256 i = 0; i < infraredVaults.length; i++) {
            for (uint256 j = 0; j < lpTokens.length; j++) {
                if (IInfraredVault(infraredVaults[i]).asset() == lpTokens[j]) {
                    IERC20(lpTokens[j]).safeIncreaseAllowance(infraredVaults[i], sharesAmounts[j]);
                    IInfraredVault(infraredVaults[i]).deposit(sharesAmounts[j], receiver);
                    successfulDeposits++;
                }
            }
        }
        if (successfulDeposits < infraredVaults.length) {
            revert Errors.IncorrectInfraredVaultArray();
        }
    }
}
