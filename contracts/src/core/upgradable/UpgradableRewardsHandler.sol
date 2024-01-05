// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External dependencies.
import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {UUPSUpgradeable} from
    "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from
    "@openzeppelin-upgradeable/access/OwnableUpgradeable.sol";

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
contract UpgradableRewardsHandler is UUPSUpgradeable, OwnableUpgradeable {
    using SafeTransferLib for ERC20;

    // Berachain Precompiled Contract and pre deployed contracts.
    IRewardsModule public REWARDS_PRECOMPILE;
    IDistributionModule public DISTRIBUTION_PRECOMPILE;
    IERC20BankModule public ERC20_BANK_PRECOMPILE;
    IWBERA public WBERA;

    // The cosmos sdk coin denomination for the berachain token.
    string public constant bgtDenom = "abgt";
    string public constant beraDenom = "abera";

    /**
     * @notice Initialize the contract.
     * @param _rewardsPrecompileAddress       address    The address of the rewards precompile.
     * @param _distributionPrecompileAddress  address    The address of the distribution precompile.
     * @param  _erc20PrecompileAddress        address    The address of the erc20 precompile.
     */
    function initialize(
        address _rewardsPrecompileAddress,
        address _distributionPrecompileAddress,
        address _erc20PrecompileAddress,
        address _wberaAddress
    ) external initializer {
        if (_rewardsPrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_distributionPrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_erc20PrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_wberaAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        REWARDS_PRECOMPILE = IRewardsModule(_rewardsPrecompileAddress);
        DISTRIBUTION_PRECOMPILE =
            IDistributionModule(_distributionPrecompileAddress);
        ERC20_BANK_PRECOMPILE = IERC20BankModule(_erc20PrecompileAddress);
        WBERA = IWBERA(_wberaAddress);

        __Ownable_init(msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                             WRITES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets the withdraw address for the rewards/distribution module.
     * @param _contract        DataTypes.RewardContract The contract to set the withdraw address for.
     * @param _withdrawAddress address                  The address to set as the withdraw address.
     * @return _success        bool                     Whether the call was successful or not.
     */
    function setWithdrawAddress(
        DataTypes.RewardContract _contract,
        address _withdrawAddress,
        address _storageAddress
    ) external returns (bool) {
        if (_withdrawAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_contract == DataTypes.RewardContract.Distribution) {
            return UpgradableRewardsHandler(_storageAddress)
                .DISTRIBUTION_PRECOMPILE().setWithdrawAddress(_withdrawAddress);
        }

        if (_contract == DataTypes.RewardContract.Rewards) {
            return UpgradableRewardsHandler(_storageAddress).REWARDS_PRECOMPILE(
            ).setDepositorWithdrawAddress(_withdrawAddress);
        }
    }

    /**
     * @notice Redeems rewards from the rewards module, which will be in the form of abgt.
     * @return _bgtAmt uint256 The amount of bgt that was redeemed.
     */
    function claimRewardsPrecompile(address storageContract)
        external
        returns (uint256 _bgtAmt)
    {
        Cosmos.Coin[] memory rewards = UpgradableRewardsHandler(storageContract)
            .REWARDS_PRECOMPILE().withdrawAllDepositorRewards(address(this)); // assumes caller calls in

        // Invariant that rewards is abgt:  https://github.com/berachain/berachain/blob/ad8eefa4f27a4193209612542111090fbd7fd92f/x/cosmos/distribution/keeper/allocate.go#L119
        assert(rewards.length <= 1); // Sanity check. either 0 or 1.

        if (rewards.length == 0) {
            return 0;
        }

        // Assert that the rewards are in the form of abgt.
        assert(PureUtils.isStringSame(rewards[0].denom, bgtDenom)); // Sanity check. Should always be true.

        return rewards[0].amount;
    }

    /**
     * @notice Redeems rewards from the distribution module, which will be in the form of []( element of sdk.Coin, bera, bgt).
     * @return _tokens DataTypes.Token[] memory The list of tokens that were redeemed to the msg.sender (the delegate caller)
     * @return _bgtAmt uint256                  The amount of bgt that was redeemed.
     */
    function claimDistrPrecompile(address _validator, address storageContract)
        external
        returns (DataTypes.Token[] memory _tokens, uint256 _bgtAmt)
    {
        Cosmos.Coin[] memory rewards = UpgradableRewardsHandler(storageContract)
            .DISTRIBUTION_PRECOMPILE().withdrawDelegatorReward(
            msg.sender, _validator
        );

        if (rewards.length == 0) {
            return (new DataTypes.Token[](0), 0); // This case: {} empty set.
        }

        (Cosmos.Coin[] memory nonBgtRewards, uint256 bgtAmt) =
            PureUtils.removeCoinFromCoins(rewards, bgtDenom);

        if (nonBgtRewards.length == 0) {
            return (new DataTypes.Token[](0), bgtAmt); // This case: {bgtAmt} singleton set.
        }

        IWBERA wrappedBera = UpgradableRewardsHandler(storageContract).WBERA();

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
        _tokens = _parseCoins(coinsRewards, length, storageContract);

        _convertCoins(coinsRewards, storageContract);

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
                            READS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the withdraw address for the rewards.
     * @param  _depositor       address The depositor address.
     * @return _withdrawAddress address The withdraw address.
     */
    function getWithdrawAddress(address _depositor, address storageContract)
        external
        view
        returns (address _withdrawAddress)
    {
        return UpgradableRewardsHandler(storageContract).REWARDS_PRECOMPILE()
            .getDepositorWithdrawAddress(_depositor);
    }

    /**
     * @notice Authorize an upgrade to `_newImplementation`.
     * @dev TODO: Please implement this function.
     */
    function _authorizeUpgrade(address) internal override onlyOwner {}

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
        address storageContract
    ) private view returns (DataTypes.Token[] memory _tokens) {
        _tokens = new DataTypes.Token[](length);

        for (uint256 i; _coins.length > i; i++) {
            address _tokenAddress = address(
                UpgradableRewardsHandler(storageContract).ERC20_BANK_PRECOMPILE(
                ).erc20AddressForCoinDenom(_coins[i].denom)
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
    function _convertCoins(Cosmos.Coin[] memory _coins, address storageContract)
        internal
    {
        for (uint256 i; _coins.length > i; i++) {
            bool success = UpgradableRewardsHandler(storageContract)
                .ERC20_BANK_PRECOMPILE().transferCoinToERC20(
                _coins[i].denom, _coins[i].amount
            );

            if (!success) {
                revert Errors.FailedToConvertCoin(
                    _coins[i].denom, _coins[i].amount
                );
            }
        }
    }
}
