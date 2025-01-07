// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC20} from "@solmate/tokens/ERC20.sol";
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

import {InfraredUpgradeable} from "src/core/InfraredUpgradeable.sol";
import {Errors} from "src/utils/Errors.sol";

import {IBribeCollector} from "src/interfaces/IBribeCollector.sol";

/**
 * @title BribeCollector
 * @notice The Bribe Collector contract is responsible for collecting bribes from Berachain rewards vaults and
 * auctioning them for a Payout token which then is distributed among Infrared validators.
 * @dev This contract is forked from Berachain POL which is forked from Uniswap V3 Factory Owner contract.
 * https://github.com/uniswapfoundation/UniStaker/blob/main/src/V3FactoryOwner.sol
 */
contract BribeCollector is InfraredUpgradeable, IBribeCollector {
    using SafeTransferLib for ERC20;

    /// @inheritdoc IBribeCollector
    address public payoutToken;

    /// @inheritdoc IBribeCollector
    uint256 public payoutAmount;

    constructor(address _infrared) InfraredUpgradeable(_infrared) {
        if (_infrared == address(0)) revert Errors.ZeroAddress();
    }

    function initialize(
        address _gov,
        address _payoutToken,
        uint256 _payoutAmount
    ) external initializer {
        if (_gov == address(0) || _payoutToken == address(0)) {
            revert Errors.ZeroAddress();
        }
        if (_payoutAmount == 0) revert Errors.ZeroAmount();

        payoutToken = _payoutToken;
        payoutAmount = _payoutAmount;
        emit PayoutAmountSet(0, _payoutAmount);

        // grant admin access roles
        _grantRole(DEFAULT_ADMIN_ROLE, _gov);
        _grantRole(GOVERNANCE_ROLE, _gov);

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
    function claimFees(
        address _recipient,
        address[] calldata _feeTokens,
        uint256[] calldata _feeAmounts
    ) external {
        if (_feeTokens.length != _feeAmounts.length) {
            revert Errors.InvalidArrayLength();
        }
        if (_recipient == address(0)) revert Errors.ZeroAddress();
        // transfer price of claiming tokens (payoutAmount) from the sender to this contract
        ERC20(payoutToken).safeTransferFrom(
            msg.sender, address(this), payoutAmount
        );
        // increase the allowance of the payout token to the infrared contract to be send to
        // validator distribution contract
        ERC20(payoutToken).safeApprove(address(infrared), payoutAmount);
        // Callback into infrared post auction to split amount to vaults and protocol
        infrared.collectBribes(payoutToken, payoutAmount);
        // payoutAmount will be transferred out at this point

        // From all the specified fee tokens, transfer them to the recipient.
        for (uint256 i = 0; i < _feeTokens.length; i++) {
            address feeToken = _feeTokens[i];
            uint256 feeAmount = _feeAmounts[i];
            ERC20(feeToken).safeTransfer(_recipient, feeAmount);
            emit FeesClaimed(msg.sender, _recipient, feeToken, feeAmount);
        }
    }
}
