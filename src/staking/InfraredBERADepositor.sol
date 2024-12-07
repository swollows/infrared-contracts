// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {Initializable} from
    "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {
    ERC1967Utils,
    UUPSUpgradeable
} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from
    "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IBeaconDeposit} from "@berachain/pol/interfaces/IBeaconDeposit.sol";
import {IInfraredBERA} from "src/interfaces/IInfraredBERA.sol";
import {IInfraredBERADepositor} from "src/interfaces/IInfraredBERADepositor.sol";

import {InfraredBERAConstants} from "./InfraredBERAConstants.sol";

/// @title InfraredBERADepositor
/// @author bungabear69420
/// @notice Depositor to deposit BERA to CL for Infrared liquid staking token
contract InfraredBERADepositor is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    IInfraredBERADepositor
{
    uint8 public constant ETH1_ADDRESS_WITHDRAWAL_PREFIX = 0x01;
    address public constant DEPOSIT_CONTRACT =
        0x00000000219ab540356cBB839Cbe05303d7705Fa; // TODO: change if different for berachain

    /// @inheritdoc IInfraredBERADepositor
    address public InfraredBERA;

    struct Slip {
        /// block.timestamp at which deposit slip issued
        uint96 timestamp;
        /// fee escrow for beacon deposit request
        uint256 fee;
        /// amount of BERA to be deposited to deposit contract at execute
        uint256 amount;
    }

    /// @inheritdoc IInfraredBERADepositor
    mapping(uint256 => Slip) public slips;

    /// @inheritdoc IInfraredBERADepositor
    uint256 public fees;

    /// @inheritdoc IInfraredBERADepositor
    uint256 public nonceSlip = 1;
    /// @inheritdoc IInfraredBERADepositor
    uint256 public nonceSubmit = 1;

    /// @dev Constructor disabled for upgradeable contracts
    constructor() {
        _disableInitializers();
    }

    /// @notice Ensure that only the governor or the contract itself can authorize upgrades
    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyOwner
    {}

    /// @notice Initialize the contract (replaces the constructor)
    /// @param admin Address for admin to upgrade
    /// @param ibera The initial InfraredBERA address
    function initialize(address admin, address ibera) public initializer {
        if (admin == address(0) || ibera == address(0)) revert ZeroAddress();
        __Ownable_init(admin);
        __UUPSUpgradeable_init();
        InfraredBERA = ibera;
        nonceSlip = 1;
        nonceSubmit = 1;
    }

    /// @notice Checks whether enough time has passed beyond min delay
    /// @param then The block timestamp in past
    /// @param current The current block timestamp now
    /// @return has Whether time between then and now exceeds forced min delay
    function _enoughtime(uint96 then, uint96 current)
        private
        pure
        returns (bool has)
    {
        unchecked {
            has = (current - then) >= InfraredBERAConstants.FORCED_MIN_DELAY;
        }
    }

    /// @inheritdoc IInfraredBERADepositor
    function reserves() public view returns (uint256) {
        return address(this).balance - fees;
    }

    /// @inheritdoc IInfraredBERADepositor
    function queue(uint256 amount) external payable returns (uint256 nonce) {
        // @dev can be called by withdrawor when rebalancing
        if (
            msg.sender != InfraredBERA
                && msg.sender != IInfraredBERA(InfraredBERA).withdrawor()
        ) {
            revert Unauthorized();
        }

        if (amount == 0 || msg.value < amount) revert InvalidAmount();
        uint256 fee = msg.value - amount;
        if (fee < InfraredBERAConstants.MINIMUM_DEPOSIT_FEE) {
            revert InvalidFee();
        }
        fees += fee;

        nonce = nonceSlip++;
        slips[nonce] =
            Slip({timestamp: uint96(block.timestamp), fee: fee, amount: amount});
        emit Queue(nonce, amount);
    }

    /// @inheritdoc IInfraredBERADepositor
    function execute(bytes calldata pubkey, uint256 amount) external {
        bool kpr = IInfraredBERA(InfraredBERA).keeper(msg.sender);
        // check if in *current* validator set on Infrared
        if (!IInfraredBERA(InfraredBERA).validator(pubkey)) {
            revert InvalidValidator();
        }
        // check stake + amount divided by 1 gwei fits in uint64
        if (
            amount == 0 || (amount % 1 gwei) != 0
                || ((IInfraredBERA(InfraredBERA).stakes(pubkey) + amount) / 1 gwei)
                    > type(uint64).max
                || (
                    !IInfraredBERA(InfraredBERA).staked(pubkey)
                        && amount != InfraredBERAConstants.INITIAL_DEPOSIT
                )
        ) {
            revert InvalidAmount();
        }
        // check if governor has added a valid deposit signature to avoid keeper mistakenly burning
        bytes memory signature = IInfraredBERA(InfraredBERA).signatures(pubkey);
        if (signature.length == 0) revert InvalidSignature();

        // cache for event after the bundling while loop
        address withdrawor = IInfraredBERA(InfraredBERA).withdrawor();
        uint256 _nonce = nonceSubmit; // start
        uint256 nonce; // end (inclusive)
        uint256 fee;

        // bundle nonces to meet up to amount
        // @dev care should be taken with choice of amount parameter not to reach gas limit
        uint256 remaining = amount;
        while (remaining > 0) {
            nonce = nonceSubmit;
            Slip memory s = slips[nonce];
            if (s.amount == 0) revert InvalidAmount();

            // @dev allow user to force stake into infrared validator if enough time has passed
            // TODO: check signature not needed (ignored) on second deposit to pubkey (think so)
            if (!kpr && !_enoughtime(s.timestamp, uint96(block.timestamp))) {
                revert Unauthorized();
            }

            // first time loop ever hits slip dedicate fee to this call
            // @dev for large slip requiring multiple separate calls to execute, keeper must front fee in subsequent calls
            // @dev but should make up for fronting via protocol fees on size
            if (s.fee > 0) {
                fee += s.fee;
                s.fee = 0;
            }

            // either use all of slip amount and increment nonce if remaining > slip amount or use remaining
            // not fully filling slip in this call
            uint256 delta = remaining > s.amount ? s.amount : remaining;
            s.amount -= delta;
            if (s.amount == 0) nonceSubmit++;
            slips[nonce] = s;

            // always >= 0 due to delta ternary
            remaining -= delta;
        }

        // remove accumulated escrowed fee from each request in bundled deposits and refund to keeper
        fees -= fee;

        // @dev ethereum/consensus-specs/blob/dev/specs/phase0/validator.md#eth1_address_withdrawal_prefix
        bytes memory credentials = abi.encodePacked(
            ETH1_ADDRESS_WITHDRAWAL_PREFIX,
            uint88(0), // 11 zero bytes
            withdrawor
        ); // TODO: check correct
        address operator = IInfraredBERA(InfraredBERA).infrared(); // infrared operator for validator
        // if operator already exists on BeaconDeposit, it must be set to zero for new deposits
        if (IBeaconDeposit(DEPOSIT_CONTRACT).getOperator(pubkey) == operator) {
            operator = address(0);
        }
        IBeaconDeposit(DEPOSIT_CONTRACT).deposit{value: amount}(
            pubkey, credentials, signature, operator
        );

        // register update to stake
        IInfraredBERA(InfraredBERA).register(pubkey, int256(amount)); // safe as max fits in uint96

        // sweep fee back to keeper to cover gas
        if (fee > 0) SafeTransferLib.safeTransferETH(msg.sender, fee);

        emit Execute(pubkey, _nonce, nonce, amount);
    }

    function implementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
