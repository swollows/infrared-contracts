// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External dependencies.
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";

// Internal dependencies.
import {Errors} from "@utils/Errors.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {PureUtils} from "@utils/PureUtils.sol";
import {IRewardsModule} from "@berachain/Rewards.sol";
import {IDistributionModule} from "@polaris/Distribution.sol";
import {IERC20BankModule} from "@berachain/ERC20BankModule.sol";
import {Cosmos} from "@polaris/CosmosTypes.sol";
import {IWBERA} from "@berachain/IWBERA.sol";

/**
 * @title UpgradableRewardsHandler
 * @notice This contract is responsible for handling the rewards and distribution module interactions.
 * @notice This is meant for callers to delegate calls to this contract.
 * @dev This contract is upgradable.
 */
library ValidatorRewards {
    using SafeTransferLib for ERC20;

    // The cosmos sdk coin denomination for the berachain token.
    string internal constant bgtDenom = "abgt";
    string internal constant beraDenom = "abera";

    struct PrecompileAddresses {
        address erc20BankPrecompile;
        address distributionPrecompile;
        address wbera;
    }

    /*//////////////////////////////////////////////////////////////
                             WRITES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Redeems rewards from the distribution module, which will be in the form of []( element of sdk.Coin, bera, bgt).
     * @return _tokens DataTypes.Token[] memory The list of tokens that were redeemed to the msg.sender (the delegate caller)
     * @return _bgtAmt uint256                  The amount of bgt that was redeemed.
     */
    function claimDistrPrecompile(
        address _validator,
        PrecompileAddresses memory precompileAddresses
    ) public returns (DataTypes.Token[] memory _tokens, uint256 _bgtAmt) {
        Cosmos.Coin[] memory rewards = IDistributionModule(
            precompileAddresses.distributionPrecompile
        ).withdrawDelegatorReward(address(this), _validator);
        /// TODO: For more defensive code, we can check the balance of the ERC20 token before and after the transfer.

        if (rewards.length == 0) {
            return (new DataTypes.Token[](0), 0); // This case: {} empty set.
        }

        (Cosmos.Coin[] memory nonBgtRewards, uint256 bgtAmt) =
            PureUtils.removeCoinFromCoins(rewards, bgtDenom);

        if (nonBgtRewards.length == 0) {
            return (new DataTypes.Token[](0), bgtAmt); // This case: {bgtAmt} singleton set.
        }

        IWBERA wrappedBera = IWBERA(precompileAddresses.wbera);

        (Cosmos.Coin[] memory coinsRewards, uint256 beraAmt) =
            PureUtils.removeCoinFromCoins(nonBgtRewards, beraDenom);

        // Only bgt and bera rewards.
        if (coinsRewards.length == 0 && beraAmt > 0) {
            // Wrap the bera.
            wrappedBera.deposit{value: beraAmt}();

            _tokens = new DataTypes.Token[](1);
            _tokens[0] = DataTypes.Token({
                tokenAddress: address(wrappedBera),
                amount: beraAmt
            });

            return (_tokens, bgtAmt); // This case: {wBera, bgtAmt} doubleton set.
        }

        // Length of the array depends on whether there is bera or not.
        uint256 length;
        if (beraAmt == 0) {
            length = coinsRewards.length;
        } else {
            length = coinsRewards.length + 1;
        }

        // Populate the tokens array.
        _tokens = new DataTypes.Token[](length);
        _tokens = _parseCoins(
            coinsRewards, length, precompileAddresses.erc20BankPrecompile
        );

        _convertCoins(coinsRewards, precompileAddresses.erc20BankPrecompile);

        // Handle the bera(wBera).
        if (beraAmt != 0) {
            wrappedBera.deposit{value: beraAmt}();

            _tokens[length - 1] = DataTypes.Token({
                tokenAddress: address(wrappedBera),
                amount: beraAmt
            });
        }

        return (_tokens, bgtAmt); // This case: {tokens, bgtAmt} doubleton set and also {tokens, wBera, bgt} triplet set.
    }

    /*//////////////////////////////////////////////////////////////
                            UTILS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Uses the ERC20BankModule to convert the coins to ERC20 data structure.
     * @notice This function does not mutate state and is view only.
     * @param _coins   Cosmos.Coin[]     memory     The coins to convert.
     * @return _tokens DataTypes.Token[] memory     The ERC20 tokens.
     */
    function _parseCoins(
        Cosmos.Coin[] memory _coins,
        uint256 length,
        address erc20BankPrecompile
    ) private view returns (DataTypes.Token[] memory _tokens) {
        _tokens = new DataTypes.Token[](length);

        for (uint256 i; _coins.length > i; i++) {
            address _tokenAddress = address(
                IERC20BankModule(erc20BankPrecompile).erc20AddressForCoinDenom(
                    _coins[i].denom
                )
            );

            if (_tokenAddress == address(0)) {
                revert Errors.DenomNotFound(_coins[i].denom);
            }

            _tokens[i] = DataTypes.Token({
                tokenAddress: _tokenAddress,
                amount: _coins[i].amount
            });
        }

        return _tokens;
    }

    /**
     * @notice Convert the coins to ERC20 tokens through the ERC20BankModule.
     * @param _coins Cosmos.Coin[] memory The coins to convert.
     */
    function _convertCoins(
        Cosmos.Coin[] memory _coins,
        address erc20BankPrecompile
    ) internal {
        for (uint256 i; _coins.length > i; i++) {
            /// TODO: For more defensive code, we can check the balance of the ERC20 token before and after the transfer.
            bool success = IERC20BankModule(erc20BankPrecompile)
                .transferCoinToERC20(_coins[i].denom, _coins[i].amount);

            if (!success) {
                revert Errors.FailedToConvertCoin(
                    _coins[i].denom, _coins[i].amount
                );
            }
        }
    }
}
