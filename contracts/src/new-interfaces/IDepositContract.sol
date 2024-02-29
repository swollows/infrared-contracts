// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

/// @title IDepositContract
/// @author Berachain Team.
/// @dev This contract is the interdface of the deposit contract that the beaconkit uses to handle its
/// delegate proof of stake system. It is derived from the Ethereum 2.0 specification but with an arbitrary
/// staking backend for the chain, hence it is very flexible and can be used with ERC20s or the native token.
interface IDepositContract {
    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        EVENTS                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @dev Emitted when a deposit is made.
     * @notice the withdrawCredentials can be left empty if its not the first deposit.
     * @param amount The amount of the deposit.
     * @param pubKey The public key of the validator.
     * @param withdrawalCredentials The withdrawal credentials of the validator.
     * @param signature The signature of the depositor.
     */
    event Deposit(
        uint64 amount,
        bytes pubKey,
        bytes withdrawalCredentials,
        bytes signature
    );

    /**
     * @dev Emitted when a redirection is made.
     * @param srcPub The public key of the source validator.
     * @param dstPub The public key of the destination validator.
     * @param amount The amount to be redirected.
     * @param signature The signature of the redirector with the stake.
     */
    event Redirect(bytes srcPub, bytes dstPub, uint64 amount, bytes signature);

    /**
     * @dev Emitted when a withdrawal is made.
     * @param pubKey The public key of the validator.
     * @param amount The amount to be withdrawn from the validator.
     * @param signature The signature of the withdrawer.
     */
    event Withdraw(bytes pubKey, uint64 amount, bytes signature);

    /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
    /*                        WRITES                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/

    /**
     * @notice Submit a stake message to the Beaconchain.
     * @param amount The amount of the deposit.
     * @param pubkey A BLS12-381 public key.
     * @param delegatorWithdrawalCredentials public key that will receive the withdrawal.
     * @param signature A BLS12-381 signature from the depositor.
     */
    function deposit(
        uint64 amount, // in Gwei even if an ERC20 token.
        bytes calldata pubkey,
        bytes calldata delegatorWithdrawalCredentials,
        bytes calldata signature
    ) external payable;

    /**
     * @notice Submit a redirect stake message.
     * @notice This function is only callable by the owner of the stake.
     * @param srcPub A BLS12-381 public key of the source validator.
     * @param dstPub A BLS12-381 public key of the destination validator.
     * @param amount The amount of the deposit.
     * @param signature A BLS12-381 signature from the redirector.
     */
    function redirect(
        bytes calldata srcPub,
        bytes calldata dstPub,
        uint64 amount,
        bytes calldata signature
    ) external payable;

    /**
     * @notice Submit a withdrawal message to the Beaconchain.
     * @notice This function is only callable by the owner of the stake.
     * @param pubkey A BLS12-381 public key.
     * @param amount The amount of the deposit to be withdrawn.
     * @param signature A BLS12-381 signature of the withdrawer.
     */
    function withdraw(
        bytes calldata pubkey,
        uint64 amount,
        bytes calldata signature
    ) external payable;
}
