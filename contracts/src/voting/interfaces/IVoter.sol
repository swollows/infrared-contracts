// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVoter {
    error AlreadyVotedOrDeposited();
    error BribeVaultAlreadyKilled();
    error BribeVaultAlreadyRevived();
    error BribeVaultExists();
    error BribeVaultDoesNotExist(address _stakingToken);
    error BribeVaultNotAlive(address _stakingToken);
    error InactiveManagedNFT();
    error MaximumVotingNumberTooLow();
    error NonZeroVotes();
    error NotAStakingToken();
    error NotApprovedOrOwner();
    error NotWhitelistedNFT();
    error NotWhitelistedToken();
    error SameValue();
    error SpecialVotingWindow();
    error TooManyStakingTokens();
    error UnequalLengths();
    error ZeroBalance();
    error ZeroAddress();
    error VaultNotRegistered();
    error NotGovernor();
    error DistributeWindow();

    event BribeVaultCreated(
        address stakingToken, address bribeVault, address creator
    );
    event BribeVaultKilled(address indexed bribeVault);
    event BribeVaultRevived(address indexed bribeVault);
    event Voted(
        address indexed voter,
        address indexed stakingToken,
        uint256 indexed tokenId,
        uint256 weight,
        uint256 totalWeight,
        uint256 timestamp
    );
    event Abstained(
        address indexed voter,
        address indexed stakingToken,
        uint256 indexed tokenId,
        uint256 weight,
        uint256 totalWeight,
        uint256 timestamp
    );
    event WhitelistToken(
        address indexed whitelister, address indexed token, bool indexed _bool
    );
    event WhitelistNFT(
        address indexed whitelister, uint256 indexed tokenId, bool indexed _bool
    );

    /// @notice The ve token that governs these contracts
    function ve() external view returns (address);

    /// @dev Total Voting Weights
    function totalWeight() external view returns (uint256);

    /// @dev Most number of stakingTokens one voter can vote for at once
    function maxVotingNum() external view returns (uint256);

    /// @dev Global fee distribution vault for voters
    function feeVault() external view returns (address);

    // mappings
    /// @dev StakingToken => BribeVault
    function bribeVaults(address stakingToken)
        external
        view
        returns (address);

    /// @dev StakingToken => Weights
    function weights(address stakingToken) external view returns (uint256);

    /// @dev NFT => StakingToken => Votes
    function votes(uint256 tokenId, address stakingToken)
        external
        view
        returns (uint256);

    /// @dev NFT => Total voting weight of NFT
    function usedWeights(uint256 tokenId) external view returns (uint256);

    /// @dev Nft => Timestamp of last vote (ensures single vote per epoch)
    function lastVoted(uint256 tokenId) external view returns (uint256);

    /// @dev Token => Whitelisted status
    function isWhitelistedToken(address token) external view returns (bool);

    /// @dev TokenId => Whitelisted status
    function isWhitelistedNFT(uint256 tokenId) external view returns (bool);

    /// @dev BribeVault => Liveness status
    function isAlive(address bribeVault) external view returns (bool);

    /// @notice Number of stakingTokens with a BribeVault
    function length() external view returns (uint256);

    /// @notice Called by users to update voting balances in voting rewards contracts.
    /// @param _tokenId Id of veNFT whose balance you wish to update.
    function poke(uint256 _tokenId) external;

    /// @notice Called by users to vote for stakingTokens. Votes distributed proportionally based on weights.
    ///         Can only vote or deposit into a managed NFT once per epoch.
    ///         Can only vote for bribeVaults that have not been killed.
    /// @dev Weights are distributed proportional to the sum of the weights in the array.
    ///      Throws if length of _stakingTokenVote and _weights do not match.
    /// @param _tokenId Id of veNFT you are voting with.
    /// @param _stakingTokenVote Array of stakingTokens you are voting for.
    /// @param _weights Weights of stakingTokens.
    function vote(
        uint256 _tokenId,
        address[] calldata _stakingTokenVote,
        uint256[] calldata _weights
    ) external;

    /// @notice Called by users to reset voting state. Required if you wish to make changes to
    ///         veNFT state (e.g. merge, split, deposit into managed etc).
    ///         Cannot reset in the same epoch that you voted in.
    ///         Can vote or deposit into a managed NFT again after reset.
    /// @param _tokenId Id of veNFT you are reseting.
    function reset(uint256 _tokenId) external;

    /// @notice Called by users to deposit into a managed NFT.
    ///         Can only vote or deposit into a managed NFT once per epoch.
    ///         Note that NFTs deposited into a managed NFT will be re-locked
    ///         to the maximum lock time on withdrawal.
    /// @dev Throws if not approved or owner.
    ///      Throws if managed NFT is inactive.
    ///      Throws if depositing within privileged window (one hour prior to epoch flip).
    /// @param _tokenId Id of veNFT you are depositing.
    /// @param _mTokenId Id of managed NFT you are depositing into.
    function depositManaged(uint256 _tokenId, uint256 _mTokenId) external;

    /// @notice Called by users to withdraw from a managed NFT.
    ///         Cannot do it in the same epoch that you deposited into a managed NFT.
    ///         Can vote or deposit into a managed NFT again after withdrawing.
    ///         Note that the NFT withdrawn is re-locked to the maximum lock time.
    /// @param _tokenId Id of veNFT you are withdrawing.
    function withdrawManaged(uint256 _tokenId) external;

    /// @notice Claim bribes for a given NFT.
    /// @dev Utility to help batch bribe claims.
    /// @param _bribes Array of BribeVotingReward contracts to collect from.
    /// @param _tokens Array of tokens that are used as bribes.
    /// @param _tokenId Id of veNFT that you wish to claim bribes for.
    function claimBribes(
        address[] memory _bribes,
        address[][] memory _tokens,
        uint256 _tokenId
    ) external;

    /// @notice Claim fees for a given NFT.
    /// @dev Utility to help batch fee claims.
    /// @param _tokens Array of tokens that are used as fee rewards.
    /// @param _tokenId Id of veNFT that you wish to claim fees for.
    function claimFees(address[] memory _tokens, uint256 _tokenId) external;

    /// @notice Set maximum number of bribeVaults that can be voted for.
    /// @dev Throws if not called by governor.
    ///      Throws if _maxVotingNum is too low.
    ///      Throws if the values are the same.
    /// @param _maxVotingNum Maximum number of bribeVaults that can be voted for.
    function setMaxVotingNum(uint256 _maxVotingNum) external;

    /// @notice Whitelist (or unwhitelist) token id for voting in last hour prior to epoch flip.
    /// @dev Throws if not called by governor.
    ///      Throws if already whitelisted.
    /// @param _tokenId Id of the token to be whitelisted or unwhitelisted.
    /// @param _bool Boolean indicating whether to whitelist or unwhitelist the token id.
    function whitelistNFT(uint256 _tokenId, bool _bool) external;

    /// @notice Create a new bribeVault (unpermissioned).
    /// @dev Governor can create a new bribeVault for a stakingToken with any address.
    /// @param _stakingToken Address of the staking token.
    /// @param _rewardTokens Array of reward tokens for the bribeVault.
    function createBribeVault(
        address _stakingToken,
        address[] calldata _rewardTokens
    ) external returns (address);

    /// @notice Kills a bribeVault. The bribeVault will not receive any new emissions and cannot be deposited into.
    ///         Can still withdraw from bribeVault.
    /// @dev Throws if not called by emergency council.
    ///      Throws if bribeVault already killed.
    /// @param _stakingToken Address of the staking token for the bribeVault to be killed.
    function killBribeVault(address _stakingToken) external;

    /// @notice Revives a killed bribeVault. BribeVault can receive emissions and deposits again.
    /// @dev Throws if not called by emergency council.
    ///      Throws if bribeVault is not killed.
    /// @param _stakingToken Address of the staking token for the bribeVault to be revived.
    function reviveBribeVault(address _stakingToken) external;
}
