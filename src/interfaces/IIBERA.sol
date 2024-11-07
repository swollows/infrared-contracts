// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IIBERA is IERC20, IAccessControl {
    error Unauthorized();
    error NotInitialized();
    error InvalidShares();
    error InvalidAmount();
    error InvalidSignature();

    event Mint(
        address indexed receiver,
        uint256 nonce,
        uint256 amount,
        uint256 shares,
        uint256 fee
    );
    event Burn(
        address indexed receiver,
        uint256 nonce,
        uint256 amount,
        uint256 shares,
        uint256 fee
    );
    event Sweep(uint256 amount);
    event Register(bytes pubkey, int256 delta, uint256 stake);
    event SetFeeProtocol(uint16 from, uint16 to);
    event SetDepositSignature(bytes pubkey, bytes from, bytes to);

    /// @notice Address of the Infrared operator contract
    function infrared() external view returns (address);

    /// @notice Address of the depositor that interacts with chain deposit precompile
    function depositor() external view returns (address);

    /// @notice Address of the withdrawor that interacts with chain withdraw precompile
    function withdrawor() external view returns (address);

    /// @notice Address of the claimor that receivers can claim withdrawn funds from
    function claimor() external view returns (address);

    /// @notice Address of the fee receivor contract that receives tx priority fees + MEV on EL
    function receivor() external view returns (address);

    /// @notice Deposits of BERA backing IBERA intended for use in CL by validators
    /// @return The amount of BERA for deposits to CL
    function deposits() external view returns (uint256);

    /// @notice Returns the amount of BERA staked in validator with given pubkey
    /// @return The amount of BERA staked in validator
    function stakes(bytes calldata pubkey) external view returns (uint256);

    /// @notice Returns whether initial deposit has been staked to validator with given pubkey
    /// @return Whethere initial deposit has been staked to validator
    function staked(bytes calldata pubkey) external view returns (bool);

    /// @notice Returns the deposit signature to use for given pubkey
    /// @return The deposit signature for pubkey
    function signatures(bytes calldata pubkey)
        external
        view
        returns (bytes memory);

    /// @notice Fee taken by the protocol on yield from EL coinbase priority fees + MEV, represented as an integer denominator (1/x)%
    /// @return The fee taken by protocol
    function feeProtocol() external view returns (uint16);

    /// @notice Pending deposits yet to be forwarded to CL
    /// @return The amount of BERA yet to be deposited to CL
    function pending() external view returns (uint256);

    /// @notice Confirmed deposits sent to CL
    /// @return The amount of BERA confirmed to be deposited to CL
    function confirmed() external view returns (uint256);

    /// @notice Returns whether given account is an IBERA keeper
    /// @return Whether account is a keeper
    function keeper(address account) external view returns (bool);

    /// @notice Returns whether given account is an IBERA governor
    /// @return Whether account is a governor
    function governor(address account) external view returns (bool);

    /// @notice Returns whether given pubkey is in Infrared validator set
    /// @return Whether pubkey in Infrared validator set
    function validator(bytes calldata pubkey) external view returns (bool);

    /// @notice Initializes IBERA to allow for future mints and burns
    /// @dev Must be called before IBERA can offer deposits and withdraws
    function initialize() external payable;

    /// @notice Compounds accumulated EL yield in fee receivor into deposits
    /// @dev Called internally at bof whenever IBERA minted or burned
    /// @dev Only sweeps if amount transferred from fee receivor would exceed min deposit thresholds
    function compound() external;

    /// @notice Sweeps received funds in `msg.value` as yield into deposits
    /// @dev Fee receivor must call this function in its sweep function for autocompounding
    function sweep() external payable;

    /// @notice Mints ibera shares to receiver for bera paid in by sender
    /// @param receiver Address of the receiver of ibera
    /// @return nonce The nonce issued to identify the credited bera funds for deposit
    /// @return shares The amount of shares of ibera minted
    function mint(address receiver)
        external
        payable
        returns (uint256 nonce, uint256 shares);

    /// @notice Burns ibera shares from sender for bera to ultimately be transferred to receiver on subsequent call to claim
    /// @dev Sender must pay withdraw precompile fee upfront
    /// @param receiver Address of the receiver of future bera
    /// @param shares The amount of shares of ibera burned
    /// @return nonce The nonce issued to identify the owed bera funds for claim
    /// @return amount The amount of bera funds that will be available for claim
    function burn(address receiver, uint256 shares)
        external
        payable
        returns (uint256 nonce, uint256 amount);

    /// @notice Registers update to BERA staked in validator with given pubkey at CL
    /// @dev Reverts if not called by depositor or withdrawor
    /// @param pubkey The pubkey of the validator to update BERA stake for at CL
    /// @param delta The change in the amount of BERA staked/unstaked (+/-) at CL
    function register(bytes calldata pubkey, int256 delta) external;

    /// @notice Sets the fee protocol taken on yield from EL coinbase priority fees + MEV
    /// @param to The new fee protocol represented as an integer denominator (1/x)%
    function setFeeProtocol(uint16 to) external;

    /// @notice Sets the deposit signature to be used when depositing to pubkey
    /// @param pubkey The pubkey of the validator receiving the deposit
    /// @param signature The deposit signature to use for pubkey
    function setDepositSignature(
        bytes calldata pubkey,
        bytes calldata signature
    ) external;
}
