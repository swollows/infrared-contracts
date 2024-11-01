// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";

import {IBeaconDeposit} from "@berachain/pol/interfaces/IBeaconDeposit.sol";
import {IIBERA} from "@interfaces/IIBERA.sol";
import {IIBERADepositor} from "@interfaces/IIBERADepositor.sol";

import {IBERAConstants} from "./IBERAConstants.sol";

/// @title IBERADepositor
/// @author bungabear69420
/// @notice Depositor to deposit BERA to CL for Infrared liquid staking token
contract IBERADepositor is IIBERADepositor {
    uint8 public constant ETH1_ADDRESS_WITHDRAWAL_PREFIX = 0x01;
    address public constant DEPOSIT_CONTRACT =
        0x00000000219ab540356cBB839Cbe05303d7705Fa; // TODO: change if different for berachain

    /// @inheritdoc IIBERADepositor
    address public immutable IBERA;

    struct Slip {
        /// block.timestamp at which deposit slip issued
        uint96 timestamp;
        /// fee escrow for beacon deposit request
        uint256 fee;
        /// amount of BERA to be deposited to deposit contract at execute
        uint256 amount;
    }

    /// @inheritdoc IIBERADepositor
    mapping(uint256 => Slip) public slips;

    /// @inheritdoc IIBERADepositor
    uint256 public fees;

    /// @inheritdoc IIBERADepositor
    uint256 public nonceSlip = 1;
    /// @inheritdoc IIBERADepositor
    uint256 public nonceSubmit = 1;

    constructor() {
        IBERA = msg.sender;
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
            has = (current - then) >= IBERAConstants.FORCED_MIN_DELAY;
        }
    }

    /// @inheritdoc IIBERADepositor
    function reserves() public view returns (uint256) {
        return address(this).balance - fees;
    }

    /// @inheritdoc IIBERADepositor
    function queue(uint256 amount) external payable returns (uint256 nonce) {
        // @dev can be called by withdrawor when rebalancing
        if (msg.sender != IBERA && msg.sender != IIBERA(IBERA).withdrawor()) {
            revert Unauthorized();
        }

        if (amount == 0 || msg.value < amount) revert InvalidAmount();
        uint256 fee = msg.value - amount;
        if (fee < IBERAConstants.MINIMUM_DEPOSIT_FEE) revert InvalidFee();
        fees += fee;

        nonce = nonceSlip++;
        slips[nonce] =
            Slip({timestamp: uint96(block.timestamp), fee: fee, amount: amount});
        emit Queue(nonce, amount);
    }

    /// @inheritdoc IIBERADepositor
    function execute(
        bytes calldata pubkey,
        uint256 amount,
        bytes calldata signature
    ) external {
        bool kpr = IIBERA(IBERA).keeper(msg.sender);
        // check if in *current* validator set on Infrared
        if (!IIBERA(IBERA).validator(pubkey)) revert InvalidValidator();
        // check stake + amount divided by 1 gwei fits in uint64
        if (
            amount == 0 || (amount % 1 gwei) != 0
                || ((IIBERA(IBERA).stakes(pubkey) + amount) / 1 gwei)
                    > type(uint64).max
        ) {
            revert InvalidAmount();
        }

        // cache for event after the bundling while loop
        address withdrawor = IIBERA(IBERA).withdrawor();
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
        address operator = IIBERA(IBERA).infrared(); // infrared operator for validator
        // if operator already exists on BeaconDeposit, it must be set to zero for new deposits
        if (IBeaconDeposit(DEPOSIT_CONTRACT).getOperator(pubkey) == operator) {
            operator = address(0);
        }
        IBeaconDeposit(DEPOSIT_CONTRACT).deposit{value: amount}(
            pubkey, credentials, signature, operator
        );

        // register update to stake
        IIBERA(IBERA).register(pubkey, int256(amount)); // safe as max fits in uint96

        // sweep fee back to keeper to cover gas
        if (fee > 0) SafeTransferLib.safeTransferETH(msg.sender, fee);

        emit Execute(pubkey, _nonce, nonce, amount);
    }
}
