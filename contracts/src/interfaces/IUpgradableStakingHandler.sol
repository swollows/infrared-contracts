// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

interface IUpgradableStakingHandler {
    /**
     * @notice Delegate `_amt` of tokens to `_validator`.
     * @param _validator address The validator to delegate to.
     * @param _amt       uint256 The amount of tokens to delegate.
     * @return _success  bool    Whether the delegation was successful.
     */
    function delegate(address _validator, uint256 _amt, address _storageAddress)
        external
        returns (bool _success);

    /**
     * @notice Undelegate `_amt` of tokens from `_validator`.
     * @param _validator address The validator to undelegate from.
     * @param _amt       uint256 The amount of tokens to undelegate.
     * @return _success  bool    Whether the undelegation was successful.
     */
    function undelegate(
        address _validator,
        uint256 _amt,
        address _storageAddress
    ) external returns (bool _success);

    /**
     * @notice Begin redelegation of `_amt` of tokens from `_from` to `_to`.
     * @param _from address The validator to redelegate from.
     * @param _to   address The validator to redelegate to.
     * @param _amt  uint256 The amount of tokens to redelegate.
     * @return _success  bool    Whether the redelegation was successful.
     */
    function beginRedelegate(
        address _from,
        address _to,
        uint256 _amt,
        address _storageAddress
    ) external returns (bool _success);

    /**
     * @notice Cancel redelegation of `_amt` of tokens from `_from` to `_to` at `_creationHeight`.
     * @param _validator      address The validator to redelegate from.
     * @param _amt            uint256 The amount of tokens to redelegate.
     * @param _creationHeight int64   The height at which the redelegation was created.
     */
    function cancelUnbondingDelegation(
        address _validator,
        uint256 _amt,
        int64 _creationHeight,
        address _storageAddress
    ) external returns (bool _success);
}
