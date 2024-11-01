// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.26;

import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

import {ReentrancyGuardUpgradeable} from
    "@openzeppelin-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

import {InfraredUpgradeable} from "@core/InfraredUpgradeable.sol";
import {Errors} from "@utils/Errors.sol";

import {IReward} from "@voting/interfaces/IReward.sol";
import {IVoter} from "@voting/interfaces/IVoter.sol";
import {IVotingEscrow} from "@voting/interfaces/IVotingEscrow.sol";

import {BribeVotingReward} from "@voting/rewards/BribeVotingReward.sol";
import {VelodromeTimeLibrary} from "@voting/libraries/VelodromeTimeLibrary.sol";

import {IInfrared} from "@interfaces/IInfrared.sol";

/// @title Infrared Voting POL CuttingBoard
/// @dev This contract manages votes for POL CuttingBoard allocation and respective bribeVault creation.
///      It also provides support for depositing and withdrawing from managed veNFTs. Inspired by Velodrome V2 Voter.
/// @author Modified from Velodrome (https://github.com/velodrome-finance/contracts/blob/main/contracts/Voter.sol)
/// @author Infrared, @NoFront
/// @notice Ensure new epoch before voting and manage staking tokens and bribe vaults.
contract Voter is IVoter, InfraredUpgradeable, ReentrancyGuardUpgradeable {
    using SafeERC20 for IERC20;

    /// @inheritdoc IVoter
    address public ve;
    /// @notice Rewards are released over 7 days
    uint256 internal constant DURATION = 7 days;
    /// @inheritdoc IVoter
    uint256 public totalWeight;
    /// @inheritdoc IVoter
    uint256 public maxVotingNum;
    uint256 internal constant MIN_MAXVOTINGNUM = 1;

    /// @inheritdoc IVoter
    address public feeVault;
    /// @dev All stakingTokens viable for incentives
    address[] public stakingTokens;
    /// @inheritdoc IVoter
    mapping(address => address) public bribeVaults;
    /// @inheritdoc IVoter
    mapping(address => uint256) public weights;
    /// @inheritdoc IVoter
    mapping(uint256 => mapping(address => uint256)) public votes;
    /// @dev NFT => List of stakingTokens voted for by NFT
    mapping(uint256 => address[]) public stakingTokenVote;
    /// @inheritdoc IVoter
    mapping(uint256 => uint256) public usedWeights;
    /// @inheritdoc IVoter
    mapping(uint256 => uint256) public lastVoted;
    /// @inheritdoc IVoter
    mapping(uint256 => bool) public isWhitelistedNFT;
    /// @inheritdoc IVoter
    mapping(address => bool) public isAlive;

    modifier onlyNewEpoch(uint256 _tokenId) {
        // ensure new epoch since last vote
        if (
            VelodromeTimeLibrary.epochStart(block.timestamp)
                <= lastVoted[_tokenId]
        ) revert AlreadyVotedOrDeposited();
        if (
            block.timestamp
                <= VelodromeTimeLibrary.epochVoteStart(block.timestamp)
        ) revert DistributeWindow();
        _;
    }

    function epochStart(uint256 _timestamp) external pure returns (uint256) {
        return VelodromeTimeLibrary.epochStart(_timestamp);
    }

    function epochNext(uint256 _timestamp) external pure returns (uint256) {
        return VelodromeTimeLibrary.epochNext(_timestamp);
    }

    function epochVoteStart(uint256 _timestamp)
        external
        pure
        returns (uint256)
    {
        return VelodromeTimeLibrary.epochVoteStart(_timestamp);
    }

    function epochVoteEnd(uint256 _timestamp) external pure returns (uint256) {
        return VelodromeTimeLibrary.epochVoteEnd(_timestamp);
    }

    constructor(address _infrared) InfraredUpgradeable(_infrared) {
        if (_infrared == address(0)) revert Errors.ZeroAddress();
    }

    function initialize(address _ve) external initializer {
        if (_ve == address(0)) revert Errors.ZeroAddress();
        ve = _ve;
        maxVotingNum = 30;

        // adaptation to create fee vault for global fees amongst all voters
        address[] memory _rewards = new address[](3);
        _rewards[0] = address(infrared.ibgt());
        _rewards[1] = address(infrared.ired());
        _rewards[2] = address(infrared.honey());

        feeVault = address(new BribeVotingReward(address(this), _rewards));

        // init upgradeable components
        __ReentrancyGuard_init();
        __InfraredUpgradeable_init();
    }

    /// @inheritdoc IVoter
    function setMaxVotingNum(uint256 _maxVotingNum) external onlyGovernor {
        if (_maxVotingNum < MIN_MAXVOTINGNUM) {
            revert MaximumVotingNumberTooLow();
        }
        if (_maxVotingNum == maxVotingNum) revert SameValue();
        maxVotingNum = _maxVotingNum;
    }

    /// @inheritdoc IVoter
    function reset(uint256 _tokenId)
        external
        onlyNewEpoch(_tokenId)
        nonReentrant
    {
        if (!IVotingEscrow(ve).isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NotApprovedOrOwner();
        }
        _reset(_tokenId);
    }

    function _reset(uint256 _tokenId) internal {
        address[] storage _stakingTokenVote = stakingTokenVote[_tokenId];
        uint256 _stakingTokenVoteCnt = _stakingTokenVote.length;
        uint256 _totalWeight = 0;

        for (uint256 i = 0; i < _stakingTokenVoteCnt; i++) {
            address _stakingToken = _stakingTokenVote[i];
            uint256 _votes = votes[_tokenId][_stakingToken];

            if (_votes != 0) {
                weights[_stakingToken] -= _votes;
                delete votes[_tokenId][_stakingToken];
                IReward(bribeVaults[_stakingToken])._withdraw(_votes, _tokenId);
                _totalWeight += _votes;
                emit Abstained(
                    msg.sender,
                    _stakingToken,
                    _tokenId,
                    _votes,
                    weights[_stakingToken],
                    block.timestamp
                );
            }
        }
        IVotingEscrow(ve).voting(_tokenId, false);
        // @dev withdraw from fees reward vault in addition to marking tokenId as not voted
        IReward(feeVault)._withdraw(usedWeights[_tokenId], _tokenId);
        totalWeight -= _totalWeight;
        usedWeights[_tokenId] = 0;
        delete stakingTokenVote[_tokenId];
    }

    /// @inheritdoc IVoter
    function poke(uint256 _tokenId) external nonReentrant {
        if (
            block.timestamp
                <= VelodromeTimeLibrary.epochVoteStart(block.timestamp)
        ) revert DistributeWindow();
        uint256 _weight = IVotingEscrow(ve).balanceOfNFT(_tokenId);
        _poke(_tokenId, _weight);
    }

    function _poke(uint256 _tokenId, uint256 _weight) internal {
        address[] memory _stakingTokenVote = stakingTokenVote[_tokenId];
        uint256 _stakingTokenCnt = _stakingTokenVote.length;
        uint256[] memory _weights = new uint256[](_stakingTokenCnt);

        for (uint256 i = 0; i < _stakingTokenCnt; i++) {
            _weights[i] = votes[_tokenId][_stakingTokenVote[i]];
        }
        _vote(_tokenId, _weight, _stakingTokenVote, _weights);
    }

    function _vote(
        uint256 _tokenId,
        uint256 _weight,
        address[] memory _stakingTokenVote,
        uint256[] memory _weights
    ) internal {
        _reset(_tokenId);
        uint256 _stakingTokenCnt = _stakingTokenVote.length;
        uint256 _totalVoteWeight = 0;
        uint256 _totalWeight = 0;
        uint256 _usedWeight = 0;

        for (uint256 i = 0; i < _stakingTokenCnt; i++) {
            _totalVoteWeight += _weights[i];
        }

        for (uint256 i = 0; i < _stakingTokenCnt; i++) {
            address _stakingToken = _stakingTokenVote[i];
            address _bribeVault = bribeVaults[_stakingToken];
            if (_bribeVault == address(0)) {
                revert BribeVaultDoesNotExist(_stakingToken);
            }
            if (!isAlive[_stakingToken]) revert BribeVaultNotAlive(_bribeVault);

            uint256 _stakingTokenWeight =
                (_weights[i] * _weight) / _totalVoteWeight;
            if (votes[_tokenId][_stakingToken] != 0) revert NonZeroVotes();
            if (_stakingTokenWeight == 0) revert ZeroBalance();

            stakingTokenVote[_tokenId].push(_stakingToken);

            weights[_stakingToken] += _stakingTokenWeight;
            votes[_tokenId][_stakingToken] += _stakingTokenWeight;

            IReward(_bribeVault)._deposit(_stakingTokenWeight, _tokenId);

            _usedWeight += _stakingTokenWeight;
            _totalWeight += _stakingTokenWeight;
            emit Voted(
                msg.sender,
                _stakingToken,
                _tokenId,
                _stakingTokenWeight,
                weights[_stakingToken],
                block.timestamp
            );
        }
        if (_usedWeight > 0) {
            IVotingEscrow(ve).voting(_tokenId, true);
            // @dev deposit in fees reward vault in addition to marking tokenId as voted
            IReward(feeVault)._deposit(_usedWeight, _tokenId);
        }
        totalWeight += _totalWeight;
        usedWeights[_tokenId] = _usedWeight;
    }

    /// @inheritdoc IVoter
    function vote(
        uint256 _tokenId,
        address[] calldata _stakingTokenVote,
        uint256[] calldata _weights
    ) external onlyNewEpoch(_tokenId) nonReentrant {
        if (!IVotingEscrow(ve).isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NotApprovedOrOwner();
        }
        if (_stakingTokenVote.length != _weights.length) {
            revert UnequalLengths();
        }
        if (_stakingTokenVote.length > maxVotingNum) {
            revert TooManyStakingTokens();
        }
        if (IVotingEscrow(ve).deactivated(_tokenId)) {
            revert InactiveManagedNFT();
        }
        uint256 _timestamp = block.timestamp;
        if (
            (_timestamp > VelodromeTimeLibrary.epochVoteEnd(_timestamp))
                && !isWhitelistedNFT[_tokenId]
        ) {
            revert NotWhitelistedNFT();
        }
        lastVoted[_tokenId] = _timestamp;
        uint256 _weight = IVotingEscrow(ve).balanceOfNFT(_tokenId);
        _vote(_tokenId, _weight, _stakingTokenVote, _weights);
    }

    /// @inheritdoc IVoter
    function depositManaged(uint256 _tokenId, uint256 _mTokenId)
        external
        nonReentrant
        onlyNewEpoch(_tokenId)
    {
        if (!IVotingEscrow(ve).isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NotApprovedOrOwner();
        }
        if (IVotingEscrow(ve).deactivated(_mTokenId)) {
            revert InactiveManagedNFT();
        }
        _reset(_tokenId);
        uint256 _timestamp = block.timestamp;
        if (_timestamp > VelodromeTimeLibrary.epochVoteEnd(_timestamp)) {
            revert SpecialVotingWindow();
        }
        lastVoted[_tokenId] = _timestamp;
        IVotingEscrow(ve).depositManaged(_tokenId, _mTokenId);
        uint256 _weight =
            IVotingEscrow(ve).balanceOfNFTAt(_mTokenId, block.timestamp);
        _poke(_mTokenId, _weight);
    }

    /// @inheritdoc IVoter
    function withdrawManaged(uint256 _tokenId)
        external
        nonReentrant
        onlyNewEpoch(_tokenId)
    {
        if (!IVotingEscrow(ve).isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NotApprovedOrOwner();
        }
        uint256 _mTokenId = IVotingEscrow(ve).idToManaged(_tokenId);
        IVotingEscrow(ve).withdrawManaged(_tokenId);
        // If the NORMAL veNFT was the last tokenId locked into _mTokenId, reset vote as there is
        // no longer voting power available to the _mTokenId.  Otherwise, updating voting power to accurately
        // reflect the withdrawn voting power.
        uint256 _weight =
            IVotingEscrow(ve).balanceOfNFTAt(_mTokenId, block.timestamp);
        if (_weight == 0) {
            _reset(_mTokenId);
            // clear out lastVoted to allow re-voting in the current epoch
            delete lastVoted[_mTokenId];
        } else {
            _poke(_mTokenId, _weight);
        }
    }

    /// @inheritdoc IVoter
    function isWhitelistedToken(address _token) external view returns (bool) {
        return infrared.whitelistedRewardTokens(_token);
    }

    /// @inheritdoc IVoter
    function whitelistNFT(uint256 _tokenId, bool _bool) external onlyGovernor {
        isWhitelistedNFT[_tokenId] = _bool;
        emit WhitelistNFT(msg.sender, _tokenId, _bool);
    }

    /// @inheritdoc IVoter
    function createBribeVault(
        address _stakingToken,
        address[] calldata _rewards
    ) external onlyKeeper nonReentrant whenInitialized returns (address) {
        if (address(infrared.vaultRegistry(_stakingToken)) == address(0)) {
            revert VaultNotRegistered();
        }
        if (bribeVaults[_stakingToken] != address(0)) revert BribeVaultExists();

        // adaptation to only create bribe voting rewards
        address _bribeVault =
            address(new BribeVotingReward(address(this), _rewards));

        bribeVaults[_stakingToken] = _bribeVault;

        stakingTokens.push(_stakingToken);
        isAlive[_stakingToken] = true;

        emit BribeVaultCreated(_stakingToken, _bribeVault, msg.sender);
        return _bribeVault;
    }

    /// @inheritdoc IVoter
    function killBribeVault(address _stakingToken) external onlyGovernor {
        if (!isAlive[_stakingToken]) revert BribeVaultAlreadyKilled();
        isAlive[_stakingToken] = false;
        emit BribeVaultKilled(_stakingToken);
    }

    /// @inheritdoc IVoter
    function reviveBribeVault(address _stakingToken) external onlyGovernor {
        if (isAlive[_stakingToken]) revert BribeVaultAlreadyRevived();
        isAlive[_stakingToken] = true;
        emit BribeVaultRevived(_stakingToken);
    }

    /// @inheritdoc IVoter
    function length() external view returns (uint256) {
        return stakingTokens.length;
    }

    /// @inheritdoc IVoter
    function claimBribes(
        address[] memory _bribes,
        address[][] memory _tokens,
        uint256 _tokenId
    ) external {
        if (!IVotingEscrow(ve).isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NotApprovedOrOwner();
        }
        uint256 _length = _bribes.length;
        for (uint256 i = 0; i < _length; i++) {
            IReward(_bribes[i]).getReward(_tokenId, _tokens[i]);
        }
    }

    /// @inheritdoc IVoter
    function claimFees(address[] memory _tokens, uint256 _tokenId) external {
        if (!IVotingEscrow(ve).isApprovedOrOwner(msg.sender, _tokenId)) {
            revert NotApprovedOrOwner();
        }
        IReward(feeVault).getReward(_tokenId, _tokens);
    }

    /// @dev helper function to get all staking tokens and their weights
    function getStakingTokenWeights()
        public
        view
        returns (
            address[] memory _stakingTokens,
            uint256[] memory _weights,
            uint256 _totalWeight
        )
    {
        uint256 length = stakingTokens.length;
        _weights = new uint256[](length);
        _stakingTokens = new address[](length);
        uint256 count = 0;

        for (uint256 i = 0; i < length; i++) {
            address token = stakingTokens[i];

            _weights[count] = weights[token];
            _stakingTokens[count] = token;
            _totalWeight += _weights[count];
            count++;
        }

        // Resize the arrays to remove unfilled entries
        assembly {
            mstore(_weights, count)
            mstore(_stakingTokens, count)
        }
    }
}
