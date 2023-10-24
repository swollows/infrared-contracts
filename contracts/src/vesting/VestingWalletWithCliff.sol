// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {VestingWallet} from '@openzeppelin/finance/VestingWallet.sol';

/**
 * @title VestingWalletWithCliff
 * @notice VestingWalletWithCliff is a VestingWallet that has a cliff period.
 */
contract VestingWalletWithCliff is VestingWallet {
    // Timestamp at which the cliff starts.
    uint64 private immutable _CLIFF;

    /*//////////////////////////////////////////////////////////////
                        CONSTRUCTOR/INITIALIZATION LOGIC
  //////////////////////////////////////////////////////////////*/
    constructor(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds,
        uint64 cliffSeconds
    ) payable VestingWallet(beneficiaryAddress, startTimestamp, durationSeconds) {
        _CLIFF = startTimestamp + cliffSeconds;
    }

    /*//////////////////////////////////////////////////////////////
                         OVERRIDES
  //////////////////////////////////////////////////////////////*/

    /**
     * @notice Calculates the vesting schedule for the given total allocation.
     * @param  _totalAllocation uint256 The total allocation to calculate the vesting schedule for.
     * @param  _timestamp       uint64  The timestamp to calculate the vesting schedule for.
     * @return _tokens          uint256 The amount of tokens that should be vested at the given timestamp.
     */
    function _vestingSchedule(
        uint256 _totalAllocation,
        uint64 _timestamp
    ) internal view override returns (uint256 _tokens) {
        if (_timestamp < start()) {
            // Vesting hasn't started yet.
            return 0;
        } else if (_timestamp < _CLIFF) {
            // Cliff period.
            return 0;
        } else if (_timestamp >= start() + duration()) {
            // Vesting has ended.
            return _totalAllocation;
        } else {
            // Vesting is in progress.
            return (_totalAllocation * (_timestamp - start())) / duration();
        }
    }
}
