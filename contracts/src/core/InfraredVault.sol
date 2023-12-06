// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {EIP5XXX, ERC4626, ERC20} from "@berachain/EIP5XXX.sol";
import {Errors} from "@utils/Errors.sol";
import {IRewardsModule} from "@berachain/Rewards.sol";
import {IDistributionModule} from "@polaris/Distribution.sol";
import {AccessControl} from "@openzeppelin/access/AccessControl.sol";
import {Cosmos} from "@polaris/CosmosTypes.sol";

/**
 * @title Infrared Vault - Reward Distribution Vault
 * @author inhereted from DevBear (https://twitter.com/itsdevbear) & Quant Bear (https://github.com/quant-bear)
 * @notice EIP5XXX represents a vault in which depositors can also be distributed ERC20 tokens rewards.
 */
contract InfraredVault is EIP5XXX, AccessControl {
    // This role is reserved for the infrared main contract.
    bytes32 internal constant _INFRARED_ROLE = keccak256("_INFRARED_ROLE");

    // This is the address of the main contract that deployed this contract.
    address private immutable _INFRARED;

    // This is the address of the pool (dex/lending..etc) that this contract is
    // representing.
    address public immutable POOL_ADDRESS;

    // The Berachain Reward Precompile contract that will be allocating rewards
    // to this vault.
    IRewardsModule public immutable REWARDS_PRECOMPILE;

    // The Berachain Distribution Precompile contract that will be allocating
    // rewards to this vault.
    IDistributionModule public immutable DISTRIBUTION_PRECOMPILE;

    /**
     * @dev Constructor.
     * @param _asset                  The underlying asset.
     * @param _name                   The name of the vault token.
     * @param _symbol                 The symbol of the vault token.
     * @param _rewardTokens           The reward tokens.
     * @param _infrared               The main contract that deployed this contract.
     * @param _poolAddress            The address of the pool (dex/lending..etc) that this contract is representing.
     * @param _rewardsPrecompileAddress      The Berachain Reward Precompile contract that will be allocating rewards to this vault.
     * @param _distributionPrecompileAddress The Berachain Distribution Precompile contract that will be allocating rewards to this vault.
     */
    constructor(
        address _asset,
        string memory _name,
        string memory _symbol,
        address[] memory _rewardTokens,
        address _infrared,
        address _poolAddress,
        address _rewardsPrecompileAddress,
        address _distributionPrecompileAddress,
        address _admin
    ) ERC4626(ERC20(_asset), _name, _symbol) {
        if (address(_asset) == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_infrared == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_poolAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Check if either of the precompiles are zero. One is enough to be non
        // zero to handle the case of only one being used.
        if (
            _rewardsPrecompileAddress == address(0)
                && _distributionPrecompileAddress == address(0)
        ) {
            revert Errors.ZeroAddress();
        }

        // Create the reward containers.
        for (uint256 _i; _i < _rewardTokens.length;) {
            // @dev we are going to be only using partition 0.
            _createNewRewardContainer(_rewardTokens[_i], 0);

            // Iteration is safe here.
            unchecked {
                ++_i;
            }
        }

        // If the distribution precompile is set, set its withdraw address to
        // the infrared contract.
        if (_distributionPrecompileAddress != address(0)) {
            IDistributionModule _distributionPrecompile =
                IDistributionModule(_distributionPrecompileAddress);

            // Make sure that the withdraw address is set.
            if (!_distributionPrecompile.setWithdrawAddress(_infrared)) {
                revert Errors.SetWithdrawAddressFailed();
            }
        }

        // If the rewards precompile is set, set its withdraw address to the
        // infrared contract.
        if (_rewardsPrecompileAddress != address(0)) {
            IRewardsModule _rewardsPrecompile =
                IRewardsModule(_rewardsPrecompileAddress);

            if (!_rewardsPrecompile.setDepositorWithdrawAddress(_infrared)) {
                revert Errors.SetWithdrawAddressFailed();
            }
        }

        // Set the constants.
        _INFRARED = _infrared;
        POOL_ADDRESS = _poolAddress;
        DISTRIBUTION_PRECOMPILE =
            IDistributionModule(_distributionPrecompileAddress);
        REWARDS_PRECOMPILE = IRewardsModule(_rewardsPrecompileAddress);

        // Set the admin.
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        // Set the infrared role.
        _grantRole(_INFRARED_ROLE, _INFRARED);
    }

    /*//////////////////////////////////////////////////////////////
                              Reads
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the reward tokens.
     * @return _rewardTokens address[] The reward tokens.
     */
    function rewardTokens()
        external
        view
        returns (address[] memory _rewardTokens)
    {
        _rewardTokens = new address[](rewardKeys.length);

        for (uint256 _i; _i < rewardKeys.length;) {
            (, _rewardTokens[_i]) = _decodeRewardKey(rewardKeys[_i]);

            // Iteration is safe here.
            unchecked {
                _i++;
            }
        }
    }

    /**
     * @notice The address of the pool.
     * @return _poolAddress address The reward tokens.
     */
    function poolAddress() external view returns (address _poolAddress) {
        return POOL_ADDRESS;
    }

    /*//////////////////////////////////////////////////////////////
                             ADMIN
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev Allows the admin of this contract to set a different withdraw
     * address for the rewards precompile.
     * @param _withdrawAddress address The new withdraw address.
     */
    function changeRewardsWithdrawAddress(address _withdrawAddress)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_withdrawAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (!REWARDS_PRECOMPILE.setDepositorWithdrawAddress(_withdrawAddress)) {
            revert Errors.SetWithdrawAddressFailed();
        }
    }

    /**
     * @dev Allows the admin of this contract to set a different withdraw
     * address for the distribution precompile.
     * @param _withdrawAddress address The new withdraw address.
     */
    function changeDistributionWithdrawAddress(address _withdrawAddress)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_withdrawAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (!DISTRIBUTION_PRECOMPILE.setWithdrawAddress(_withdrawAddress)) {
            revert Errors.SetWithdrawAddressFailed();
        }
    }

    /**
     * @dev Allows the admin of this contract to add reward tokens.
     * @param _rewardTokens address[] The reward tokens to add.
     */
    function addRewardTokens(address[] calldata _rewardTokens)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        // Create the reward containers.
        for (uint256 _i; _i < _rewardTokens.length;) {
            if (_rewardTokens[_i] == address(0)) {
                revert Errors.ZeroAddress();
            }

            // @dev we are going to be only using partition 0.
            _createNewRewardContainer(_rewardTokens[_i], 0);

            // Iteration is safe here.
            unchecked {
                _i++;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                            INFRARED ONLY
    //////////////////////////////////////////////////////////////*/

    /**
     * @dev The Infrared contract can claim the rewards in behalf of the vault.
     * @dev Since withdraw address set in constructor, it will be credited to
     * that address.
     * @return _rewards Cosmos.Coin[] The rewards.
     */
    function claimRewardsPrecompile()
        external
        onlyRole(_INFRARED_ROLE)
        returns (Cosmos.Coin[] memory _rewards)
    {
        return REWARDS_PRECOMPILE.withdrawAllDepositorRewards(POOL_ADDRESS);
    }

    /*//////////////////////////////////////////////////////////////
                      EIP5XXX OVERRIDES
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the current epoch per week for a reward token.
     * @return _rk  bytes32[]  The reward token to get the current epoch per
     * week for.
     */
    function rewardKeysOf(address)
        public
        view
        override
        returns (bytes32[] memory _rk)
    {
        return rewardKeys;
    }

    /**
     * @notice Returns the total amount of assets held by the vault.
     * @return _assets uint256 The total amount of assets held by the vault.
     */
    function totalAssets() public view override returns (uint256 _assets) {
        return asset.balanceOf(address(this));
    }

    /**
     * @notice Returns the total weight of a partition, in this vault it is the
     * total supply of the vault.
     * @return _tw uint256 The total weight of the partition.
     */
    function totalWeight(uint96) public view override returns (uint256 _tw) {
        return totalSupply;
    }

    /**
     * @notice Returns the weight of a user, in this vault it is the balance of
     * the users shares of the vault.
     * @param _user address The user to get the weight of.
     * @return _wo  uint256 The eight of the user in the partition.
     */
    function weightOf(address _user, uint96)
        public
        view
        override
        returns (uint256 _wo)
    {
        return balanceOf[_user];
    }

    /*//////////////////////////////////////////////////////////////
                      Internal
    //////////////////////////////////////////////////////////////*/

    function _decodeRewardKey(bytes32 _packedData)
        internal
        pure
        returns (uint96 _partition, address _reward)
    {
        // Extracting the partition
        _partition = uint96(uint256(_packedData) >> (256 - 96)); // Shift right
        // by (256-96)=160 bits

        // Extracting the reward (address)
        _reward = address(uint160(uint256(_packedData)));
    }
}
