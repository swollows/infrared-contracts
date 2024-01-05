// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// External dependencies.
import {AccessControl} from "@openzeppelin/access/AccessControl.sol";

// Internal dependencies.
import {EIP5XXX, ERC4626, ERC20} from "@berachain/vaults/EIP5XXX.sol";
import {IUpgradableRewardsHandler} from
    "@interfaces/IUpgradableRewardsHandler.sol";
import {Errors} from "@utils/Errors.sol";
import {DataTypes} from "@utils/DataTypes.sol";
import {Cosmos} from "@polaris/CosmosTypes.sol";

/**
 * @title InfraredVault
 * @notice This contract is the main vault contract that is deployed by the
 * infrared contract. It is the main contract that holds the assets and
 * distributes the rewards.
 * @dev This contract is an implementation of the EIP5XXX standard.
 */
contract InfraredVault is EIP5XXX, AccessControl {
    // This role is reserved for the main infrared contract.
    bytes32 public constant INFRARED_ROLE = keccak256("INFRARED_ROLE");

    // This is the address of the main contract that deployed this contract.
    address public immutable INFRARED;

    // This is the address of the pool (dex/lending..etc) that this contract is
    // representing.
    address public immutable POOL_ADDRESS;

    // The upgradable berachain handler that vacilitates the calls to the
    // berachain precompiles.
    IUpgradableRewardsHandler public immutable UPGRADABLE_REWARDS_HANDLER;

    // Events.
    event ChangedWithdrawAddress(address indexed withdrawAddress);

    constructor(
        address _asset,
        string memory _name,
        string memory _symbol,
        address[] memory _rewardTokens,
        address _infrared,
        address _poolAddress,
        address _upgradableBerachainHandlerAddress,
        address _admin
    ) ERC4626(ERC20(_asset), _name, _symbol) {
        if (_infrared == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_poolAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_upgradableBerachainHandlerAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_admin == address(0)) {
            revert Errors.ZeroAddress();
        }

        // Set the constants.
        INFRARED = _infrared;
        POOL_ADDRESS = _poolAddress;
        UPGRADABLE_REWARDS_HANDLER =
            IUpgradableRewardsHandler(_upgradableBerachainHandlerAddress);

        // Create the reward containers.
        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            if (_rewardTokens[i] == address(0)) {
                revert Errors.ZeroAddress();
            }

            // No need to have partial shares.
            _createNewRewardContainer(_rewardTokens[i], 0);
        }

        // Set the withdraw address to the `INFRARED` address, allowing it to claim rewards in behalf of the vault.
        // _setWithdrawAddress(_infrared); // delegate call is not possible in constructot, will be moved to infrared contract

        // Set the roles.
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        _grantRole(INFRARED_ROLE, INFRARED);
    }

    /*//////////////////////////////////////////////////////////////
                            READS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the reward tokens this vault is supporting.
     * @return _rewardTokens address[] The reward tokens this vault is supporting.
     */
    function rewardTokens()
        external
        view
        returns (address[] memory _rewardTokens)
    {
        _rewardTokens = new address[](rewardKeys.length);
        // Loop through the reward keys and decode them to get the reward token.
        for (uint256 i = 0; i < rewardKeys.length; i++) {
            (, _rewardTokens[i]) = _decodeRewardKey(rewardKeys[i]);
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
     * @notice Changes the withdraw address for the rewards module.
     * @dev    This function can only be called by the admin.
     * @dev    We only care about the rewards module since there is no BGT in this vault.
     * @param _withdrawAddress  address  The address to set as the withdraw address.
     */
    function changeWithdrawAddress(address _withdrawAddress)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        if (_withdrawAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        if (_withdrawAddress == address(0)) {
            revert Errors.ZeroAddress();
        }

        (bool success, bytes memory data) = address(UPGRADABLE_REWARDS_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_REWARDS_HANDLER.setWithdrawAddress.selector,
                DataTypes.RewardContract.Rewards,
                _withdrawAddress,
                address(UPGRADABLE_REWARDS_HANDLER)
            )
        );

        bool result = abi.decode(data, (bool));

        // Ensure the call was successful.
        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        // Ensure the data returned is correct.
        if (!result) {
            revert Errors.WrongDataResponse();
        }

        emit ChangedWithdrawAddress(_withdrawAddress);
    }

    /**
     * @notice Adds a reward token to the vault.
     * @dev    This function can only be called by the admin.
     * @param _rewardTokens  address[] calldata The reward tokens to add.
     */
    function addRewardTokens(address[] calldata _rewardTokens)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            if (_rewardTokens[i] == address(0)) {
                revert Errors.ZeroAddress();
            }

            // No need to have partial shares.
            _createNewRewardContainer(_rewardTokens[i], 0);
        }
    }

    /*//////////////////////////////////////////////////////////////
                        ONLY INFRARED.
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Claims all the rewards for this vault.
     * @dev    This function can only be called by the INFRARED.
     * @return _amt uint256 The amount of `abgt` that was claimed to the withdraw address.
     */
    function claimRewardsPrecompile()
        external
        onlyRole(INFRARED_ROLE)
        returns (uint256 _amt)
    {
        // Ensure that the withdraw address is set to the INFRARED address.
        address withdrawAddress = _getDepositorWithdrawAddress();
        if (withdrawAddress != INFRARED) {
            revert Errors.WithdrawAddressNotSet();
        }

        return _claim();
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
                            UTILS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Decodes the reward key and returns the partition and reward.
     * @param _packedData  bytes32  The packed data to decode.
     * @return _partition  uint96   The partition of the reward.
     * @return _reward     address  The reward (address).
     */
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

    /**
     * @notice Calls the upgradable rewards handler to get the withdraw address of this vault.
     * @return _withdrawAddress address The withdraw address of this vault.
     */
    function _getDepositorWithdrawAddress()
        private
        returns (address _withdrawAddress)
    {
        // Delegate call to the upgradable rewards handler, getting the withdraw address for the rewards module.
        (bool success, bytes memory data) = address(UPGRADABLE_REWARDS_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_REWARDS_HANDLER.getWithdrawAddress.selector,
                address(this), // The depositor address is this contract.
                address(UPGRADABLE_REWARDS_HANDLER) //
            )
        );

        // Ensure the call was successful.
        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        // Decode and return the withdraw address.
        return abi.decode(data, (address));
    }

    /**
     * @notice Calls the upgradable rewards handler to claim all the rewards for this vault.
     * @return _amt uint256 The amount of `abgt` that was claimed to the withdraw address.
     */
    function _claim() private returns (uint256 _amt) {
        (bool success, bytes memory data) = address(UPGRADABLE_REWARDS_HANDLER)
            .delegatecall(
            abi.encodeWithSelector(
                UPGRADABLE_REWARDS_HANDLER.claimRewardsPrecompile.selector,
                address(UPGRADABLE_REWARDS_HANDLER)
            )
        );

        if (!success) {
            revert Errors.DelegateCallFailed();
        }

        _amt = abi.decode(data, (uint256));
    }
}
