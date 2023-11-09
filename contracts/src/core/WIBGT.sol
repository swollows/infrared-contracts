// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {ERC20PresetMinterPauser} from "../vendors/ERC20PresetMinterPauser.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {Errors} from "@utils/Errors.sol";
import {ReentrancyGuard} from "@openzeppelin/utils/ReentrancyGuard.sol";
import {InfraredVault} from "./InfraredVault.sol";

/**
 * @title Wrapped IBGT (WIBGT)
 * @notice This contracts wrappper to the IBGT tokens since the IBGT vault might
 * get more IBGT, breaking 4626.
 * @notice The user will only deal with ibgt and the vault share token and never
 * the wrapped token.
 */
contract WrappedIBGT is ERC20PresetMinterPauser, ReentrancyGuard {
    using SafeERC20 for IERC20;

    // The IBGT token we are wrapping.
    IERC20 public immutable IBGT;

    // The WIBGT Vault.
    InfraredVault public wibgtVault;

    event Wrap(address indexed _from, address indexed _to, uint256 _amount);
    event Unwrap(address indexed _from, address indexed _to, uint256 _amount);

    /**
     * @notice Construct a new Wrapped IBGT contract.
     * @param _ibgt The IBGT token we are wrapping.
     */
    constructor(IERC20 _ibgt)
        ERC20PresetMinterPauser("Wrapped IBGT", "WIBGT")
    {
        if (address(_ibgt) == address(0)) {
            revert Errors.ZeroAddress();
        }

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        IBGT = _ibgt;
    }

    /*//////////////////////////////////////////////////////////////
                          Admin Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets the WIBGT Vault.
     * @param _vault The address of the WIBGT Vault.
     */
    function setVault(InfraredVault _vault)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (address(_vault) == address(0)) {
            revert Errors.ZeroAddress();
        }

        wibgtVault = _vault;
    }

    /**
     * @notice Approves the WIBGT Vault to transfer the WIBGT and vault share
     * tokens.
     */
    function approveVault() external onlyRole(DEFAULT_ADMIN_ROLE) {
        // Cache the Vault.
        InfraredVault _vault = wibgtVault;

        if (address(_vault) == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Approve the vault to transfer the WIBGT vault share tokens.
        bool _success = _vault.approve(address(_vault), type(uint256).max);
        if (!_success) {
            revert Errors.ApprovalFailed();
        }
        // Approve the vault to spend this contracts wrapped tokens.
        _approve(address(this), address(_vault), type(uint256).max);
    }

    /*//////////////////////////////////////////////////////////////
                      ERC4626 Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Wraps IBGT tokens to WIBGT tokens.
     * @param _assets   uint256 The amount of IBGT tokens to wrap and deposit.
     * @param _receiver address The address to receive the WIBGT vault tokens.
     */
    function deposit(uint256 _assets, address _receiver)
        external
        nonReentrant
        returns (uint256 _shares)
    {
        if (_assets == 0) {
            revert Errors.ZeroAmount();
        }

        if (_receiver == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Wrap the IBGT tokens to this contract.
        _wrap(msg.sender, _assets);

        // Deposit the wrapped IBGT tokens to the WIBGT Vault and set the
        // receiver.
        _shares = wibgtVault.deposit(_assets, _receiver);

        return _shares;
    }

    /**
     * @notice Wraps IBGT tokens to WIBGT tokens and then mints the vault tokens
     * to the receiver.
     * @param _shares   uint256 The amount of vault tokens to mint.
     * @param _receiver address The address to receive the vault tokens.
     */
    function mint(uint256 _shares, address _receiver)
        external
        nonReentrant
        returns (uint256 _assets)
    {
        if (_shares == 0) {
            revert Errors.ZeroAmount();
        }

        if (_receiver == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Cache the Vault.
        InfraredVault _vault = wibgtVault;

        // Preview the amount of WIBGT tokens that will be needed to mint
        // _shares.
        _assets = _vault.previewMint(_shares);

        // Wrap the IBGT tokens form the sender to this contract.
        _wrap(msg.sender, _assets);

        // Mint the vault tokens to the receiver.
        _vault.mint(_shares, _receiver);

        return _assets;
    }

    /**
     * @notice Withdraw vault tokens from the WIBGT Vault and then unwrap the
     * IBGT tokens to the receiver.
     * @notice User needs to have approved this contract the vault share tokens
     * that amount to `_assets`.
     * @param _assets   uint256 The amount of vault tokens to burn.
     * @param _receiver address The address to receive the IBGT tokens.
     * @param _owner    address The owner of the vault tokens.
     */
    function withdraw(uint256 _assets, address _receiver, address _owner)
        external
        nonReentrant
        returns (uint256 _shares)
    {
        if (_assets == 0) {
            revert Errors.ZeroAmount();
        }

        if (_receiver == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_owner == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Cache the Vault.
        InfraredVault _vault = wibgtVault;

        // The amount of shares for the `_assets`
        _shares = _vault.previewWithdraw(_assets);

        // Transfer the vault tokens from the owner to this contract.
        // solhint-disable-next-line custom-errors
        require(
            _vault.transferFrom(_owner, address(this), _shares),
            "WIBGT: transferFrom failed"
        );

        // Withdraw the vault tokens from the WIBGT Vault.
        _vault.withdraw(_shares, address(this), address(this));

        // Unwrap and transfer to the receiver.
        _unwrap(_receiver, _assets);

        return _shares;
    }

    /**
     * @notice Redeem vault tokens from the WIBGT Vault and then unwrap the IBGT
     * tokens to the receiver.
     * @notice User needs to have approved this contract the vault share tokens
     * that amount to `_shares`.
     * @param _shares   uint256 The amount of vault tokens to burn.
     * @param _receiver address The address to receive the IBGT tokens.
     * @param _owner    address The owner of the vault tokens.
     */
    function redeem(uint256 _shares, address _receiver, address _owner)
        external
        nonReentrant
        returns (uint256 _assets)
    {
        if (_shares == 0) {
            revert Errors.ZeroAmount();
        }

        if (_receiver == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_owner == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Cache the Vault.
        InfraredVault _vault = wibgtVault;

        // Transfer the vault share tokens to this contract.
        // solhint-disable-next-line custom-errors
        require(
            _vault.transferFrom(_owner, address(this), _shares),
            "WIBGT: transferFromFailed"
        );

        // Redeem the vault share tokens for the WIBGT tokens.
        _assets = _vault.redeem(_shares, address(this), address(this));

        // Unwrap and transfer to the receiver.
        _unwrap(_receiver, _assets);

        return _assets;
    }

    /*//////////////////////////////////////////////////////////////
                      Internal Functions
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Takes IBGT tokens from the user and mints WIBGT tokens to this
     * contract.
     * @param _from   address The address to deposit the IBGT tokens from.
     * @param _amount uint256 The amount of IBGT tokens to deposit.
     */
    function _wrap(address _from, uint256 _amount) internal {
        // Transfer the IBGT tokens from the user to this contract.
        IBGT.safeTransferFrom(_from, address(this), _amount);

        // Mint the WIBGT tokens to this contract.
        _mint(address(this), _amount);
    }

    function _unwrap(address _to, uint256 _amount) internal {
        // Burn the WIBGT tokens from this contract.
        _burn(address(this), _amount);

        // Transfer the IBGT tokens to the user.
        IBGT.safeTransfer(_to, _amount);
    }
}
