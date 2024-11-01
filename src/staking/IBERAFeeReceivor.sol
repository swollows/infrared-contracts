// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

import {IIBERA} from "@interfaces/IIBERA.sol";
import {IIBERAFeeReceivor} from "@interfaces/IIBERAFeeReceivor.sol";

import {IBERAConstants} from "./IBERAConstants.sol";

/// @title IBERAFeeReceivor
/// @author bungabear69420
/// @notice Fee receivor receives coinbase priority fees + MEV credited to contract on EL upon block validation
/// @dev CL validators should set fee_recipient to the address of this contract
contract IBERAFeeReceivor is IIBERAFeeReceivor {
    /// @inheritdoc IIBERAFeeReceivor
    address public immutable IBERA;

    /// @inheritdoc IIBERAFeeReceivor
    uint256 public protocolFees;

    constructor() {
        IBERA = msg.sender;
    }

    /// @inheritdoc IIBERAFeeReceivor
    function distribution()
        public
        view
        returns (uint256 amount, uint256 fees)
    {
        amount = (address(this).balance - protocolFees);
        uint16 feeProtocol = IIBERA(IBERA).feeProtocol();

        // take protocol fees
        if (feeProtocol > 0) {
            fees = amount / uint256(feeProtocol);
            amount -= fees;
        }
    }

    /// @inheritdoc IIBERAFeeReceivor
    function sweep() external returns (uint256 amount, uint256 fees) {
        (amount, fees) = distribution();
        // do nothing if IBERA deposit would revert
        uint256 min =
            IBERAConstants.MINIMUM_DEPOSIT + IBERAConstants.MINIMUM_DEPOSIT_FEE;
        if (amount < min) return (0, 0);

        // add to protocol fees and sweep amount back to ibera to deposit
        if (fees > 0) protocolFees += fees;
        if (amount > 0) IIBERA(IBERA).sweep{value: amount}();
        emit Sweep(IBERA, amount, fees);
    }

    /// @inheritdoc IIBERAFeeReceivor
    function collect(address receiver) external {
        if (!IIBERA(IBERA).governor(msg.sender)) revert Unauthorized();
        uint256 pf = protocolFees;
        if (pf == 0) revert InvalidAmount();

        uint256 amount = pf - 1; // gas savings on sweep
        protocolFees -= amount;
        if (amount > 0) SafeTransferLib.safeTransferETH(receiver, amount);
        emit Collect(receiver, amount);
    }

    receive() external payable {}
}
