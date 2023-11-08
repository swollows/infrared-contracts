// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Helper, ERC20, InfraredVault, IBGT, IInfraredVault, IERC20Mintable} from "./Helper.sol";
import {Errors} from "@utils/Errors.sol";
import {Cosmos} from "@polaris/CosmosTypes.sol";
import {IERC20Mintable} from "@interfaces/IERC20Mintable.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";

contract InfraredTest is Helper {
    /*//////////////////////////////////////////////////////////////
                     Register Vault
    //////////////////////////////////////////////////////////////*/
    using SafeERC20 for IERC20Mintable;

    function testRegisterVaultAuth() public prank(ALICE) {
        address[] memory _rewardTokens = new address[](1);
        _rewardTokens[0] = address(_dai);
        vm.expectRevert();
        _infrared.registerVault(address(1), "test", "TST", _rewardTokens, address(2));
    }

    function testRegisterVault() public prank(KEEPER) {
        address[] memory _rewardTokens = new address[](1);
        _rewardTokens[0] = address(_dai);
        IInfraredVault _new = _infrared.registerVault(address(_usdc), "test", "TST", _rewardTokens, address(2));

        // Check that the vault is registered.
        _infrared.isInfraredVault(address(_new));
    }

    /*//////////////////////////////////////////////////////////////
                     Update Wrapped IBGT Vault
    //////////////////////////////////////////////////////////////*/

    function testUpdateWrappedIBGTVaultAuth() public prank(ALICE) {
        address[] memory _rewardTokens = new address[](1);
        _rewardTokens[0] = address(_dai);
        vm.expectRevert();
        _infrared.updateWIBGTVault(IInfraredVault(address(_wibgtVault)), _rewardTokens);
    }

    function testUpdateWrappedIBGTVault12() public prank(GOVERNANCE) {
        address[] memory _rewardTokens = new address[](1);
        _rewardTokens[0] = address(_dai);

        // _dai.allowance(address(_infrared), address(_wibgtVault));
        // vm.stopPrank();
        // vm.startPrank(address(this));
        // vm.stopPrank();

        // vm.startPrank(address(_infrared));
        // IERC20Mintable(address(_dai)).safeApprove(address(_wibgtVault),
        // type(uint256).max);
        // vm.stopPrank();

        // vm.startPrank(GOVERNANCE);
        _infrared.updateWIBGTVault(IInfraredVault(address(_wibgtVault)), _rewardTokens);
    }

    /*//////////////////////////////////////////////////////////////
                    Validator Set
    //////////////////////////////////////////////////////////////*/

    function testAddValidatorsAuth() public prank(ALICE) {
        address[] memory _validators = new address[](1);
        _validators[0] = address(1);
        vm.expectRevert();
        _infrared.addValidators(_validators);
    }

    function testAddValidators() public prank(GOVERNANCE) {
        address[] memory _validators = new address[](1);
        _validators[0] = address(1);
        _infrared.addValidators(_validators);

        // Check that the validator is added.
        assert(_infrared.isInfraredValidator(address(1)));
    }

    function testRemoveValidatorsAuth() public prank(ALICE) {
        address[] memory _validators = new address[](1);
        _validators[0] = address(1);
        vm.expectRevert();
        _infrared.removeValidators(_validators);
    }

    function testRemoveValidator() public prank(GOVERNANCE) {
        address[] memory _validators = new address[](1);
        _validators[0] = address(1);
        _infrared.addValidators(_validators);
        _infrared.removeValidators(_validators);

        // Check that the validator is removed.
        assert(!_infrared.isInfraredValidator(address(1)));
    }

    function testReplaceValidatorAuth() public prank(ALICE) {
        vm.expectRevert();
        _infrared.replaceValidator(address(1), address(2));
    }

    function testReplaceValidator() public prank(GOVERNANCE) {
        address _val0 = address(1);
        address _val1 = address(2);

        // Set the validator.
        address[] memory _validators = new address[](1);
        _validators[0] = _val0;
        _infrared.addValidators(_validators);

        // Replace the validator.
        _infrared.replaceValidator(_val0, _val1);

        // Check that the validator is removed.
        assert(!_infrared.isInfraredValidator(_val0));

        // Check that the validator is added.
        assert(_infrared.isInfraredValidator(_val1));
    }

    /*//////////////////////////////////////////////////////////////
                    Harvest Validator
    //////////////////////////////////////////////////////////////*/

    function testHarvestValidatorZeroAddress() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _infrared.harvestValidator(address(0));
    }

    function testHarvestValidatorDoesNotExist() public {
        vm.expectRevert(abi.encodeWithSelector(Errors.ValidatorDoesNotExist.selector, address(ALICE)));
        _infrared.harvestValidator(ALICE);
    }

    function testHarvestValidatorZeroRewards() public {
        // Rewards From the distribution module.
        Cosmos.Coin[] memory _rewards = new Cosmos.Coin[](0);
        _mockDistributionModuleWithdraw(_val0, _rewards);

        // Harvest the validator.
        _infrared.harvestValidator(_val0);
    }

    function testHarvestValidatorOnlyBGT() public {
        // Rewards From the distribution module.
        Cosmos.Coin[] memory _rewards = new Cosmos.Coin[](1);
        _rewards[0] = Cosmos.Coin(100, BGT_DENOM);
        _mockDistributionModuleWithdraw(_val0, _rewards);

        // Harvest the validator.
        _infrared.harvestValidator(_val0);

        // Check that the vault has the correct balances.
        assertEq(_ibgt.balanceOf(address(_wibgtVault)), 100);
    }

    function testHarvestValidator() public prank(GOVERNANCE) {
        // Rewards From the distribution module.
        Cosmos.Coin[] memory _rewards = new Cosmos.Coin[](2);
        _rewards[0] = Cosmos.Coin(100, "dai");
        _rewards[1] = Cosmos.Coin(100, BGT_DENOM);
        _mockDistributionModuleWithdraw(_val0, _rewards);

        // Mock the ERC20 module for the cosmos sdk coins to contract address.
        _mockERC20ModuleMapping("dai", address(_dai));

        // Assert that the mock is correct.
        assertEq(address(_erc20Precompile.erc20AddressForCoinDenom("dai")), address(_dai));

        // Mint the tokens to the infrared contract to mimick a transfer from
        // erc20 module.
        IBGT(address(_dai)).mint(address(_infrared), 100);

        // Harvest the validator.
        _infrared.harvestValidator(_val0);

        // Check that the vault has the correct balances.
        assertEq(_dai.balanceOf(address(_wibgtVault)), 100);
        assertEq(_ibgt.balanceOf(address(_wibgtVault)), 100);
    }

    /*//////////////////////////////////////////////////////////////
                    Harvest Vault
    //////////////////////////////////////////////////////////////*/

    function testHarvestVaultZeroAddress() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _infrared.harvestVault(address(0));
    }

    function testHarvestVaultVaultNotSupported() public {
        vm.expectRevert(abi.encodeWithSelector(Errors.VaultNotSupported.selector, address(_usdc)));
        _infrared.harvestVault(address(_usdc));
    }

    function testHarvestVaultZeroRewards() public {
        // Rewards from the rewards module.
        Cosmos.Coin[] memory _rewards = new Cosmos.Coin[](0);
        _mockRewardsPrecompileWithdraw(_daiVault.poolAddress(), _rewards);

        // Harvest the vault.
        _infrared.harvestVault(address(_daiVault));
    }

    function testHarvestVaultOnlyBGT() public {
        // Rewards from the rewards module.
        Cosmos.Coin[] memory _rewards = new Cosmos.Coin[](1);
        _rewards[0] = Cosmos.Coin(100, BGT_DENOM);
        _mockRewardsPrecompileWithdraw(_daiVault.poolAddress(), _rewards);

        // Harvest the vault.
        _infrared.harvestVault(address(_daiVault));

        // Check that the vault has the correct balances.
        assertEq(_ibgt.balanceOf(address(_daiVault)), 100);
    }

    function testHarvestVault() public prank(GOVERNANCE) {
        // Rewards from the rewards module.
        Cosmos.Coin[] memory _rewards = new Cosmos.Coin[](2);
        _rewards[0] = Cosmos.Coin(100, "usdc");
        _rewards[1] = Cosmos.Coin(100, BGT_DENOM);
        _mockRewardsPrecompileWithdraw(_daiVault.poolAddress(), _rewards);

        // Mock the ERC20 module for the cosmos sdk coins to contract address.
        _mockERC20ModuleMapping("usdc", address(_usdc));

        // Assert that the mock is correct.
        assertEq(address(_erc20Precompile.erc20AddressForCoinDenom("usdc")), address(_usdc));

        // Mint the usdc tokens to the infrared contract to mimick a transfer
        // from erc20 module.
        IBGT(address(_usdc)).mint(address(_infrared), 100);

        // Harvest the vault.
        _infrared.harvestVault(address(_daiVault));

        // Check that the vault has the correct balances.
        assertEq(_usdc.balanceOf(address(_daiVault)), 100);
        assertEq(_ibgt.balanceOf(address(_daiVault)), 100);
    }

    /*//////////////////////////////////////////////////////////////
                          Delegate
    //////////////////////////////////////////////////////////////*/

    function testDelegateAuth() public prank(ALICE) {
        vm.expectRevert();
        _infrared.delegate(address(1), 100);
    }

    function testDelegateZeroAddress() public prank(KEEPER) {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _infrared.delegate(address(0), 100);
    }

    function testDelegateZeroAmount() public prank(KEEPER) {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _infrared.delegate(address(1), 0);
    }

    function testDelegateNotInfraredValidator() public prank(KEEPER) {
        vm.expectRevert(abi.encodeWithSelector(Errors.ValidatorDoesNotExist.selector, address(1)));
        _infrared.delegate(address(1), 100);
    }

    function testDelegateDelegateFails() public prank(KEEPER) {
        _mockDelegate(_val0, 100, false);
        vm.expectRevert(abi.encodeWithSelector(Errors.DelegationFailed.selector));
        _infrared.delegate(_val0, 100);
    }

    function testDelegate() public prank(KEEPER) {
        _mockDelegate(_val0, 100, true);
        _infrared.delegate(_val0, 100);
    }

    /*//////////////////////////////////////////////////////////////
                          Undelegate
    //////////////////////////////////////////////////////////////*/

    function testUndelegateAuth() public prank(ALICE) {
        vm.expectRevert();
        _infrared.undelegate(address(1), 100);
    }

    function testUndelegateZeroAddress() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _infrared.undelegate(address(0), 100);
    }

    function testUndelegateZeroAmount() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _infrared.undelegate(address(1), 0);
    }

    function testUndelegateNotInfraredValidator() public prank(GOVERNANCE) {
        vm.expectRevert(abi.encodeWithSelector(Errors.ValidatorDoesNotExist.selector, address(1)));
        _infrared.undelegate(address(1), 100);
    }

    function testUndelegateUndelegateFails() public prank(GOVERNANCE) {
        _mockUndelegate(_val0, 100, false);
        vm.expectRevert(abi.encodeWithSelector(Errors.UndelegateFailed.selector));
        _infrared.undelegate(_val0, 100);
    }

    function testUndelegate() public prank(GOVERNANCE) {
        _mockUndelegate(_val0, 100, true);
        _infrared.undelegate(_val0, 100);
    }

    /*//////////////////////////////////////////////////////////////
                      Begin Redelegation
    //////////////////////////////////////////////////////////////*/

    function testBeginRedelegateAuth() public prank(ALICE) {
        vm.expectRevert();
        _infrared.beginRedelegate(address(1), address(2), 100);
    }

    function testBeginRedelegateZeroAddress() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _infrared.beginRedelegate(address(0), address(2), 100);
    }

    function testBeginRedelegateZeroDestination() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _infrared.beginRedelegate(address(1), address(0), 100);
    }

    function testBeginRedelegateZeroAmount() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _infrared.beginRedelegate(address(1), address(2), 0);
    }

    function testBeginRedelegateNotInfraredValidator() public prank(GOVERNANCE) {
        vm.expectRevert(abi.encodeWithSelector(Errors.ValidatorDoesNotExist.selector, address(2)));
        _infrared.beginRedelegate(address(1), address(2), 100);
    }

    function testBeginRedelegateBeginRedelegateFails() public prank(GOVERNANCE) {
        _mockBeginRedelegations(_val0, _val1, 100, false);
        vm.expectRevert(abi.encodeWithSelector(Errors.BeginRedelegateFailed.selector));
        _infrared.beginRedelegate(_val0, _val1, 100);
    }

    /*//////////////////////////////////////////////////////////////
                    CancelUnbondingDelegation
    //////////////////////////////////////////////////////////////*/

    function testCancelUnbondingDelegationAuth() public prank(ALICE) {
        vm.expectRevert();
        _infrared.cancelUnbondingDelegation(_val0, 100, 100);
    }

    function testCancelUnbondingDelegationZeroAddress() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _infrared.cancelUnbondingDelegation(address(0), 100, 100);
    }

    function testCancelUnbondingDelegationZeroAmount0() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _infrared.cancelUnbondingDelegation(_val0, 0, 100);
    }

    function testCancelUnbondingDelegationZeroAmount1() public prank(GOVERNANCE) {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _infrared.cancelUnbondingDelegation(_val0, 100, 0);
    }

    function testCancelUnbondingDelegationNotInfraredValidator() public prank(GOVERNANCE) {
        vm.expectRevert(abi.encodeWithSelector(Errors.ValidatorDoesNotExist.selector, address(10)));
        _infrared.cancelUnbondingDelegation(address(10), 100, 100);
    }

    function testCancelUnbondingDelegationCancelUnbondingDelegationFails() public prank(GOVERNANCE) {
        _mockCancelUnbondingDelegation(_val0, 100, 100, false);
        vm.expectRevert(abi.encodeWithSelector(Errors.CancelUnbondingDelegationFailed.selector));
        _infrared.cancelUnbondingDelegation(_val0, 100, 100);
    }

    function testCancelUnbondingDelegation() public prank(GOVERNANCE) {
        _mockCancelUnbondingDelegation(_val0, 100, 100, true);
        _infrared.cancelUnbondingDelegation(_val0, 100, 100);
    }
}
