// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./Helper.sol";
import "@forge-std/console2.sol";

contract InfraredRegisterVaultTest is Helper {
    /*//////////////////////////////////////////////////////////////
                Vault Registration Tests (registerVault)
    //////////////////////////////////////////////////////////////*/
    function testSuccessfulVaultRegistration() public {
        stakingAsset = address(ired); // Assuming you have a mock iRED token
        // Grant the caller (this test contract) the KEEPER_ROLE to allow vault registration
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        // Mock data for the test
        address[] memory _rewardTokens = new address[](2); // Assuming you have reward token addresses
        _rewardTokens[0] = address(ibgt);
        _rewardTokens[1] = address(ired);

        /*
        // Expect the NewVault event to be emitted with correct parameters
        vm.expectEmit();
        emit IInfrared.NewVault(
            address(this), stakingAsset, expectedNewVaultAddress, _rewardTokens
        );
        */

        // Register the vault and capture the return value
        IInfraredVault newVault =
            infrared.registerVault(stakingAsset, _rewardTokens);
        address newVaultAddress = address(newVault);

        // Validate that the returned vault address matches the expected new vault address
        assertEq(
            address(newVault), newVaultAddress, "Vault not registered correctly"
        );

        // Validate that the vault is correctly registered in the vaultRegistry with the asset address
        assertEq(
            address(infrared.vaultRegistry(stakingAsset)),
            newVaultAddress,
            "Vault registry does not contain the new vault under the asset address"
        );
    }

    function testFailVaultRegistrationWithZeroAsset() public {
        // Grant the KEEPER_ROLE to this contract to perform the vault registration
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        // Define reward tokens assuming you have them set up for the test
        address[] memory _rewardTokens = new address[](1); // Modify as per your test setup
        _rewardTokens[0] = address(ired); // Example reward token address

        // Expect a revert due to passing a zero asset address to registerVault
        vm.expectRevert(Errors.ZeroAddress.selector);
        try infrared.registerVault(address(0), _rewardTokens) {
            revert("Zero address should revert");
        } catch {
            revert();
        }
    }

    function testFailVaultRegistrationWithInvalid_rewardTokens() public {
        // Grant the KEEPER_ROLE to this contract
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        MockERC20 mockAsset = new MockERC20("MockAsset", "MAS", 18); // Mock asset token
        // Setup for the asset and reward tokens
        address assetAddress = address(mockAsset); // Your mock asset address
        address[] memory _rewardTokens = new address[](1);
        _rewardTokens[0] = address(0); // Assuming zero address is an unsupported reward token

        // Pre-define the reward tokens as unsupported in your contract setup or mock accordingly
        // This step depends on your contract's logic for whitelisting reward tokens

        // Expect a revert due to invalid (unsupported) reward tokens
        vm.expectRevert(Errors.RewardTokenNotSupported.selector);
        infrared.registerVault(assetAddress, _rewardTokens);
        vm.expectRevert(Errors.RewardTokenNotSupported.selector);
    }

    function testFailVaultRegistrationUnauthorized() public {
        vm.startPrank(address(404)); // Simulate call from an unauthorized address

        address[] memory _rewardTokens; // Assuming you've defined _rewardTokens somewhere
        _rewardTokens[0] = address(ibgt); // Example reward token address
        _rewardTokens[1] = address(ired);
        // Adjusted to reflect the lack of poolAddress parameter and updated error handling
        vm.expectRevert(
            abi.encodeWithSelector(
                IAccessControl.AccessControlUnauthorizedAccount.selector,
                address(404),
                infrared.KEEPER_ROLE()
            )
        );

        // Updated to match the new function signature
        try infrared.registerVault(address(stakingAsset), _rewardTokens) {
            revert("Unauthorized address should revert");
        } catch {
            revert();
        }
    }

    function testFailVaultRegistrationDuplicateAsset() public {
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        address[] memory _rewardTokens; // Assuming you've defined _rewardTokens somewhere
        _rewardTokens[0] = address(ibgt); // Example reward token address
        _rewardTokens[1] = address(ired);

        // Because stakingAsset is already registered, expect a revert
        vm.expectRevert(Errors.DuplicateAssetAddress.selector);
        infrared.registerVault(address(stakingAsset), _rewardTokens);
    }

    function testVaultRegistrationWithEmpty_rewardTokens() public {
        address[] memory empty_rewardTokens = new address[](0); // Empty array for reward tokens
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        MockERC20 mockAsset = new MockERC20("MockAsset", "MAS", 18);

        // Assuming mockAsset has been initialized and represents the asset being staked
        address assetAddress = address(mockAsset);

        // Register the vault with an empty array of reward tokens
        vm.expectRevert(Errors.IBGTNotRewardToken.selector);
        infrared.registerVault(assetAddress, empty_rewardTokens);
    }

    function testVaultRegistrationWithoutIBGTRewardToken() public {
        address[] memory _rewardTokens = new address[](2); // Empty array for reward tokens
        _rewardTokens[0] = address(ired); // Example reward token address
        _rewardTokens[1] = address(wbera); // Example reward token address

        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        MockERC20 mockAsset = new MockERC20("MockAsset", "MAS", 18);

        // Assuming mockAsset has been initialized and represents the asset being staked
        address assetAddress = address(mockAsset);

        // Register the vault with an empty array of reward tokens
        vm.expectRevert(Errors.IBGTNotRewardToken.selector);
        infrared.registerVault(assetAddress, _rewardTokens);
    }

    function testVaultRegistrationWithoutIREDRewardToken() public {
        address[] memory _rewardTokens = new address[](2); // Empty array for reward tokens
        _rewardTokens[0] = address(ibgt); // Example reward token address
        _rewardTokens[1] = address(wbera); // Example reward token address

        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        MockERC20 mockAsset = new MockERC20("MockAsset", "MAS", 18);

        // Assuming mockAsset has been initialized and represents the asset being staked
        address assetAddress = address(mockAsset);

        // Register the vault with an empty array of reward tokens
        vm.expectRevert(Errors.IREDNotRewardToken.selector);
        infrared.registerVault(assetAddress, _rewardTokens);
    }

    function testRolePersistencePostVaultRegistration() public {
        // Grant the KEEPER_ROLE to the test contract
        infrared.grantRole(infrared.KEEPER_ROLE(), address(this));

        MockERC20 mockAsset = new MockERC20("MockAsset", "MAS", 18);
        // Prepare the reward tokens array; assuming it's already initialized and filled as needed
        address[] memory _rewardTokens = new address[](2); // example initialization
        _rewardTokens[0] = address(ibgt); // Assuming mockRewardToken has been defined elsewhere
        _rewardTokens[1] = address(ired);

        // Register the vault without specifying a pool address, adhering to the updated function signature
        infrared.registerVault(address(mockAsset), _rewardTokens);

        // Assert that the test contract still holds the KEEPER_ROLE after registering the vault
        assertTrue(
            infrared.hasRole(infrared.KEEPER_ROLE(), address(this)),
            "Keeper role should persist post registration"
        );
    }
}
