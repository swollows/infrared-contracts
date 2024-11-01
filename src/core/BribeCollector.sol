// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {InfraredUpgradeable} from "@core/InfraredUpgradeable.sol";
import {Errors} from "@utils/Errors.sol";

import {IBribeCollector} from "@interfaces/IBribeCollector.sol";
import {IInfrared} from "@interfaces/IInfrared.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

/**
 * @title BribeCollector
 * @notice The Bribe Collector contract is responsible for collecting bribes from Berachain rewards vaults and
 * auctioning them for a Payout token which then is distributed among Infrared validators.
 * @dev This contract is forked from Berachain POL which is forked from Uniswap V3 Factory Owner contract.
 * https://github.com/uniswapfoundation/UniStaker/blob/main/src/V3FactoryOwner.sol
 */
contract BribeCollector is InfraredUpgradeable, IBribeCollector {
    using SafeERC20 for IERC20;

    /// @inheritdoc IBribeCollector
    address public payoutToken;

    /// @inheritdoc IBribeCollector
    uint256 public payoutAmount;

    constructor(address _infrared) InfraredUpgradeable(_infrared) {
        if (_infrared == address(0)) revert Errors.ZeroAddress();
    }

    function initialize(
        address _admin,
        address _payoutToken,
        uint256 _payoutAmount
    ) external initializer {
        if (_admin == address(0) || _payoutToken == address(0)) {
            revert Errors.ZeroAddress();
        }
        if (_payoutAmount == 0) revert Errors.ZeroAmount();

        payoutToken = _payoutToken;
        payoutAmount = _payoutAmount;
        emit PayoutAmountSet(0, _payoutAmount);

        // init upgradeable components
        __InfraredUpgradeable_init();
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       ADMIN FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IBribeCollector
    function setPayoutAmount(uint256 _newPayoutAmount) external onlyGovernor {
        if (_newPayoutAmount == 0) revert Errors.ZeroAmount();
        emit PayoutAmountSet(payoutAmount, _newPayoutAmount);
        payoutAmount = _newPayoutAmount;
    }

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                       WRITE FUNCTIONS                      */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /// @inheritdoc IBribeCollector
    function claimFees(address _recipient, address[] calldata _feeTokens)
        external
    {
        IERC20(payoutToken).safeIncreaseAllowance(
            address(infrared), payoutAmount
        );

        // Callback into infrared post auction to split amount to vaults and protocol
        infrared.collectBribes(payoutToken, payoutAmount);

        // From all the specified fee tokens, transfer them to the recipient.
        for (uint256 i = 0; i < _feeTokens.length; i++) {
            address feeToken = _feeTokens[i];
            uint256 feeTokenAmountToTransfer =
                IERC20(feeToken).balanceOf(address(this));
            IERC20(feeToken).safeTransfer(_recipient, feeTokenAmountToTransfer);
            emit FeesClaimed(
                msg.sender, _recipient, feeToken, feeTokenAmountToTransfer
            );
        }
    }
}
