// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {IIBERAClaimor} from "@interfaces/IIBERAClaimor.sol";

/// @title IBERAClaimor
/// @author bungabear69420
/// @notice Claimor to claim BERA withdrawn from CL for Infrared liquid staking token
/// @dev Separate contract so withdrawor process has trusted contract to forward funds to so no issue with naked bera transfer and receive function
contract IBERAClaimor is IIBERAClaimor {
    /// @inheritdoc IIBERAClaimor
    mapping(address => uint256) public claims;

    /// @inheritdoc IIBERAClaimor
    function queue(address receiver) external payable {
        uint256 claim = claims[receiver];
        claim += msg.value;
        claims[receiver] = claim;
        emit Queue(receiver, msg.value, claim);
    }

    /// @inheritdoc IIBERAClaimor
    function sweep(address receiver) external {
        uint256 amount = claims[receiver];
        delete claims[receiver];
        if (amount > 0) SafeTransferLib.safeTransferETH(receiver, amount);
        emit Sweep(receiver, amount, 0);
    }
}
