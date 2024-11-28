// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {SafeERC20} from
    "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IBeaconDeposit as IBerachainBeaconDeposit} from
    "@berachain/pol/interfaces/IBeaconDeposit.sol";

import {InfraredUpgradeable} from "@core/InfraredUpgradeable.sol";

import {IInfrared} from "@interfaces/IInfrared.sol";
import {IInfraredDistributor} from "@interfaces/IInfraredDistributor.sol";
import {Errors} from "@utils/Errors.sol";

/// @title InfraredDistributor
/// @notice A contract for distributing rewards in a single ERC20 token (iBERA) to validators
contract InfraredDistributor is InfraredUpgradeable, IInfraredDistributor {
    using SafeERC20 for IERC20;

    /// @inheritdoc IInfraredDistributor
    IERC20 public token;

    /// @inheritdoc IInfraredDistributor
    uint256 public amountsCumulative;

    mapping(bytes32 pubkeyHash => Snapshot) internal _snapshots;

    mapping(bytes32 pubkeyHash => address) internal _validators;

    constructor(address _infrared) InfraredUpgradeable(_infrared) {
        if (_infrared == address(0)) revert Errors.ZeroAddress();
    }

    function initialize(address _token) external initializer {
        token = IERC20(_token);

        // claim amounts calculated via differences so absolute amount not relevant
        amountsCumulative++;

        // init upgradeable components
        __InfraredUpgradeable_init();
    }

    /// @inheritdoc IInfraredDistributor
    function add(bytes calldata pubkey, address validator)
        external
        onlyInfrared
    {
        if (_validators[keccak256(pubkey)] != address(0)) {
            revert Errors.ValidatorAlreadyExists();
        }
        _validators[keccak256(pubkey)] = validator;

        Snapshot storage s = _snapshots[keccak256(pubkey)];
        uint256 _amountsCumulative = amountsCumulative;

        s.amountCumulativeLast = _amountsCumulative;
        s.amountCumulativeFinal = 0;

        emit Added(pubkey, validator, _amountsCumulative);
    }

    /// @inheritdoc IInfraredDistributor
    function remove(bytes calldata pubkey) external onlyInfrared {
        address validator = _validators[keccak256(pubkey)];
        if (validator == address(0)) revert Errors.ValidatorDoesNotExist();

        uint256 _amountsCumulative = amountsCumulative;
        if (_amountsCumulative == 0) revert Errors.ZeroAmount();

        Snapshot storage s = _snapshots[keccak256(pubkey)];
        s.amountCumulativeFinal = _amountsCumulative;

        emit Removed(pubkey, validator, _amountsCumulative);
    }

    /// @inheritdoc IInfraredDistributor
    function purge(bytes calldata pubkey) external {
        address validator = _validators[keccak256(pubkey)];
        if (validator == address(0)) revert Errors.ValidatorDoesNotExist();

        Snapshot memory s = _snapshots[keccak256(pubkey)];
        if (s.amountCumulativeLast == 0) revert Errors.ZeroAmount();
        if (s.amountCumulativeLast != s.amountCumulativeFinal) {
            revert Errors.ClaimableRewardsExist();
        }

        delete _snapshots[keccak256(pubkey)];
        delete _validators[keccak256(pubkey)];

        emit Purged(pubkey, validator);
    }

    /// @inheritdoc IInfraredDistributor
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

    /// @inheritdoc IInfraredDistributor
    function claim(bytes calldata pubkey, address recipient) external {
        address validator = _validators[keccak256(pubkey)];
        if (validator != msg.sender) revert Errors.InvalidValidator();

        Snapshot memory s = _snapshots[keccak256(pubkey)];
        if (s.amountCumulativeLast == 0) revert Errors.ZeroAmount();

        uint256 fin = s.amountCumulativeFinal == 0
            ? amountsCumulative
            : s.amountCumulativeFinal;
        uint256 amount;
        unchecked {
            amount = fin - s.amountCumulativeLast;
        }

        s.amountCumulativeLast = fin;
        _snapshots[keccak256(pubkey)] = s;

        if (amount > 0) token.safeTransfer(recipient, amount);
        emit Claimed(pubkey, validator, recipient, amount);
    }

    /// @inheritdoc IInfraredDistributor
    function snapshots(bytes calldata pubkey)
        external
        view
        returns (uint256 amountCumulativeLast, uint256 amountCumulativeFinal)
    {
        Snapshot memory s = _snapshots[keccak256(pubkey)];
        return (s.amountCumulativeLast, s.amountCumulativeFinal);
    }

    /// @inheritdoc IInfraredDistributor
    function validators(bytes calldata pubkey)
        external
        view
        returns (address)
    {
        return _validators[keccak256(pubkey)];
    }
}
