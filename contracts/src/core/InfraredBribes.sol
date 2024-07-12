// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

import {InfraredUpgradeable} from "@core/InfraredUpgradeable.sol";

import {IInfrared} from "@interfaces/IInfrared.sol";
import {IBribeCollector} from "@interfaces/IBribeCollector.sol";
import {IInfraredBribes} from "@interfaces/IInfraredBribes.sol";
import {Errors} from "@utils/Errors.sol";

/// @title InfraredBribes
/// @notice A contract for distributing bribes in a single ERC20 token to validators
/// @dev Must be initialized after bribe collector initialization
contract InfraredBribes is InfraredUpgradeable, IInfraredBribes {
    using SafeERC20 for IERC20;

    // infrared coordinator contract
    IInfrared public infrared;

    // bribe collector contract
    IBribeCollector public collector;

    // token for bribe payouts
    IERC20 public token;

    // cumulative bribe amount of token per validator
    uint256 public amountsCumulative;

    struct Bribe {
        uint256 amountCumulativeLast;
        uint256 amountCumulativeFinal;
    }

    // validator claimed bribe status
    mapping(address validator => Bribe) public bribes;

    modifier onlyInfrared() {
        if (msg.sender != address(infrared)) revert Errors.NotInfrared();
        _;
    }

    constructor() InfraredUpgradeable() {}

    function initialize(address _admin, address _infrared, address _collector)
        external
        initializer
    {
        if (
            _admin == address(0) || _infrared == address(0)
                || _collector == address(0)
        ) revert Errors.ZeroAddress();

        // grand admin access roles
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(KEEPER_ROLE, _admin);
        _grantRole(GOVERNANCE_ROLE, _admin);

        infrared = IInfrared(_infrared);
        collector = IBribeCollector(_collector);
        token = IERC20(collector.payoutToken());

        // claim amounts calculated via differences so absolute amount not relevant
        amountsCumulative++;
    }

    /// @inheritdoc IInfraredBribes
    function add(address validator) external onlyInfrared {
        Bribe storage b = bribes[validator];
        uint256 _amountsCumulative = amountsCumulative;

        b.amountCumulativeLast = _amountsCumulative;
        b.amountCumulativeFinal = 0;

        emit Added(validator, _amountsCumulative);
    }

    /// @inheritdoc IInfraredBribes
    function remove(address validator) external onlyInfrared {
        uint256 _amountsCumulative = amountsCumulative;
        if (_amountsCumulative == 0) revert Errors.ZeroAmount();

        Bribe storage b = bribes[validator];
        b.amountCumulativeFinal = _amountsCumulative;

        emit Removed(validator, _amountsCumulative);
    }

    /// @inheritdoc IInfraredBribes
    function notifyRewardAmount(uint256 amount) external {
        if (amount == 0) revert Errors.ZeroAmount();

        uint256 num = infrared.numInfraredValidators();
        if (num == 0) revert Errors.InvalidValidator();

        unchecked {
            amountsCumulative += amount / num;
        }
        token.safeTransferFrom(msg.sender, address(this), amount);

        emit Notified(amount, num);
    }

    /// @inheritdoc IInfraredBribes
    function claim(address recipient) external {
        Bribe memory b = bribes[msg.sender];
        if (b.amountCumulativeLast == 0) revert Errors.InvalidValidator();

        uint256 fin = b.amountCumulativeFinal == 0
            ? amountsCumulative
            : b.amountCumulativeFinal;
        uint256 amount;
        unchecked {
            amount = fin - b.amountCumulativeLast;
        }

        b.amountCumulativeLast = fin;
        bribes[msg.sender] = b;

        if (amount > 0) token.safeTransfer(recipient, amount);
        emit Claimed(recipient, amount);
    }
}
