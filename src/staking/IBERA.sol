// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {AccessControl} from "@openzeppelin/access/AccessControl.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {Math} from "@openzeppelin/utils/math/Math.sol";

import {IInfrared} from "@interfaces/IInfrared.sol";
import {IIBERADepositor} from "@interfaces/IIBERADepositor.sol";
import {IIBERAWithdrawor} from "@interfaces/IIBERAWithdrawor.sol";
import {IIBERAFeeReceivor} from "@interfaces/IIBERAFeeReceivor.sol";
import {IIBERA} from "@interfaces/IIBERA.sol";

import {IBERAConstants} from "./IBERAConstants.sol";
import {IBERADepositor} from "./IBERADepositor.sol";
import {IBERAWithdrawor} from "./IBERAWithdrawor.sol";
import {IBERAClaimor} from "./IBERAClaimor.sol";
import {IBERAFeeReceivor} from "./IBERAFeeReceivor.sol";

/// @title IBERA
/// @author bungabear69420
/// @notice Infrared liquid staking token for BERA
/// @dev Assumes BERA balances do *not* change at the CL
contract IBERA is ERC20, AccessControl, IIBERA {
    // Access control constants
    bytes32 public constant KEEPER_ROLE = keccak256("KEEPER_ROLE");
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    /// @inheritdoc IIBERA
    address public immutable infrared;
    /// @inheritdoc IIBERA
    address public immutable depositor;
    /// @inheritdoc IIBERA
    address public immutable withdrawor;
    /// @inheritdoc IIBERA
    address public immutable claimor;
    /// @inheritdoc IIBERA
    address public immutable receivor;

    /// @inheritdoc IIBERA
    uint256 public deposits;

    /// @inheritdoc IIBERA
    mapping(bytes => uint256) public stakes;

    /// @inheritdoc IIBERA
    uint16 public feeProtocol;

    /// @notice Whether initial mint to address(this) has happened
    bool private _initialized;

    constructor(address _infrared) payable ERC20("Infrared BERA", "iBERA") {
        infrared = _infrared;
        depositor = address(new IBERADepositor());
        withdrawor = address(new IBERAWithdrawor()); // -or is more fun
        claimor = address(new IBERAClaimor());
        receivor = address(new IBERAFeeReceivor());
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function _deposit(uint256 value)
        private
        returns (uint256 nonce, uint256 amount, uint256 fee)
    {
        // @dev check at internal deposit level to prevent donations prior
        if (!_initialized) revert NotInitialized();

        // calculate amount as value less deposit fee
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;
        fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        if (value < min + fee) revert InvalidAmount();

        amount = value - fee;
        // update tracked deposits with validators
        deposits += amount;
        // escrow funds to depositor contract to eventually forward to precompile
        nonce = IIBERADepositor(depositor).queue{value: value}(amount);
    }

    function _withdraw(address receiver, uint256 amount, uint256 fee)
        private
        returns (uint256 nonce)
    {
        if (!_initialized) revert NotInitialized();

        // request to withdrawor contract to eventually forward to precompile
        nonce = IIBERAWithdrawor(withdrawor).queue{value: fee}(receiver, amount);
        // update tracked deposits with validators *after* queue given used by withdrawor via confirmed
        deposits -= amount;
    }

    /// @inheritdoc IIBERA
    function pending() public view returns (uint256) {
        return (
            IIBERADepositor(depositor).reserves()
                + IIBERAWithdrawor(withdrawor).rebalancing()
        );
    }

    /// @inheritdoc IIBERA
    function confirmed() external view returns (uint256) {
        return (deposits - pending());
    }

    /// @inheritdoc IIBERA
    function keeper(address account) public view returns (bool) {
        return hasRole(KEEPER_ROLE, account);
    }

    /// @inheritdoc IIBERA
    function governor(address account) public view returns (bool) {
        return hasRole(GOVERNANCE_ROLE, account);
    }

    /// @inheritdoc IIBERA
    function validator(bytes calldata pubkey) external view returns (bool) {
        return IInfrared(infrared).isInfraredValidator(pubkey);
    }

    /// @inheritdoc IIBERA
    function initialize() external payable {
        // burn minimum amount to mitigate inflation attack with shares
        _initialized = true;
        mint(address(this));
    }

    /// @inheritdoc IIBERA
    function compound() public {
        IIBERAFeeReceivor(receivor).sweep();
    }

    /// @inheritdoc IIBERA
    function sweep() external payable {
        _deposit(msg.value);
        emit Sweep(msg.value);
    }

    /// @inheritdoc IIBERA
    function mint(address receiver)
        public
        payable
        returns (uint256 nonce, uint256 shares)
    {
        // compound yield earned from EL rewards first
        compound();

        // cache prior since updated in _deposit call
        uint256 d = deposits;
        uint256 ts = totalSupply();

        // deposit bera request
        uint256 amount;
        uint256 fee;
        (nonce, amount, fee) = _deposit(msg.value);

        // mint shares to receiver of ibera
        shares = (d != 0 && ts != 0) ? Math.mulDiv(ts, amount, d) : amount;
        if (shares == 0) revert InvalidShares();
        _mint(receiver, shares);

        emit Mint(receiver, nonce, amount, shares, fee);
    }

    /// @inheritdoc IIBERA
    function burn(address receiver, uint256 shares)
        external
        payable
        returns (uint256 nonce, uint256 amount)
    {
        // compound yield earned from EL rewards first
        compound();

        uint256 ts = totalSupply();
        if (shares == 0 || ts == 0) revert InvalidShares();

        amount = Math.mulDiv(deposits, shares, ts);
        if (amount == 0) revert InvalidAmount();

        // burn shares from sender of ibera
        _burn(msg.sender, shares);

        // withdraw bera request
        // @dev pay withdraw precompile fee via funds sent in on payable call
        uint256 fee = msg.value;
        nonce = _withdraw(receiver, amount, fee);

        emit Burn(receiver, nonce, amount, shares, fee);
    }

    /// @inheritdoc IIBERA
    function register(bytes calldata pubkey, int256 delta) external {
        if (msg.sender != depositor && msg.sender != withdrawor) {
            revert Unauthorized();
        }
        // update validator pubkey stake for delta
        uint256 stake = stakes[pubkey];
        if (delta > 0) stake += uint256(delta);
        else stake -= uint256(-delta);
        stakes[pubkey] = stake;
        emit Register(pubkey, delta, stake);
    }

    /// @inheritdoc IIBERA
    function setFeeProtocol(uint16 to) external {
        if (!governor(msg.sender)) revert Unauthorized();
        emit SetFeeProtocol(feeProtocol, to);
        feeProtocol = to;
    }
}
