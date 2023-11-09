// SPDX-License-Identifier: MIT
//
// Copyright (c) 2023 Berachain Foundation
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

pragma solidity 0.8.20;

/**
 * @dev Interface of the erc20 dex module's precompiled contract
 */
interface IERC20DexModule {
    /////////////////////////////////////// READ METHODS
    // //////////////////////////////////////////
    /**
     * @dev previews a single swap into a pool.
     * @param kind The swap kind. (GIVEN_IN vs GIVEN_OUT)
     * @param pool The address of the pool.
     * @param baseAsset The base asset.
     * @param baseAssetAmount The amount of base asset.
     * @param quoteAsset The quote asset.
     * @return asset The token to be received from the pool.
     * @return amount The amount of tokens to be received from the pool.
     */
    function getPreviewSwapExact(
        SwapKind kind,
        address pool,
        address baseAsset,
        uint256 baseAssetAmount,
        address quoteAsset
    ) external view returns (address asset, uint256 amount);

    /**
     * @dev previews a batch swap.
     * @param kind The swap kind. (GIVEN_IN vs GIVEN_OUT)
     * @param swaps The swaps to be executed.
     * @return asset The token to be received from the pool.
     * @return amount The amount of tokens to be received from the pool.
     */
    function getPreviewBatchSwap(SwapKind kind, BatchSwapStep[] memory swaps)
        external
        view
        returns (address asset, uint256 amount);

    /**
     * @dev previews the balance of tokens currently in the liquidity pool.
     * @param pool The address of the pool.
     * @return asset The tokens in the pool.
     * @return amounts The amount of tokens in the pool.
     */
    function getLiquidity(address pool)
        external
        view
        returns (address[] memory asset, uint256[] memory amounts);

    /**
     * @dev previews the total amount of shares of the liquidity pool.
     * @param pool The address of the pool.
     * @return assets The share tokens / LP tokens of the pool.
     * @return amounts The amount share tokens / LP tokens of the pool.
     */
    function getTotalShares(address pool)
        external
        view
        returns (address[] memory assets, uint256[] memory amounts);

    /**
     * @dev previews the exchange rate between two assets in a pool.
     * Note: the returned uint is represented as a value of up to 18 decimal
     * precision
     * @param pool The address of the pool.
     * @param baseAsset The base asset to get the exchange rate for.
     * @param quoteAsset The quote asset to get the exchange rate for.
     * @return rate The exchange rate between the two assets.
     */
    function getExchangeRate(
        address pool,
        address baseAsset,
        address quoteAsset
    ) external view returns (uint256);

    /**
     * @dev previews the amount of LP tokens that will be received for adding
     * liquidity to a pool.
     * @param pool The address of the pool.
     * @param assets The assets to add to the pool.
     * @param amounts The amounts of assets to add to the pool.
     * @return shares The LP tokens that will be received for adding liquidity
     * to the pool.
     * @return shareAmounts The amount of LP tokens that will be received for
     * adding liquidity to the pool.
     * @return liquidity The liquidity in the pool.
     * @return liquidityAmounts The amount of liquidity in the pool.
     */
    function getPreviewSharesForLiquidity(
        address pool,
        address[] memory assets,
        uint256[] memory amounts
    )
        external
        view
        returns (
            address[] memory shares,
            uint256[] memory shareAmounts,
            address[] memory liquidity,
            uint256[] memory liquidityAmounts
        );

    /**
     * @dev previews the amount of tokens that can be added to a pool without
     * impacting the exchange rate.
     * @param pool The address of the pool.
     * @param liquidity The tokens to add to the pool.
     * @param amounts The amounts of tokens to add to the pool.
     * @return shares The LP tokens that will be received for adding liquidity
     * to the pool.
     * @return shareAmounts The amount of LP tokens that will be received for
     * adding liquidity to the pool.
     * @return liqOut The pool's asset tokens.
     * @return liquidityAmounts The amount of liquidity assets not used.
     */
    function getPreviewAddLiquidityStaticPrice(
        address pool,
        address[] memory liquidity,
        uint256[] memory amounts
    )
        external
        view
        returns (
            address[] memory shares,
            uint256[] memory shareAmounts,
            address[] memory liqOut,
            uint256[] memory liquidityAmounts
        );

    /**
     * @dev previews the amount of shares that will be received from adding one
     * sided liquidity to a pool.
     * @param pool The address of the pool.
     * @param asset The token to be added into the liquidity pool.
     * @param amount The amount of token to be added into the liquidity pool.
     * @return assets The share/LP token to be received
     * @return amounts The amount of LP tokens to be received.
     */
    function getPreviewSharesForSingleSidedLiquidityRequest(
        address pool,
        address asset,
        uint256 amount
    )
        external
        view
        returns (address[] memory assets, uint256[] memory amounts);

    /**
     * @dev previews the amount of tokens that will be received from adding
     * liquidity without swapping.
     * @param pool The address of the pool.
     * @param assets The tokens to be added into the liquidity pool.
     * @param amounts The amounts of tokens to be added into the liquidity pool.
     * @return shares The LP tokens that will be received for adding liquidity
     * to the pool.
     * @return shareAmounts The amount of LP tokens that will be received for
     * adding liquidity to the pool.
     * @return liqOut The pool's asset tokens.
     * @return liquidityAmounts The amount of liquidity assets added.
     */
    function getPreviewAddLiquidityNoSwap(
        address pool,
        address[] memory assets,
        uint256[] memory amounts
    )
        external
        view
        returns (
            address[] memory shares,
            uint256[] memory shareAmounts,
            address[] memory liqOut,
            uint256[] memory liquidityAmounts
        );

    /**
     * @dev previews the amount of tokens that will be received from burning LP
     * tokens to remove liquidity.
     * @param pool The address of the pool.
     * @param asset The LP token to be burned.
     * @param amount The amount of LP tokens to be burned.
     * @return assets The tokens to be received for burning shares/LP tokens.
     * @return amounts The amount of tokens to be received for burning shares/LP
     * tokens.
     */
    function getPreviewBurnShares(address pool, address asset, uint256 amount)
        external
        view
        returns (address[] memory assets, uint256[] memory amounts);

    /**
     * @dev previews the amount of LP tokens required to be removed to withdraw
     * a specific amount of one asset from the pool.
     * @param pool The address of the pool.
     * @param assetIn The target asset to be received from burning LP tokens.
     * @param assetAmount The amount of target asset to be received from burning
     * LP tokens.
     * @return assets The asset received for burning the LP tokens.
     * @return amounts The amount of asset received for burning the LP tokens.
     */
    function getRemoveLiquidityExactAmountOut(
        address pool,
        address assetIn,
        uint256 assetAmount
    )
        external
        view
        returns (address[] memory assets, uint256[] memory amounts);

    /**
     * @dev previews the amount of one asset that will be received for burning
     * LP tokens.
     * @param pool The address of the pool.
     * @param assetOut The target asset to be received from burning LP tokens.
     * @param sharesIn The amount of LP tokens to be burned.
     * @return assets The asset received for burning the LP tokens.
     * @return amounts The amount of target asset received for burning the LP
     * tokens.
     */
    function getRemoveLiquidityOneSideOut(
        address pool,
        address assetOut,
        uint256 sharesIn
    )
        external
        view
        returns (address[] memory assets, uint256[] memory amounts);

    /**
     * @dev gets the pool name for a given pool address.
     * @param pool The address of the pool.
     * @return name The name of the pool.
     */
    function getPoolName(address pool) external view returns (string memory);

    /**
     * @dev gets the pool options for a given pool address.
     * @param pool The address of the pool.
     * @return options The options of the pool.
     */
    function getPoolOptions(address pool)
        external
        view
        returns (PoolOptions memory);

    /////////////////////////////////////// WRITE METHODS
    // //////////////////////////////////////////

    /**
     * @dev Performs a swap with a single Pool.
     * NOTE: If the limit is set as 0, there is no maximum slippage set.
     * NOTE: The type of swap (GIVEN_IN vs GIVEN_OUT) determines if the limit is
     * a max input, or a min output.
     * @param kind The type of swap.
     * @param poolId The address of the pool.
     * @param assetIn The asset to be sent to the pool.
     * @param amountIn The amount of asset in to be sent to the pool.
     * @param assetOut The asset to be received from the pool.
     * @param amountOut The amount of asset out to be received from the pool.
     * @param deadline The deadline for the swap.
     * @return assets The asset received from the swap.
     * @return amounts The amount of asset received from the swap.
     */
    function swap(
        SwapKind kind,
        address poolId,
        address assetIn,
        uint256 amountIn,
        address assetOut,
        uint256 amountOut,
        uint256 deadline
    )
        external
        payable
        returns (address[] memory assets, uint256[] memory amounts);

    /**
     * @dev Performs a swap with a single Pool.
     * NOTE: If the limit is set as 0, there is no maximum slippage set.
     * NOTE: The type of swap (GIVEN_IN vs GIVEN_OUT) determines if the limit is
     * a max input, or a min output.
     * @param kind The type of swap.
     * @param swaps The swap steps to be executed.
     * @param deadline The deadline for the swap.
     * @return assets The asset received from the swap.
     * @return amounts The amount of asset received from the swap.
     */
    function batchSwap(
        SwapKind kind,
        BatchSwapStep[] memory swaps,
        uint256 deadline
    )
        external
        payable
        returns (address[] memory assets, uint256[] memory amounts);

    /**
     * @dev Creates a new pool.
     * @param name The name of the pool.
     * @param assetsIn The assets to be added to the pool.
     * @param amountsIn The amounts of assets to be added to the pool.
     * @param poolType The type of pool to be created. (Currently only
     * `balancer`style pools are supported)
     * @param options The options for the pool.
     * @return pool The address of the newly created pool.
     */
    function createPool(
        string memory name,
        address[] memory assetsIn,
        uint256[] memory amountsIn,
        string memory poolType,
        PoolOptions memory options
    ) external payable returns (address);

    /**
     * @dev Adds liquidity to a pool.
     * @param pool The address of the pool.
     * @param receiver The address to receive the LP tokens.
     * @param assetsIn The assets to be added to the pool.
     * @param amountsIn The amounts of assets to be added to the pool.
     * @return shares The LP tokens that were received for adding liquidity to
     * the pool.
     * @return shareAmounts The amount of LP tokens that were received for
     * adding liquidity to the pool.
     * @return liquidity The liquidity in the pool.
     * @return liquidityAmounts The amount of liquidity in the pool.
     */
    function addLiquidity(
        address pool,
        address receiver,
        address[] memory assetsIn,
        uint256[] memory amountsIn
    )
        external
        payable
        returns (
            address[] memory shares,
            uint256[] memory shareAmounts,
            address[] memory liquidity,
            uint256[] memory liquidityAmounts
        );

    /**
     * @dev Removes liquidity from a pool by burning shares.
     * @param pool The address of the pool.
     * @param withdrawAddress The address to receive the assets from burning the
     * LP shares.
     * @param assetIn The LP token to be burned.
     * @param amountIn The amount of LP tokens to be burned.
     * @return liquidity The tokens received from burning the LP tokens.
     * @return liquidityAmounts The amount of tokens received from burning the
     * LP tokens.
     */
    function removeLiquidityBurningShares(
        address pool,
        address withdrawAddress,
        address assetIn,
        uint256 amountIn
    )
        external
        payable
        returns (address[] memory liquidity, uint256[] memory liquidityAmounts);

    /**
     * @dev Removes a specific amount of liquidity from the pool, with a maximum
     * number of shares to be burned.
     * @param pool The address of the pool.
     * @param withdrawAddress The address to receive the assets from burning the
     * LP shares.
     * @param assetOut The target asset to be received from burning the LP
     * shares.
     * @param amountOut The target amount of asset to be received from burning
     * the LP shares.
     * @param sharesIn The LP token to be burned
     * @param maxSharesIn The maximum amount (limit) of LP tokens to be burned.
     * @return shares The LP tokens that were burned.
     * @return shareAmounts The amount of LP tokens that were burned.
     * @return liquidity The tokens received from burning the LP tokens.
     * @return liquidityAmounts The amount of tokens received from burning the
     * LP tokens.
     */
    function removeLiquidityExactAmount(
        address pool,
        address withdrawAddress,
        address assetOut,
        uint256 amountOut,
        address sharesIn,
        uint256 maxSharesIn
    )
        external
        payable
        returns (
            address[] memory shares,
            uint256[] memory shareAmounts,
            address[] memory liquidity,
            uint256[] memory liquidityAmounts
        );

    ///////////////////////////////////////// STRUCTS
    // //////////////////////////////////////////////

    /**
     * @dev SwapKind is an enum which represents what type of swap it is.
     * There are two swap kinds:
     * - 'GIVEN_IN' swaps, where the amount of tokens in (sent to the Pool) is
     * known, and the Pool determines the amount of tokens out.
     * - 'GIVEN_OUT' swaps, where the amount of tokens out (received from the
     * Pool) is known, and the Pool determines the amount of tokens in.
     */
    enum SwapKind {
        GIVEN_IN,
        GIVEN_OUT
    }

    /**
     * @dev A single swap step to be executed in a batch swap.
     * NOTE: The steps are executed sequentially, so the order in which they're
     * passed in must logically make sense.
     * Example: Given pools of (A,B) (B,C) (C,D), the following steps would be
     * valid: A-B, B->C, C->D.
     * The following steps would be invalid: A->B, C->D, B->C.
     * @param poolId The address of the pool.
     * @param assetIn The input asset of the swap.
     * @param amountIn The amount of the input asset.
     * @param assetOut The output asset of the swap.
     * @param amountOut The amount of the output asset.
     * @param userData The user data to be passed to the pool.
     */
    struct BatchSwapStep {
        address poolId;
        address assetIn;
        uint256 amountIn;
        address assetOut;
        uint256 amountOut;
        bytes userData;
    }

    /**
     * @dev The configuration options for a pool. This contains asset weights,
     * and swap fees.
     * NOTE: The swap fees must be one of the following options: (0.05%, 0.3%,
     * 1%)
     */
    struct PoolOptions {
        AssetWeight[] weights;
        uint256 swapFee;
    }

    /**
     * @dev An asset weight to be used for pool options.
     * NOTE: The weights do not have to add up to any specific number. The
     * weight given here is normalized against the total weight.
     */
    struct AssetWeight {
        address asset;
        uint256 weight;
    }
}
