// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.19;

/* External */
import {ERC20, ERC4626} from '@solmate/mixins/ERC4626.sol';
import {SafeTransferLib} from '@solmate/utils/SafeTransferLib.sol';

/* solhint-disable */

/**
 * @title EIP5XXX - Reward Distribution Vault
 *     @author DevBear (https://twitter.com/itsdevbear) & Quant Bear (https://github.com/quant-bear)
 *     @notice EIP5XXX represents a vault in which depositors can also be distributed  ERC20 tokens rewards.
 */
abstract contract EIP5XXX is ERC4626 {
    using SafeTransferLib for ERC20;

    /*//////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    uint256 internal constant RAY = 1e27;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    ///@notice emitted when a claim approval occurs
    event ClaimApproval(address indexed owner, address indexed claimer, address indexed reward, uint256 amount);

    ///@notice emitted when rewards are claimed
    event Claimed(
        address indexed caller,
        address indexed owner,
        address receiver,
        address indexed reward,
        uint256 amount
    );

    ///@notice emitted when rewards are supplied
    event Supplied(address indexed caller, address indexed supplier, address indexed reward, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                             REWARDS STORAGE
    //////////////////////////////////////////////////////////////*/

    // Store a list of rewardKeys for iteration
    bytes32[] public rewardKeys;

    /// @notice approve contracts to withdrawl the rewards
    mapping(address => mapping(address => mapping(address => uint256))) public claimAllowance;

    /// @notice dividend container lookup by token address
    mapping(bytes32 => RewardsContainer) public keyToRewardsContainer;

    /**
     * @notice The container stores information about the dividend program
     * @param suppliedSinceLastUpdate accumulated rewards since last update
     * @param suppliedPerUnitWeight earned rewards per share over time
     * @param joinedAt The array index of `suppliedPerUnitWeight` at which the user joined the vault
     * @param claimableRewards The available rewards that can be redeemed
     */
    struct RewardsContainer {
        uint96 partition;
        uint208 suppliedSinceLastUpdate;
        uint208 currentSupplyError;
        uint256[] suppliedPerUnitWeight;
        mapping(address => uint256) joinedAt;
        mapping(address => uint256) claimableRewards;
    }

    /*//////////////////////////////////////////////////////////////
                              VIRTUAL LOGIC
    //////////////////////////////////////////////////////////////*/

    function rewardKeysOf(address owner) public view virtual returns (bytes32[] memory);

    function weightOf(address owner, uint96 partition) public view virtual returns (uint256);

    function totalWeight(uint96 partition) public view virtual returns (uint256);

    function totalAssets() public view virtual override returns (uint256);

    /*//////////////////////////////////////////////////////////////
                           CLAIM/SUPPLY LOGIC
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets `amount` as the allowance of `claimer` over the caller's rewards.
     *       @dev Emits a {ClaimApproval} event.
     *       @param reward The asset to set allowance for.
     *       @param amount The amount to set allowance for.
     *       @param claimer The address to set allowance for.
     *       @return success value indicating whether the operation succeeded.
     */
    function approveClaim(address reward, uint256 amount, address claimer) external virtual returns (bool success) {
        claimAllowance[reward][msg.sender][claimer] = amount;

        emit ClaimApproval(msg.sender, claimer, reward, amount);
        return true;
    }

    /**
     * @notice returns the amount of tokens that have been earned by depositors
     *       @param reward the reward asset to claim
     *       @param amount amount of tokens that were claimed
     *       @param receiver address to receieve the claim of rewards
     *       @return success value indicating whether the operation succeeded.
     */
    function claim(address reward, uint256 amount, address receiver) external virtual returns (bool success) {
        return _claim(reward, 0, amount, receiver);
    }

    function claim(
        address reward,
        uint256 amount,
        uint96 partition,
        address receiver
    ) external virtual returns (bool success) {
        return _claim(reward, partition, amount, receiver);
    }

    function _claim(
        address reward,
        uint96 partition,
        uint256 amount,
        address receiver
    ) internal virtual returns (bool success) {
        RewardsContainer storage c = keyToRewardsContainer[bytes32(abi.encodePacked(partition, reward))];
        _updateClaim(c, msg.sender, amount);
        ERC20(reward).safeTransfer(receiver, amount);

        emit Claimed(msg.sender, msg.sender, receiver, reward, amount);
        return true;
    }

    /**
     * @notice returns the amount of tokens that have been earned by depositors
     *       @param owner address that has ownership rights to the rewards
     *       @param reward the reward asset to claim
     *       @param amount amount of tokens that were claimed
     *       @param receiver address to receieve the claim of rewards
     *       @return success value indicating whether the operation succeeded.
     */
    function claimFor(
        address owner,
        address reward,
        uint256 amount,
        address receiver
    ) external virtual returns (bool success) {
        return _claimFor(owner, reward, 0, amount, receiver);
    }

    function claimFor(
        address owner,
        address reward,
        uint96 partition,
        uint256 amount,
        address receiver
    ) external virtual returns (bool success) {
        return _claimFor(owner, reward, partition, amount, receiver);
    }

    function _claimFor(
        address owner,
        address reward,
        uint96 partition,
        uint256 amount,
        address receiver
    ) internal virtual returns (bool success) {
        uint256 allowed = claimAllowance[reward][owner][msg.sender]; // Saves gas for limited approvals.
        if (allowed != type(uint256).max) claimAllowance[reward][owner][msg.sender] = allowed - amount;

        _updateClaim(keyToRewardsContainer[bytes32(abi.encodePacked(partition, reward))], owner, amount);
        ERC20(reward).safeTransfer(receiver, amount);

        emit Claimed(msg.sender, owner, receiver, reward, amount);
        return true;
    }

    /**
     * @notice Supply rewards to distributor to depositors
     *       @param supplier The address where the incoming tokens are coming from
     *       @param reward The asset being supplied
     *       @param amount The amount of said asset
     */
    function supply(address supplier, address reward, uint256 amount) external virtual {
        return _supply(supplier, reward, 0, amount);
    }

    function supply(address supplier, address reward, uint96 partition, uint256 amount) external virtual {
        _supply(supplier, reward, partition, amount);
    }

    // slither-disable-next-line naming-convention
    function _supply(address supplier, address reward, uint96 partition, uint256 amount) public virtual {
        ERC20(reward).safeTransferFrom(supplier, address(this), amount);
        // if the underlying asset supplied, we use the systemic share math instead of the container math
        if (ERC20(reward) != asset) {
            // safe unchecked: cannot reasonably overflow
            unchecked {
                keyToRewardsContainer[bytes32(abi.encodePacked(partition, reward))].suppliedSinceLastUpdate += uint208(
                    amount
                );
            }
        }
        emit Supplied(msg.sender, supplier, reward, amount);
    }

    /*//////////////////////////////////////////////////////////////
                               VIEW LOGIC
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice returns the weighting share of rewards a user has for partition 0
     *       @param owner the address of the the query
     *       @return weight the weighting share of rewards a user has for partition 0
     */
    function weightOf(address owner) external view virtual returns (uint256) {
        return weightOf(owner, 0);
    }

    /**
     * @notice returns the total weighting share of rewards for partition 0
     *       @return weight the total weighting share of rewards for partition 0
     */
    function totalWeight() external view virtual returns (uint256) {
        return totalWeight(0);
    }

    /**
     * @notice Returns the amount of tokens that can be claimed by the given owner
     *       @param reward The asset to check.
     *       @param owner The owner to check.
     *       @return amount The amount of okens that can be claimed by or on behalf of the given owner.
     */
    function maxClaimable(address reward, address owner) external view virtual returns (uint256 amount) {
        return _maxClaimable(reward, 0, owner);
    }

    function maxClaimable(address reward, uint96 id, address owner) external view virtual returns (uint256 amount) {
        return _maxClaimable(reward, id, owner);
    }

    function _maxClaimable(
        address reward,
        uint96 partition,
        address owner
    ) internal view virtual returns (uint256 amount) {
        RewardsContainer storage c = keyToRewardsContainer[bytes32(abi.encodePacked(partition, reward))];
        uint256 _weight = weightOf(owner, c.partition);

        if (_weight == 0) return c.claimableRewards[owner] / RAY;
        (uint256 eps, ) = _currentEPW(c);
        return ((eps - c.suppliedPerUnitWeight[c.joinedAt[owner]]) * _weight + c.claimableRewards[owner]) / RAY;
    }

    /*//////////////////////////////////////////////////////////////
                             INTERNAL LOGIC
    //////////////////////////////////////////////////////////////*/

    function _currentEPW(RewardsContainer storage c) internal view returns (uint256 eps, uint256 remainder) {
        uint256 _totalWeight = totalWeight(c.partition); // save sloads
        if (_totalWeight == 0) return (0, 0);
        uint256 totalEarningsInRay = c.suppliedSinceLastUpdate * RAY + c.currentSupplyError;
        return (
            c.suppliedPerUnitWeight[c.suppliedPerUnitWeight.length - 1] + (totalEarningsInRay / _totalWeight),
            totalEarningsInRay % _totalWeight
        );
    }

    function _updateSupplied(RewardsContainer storage c) internal {
        // If there are presently no shareholders, so we can start over
        // Any remainder in the earnings per share is rolled forward into
        // the next accrual period.

        (uint256 eps, uint256 remainder) = _currentEPW(c);
        c.suppliedPerUnitWeight.push(eps);
        c.currentSupplyError = uint208(remainder);
        c.suppliedSinceLastUpdate = 0;
    }

    function _updateClaimable(RewardsContainer storage c, address owner) internal {
        uint256 joinedTime = c.joinedAt[owner];
        uint256 weight = weightOf(owner, c.partition);
        c.claimableRewards[owner] += (weight == 0)
            ? 0
            : (c.suppliedPerUnitWeight[c.suppliedPerUnitWeight.length - 1] - c.suppliedPerUnitWeight[joinedTime]) *
                weight;
        c.joinedAt[owner] = c.suppliedPerUnitWeight.length - 1;
    }

    function _updateClaim(RewardsContainer storage c, address owner, uint256 amount) internal virtual {
        uint256 rewards = c.claimableRewards[owner];

        // todo: add comment
        amount *= RAY;

        // to save gas: only perform update if there isn't enough rewards
        // in c.claimableRewards[owner] to perform the claim
        if (rewards < amount) {
            _updateSupplied(c);
            _updateClaimable(c, owner);

            // Value updated by above code
            rewards = c.claimableRewards[owner];

            // If still insufficient after update, revert.
            if (rewards < amount) {
                revert('Insufficent payable rewards');
            }
        }

        // safe unchecked: rewards must be greater than amount to reach here
        unchecked {
            c.claimableRewards[owner] = rewards - amount;
        }
    }

    function _updateUserAccounting(address user) internal virtual {
        bytes32[] memory rewardContainerIds = rewardKeysOf(user);
        uint256 len = rewardContainerIds.length;

        for (uint256 i = 0; i < len; ) {
            bytes32 rewardContainerId = rewardContainerIds[i];
            RewardsContainer storage c = keyToRewardsContainer[rewardContainerId];
            _updateSupplied(c);
            _updateClaimable(c, user);

            // safe unchecked: iteration is safe
            unchecked {
                ++i;
            }
        }
    }

    /*//////////////////////////////////////////////////////////////
                        CONTAINER CREATION LOGIC
    //////////////////////////////////////////////////////////////*/

    function _createNewRewardContainer(address reward, uint96 partition) internal virtual {
        bytes32 rewardKey = bytes32(abi.encodePacked(partition, reward));
        rewardKeys.push(rewardKey);
        keyToRewardsContainer[rewardKey].partition = partition;
    }

    /*//////////////////////////////////////////////////////////////
                             ERC20 OVERRIDES
    //////////////////////////////////////////////////////////////*/

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        _updateUserAccounting(msg.sender);
        _updateUserAccounting(to);
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        _updateUserAccounting(from);
        _updateUserAccounting(to);
        return super.transferFrom(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal virtual override {
        _updateUserAccounting(to);
        super._mint(to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual override {
        _updateUserAccounting(from);
        super._burn(from, amount);
    }

    /*//////////////////////////////////////////////////////////////
                             EIP-2612 LOGIC
    //////////////////////////////////////////////////////////////*/

    function permitClaim(
        address reward,
        address owner,
        address claimer,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual {
        // slither-disable-next-line timestamp
        require(deadline >= block.timestamp, 'PERMIT_DEADLINE_EXPIRED');

        // Unchecked because the only math done is incrementing
        // the owner's nonce which cannot realistically overflow.
        unchecked {
            {
                // prevent stack too deep
                address _owner = owner;
                address recoveredAddress = ecrecover(
                    keccak256(
                        abi.encodePacked(
                            '\x19\x01',
                            DOMAIN_SEPARATOR(),
                            keccak256(
                                abi.encode(
                                    keccak256(
                                        'Permit(address reward, address owner,address claimer,uint256 value,uint256 nonce,uint256 deadline)'
                                    ),
                                    reward,
                                    owner,
                                    claimer,
                                    value,
                                    nonces[_owner]++,
                                    deadline
                                )
                            )
                        )
                    ),
                    v,
                    r,
                    s
                );

                require(recoveredAddress != address(0) && recoveredAddress == owner, 'INVALID_SIGNER');

                // must be in the unchecked to prevent stack too deep
                emit ClaimApproval(recoveredAddress, claimer, reward, value);
            }
        }
        claimAllowance[reward][msg.sender][claimer] = value;
    }
}

/* solhint-enable */
