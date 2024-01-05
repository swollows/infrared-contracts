// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// external
import "@forge-std/Test.sol";
import "@forge-std/Vm.sol";

// berachain precompile mock contracts
import "../mocks/MockDistributionPrecompile.sol";
import "../mocks/MockERC20BankModule.sol";
import "../mocks/MockRewardsPrecompile.sol";
import "../mocks/MockWbera.sol";

// internal
import "@core/upgradable/UpgradableRewardsHandler.sol";

contract UpgradableRewardsHandlerTest is Test {
    UpgradableRewardsHandler rewardsHandler;
    MockDistributionPrecompile mockDistribution;
    MockERC20BankModule mockErc20Bank;
    MockWbera mockWbera;
    MockRewardsPrecompile mockRewardsPrecompile;

    function setUp() public {
        rewardsHandler = new UpgradableRewardsHandler();

        // Mock contracts
        mockErc20Bank = new MockERC20BankModule();
        mockWbera = new MockWbera();
        mockRewardsPrecompile =
            new MockRewardsPrecompile(address(mockErc20Bank));
        mockDistribution =
            new MockDistributionPrecompile(address(mockErc20Bank));

        // Mapp coin denoms to mock ERC20 addresses
        mockErc20Bank.setErc20AddressForCoinDenom("abgt", address(mockWbera));
        mockErc20Bank.setErc20AddressForCoinDenom(
            "abera", address(new MockWbera())
        );
        mockErc20Bank.setErc20AddressForCoinDenom(
            "other", address(new MockWbera())
        );

        // Initialize the rewards handler with mock addresses
        rewardsHandler.initialize(
            address(mockRewardsPrecompile),
            address(mockDistribution),
            address(mockErc20Bank),
            address(mockWbera)
        );

        deal(address(rewardsHandler), 10000 ether);
    }

    /*//////////////////////////////////////////////////////////////
                            claimDistrPrecompile
    //////////////////////////////////////////////////////////////*/

    function testClaimDistrPrecompileNoRewards() public {
        // Set up the mock distribution module to return no rewards
        mockDistribution.setMockRewards(new Cosmos.Coin[](0));

        // Call the claimDistrPrecompile function
        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = rewardsHandler
            .claimDistrPrecompile(address(1), address(rewardsHandler));

        // Assert that no rewards are returned
        assertEq(tokens.length, 0);
        assertEq(bgtAmt, 0);
    }

    // Test Only BGT Rewards
    function testClaimDistrPrecompileOnlyBgtRewards() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = rewardsHandler
            .claimDistrPrecompile(address(1), address(rewardsHandler));

        assertEq(tokens.length, 0);
        assertEq(bgtAmt, 100);
    }

    // Test BGT and BERA Rewards
    function testClaimDistrPrecompileBgtAndBeraRewards() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        rewards[1] = Cosmos.Coin(50, "abera"); // 50 bera
        mockDistribution.setMockRewards(rewards);

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = rewardsHandler
            .claimDistrPrecompile(address(1), address(rewardsHandler));

        assertEq(tokens.length, 1);
        assertEq(tokens[0].amount, 50); // 50 bera wrapped as WBERA
        assertEq(tokens[0].tokenAddress, address(mockWbera));
        assertEq(bgtAmt, 100);
    }

    // Test Multiple Rewards Scenario
    function testClaimDistrPrecompileMultipleRewards() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](3);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        rewards[1] = Cosmos.Coin(50, "abera"); // 50 bera
        rewards[2] = Cosmos.Coin(200, "other"); // 200 of some other denom
        mockDistribution.setMockRewards(rewards);

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = rewardsHandler
            .claimDistrPrecompile(address(1), address(rewardsHandler));

        assertEq(tokens.length, 2);
        assertEq(tokens[0].amount, 200);
        assertEq(tokens[1].amount, 50); // 50 bera wrapped as WBERA
        assertEq(tokens[1].tokenAddress, address(mockWbera));
        assertEq(bgtAmt, 100);
    }

    // Test Error Handling
    function testClaimDistrPrecompileErrorHandling() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "unknown"); // Unknown denom
        mockDistribution.setMockRewards(rewards);

        vm.expectRevert();
        rewardsHandler.claimDistrPrecompile(address(1), address(rewardsHandler));
    }

    /*//////////////////////////////////////////////////////////////
                            claimRewardsPrecompile
    //////////////////////////////////////////////////////////////*/

    function testClaimRewardsPrecompileSuccess() public {
        // Set up mock rewards
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockRewardsPrecompile.setMockRewards(rewards);

        // Claim rewards
        uint256 bgtAmt =
            rewardsHandler.claimRewardsPrecompile(address(rewardsHandler));

        // Assert that the claimed amount is correct
        assertEq(bgtAmt, 100);
    }

    function testClaimRewardsPrecompileNoRewards() public {
        // Set up no rewards
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](0);
        mockRewardsPrecompile.setMockRewards(rewards);

        // Claim rewards
        uint256 bgtAmt =
            rewardsHandler.claimRewardsPrecompile(address(rewardsHandler));

        // Assert that no rewards were claimed
        assertEq(bgtAmt, 0);
    }

    function testClaimRewardsPrecompileUnexpectedDenom() public {
        // Set up mock rewards with an unexpected denomination
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "unexpected"); // 100 of unexpected denom
        mockRewardsPrecompile.setMockRewards(rewards);

        // Expect revert due to unexpected denomination
        vm.expectRevert();
        rewardsHandler.claimRewardsPrecompile(address(rewardsHandler));
    }

    function testClaimRewardsPrecompileMoreThanOneReward() public {
        // Set up mock rewards with more than one reward
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt");
        rewards[1] = Cosmos.Coin(50, "abgt");
        mockRewardsPrecompile.setMockRewards(rewards);

        // Expect the function to revert due to more than one reward
        vm.expectRevert();
        rewardsHandler.claimRewardsPrecompile(address(rewardsHandler));
    }

    /*//////////////////////////////////////////////////////////////
                            setWithdrawAddress
    //////////////////////////////////////////////////////////////*/

    function testSetWithdrawAddressSuccess() public {
        // Set a valid withdraw address
        bool success = rewardsHandler.setWithdrawAddress(
            DataTypes.RewardContract.Distribution,
            address(1),
            address(rewardsHandler)
        );
        assertTrue(success);

        // Repeat for the Rewards contract
        success = rewardsHandler.setWithdrawAddress(
            DataTypes.RewardContract.Rewards,
            address(1),
            address(rewardsHandler)
        );
        assertTrue(success);
    }

    function testSetWithdrawAddressZeroAddress() public {
        // Attempt to set a zero address and expect a revert
        vm.expectRevert(Errors.ZeroAddress.selector);
        rewardsHandler.setWithdrawAddress(
            DataTypes.RewardContract.Distribution,
            address(0),
            address(rewardsHandler)
        );

        // Repeat for the Rewards contract
        vm.expectRevert(Errors.ZeroAddress.selector);
        rewardsHandler.setWithdrawAddress(
            DataTypes.RewardContract.Rewards,
            address(0),
            address(rewardsHandler)
        );
    }

    /*//////////////////////////////////////////////////////////////
                            FUZZING
    //////////////////////////////////////////////////////////////*/

    function testClaimDistrPrecompileFuzz(uint8 numRewards, uint256 rand)
        public
    {
        // Limit the number of rewards
        uint8 cappedNumRewards = numRewards % 10;

        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](cappedNumRewards);
        for (uint8 i = 0; i < cappedNumRewards; i++) {
            // Randomly include 'abgt' and 'abera'
            string memory denom = (rand % 3 == 0)
                ? "abgt"
                : ((rand % 3 == 1) ? "abera" : string(abi.encodePacked("denom", i)));
            rewards[i] = Cosmos.Coin({
                amount: uint256(keccak256(abi.encodePacked(block.timestamp, i)))
                    % 1000,
                denom: denom
            });
            // Set the mock ERC20 address for the denom
            address mockAddress = address(new MockWbera());
            mockErc20Bank.setErc20AddressForCoinDenom(
                rewards[i].denom, mockAddress
            );
        }

        // Set the mock rewards
        mockDistribution.setMockRewards(rewards);

        // Call the function
        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = rewardsHandler
            .claimDistrPrecompile(address(1), address(rewardsHandler));

        // Prepare variables to sum amounts for each denomination
        uint256 sumBgt = 0;
        uint256 sumBera = 0;
        uint256 sumOther = 0;

        for (uint256 i = 0; i < rewards.length; i++) {
            if (keccak256(bytes(rewards[i].denom)) == keccak256(bytes("abgt")))
            {
                sumBgt += rewards[i].amount;
            } else if (
                keccak256(bytes(rewards[i].denom)) == keccak256(bytes("abera"))
            ) {
                sumBera += rewards[i].amount;
            } else {
                sumOther += rewards[i].amount; // Assuming 'other' is the third type
            }
        }

        // Check if the amounts in tokens match the summed amounts
        uint256 tokenSumBgt = bgtAmt;
        uint256 tokenSumBera = 0;
        uint256 tokenSumOther = 0;

        for (uint256 i = 0; i < tokens.length; i++) {
            if (tokens[i].tokenAddress == address(mockWbera)) {
                tokenSumBera += tokens[i].amount;
            } else {
                tokenSumOther += tokens[i].amount; // Assuming all other tokens are 'other'
            }
        }

        // Assert the amounts match
        assertEq(tokenSumBgt, sumBgt, "Mismatch in BGT amounts");
        assertEq(tokenSumBera, sumBera, "Mismatch in BERA amounts");
        assertEq(tokenSumOther, sumOther, "Mismatch in other token amounts");

        // Assert that the length of the tokens array is correct
        assertCorrectTokensArrayLength(tokens, rewards, bgtAmt, tokenSumBera);
    }

    /*//////////////////////////////////////////////////////////////
                            ASSERTION HELPERS
    //////////////////////////////////////////////////////////////*/

    function assertCorrectTokensArrayLength(
        DataTypes.Token[] memory tokens,
        Cosmos.Coin[] memory rewards,
        uint256 bgtAmt,
        uint256 beraAmt
    ) internal pure {
        // Count the number of unique non-bgt, non-bera denominations
        uint256 uniqueDenomsCount = countUniqueDenominations(rewards);

        // Calculate the expected length of the tokens array
        uint256 expectedLength = uniqueDenomsCount;
        if (beraAmt > 0) {
            expectedLength += 1; // Add one for the wrapped bera token
        }

        // Assert that the length of tokens array is as expected
        require(
            tokens.length == expectedLength,
            "Incorrect length of the tokens array"
        );
    }

    /*//////////////////////////////////////////////////////////////
                           PURE HELPERS
    //////////////////////////////////////////////////////////////*/

    function findAmountInRewards(
        Cosmos.Coin[] memory rewards,
        string memory denom
    ) internal pure returns (uint256) {
        uint256 amount = 0;
        for (uint256 i = 0; i < rewards.length; i++) {
            if (keccak256(bytes(rewards[i].denom)) == keccak256(bytes(denom))) {
                amount += rewards[i].amount;
            }
        }
        return amount;
    }

    function findWrappedTokenAmount(
        DataTypes.Token[] memory tokens,
        address tokenAddress
    ) internal pure returns (uint256) {
        for (uint256 i = 0; i < tokens.length; i++) {
            if (tokens[i].tokenAddress == tokenAddress) {
                return tokens[i].amount;
            }
        }
        return 0;
    }

    function countUniqueDenominations(Cosmos.Coin[] memory rewards)
        internal
        pure
        returns (uint256)
    {
        // Logic to count unique denominations excluding 'bgt' and 'bera'
        uint256 uniqueDenomsCount = 0;
        for (uint256 i = 0; i < rewards.length; i++) {
            if (
                keccak256(bytes(rewards[i].denom)) != keccak256(bytes("abgt"))
                    && keccak256(bytes(rewards[i].denom))
                        != keccak256(bytes("abera"))
            ) {
                uniqueDenomsCount++;
            }
        }
        return uniqueDenomsCount;
    }
}
