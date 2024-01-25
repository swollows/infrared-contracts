// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

//
import "@utils/DataTypes.sol";
import "@utils/ValidatorRewards.sol";

import "../../mocks/MockERC20.sol";

// internal
import "../Infrared/Helper.sol";

contract ValidatorRewardsTest is Helper {
    /*//////////////////////////////////////////////////////////////
                            claimDistrPrecompile
    //////////////////////////////////////////////////////////////*/

    function testClaimDistrPrecompileNoRewards() public {
        // Set up the mock distribution module to return no rewards
        mockDistribution.setMockRewards(new Cosmos.Coin[](0));

        // Call the claimDistrPrecompile function
        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = ValidatorRewards
            .claimDistrPrecompile(
            address(1),
            ValidatorRewards.PrecompileAddresses({
                erc20BankPrecompile: address(mockErc20Bank),
                distributionPrecompile: address(mockDistribution),
                wbera: address(mockWbera)
            })
        );

        // Assert that no rewards are returned
        assertEq(tokens.length, 0);
        assertEq(bgtAmt, 0);
    }

    // Test Only BGT Rewards
    function testClaimDistrPrecompileOnlyBgtRewards() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = ValidatorRewards
            .claimDistrPrecompile(
            address(1),
            ValidatorRewards.PrecompileAddresses({
                erc20BankPrecompile: address(mockErc20Bank),
                distributionPrecompile: address(mockDistribution),
                wbera: address(mockWbera)
            })
        );

        assertEq(tokens.length, 0);
        assertEq(bgtAmt, 100);
    }

    // Test BGT and BERA Rewards
    function testClaimDistrPrecompileBgtAndBeraRewards() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        rewards[1] = Cosmos.Coin(50, "abera"); // 50 bera
        mockDistribution.setMockRewards(rewards);

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = ValidatorRewards
            .claimDistrPrecompile(
            address(1),
            ValidatorRewards.PrecompileAddresses({
                erc20BankPrecompile: address(mockErc20Bank),
                distributionPrecompile: address(mockDistribution),
                wbera: address(mockWbera)
            })
        );

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

        // mockErc20Bank.setErc20AddressForCoinDenom(denom, erc20Address);

        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = ValidatorRewards
            .claimDistrPrecompile(
            address(1),
            ValidatorRewards.PrecompileAddresses({
                erc20BankPrecompile: address(mockErc20Bank),
                distributionPrecompile: address(mockDistribution),
                wbera: address(mockWbera)
            })
        );

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
        ValidatorRewards.claimDistrPrecompile(
            address(1),
            ValidatorRewards.PrecompileAddresses({
                erc20BankPrecompile: address(mockErc20Bank),
                distributionPrecompile: address(mockDistribution),
                wbera: address(mockWbera)
            })
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
            address mockAddress = address(new MockERC20("Mock", "Mock", 18));
            mockErc20Bank.setErc20AddressForCoinDenom(
                rewards[i].denom, mockAddress
            );
        }

        // Set the mock rewards
        mockDistribution.setMockRewards(rewards);

        console2.log(address(this).balance);

        // Call the function
        (DataTypes.Token[] memory tokens, uint256 bgtAmt) = ValidatorRewards
            .claimDistrPrecompile(
            address(1),
            ValidatorRewards.PrecompileAddresses({
                erc20BankPrecompile: address(mockErc20Bank),
                distributionPrecompile: address(mockDistribution),
                wbera: address(mockWbera)
            })
        );

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
