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

import {IIBERA} from "@interfaces/IIBERA.sol";
import {IIBERADepositor} from "@interfaces/IIBERADepositor.sol";
import {IIBERAClaimor} from "@interfaces/IIBERAClaimor.sol";
import {IIBERAWithdrawor} from "@interfaces/IIBERAWithdrawor.sol";

import {IBERAConstants} from "./IBERAConstants.sol";

/// @title IBERAWithdrawor
/// @author bungabear69420
/// @notice Withdrawor to withdraw BERA from CL for Infrared liquid staking token
/// @dev Assumes ETH returned via withdraw precompile credited to contract so receive unnecessary
contract IBERAWithdrawor is
    Initializable,
    UUPSUpgradeable,
    OwnableUpgradeable,
    IIBERAWithdrawor
{
    uint8 public constant WITHDRAW_REQUEST_TYPE = 0x01;
    address public constant WITHDRAW_PRECOMPILE =
        0x00A3ca265EBcb825B45F985A16CEFB49958cE017; // @dev: EIP7002

    /// @inheritdoc IIBERAWithdrawor
    address public IBERA;

    struct Request {
        /// receiver of withdrawn bera funds
        address receiver;
        /// block.timestamp at which withdraw request issued
        uint96 timestamp;
        /// fee escrow for withdraw precompile request
        uint256 fee;
        /// amount of withdrawn bera funds left to submit request to withdraw precompile
        uint256 amountSubmit;
        /// amount of withdrawn bera funds left to process from funds received via withdraw request
        uint256 amountProcess;
    }

    /// @inheritdoc IIBERAWithdrawor
    mapping(uint256 => Request) public requests;

    /// @inheritdoc IIBERAWithdrawor
    uint256 public fees;

    /// @inheritdoc IIBERAWithdrawor
    uint256 public rebalancing;

    /// @inheritdoc IIBERAWithdrawor
    uint256 public nonceRequest;
    /// @inheritdoc IIBERAWithdrawor
    uint256 public nonceSubmit;
    /// @inheritdoc IIBERAWithdrawor
    uint256 public nonceProcess;

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
    /// @param ibera The initial IBERA address
    function initialize(address admin, address ibera) public initializer {
        __Ownable_init(admin);
        __UUPSUpgradeable_init();
        IBERA = ibera;

        nonceRequest = 1;
        nonceSubmit = 1;
        nonceProcess = 1;
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

    /// @inheritdoc IIBERAWithdrawor
    function reserves() public view returns (uint256) {
        return address(this).balance - fees;
    }

    /// @inheritdoc IIBERAWithdrawor
    function queue(address receiver, uint256 amount)
        external
        payable
        returns (uint256 nonce)
    {
        bool kpr = IIBERA(IBERA).keeper(msg.sender);
        address depositor = IIBERA(IBERA).depositor();
        // @dev rebalances can be queued by keeper but receiver must be depositor and amount must exceed deposit fee
        if (msg.sender != IBERA && !kpr) revert Unauthorized();
        if ((kpr && receiver != depositor) || (!kpr && receiver == depositor)) {
            revert InvalidReceiver();
        }
        if (
            (receiver != depositor && amount == 0)
                || (
                    receiver == depositor
                        && amount <= IBERAConstants.MINIMUM_DEPOSIT_FEE
                ) || amount > IIBERA(IBERA).confirmed()
        ) {
            revert InvalidAmount();
        }

        if (msg.value < IBERAConstants.MINIMUM_WITHDRAW_FEE) {
            revert InvalidFee();
        }
        fees += msg.value;

        // account for rebalancing amount
        // @dev must update *after* IBERA.confirmed checked given used in confirmed view
        if (kpr) rebalancing += amount;

        nonce = nonceRequest++;
        requests[nonce] = Request({
            receiver: receiver,
            timestamp: uint96(block.timestamp),
            fee: msg.value,
            amountSubmit: amount,
            amountProcess: amount
        });
        emit Queue(receiver, nonce, amount);
    }

    /// @inheritdoc IIBERAWithdrawor
    function execute(bytes calldata pubkey, uint256 amount) external payable {
        bool kpr = IIBERA(IBERA).keeper(msg.sender);
        // no need to check if in *current* validator set as revert before precompile call if have no stake in pubkey
        // allows for possibly removing stake from validators that were previously removed from validator set on Infrared
        // TODO: check whether precompile ultimately modified for amount / 1 gwei to be consistent with deposits
        if (
            amount == 0 || IIBERA(IBERA).stakes(pubkey) < amount
                || (amount % 1 gwei) != 0 || (amount / 1 gwei) > type(uint64).max
        ) {
            revert InvalidAmount();
        }

        // cache for event after the bundling while loop
        uint256 _nonce = nonceSubmit; // start
        uint256 nonce; // end (inclusive)
        uint256 fee;

        // bundle nonces to meet up to amount
        // @dev care should be taken with choice of amount parameter not to reach gas limit
        uint256 remaining = amount;
        while (remaining > 0) {
            nonce = nonceSubmit;
            Request memory r = requests[nonce];
            if (r.amountSubmit == 0) revert InvalidAmount();

            // @dev allow user to force withdraw from infrared validator if enough time has passed
            // TODO: check signature not needed (ignored) on second deposit to pubkey (think so)
            if (!kpr && !_enoughtime(r.timestamp, uint96(block.timestamp))) {
                revert Unauthorized();
            }

            // first time loop ever hits request dedicate fee to this call
            // @dev for large request requiring multiple separate calls to execute, keeper must front fee in subsequent calls
            // @dev but should make up for fronting via protocol fees on size
            if (r.fee > 0) {
                fee += r.fee;
                r.fee = 0;
            }

            // either use all of request amount and increment nonce if remaining > request amount or use remaining
            // not fully filling request in this call
            uint256 delta =
                remaining > r.amountSubmit ? r.amountSubmit : remaining;
            r.amountSubmit -= delta;
            if (r.amountSubmit == 0) nonceSubmit++;
            requests[nonce] = r;

            // always >= 0 due to delta ternary
            remaining -= delta;
        }

        // remove accumulated escrowed fee from each request in bundled withdraws and refund excess to keeper
        fees -= fee;
        // couple with additional msg.value from keeper in case withdraw precompile fee is large or has been used in prior call that did not fully fill
        fee += msg.value;
        // cache balance prior to withdraw compile to calculate refund on fee
        uint256 _balance = address(this).balance;

        // prepare RLP encoded data (for simplicity, using abi.encodePacked for concatenation)
        // @dev must ensure no matter what withdraw call guaranteed to happen
        bytes memory encoded = abi.encodePacked(
            WITHDRAW_REQUEST_TYPE, // 0x01
            msg.sender, // source_address
            pubkey, // validator_pubkey
            uint64(amount / 1 gwei) // amount in gwei
        );
        (bool success,) = WITHDRAW_PRECOMPILE.call{value: fee}(encoded);
        if (!success) revert CallFailed();

        // calculate excess from withdraw precompile call to refund
        // TODO: test excess value passed over fee actually refunded
        uint256 excess = fee - (_balance - address(this).balance);

        // register update to stake
        IIBERA(IBERA).register(pubkey, -int256(amount)); // safe as max fits in uint96

        // sweep excess fee back to keeper to cover gas
        if (excess > 0) SafeTransferLib.safeTransferETH(msg.sender, excess);

        emit Execute(pubkey, _nonce, nonce, amount);
    }

    /// @inheritdoc IIBERAWithdrawor
    function process() external {
        uint256 nonce = nonceProcess;
        address depositor = IIBERA(IBERA).depositor();
        Request memory r = requests[nonce];
        if (r.amountSubmit != 0 || r.amountProcess == 0) revert InvalidAmount();

        uint256 amount = r.amountProcess;
        if (amount > reserves()) revert InvalidReserves();
        r.amountProcess -= amount;
        nonceProcess++;
        requests[nonce] = r;

        if (r.receiver == depositor) {
            // queue up rebalance to depositor
            rebalancing -= amount;
            IIBERADepositor(r.receiver).queue{value: amount}(
                amount - IBERAConstants.MINIMUM_DEPOSIT_FEE
            );
        } else {
            // queue up receiver claim to claimor
            address claimor = IIBERA(IBERA).claimor();
            IIBERAClaimor(claimor).queue{value: amount}(r.receiver);
        }
        emit Process(r.receiver, nonce, amount);
    }

    function implementation() external view returns (address) {
        return ERC1967Utils.getImplementation();
    }

    /// @inheritdoc IIBERAWithdrawor
    function sweep(uint256 amount, bytes calldata pubkey) external {
        // only callable when withdrawals are not enabled
        if (IIBERA(IBERA).withdrawalsEnabled()) revert Unauthorized();
        // onlyKeeper call
        if (!IIBERA(IBERA).keeper(msg.sender)) revert Unauthorized();
        // do nothing if IBERA deposit would revert
        uint256 min =
            IBERAConstants.MINIMUM_DEPOSIT + IBERAConstants.MINIMUM_DEPOSIT_FEE;
        if (amount < min) return;
        // revert if insufficient balance
        if (amount > address(this).balance) revert InvalidAmount();

        // todo: verfiy forced withdrawal against beacon roots

        // register new validator delta
        IIBERA(IBERA).register(pubkey, -int256(amount));

        // re-stake amount back to ibera depositor
        IIBERADepositor(IIBERA(IBERA).depositor()).queue{value: amount}(
            amount - IBERAConstants.MINIMUM_DEPOSIT_FEE
        );

        emit Sweep(IBERA, amount);
    }

    receive() external payable {}
}
