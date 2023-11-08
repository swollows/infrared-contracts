// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {SafeTransferLib} from "@solmate/utils/SafeTransferLib.sol";
import {IRewardsModule} from "@berachain/Rewards.sol";
import {IDistributionModule} from "@polaris/Distribution.sol";
import {IERC20Module} from "@polaris/ERC20Module.sol";
import {Cosmos} from "@polaris/CosmosTypes.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Errors} from "@utils/Errors.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";

abstract contract BerachainHandler {
    using SafeTransferLib for ERC20;

    // Berachain Precompiled Contracts.
    address public immutable REWARDS_PRECOMPILE;
    address public immutable DISTRIBUTION_PRECOMPILE;
    address public immutable ERC20_PRECOMPILE;

    // The cosmos sdk denomination for BGT.
    string public bgtDenom;

    /*//////////////////////////////////////////////////////////////
                        CONSTRUCTOR/INITIALIZATION LOGIC
    //////////////////////////////////////////////////////////////*/
    constructor(
        address _rewardsPrecompileAddress,
        address _distributionPrecompileAddress,
        address _erc20PrecompileAddress,
        string memory _bgtDenom
    ) {
        if (_rewardsPrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_distributionPrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_erc20PrecompileAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (bytes(_bgtDenom).length == 0) {
            revert Errors.ZeroString();
        }

        REWARDS_PRECOMPILE = _rewardsPrecompileAddress;
        DISTRIBUTION_PRECOMPILE = _distributionPrecompileAddress;
        ERC20_PRECOMPILE = _erc20PrecompileAddress;
        bgtDenom = _bgtDenom;
    }

    /*//////////////////////////////////////////////////////////////
                      Write Methods
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Withdraws the rewards for the given validator from the
     * distribution module.
     * @param _validator  address              The validator to withdraw rewards
     * for.
     * @return _coins     Cosmos.Coin[] memory The coins that were withdrawn.
     */
    function _withdrawDistrRewards(address _validator) internal returns (Cosmos.Coin[] memory _coins) {
        return IDistributionModule(DISTRIBUTION_PRECOMPILE).withdrawDelegatorReward(address(this), _validator);
    }

    /**
     * @notice WithdrawRewards Calls into the vault, to withdraw rewards to this
     * address.
     * @param _vault        address              The address of the vault to
     * call into.
     * @return _coins       Cosmos.Coin[] memory The coins that were withdrawn.
     */
    function _withdrawPOLRewards(address _vault) internal returns (Cosmos.Coin[] memory _coins) {
        return IInfraredVault(_vault).claimRewardsPrecompile();
    }

    /*//////////////////////////////////////////////////////////////
                        Utils
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Parses a Cosmos coin into a Token struct.
     * @param _coins   Cosmos.Coin[] memory     The coins to parse.
     * @return _tokens DataTypes.Token[] memory The parsed tokens.
     */
    function _parseCoins(Cosmos.Coin[] memory _coins) internal view returns (DataTypes.Token[] memory _tokens) {
        // Using the ERC20Module, get the token address for each coin denom and
        // return a Token struct.
        _tokens = new DataTypes.Token[](_coins.length);
        for (uint256 i = 0; i < _coins.length; i++) {
            address _addr = address(IERC20Module(ERC20_PRECOMPILE).erc20AddressForCoinDenom(_coins[i].denom));

            if (_addr == address(0)) {
                revert Errors.ZeroAddress();
            }

            _tokens[i] = DataTypes.Token({tokenAddress: _addr, amount: _coins[i].amount});
        }

        return _tokens;
    }

    /**
     * @notice Merges two Cosmos coin arrays into one.
     * @param _coinsA       Cosmos.Coin[] memory The first array of coins.
     * @param _coinsB       Cosmos.Coin[] memory The second array of coins.
     * @return _mergedCoins Cosmos.Coin[] memory The merged array of coins.
     */
    function _mergeCoinsArray(Cosmos.Coin[] memory _coinsA, Cosmos.Coin[] memory _coinsB)
        internal
        pure
        returns (Cosmos.Coin[] memory _mergedCoins)
    {
        _mergedCoins = new Cosmos.Coin[](_coinsA.length + _coinsB.length);

        // Populate the merged array with the first array.
        for (uint256 i = 0; i < _coinsA.length; i++) {
            _mergedCoins[i] = _coinsA[i];
        }

        // Populate the merged array with the second array, starting at the end
        // of the first array.
        for (uint256 i = 0; i < _coinsB.length; i++) {
            _mergedCoins[i + _coinsA.length] = _coinsB[i];
        }

        return _mergedCoins;
    }

    /**
     * @notice Converts a Cosmos Coins into ERC20 through the ERC20Module.
     * @param _coins Cosmos.Coin[] memory The coins to convert.
     */
    function _convertCoins(Cosmos.Coin[] memory _coins) internal {
        for (uint256 i = 0; i < _coins.length; i++) {
            if (!IERC20Module(ERC20_PRECOMPILE).transferCoinToERC20(_coins[i].denom, _coins[i].amount)) {
                revert Errors.ERC20ModuleTransferFailed();
            }
        }
    }

    /**
     * @notice Removes the BGT from the given array of coins.
     * @param _coins          Cosmos.Coin[] memory The coins to remove the BGT
     * from.
     * @return _newCoins      Cosmos.Coin[] memory The coins with the BGT
     * removed.
     * @return _amt           uint256              The amount of BGT that was
     * removed.
     */
    function _removeBGTFromCoins(Cosmos.Coin[] memory _coins)
        internal
        view
        returns (Cosmos.Coin[] memory _newCoins, uint256 _amt)
    {
        uint256 _bgtIndex = _indexOfBGT(_coins);

        // If BGT is not in the array, return the original array.
        if (_bgtIndex == type(uint256).max) {
            return (_coins, 0);
        }

        // If BGT is in the array, remove it and return the new array.
        _newCoins = new Cosmos.Coin[](_coins.length - 1);
        for (uint256 i = 0; i < _coins.length; i++) {
            if (i != _bgtIndex) {
                _newCoins[i] = _coins[i];
            }
        }

        return (_newCoins, _coins[_bgtIndex].amount);
    }

    /**
     * @notice Checks if the given string is the same.
     * @param _a       string The first string.
     * @param _b       string The second string.
     * @return _isSame bool Whether or not the strings are the same.
     */
    function _isStringSame(string memory _a, string memory _b) private pure returns (bool _isSame) {
        return keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }

    /**
     * @dev Returns the index of the BGT in the given array of coins.
     * @param   _coins  Cosmos.Coin[] memory The coins to check for the presence
     * of BGT.
     * @return _index   uint256              The index of BGT in the array or
     * type(uint256).max if not found.
     */
    function _indexOfBGT(Cosmos.Coin[] memory _coins) private view returns (uint256 _index) {
        for (uint256 i = 0; i < _coins.length; i++) {
            if (_isStringSame(_coins[i].denom, bgtDenom)) {
                return i;
            }
        }

        return type(uint256).max;
    }
}
