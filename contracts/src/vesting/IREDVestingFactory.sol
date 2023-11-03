// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Ownable} from '@openzeppelin/access/Ownable.sol';
import {VestingWalletWithCliff} from './VestingWalletWithCliff.sol';
import {Errors} from '@utils/Errors.sol';

/**
 * @title IREDVestingFactory
 * @notice IREDVestingFactory deploys vesting wallets for the Infrared ecosystem contributors and partners.
 */
contract IREDVestingFactory is Ownable {
    // Mapping of beneficiary to vesting wallet address.
    mapping(address => address) public vestingWallets;

    /*//////////////////////////////////////////////////////////////
                        CONSTRUCTOR/INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/
    constructor(
        address _treasuryBeneficiary,
        address _teamBeneficiary,
        address _investorBeneficiary
    ) Ownable(msg.sender) {
        if (_treasuryBeneficiary == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_teamBeneficiary == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_investorBeneficiary == address(0)) {
            revert Errors.ZeroAddress();
        }

        uint64 startTimestamp = uint64(block.timestamp);

        // Treasury: Linear vest over 12 months
        _deployVestingWallet(
            _treasuryBeneficiary,
            startTimestamp,
            365 days, // 12 months
            0
        );

        // Team: 6 month cliff + 18 month linear vest
        _deployVestingWallet(
            _teamBeneficiary,
            startTimestamp,
            720 days, // 6 + 18 months
            180 days // 6 months
        );

        // Investor: 6 month cliff + 24 month linear vest
        _deployVestingWallet(
            _investorBeneficiary,
            startTimestamp,
            900 days, // 6 + 24 months
            180 days // 6 months
        );
    }

    /**
     * @notice Deploys a vesting wallet for the given beneficiary.
     * @param _beneficiary     address The beneficiary of the vesting wallet.
     * @param _startTimestamp  uint64  The start timestamp of the vesting wallet.
     * @param _durationSeconds uint64  The duration of the vesting wallet.
     * @param _cliffSeconds    uint64  The cliff of the vesting wallet.
     */
    function _deployVestingWallet(
        address _beneficiary,
        uint64 _startTimestamp,
        uint64 _durationSeconds,
        uint64 _cliffSeconds
    ) internal returns (address _vestingWallet) {
        if (vestingWallets[_beneficiary] != address(0)) {
            revert Errors.ElementAlreadyExists();
        }

        // Deploy the vesting wallet.
        VestingWalletWithCliff vestingWallet = new VestingWalletWithCliff(
            _beneficiary,
            _startTimestamp,
            _durationSeconds,
            _cliffSeconds
        );

        vestingWallets[_beneficiary] = address(vestingWallet);
        return address(vestingWallet);
    }
}
