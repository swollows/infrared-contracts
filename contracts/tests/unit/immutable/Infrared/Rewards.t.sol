// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";
import "@forge-std/console2.sol";

contract InfraredRewardsTest is Helper {
    /*//////////////////////////////////////////////////////////////
                Vault Rewards test
    //////////////////////////////////////////////////////////////*/
    function testHarvestVault() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt // harvestVault should only ever be abgt
        mockRewardsPrecompile.setMockRewards(rewards);

        (address vault, address pool) = setupMockVault();

        vm.prank(keeper);
        infrared.harvestVault(pool);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 balance = ibgt.balanceOf(vault);
        assertEq(balance, 100);
    }

    function testFailHarvestVaultInvalidPool() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt // harvestVault should only ever be abgt
        mockRewardsPrecompile.setMockRewards(rewards);

        vm.prank(keeper);
        try infrared.harvestVault(address(123)) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Infrared: Invalid pool");
        }
        vm.stopPrank();
    }

    function testFailHarvestVaultUnauthorized() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt // harvestVault should only ever be abgt
        mockRewardsPrecompile.setMockRewards(rewards);

        (address vault, address pool) = setupMockVault();

        try infrared.harvestVault(pool) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Infrared: Unauthorized");
        }
    }

    function testFailHarvestVault_BGT_and_BERA_RewardTokens() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt // harvestVault should only ever be abgt
        rewards[1] = Cosmos.Coin(100, "abera"); // 100 abera // harvestVault should only ever be abgt
        mockRewardsPrecompile.setMockRewards(rewards);

        (address vault, address pool) = setupMockVault();

        vm.prank(keeper);
        try infrared.harvestVault(pool) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Infrared: Multiple reward tokens");
        }
        vm.stopPrank();
    }

    /*//////////////////////////////////////////////////////////////
                Validator Rewards test
    //////////////////////////////////////////////////////////////*/

    function testHarvestValidator() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abera"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        vm.prank(keeper);
        infrared.harvestValidator(validator);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 balance = mockWbera.balanceOf(address(ibgtVault));
        assertEq(balance, 100);
    }

    function testFailHarvestValidatorInvalidPool() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](1);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        vm.prank(keeper);
        infrared.harvestValidator(address(123));
        vm.expectRevert(
            abi.encodeWithSelector(Errors.InvalidValidator.selector)
        );
        vm.stopPrank();
    }

    function testFailHarvestValidatorUnauthorized() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        mockDistribution.setMockRewards(rewards);

        (address vault, address pool) = setupMockVault();

        try infrared.harvestValidator(validator) {
            fail();
        } catch Error(string memory reason) {
            assertEq(reason, "Infrared: Unauthorized");
        }
    }

    function testHarvestMultipleRewardTokens() public {
        Cosmos.Coin[] memory rewards = new Cosmos.Coin[](2);
        rewards[0] = Cosmos.Coin(100, "abgt"); // 100 bgt
        rewards[1] = Cosmos.Coin(100, "abera"); // 100 abera
        mockDistribution.setMockRewards(rewards);

        uint256 prevEthBalance = mockWbera.balanceOf(address(ibgtVault));

        vm.prank(keeper);
        infrared.harvestValidator(validator);
        vm.stopPrank();

        // check that the vault has the correct balance
        uint256 balance = mockWbera.balanceOf(address(ibgtVault));
        assertEq(balance, 100);
        assertEq(mockWbera.balanceOf(address(ibgtVault)) - prevEthBalance, 100); // check that native balance was increased by abera amount
    }
}
