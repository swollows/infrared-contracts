// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IRewardVault as IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IRewardVault.sol";
import {
    IERC20,
    SafeERC20
} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IInfraredDistributor} from "@interfaces/IInfraredDistributor.sol";
import {IBerachainBGTStaker} from "@interfaces/IBerachainBGTStaker.sol";
import {IERC20Mintable} from "@interfaces/IERC20Mintable.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";
import {ConfigTypes} from "@core/libraries/ConfigTypes.sol";
import {IBerachainBGT} from "@interfaces/IBerachainBGT.sol";
import {IReward} from "@voting/interfaces/IReward.sol";
import {IVoter} from "@voting/interfaces/IVoter.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {IWBERA} from "@interfaces/IWBERA.sol";
import {IIBGT} from "@interfaces/IIBGT.sol";
import {Errors} from "@utils/Errors.sol";

library RewardsLib {
    using SafeERC20 for IERC20;

    struct RewardsStorage {
        address collector;
        address distributor;
        address wbera;
        address bgt;
        address ibgt;
        address voter;
        address ibgtVault;
        address wiberaVault;
        address ired;
        mapping(address => uint256) protocolFeeAmounts; // Tracks accumulated protocol fees per token
        uint256 iredMintRate; // Rate for minting IRED tokens
        uint256 rewardsDuration; // Duration for reward programs
        mapping(uint256 => uint256) weights; // Weight configuration
        mapping(uint256 => uint256) fees; // Fee configuration
    }

    /**
     * @notice Weight units when partitioning reward amounts in hundredths of 1 bip
     * @dev Used as the denominator when calculating weighted distributions (1e6)
     */
    uint256 internal constant WEIGHT_UNIT = 1e6;

    /**
     * @notice IRED mint rate in hundredths of 1 bip
     * @dev Used as the denominator when calculating IRED minting (1e6)
     */
    uint256 internal constant RATE_UNIT = 1e6;

    /**
     * @notice Protocol fee rate in hundredths of 1 bip
     * @dev Used as the denominator when calculating protocol fees (1e6)
     */
    uint256 internal constant FEE_UNIT = 1e6;

    /// @notice Calculates how fees are split between protocol, voters, and the recipient.
    function chargedFeesOnRewards(
        RewardsStorage storage,
        uint256 _amt,
        uint256 _feeTotal,
        uint256 _feeProtocol
    )
        public
        pure
        returns (uint256 amtRecipient, uint256 amtVoter, uint256 amtProtocol)
    {
        amtRecipient = _amt;
        if (_feeTotal == 0) return (amtRecipient, 0, 0);

        uint256 _amtTotal = amtRecipient * _feeTotal / FEE_UNIT; // FEE_UNIT = 1e6
        amtProtocol = _amtTotal * _feeProtocol / FEE_UNIT; // Protocol's share
        amtVoter = _amtTotal - amtProtocol; // Remainder for voter
        amtRecipient -= (amtProtocol + amtVoter); // Deduct fees from recipient
    }

    function _distributeFeesOnRewards(
        RewardsStorage storage $,
        address _token,
        uint256 _amtVoter,
        uint256 _amtProtocol
    ) internal {
        // add protocol fees to accumulator for token
        $.protocolFeeAmounts[_token] += _amtProtocol;

        // forward voter fees
        if (_amtVoter > 0) {
            address voterFeeVault = IVoter($.voter).feeVault();
            IERC20(_token).safeIncreaseAllowance(voterFeeVault, _amtVoter);
            IReward(voterFeeVault).notifyRewardAmount(_token, _amtVoter);
        }
    }

    function harvestBase(RewardsStorage storage $)
        external
        returns (uint256 bgtAmt)
    {
        uint256 minted = IIBGT($.ibgt).totalSupply();
        uint256 bgtBalance = _getBGTBalance($);
        // @dev should never happen but check in case
        if (bgtBalance <= minted) revert Errors.UnderFlow();

        bgtAmt = bgtBalance - minted;

        // get total and protocol fee rates
        uint256 feeTotal =
            $.fees[uint256(ConfigTypes.FeeType.HarvestBaseFeeRate)];
        uint256 feeProtocol =
            $.fees[uint256(ConfigTypes.FeeType.HarvestBaseProtocolRate)];

        _handleBGTRewardsForDistributor($, bgtAmt, feeTotal, feeProtocol);
    }

    function harvestVault(RewardsStorage storage $, IInfraredVault vault)
        external
        returns (uint256 bgtAmt)
    {
        // IInfraredVault vault = vaultRegistry(_asset);
        if (vault == IInfraredVault(address(0))) {
            revert Errors.VaultNotSupported();
        }

        uint256 balanceBefore = _getBGTBalance($);
        IBerachainRewardsVault rewardsVault = vault.rewardsVault();
        rewardsVault.getReward(address(vault), address(this));

        bgtAmt = _getBGTBalance($) - balanceBefore;

        // get total and protocol fee rates
        uint256 feeTotal =
            $.fees[uint256(ConfigTypes.FeeType.HarvestVaultFeeRate)];
        uint256 feeProtocol =
            $.fees[uint256(ConfigTypes.FeeType.HarvestVaultProtocolRate)];

        _handleBGTRewardsForVault($, vault, bgtAmt, feeTotal, feeProtocol);
    }

    function harvestBribes(
        RewardsStorage storage $,
        address[] memory _tokens,
        bool[] memory whitelisted
    ) external returns (address[] memory tokens, uint256[] memory _amounts) {
        uint256 len = _tokens.length;
        _amounts = new uint256[](len);
        tokens = new address[](len);

        for (uint256 i = 0; i < _tokens.length; i++) {
            if (!whitelisted[i]) continue;
            address _token = _tokens[i];
            if (_token == DataTypes.NATIVE_ASSET) {
                IWBERA($.wbera).deposit{value: address(this).balance}();
                _token = $.wbera;
            }
            // amount to forward is balance of this address less existing protocol fees
            uint256 _amount = IERC20(_token).balanceOf(address(this))
                - $.protocolFeeAmounts[_token];
            _amounts[i] = _amount;
            tokens[i] = _token;
            _handleTokenBribesForReceiver($, $.collector, _token, _amount);
        }
    }

    function collectBribes(
        RewardsStorage storage $,
        address _token,
        uint256 _amount
    ) internal returns (uint256 amtWiberaVault, uint256 amtIbgtVault) {
        IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);

        amtIbgtVault = _amount;

        // get total and protocol fee rates
        uint256 feeTotal =
            $.fees[uint256(ConfigTypes.FeeType.HarvestBribesFeeRate)];
        uint256 feeProtocol =
            $.fees[uint256(ConfigTypes.FeeType.HarvestBribesProtocolRate)];

        _handleTokenRewardsForVault(
            $,
            IInfraredVault($.ibgtVault),
            _token,
            amtIbgtVault,
            feeTotal,
            feeProtocol
        );
    }

    function harvestBoostRewards(RewardsStorage storage $)
        external
        returns (address _vault, address _token, uint256 _amount)
    {
        IBerachainBGTStaker _bgtStaker = IBerachainBGT($.bgt).staker();
        _token = address(_bgtStaker.rewardToken());

        // claim boost reward
        // @dev not trusting return from bgt staker in case transfer fees
        uint256 balanceBefore = IERC20(_token).balanceOf(address(this));
        _bgtStaker.getReward();
        _amount = IERC20(_token).balanceOf(address(this)) - balanceBefore;

        // get total and protocol fee rates
        uint256 feeTotal =
            $.fees[uint256(ConfigTypes.FeeType.HarvestBoostFeeRate)];
        uint256 feeProtocol =
            $.fees[uint256(ConfigTypes.FeeType.HarvestBoostProtocolRate)];

        _vault = $.ibgtVault;
        _handleTokenRewardsForVault(
            $,
            IInfraredVault($.ibgtVault),
            _token,
            _amount,
            feeTotal,
            feeProtocol
        );
    }

    /**
     * @notice Handles non-IBGT token rewards to the vault.
     * @param _vault       IInfraredVault   The address of the vault.
     * @param _token       address          The reward token.
     * @param _amount      uint256          The amount of reward token to send to vault.
     * @param _feeTotal    uint256          The rate to charge for total fees on `_amount`.
     * @param _feeProtocol uint256          The rate to charge for protocol treasury on total fees.
     */
    function _handleTokenRewardsForVault(
        RewardsStorage storage $,
        IInfraredVault _vault,
        address _token,
        uint256 _amount,
        uint256 _feeTotal,
        uint256 _feeProtocol
    ) internal {
        if (_amount == 0) return;

        // add reward if not already added
        (, uint256 _vaultRewardsDuration,,,,) = _vault.rewardData(_token);
        if (_vaultRewardsDuration == 0) {
            _vault.addReward(_token, $.rewardsDuration);
        }

        uint256 _amtVoter;
        uint256 _amtProtocol;

        // calculate and distribute fees on rewards
        (_amount, _amtVoter, _amtProtocol) =
            chargedFeesOnRewards($, _amount, _feeTotal, _feeProtocol);
        _distributeFeesOnRewards($, _token, _amtVoter, _amtProtocol);

        // increase allowance then notify vault of new rewards
        if (_amount > 0) {
            IERC20(_token).safeIncreaseAllowance(address(_vault), _amount);
            _vault.notifyRewardAmount(_token, _amount);
        }
    }

    /**
     * @notice Handles non-IBGT token bribe rewards to a non-vault receiver address.
     * @dev Does *not* take protocol fee on bribe coin, as taken on bribe collector payout token in eventual callback.
     * @param _recipient address  The address of the recipient.
     * @param _token     address  The address of the token to forward to recipient.
     */
    function _handleTokenBribesForReceiver(
        RewardsStorage storage,
        address _recipient,
        address _token,
        uint256 _amount
    ) internal {
        if (_amount == 0) return;

        // transfer rewards to recipient
        IERC20(_token).safeTransfer(_recipient, _amount);
    }

    /**
     * @notice Handles BGT token rewards, minting IBGT and supplying to the vault.
     * @param _vault       address         The address of the vault.
     * @param _bgtAmt      uint256         The BGT reward amount.
     * @param _feeTotal    uint256         The rate to charge for total fees on iBGT `_bgtAmt`.
     * @param _feeProtocol uint256         The rate to charge for protocol treasury on total iBGT fees.
     */
    function _handleBGTRewardsForVault(
        RewardsStorage storage $,
        IInfraredVault _vault,
        uint256 _bgtAmt,
        uint256 _feeTotal,
        uint256 _feeProtocol
    ) internal {
        // pass if no bgt rewards
        if (_bgtAmt == 0) return;

        // handle bgt rewards by minting and supplying IBGT to vault
        IIBGT($.ibgt).mint(address(this), _bgtAmt);

        // calculate and distribute fees on rewards
        (uint256 _amt, uint256 _amtVoter, uint256 _amtProtocol) =
            chargedFeesOnRewards($, _bgtAmt, _feeTotal, _feeProtocol);
        _distributeFeesOnRewards($, $.ibgt, _amtVoter, _amtProtocol);

        // send token rewards less fee to vault
        if (_amt > 0) {
            IERC20($.ibgt).safeIncreaseAllowance(address(_vault), _amt);
            _vault.notifyRewardAmount($.ibgt, _amt);
        }
    }

    /**
     * @notice Handles BGT base rewards supplied to validator distributor.
     * @param _bgtAmt      uint256         The BGT reward amount.
     * @param _feeTotal    uint256         The rate to charge for total fees on `_bgtAmt`.
     * @param _feeProtocol uint256         The rate to charge for protocol treasury on total fees.
     */
    function _handleBGTRewardsForDistributor(
        RewardsStorage storage $,
        uint256 _bgtAmt,
        uint256 _feeTotal,
        uint256 _feeProtocol
    ) internal {
        // pass if no bgt rewards
        if (_bgtAmt == 0) return;

        // handle bgt rewards by minting and supplying to distributor
        IIBGT($.ibgt).mint(address(this), _bgtAmt);

        address _token = $.ibgt;
        uint256 _amt = _bgtAmt;

        uint256 _amtVoter;
        uint256 _amtProtocol;

        // calculate and distribute fees on rewards
        (_amt, _amtVoter, _amtProtocol) =
            chargedFeesOnRewards($, _amt, _feeTotal, _feeProtocol);
        _distributeFeesOnRewards($, _token, _amtVoter, _amtProtocol);

        // send token rewards less fee to vault
        if (_amt > 0) {
            IERC20(_token).safeIncreaseAllowance($.distributor, _amt);
            IInfraredDistributor($.distributor).notifyRewardAmount(_amt);
        }
    }

    function delegateBGT(RewardsStorage storage $, address _delegatee)
        internal
    {
        if (_delegatee == address(0)) revert Errors.ZeroAddress();
        if (_delegatee == address(this)) revert Errors.InvalidDelegatee();
        IBerachainBGT($.bgt).delegate(_delegatee);
    }

    function updateWeight(
        RewardsStorage storage $,
        ConfigTypes.WeightType _t,
        uint256 _weight
    ) internal {
        if (_weight > WEIGHT_UNIT) revert Errors.InvalidWeight();
        $.weights[uint256(_t)] = _weight;
    }

    function updateFee(
        RewardsStorage storage $,
        ConfigTypes.FeeType _t,
        uint256 _fee
    ) internal {
        if (_fee > FEE_UNIT) revert Errors.InvalidFee();
        $.fees[uint256(_t)] = _fee;
    }

    function claimProtocolFees(
        RewardsStorage storage $,
        address _to,
        address _token,
        uint256 _amount
    ) internal {
        if (_amount > $.protocolFeeAmounts[_token]) {
            revert Errors.MaxProtocolFeeAmount();
        }
        $.protocolFeeAmounts[_token] -= _amount;
        IERC20(_token).safeTransfer(_to, _amount);
    }

    function getBGTBalance(RewardsStorage storage $)
        public
        view
        returns (uint256)
    {
        return _getBGTBalance($);
    }

    function _getBGTBalance(RewardsStorage storage $)
        internal
        view
        returns (uint256)
    {
        return IBerachainBGT($.bgt).balanceOf(address(this));
    }

    function updateRewardsDuration(
        RewardsStorage storage $,
        uint256 newDuration
    ) internal {
        if (newDuration == 0) revert Errors.ZeroAmount();

        $.rewardsDuration = newDuration;
    }

    function updateIredMintRate(RewardsStorage storage $, uint256 _iredMintRate)
        internal
    {
        $.iredMintRate = _iredMintRate;
    }
}
