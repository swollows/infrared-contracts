// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {
    Helper,
    Infrared,
    Errors,
    MockERC20,
    IInfraredVault,
    IAccessControl
} from "./Helper.sol";
import "@forge-std/console2.sol";

contract InfraredRegisterVaultTest is Helper {
    /*//////////////////////////////////////////////////////////////
                Vault Registration Tests (registerVault)
    //////////////////////////////////////////////////////////////*/

    function testSuccessfulVaultRegistration() public {
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));
        IInfraredVault newVault = infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            rewardTokens,
            poolAddress
        );

        assertEq(
            address(newVault),
            address(infrared.vaultRegistry(poolAddress)),
            "Vault not registered correctly"
        );
    }

    function testFailVaultRegistrationWithZeroAsset() public {
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));
        vm.expectRevert(Errors.ZeroAddress.selector);
        infrared.registerVault(
            address(0), vaultName, vaultSymbol, rewardTokens, poolAddress
        );
    }

    function testFailVaultRegistrationWithInvalidPoolAddress() public {
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));
        vm.expectRevert(Errors.ZeroAddress.selector);
        infrared.registerVault(
            address(mockAsset), vaultName, vaultSymbol, rewardTokens, address(0)
        );
    }

    function testFailVaultRegistrationUnauthorized() public {
        vm.prank(address(2)); // Simulate call from unauthorized address
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(2),
                infrared.DEFAULT_ADMIN_ROLE()
            )
        );
        infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            rewardTokens,
            poolAddress
        );
    }

    function testFailVaultRegistrationDuplicatePoolAddress() public {
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        // First registration should succeed
        infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            rewardTokens,
            poolAddress
        );

        // Second attempt to register the same pool address
        infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            rewardTokens,
            poolAddress
        );

        // Expect a revert due to duplicate pool address
        vm.expectRevert(Errors.DuplicatePoolAddress.selector);
    }

    function testFailVaultRegistrationInvalidRewardTokens() public {
        address[] memory invalidRewardTokens = new address[](1);
        invalidRewardTokens[0] = address(0); // Invalid reward token address

        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        // Expect a revert due to invalid reward tokens
        vm.expectRevert(Errors.ZeroAddress.selector);

        // Attempt to register with invalid reward tokens
        infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            invalidRewardTokens,
            poolAddress
        );
    }

    function testVaultRegistrationWithEmptyRewardTokens() public {
        address[] memory emptyRewardTokens = new address[](0);
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        IInfraredVault newVault = infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            emptyRewardTokens,
            poolAddress
        );

        assertEq(
            address(newVault),
            address(infrared.vaultRegistry(poolAddress)),
            "Vault registration with empty reward tokens failed"
        );
    }

    function testVaultRegistrationWithMultipleRewardTokens() public {
        address[] memory multipleRewardTokens = new address[](2);
        multipleRewardTokens[0] =
            address(new MockERC20("Mock Reward Token 1", "MRT1", 18));
        multipleRewardTokens[1] =
            address(new MockERC20("Mock Reward Token 2", "MRT2", 18));

        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        IInfraredVault newVault = infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            multipleRewardTokens,
            poolAddress
        );

        assertEq(
            address(newVault),
            address(infrared.vaultRegistry(poolAddress)),
            "Vault registration with multiple reward tokens failed"
        );
    }

    function testVaultRegistrationWithLongNameAndSymbol() public {
        string memory longName = new string(256); // Assuming 256 is an unusually long name
        string memory longSymbol = new string(256); // Assuming 256 is an unusually long symbol

        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        IInfraredVault newVault = infrared.registerVault(
            address(mockAsset), longName, longSymbol, rewardTokens, poolAddress
        );

        assertEq(
            address(newVault),
            address(infrared.vaultRegistry(poolAddress)),
            "Vault registration with long name and symbol failed"
        );
    }

    function testRolePersistencePostVaultRegistration() public {
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        infrared.registerVault(
            address(mockAsset),
            vaultName,
            vaultSymbol,
            rewardTokens,
            poolAddress
        );

        assertTrue(
            infrared.hasRole(infrared.KEEPER_ROLE(), address(this)),
            "Keeper role should persist post registration"
        );
    }
}
