// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {
    ERC1967Utils,
    UUPSUpgradeable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {AccessControlUpgradeable} from
    "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ERC20Upgradeable} from
    "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

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
contract IBERA is
    ERC20Upgradeable,
    AccessControlUpgradeable,
    UUPSUpgradeable,
    IIBERA
{
    /// @inheritdoc IIBERA
    bool public withdrawalsEnabled;

    // Access control constants
    bytes32 public constant KEEPER_ROLE = keccak256("KEEPER_ROLE");
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");

    /// @inheritdoc IIBERA
    address public infrared;
    /// @inheritdoc IIBERA
    address public depositor;
    /// @inheritdoc IIBERA
    address public withdrawor;
    /// @inheritdoc IIBERA
    address public claimor;
    /// @inheritdoc IIBERA
    address public receivor;

    /// @inheritdoc IIBERA
    uint256 public deposits;

    mapping(bytes32 pubkeyHash => uint256 stake) internal _stakes;

    mapping(bytes32 pubkeyHash => bool isStaked) internal _staked;

    mapping(bytes32 pubkeyHash => bytes) internal _signatures;

    /// @inheritdoc IIBERA
    uint16 public feeShareholders;

    /// @notice Whether initial mint to address(this) has happened
    bool private _initialized;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers(); // Ensure the contract cannot be initialized through the logic contract
    }

    /// @inheritdoc IIBERA
    function initialize(
        address admin,
        address _infrared,
        address _depositor,
        address _withdrawor,
        address _claimor,
        address _receivor
    ) external payable initializer {
        if (
            admin == address(0) || _infrared == address(0)
                || _depositor == address(0) || _withdrawor == address(0)
                || _claimor == address(0) || _receivor == address(0)
        ) revert ZeroAddress();
        __ERC20_init("Infrared BERA", "iBERA");
        __AccessControl_init();
        __UUPSUpgradeable_init();

        infrared = _infrared;
        depositor = _depositor;
        withdrawor = _withdrawor;
        claimor = _claimor;
        receivor = _receivor;
        _grantRole(DEFAULT_ADMIN_ROLE, admin);

        // burn minimum amount to mitigate inflation attack with shares
        _initialized = true;
        mint(address(this));
    }

    function setWithdrawalsEnabled(bool flag) external {
        if (!governor(msg.sender)) revert Unauthorized();
        withdrawalsEnabled = flag;
        emit WithdrawalFlagSet(flag);
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
        if (!withdrawalsEnabled) revert WithdrawalsNotEnabled();
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
        uint256 stake = _stakes[keccak256(pubkey)];
        if (delta > 0) stake += uint256(delta);
        else stake -= uint256(-delta);
        _stakes[keccak256(pubkey)] = stake;
        // update whether have staked to validator before
        if (delta > 0 && !_staked[keccak256(pubkey)]) {
            _staked[keccak256(pubkey)] = true;
        }

        emit Register(pubkey, delta, stake);
    }

    /// @inheritdoc IIBERA
    function setFeeShareholders(uint16 to) external {
        if (!governor(msg.sender)) revert Unauthorized();
        emit SetFeeShareholders(feeShareholders, to);
        feeShareholders = to;
    }

    /// @inheritdoc IIBERA
    function setDepositSignature(
        bytes calldata pubkey,
        bytes calldata signature
    ) external {
        if (!governor(msg.sender)) revert Unauthorized();
        if (signature.length != 96) revert InvalidSignature();
        emit SetDepositSignature(
            pubkey, _signatures[keccak256(pubkey)], signature
        );
        _signatures[keccak256(pubkey)] = signature;
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(DEFAULT_ADMIN_ROLE)
    {}

    function setDepositor(address _depositor)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_depositor == address(0)) revert ZeroAddress();
        depositor = _depositor;
    }

    function setWithdrawor(address _withdrawor)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_withdrawor == address(0)) revert ZeroAddress();
        withdrawor = _withdrawor;
    }

    function setClaimor(address _claimor) public onlyRole(DEFAULT_ADMIN_ROLE) {
        if (_claimor == address(0)) revert ZeroAddress();
        claimor = _claimor;
    }

    function setReceivor(address _receivor)
        public
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_receivor == address(0)) revert ZeroAddress();
        receivor = _receivor;
    }

    function implementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }

    /// @inheritdoc IIBERA
    function collect() external returns (uint256 sharesMinted) {
        if (msg.sender != address(infrared)) revert Unauthorized();
        sharesMinted = IIBERAFeeReceivor(receivor).collect();
    }

    /// @inheritdoc IIBERA
    function previewMint(uint256 beraAmount)
        public
        view
        returns (uint256 shares, uint256 fee)
    {
        if (!_initialized) {
            return (0, 0);
        }

        // First simulate compound effects like in actual mint
        (uint256 compoundAmount,) = IIBERAFeeReceivor(receivor).distribution();

        // Calculate fee
        fee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
        uint256 min = IBERAConstants.MINIMUM_DEPOSIT;

        if (beraAmount < min + fee) {
            return (0, fee);
        }

        // Calculate shares considering both:
        // 1. The compound effect (compoundAmount - fee)
        // 2. The new deposit (beraAmount - fee)
        uint256 ts = totalSupply();
        uint256 depositsAfterCompound = deposits;

        // First simulate compound effect on deposits
        if (compoundAmount > 0) {
            uint256 compoundFee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
            if (compoundAmount > compoundFee) {
                depositsAfterCompound += (compoundAmount - compoundFee);
            }
        }

        // Then calculate shares based on user deposit
        uint256 amount = beraAmount - fee;
        if (depositsAfterCompound == 0 || ts == 0) {
            shares = amount;
        } else {
            shares = Math.mulDiv(ts, amount, depositsAfterCompound);
        }

        if (shares == 0) {
            return (0, fee);
        }
    }

    /// @inheritdoc IIBERA
    function previewBurn(uint256 shareAmount)
        public
        view
        returns (uint256 beraAmount, uint256 fee)
    {
        if (!_initialized || shareAmount == 0) {
            return (0, IBERAConstants.MINIMUM_WITHDRAW_FEE);
        }

        // First simulate compound effects like in actual burn
        (uint256 compoundAmount,) = IIBERAFeeReceivor(receivor).distribution();

        uint256 ts = totalSupply();
        if (ts == 0) {
            return (0, IBERAConstants.MINIMUM_WITHDRAW_FEE);
        }

        // Calculate amount considering compound effect
        uint256 depositsAfterCompound = deposits;

        if (compoundAmount > 0) {
            uint256 compoundFee = IBERAConstants.MINIMUM_DEPOSIT_FEE;
            if (compoundAmount > compoundFee) {
                depositsAfterCompound += (compoundAmount - compoundFee);
            }
        }

        beraAmount = Math.mulDiv(depositsAfterCompound, shareAmount, ts);
        fee = IBERAConstants.MINIMUM_WITHDRAW_FEE;

        if (beraAmount == 0) {
            return (0, fee);
        }
    }

    /// @inheritdoc IIBERA
    function stakes(bytes calldata pubkey) external view returns (uint256) {
        return _stakes[keccak256(pubkey)];
    }

    /// @inheritdoc IIBERA
    function staked(bytes calldata pubkey) external view returns (bool) {
        return _staked[keccak256(pubkey)];
    }

    /// @inheritdoc IIBERA
    function signatures(bytes calldata pubkey)
        external
        view
        returns (bytes memory)
    {
        return _signatures[keccak256(pubkey)];
    }
}
