// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Helper} from './Helper.sol';
import {Errors} from '@utils/Errors.sol';

contract InfraredVaultTest is Helper {
    function testRewardTokens() public {
        address[] memory expected = new address[](2);
        expected[0] = address(_ibgt);
        expected[1] = address(_dai);
        address[] memory actual = _wibgtVault.rewardTokens();
        assertEq(actual.length, expected.length);

        for (uint256 _i; _i < actual.length; _i++) {
            assertEq(actual[_i], expected[_i]);
        }
    }

    /*//////////////////////////////////////////////////////////////
              Change Rewards Withdraw Address
  //////////////////////////////////////////////////////////////*/

    function TestChangeRewardsWithdrawAddressAuth() public prank(ALICE) {
        vm.expectRevert();
        _wibgtVault.changeRewardsWithdrawAddress(ALICE);
    }

    function testCannotChangeWithdrawAddressWithZeroAddress() public prank(DEFAULT_ADMIN) {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wibgtVault.changeRewardsWithdrawAddress(address(0));
    }

    function testCannotChangeWithdrawAddressIfPrecompileFails() public prank(DEFAULT_ADMIN) {
        // Mock the precompile to fail.
        vm.mockCall(
            address(_rewardsPrecompile),
            abi.encodeWithSelector(_rewardsPrecompile.setDepositorWithdrawAddress.selector, address(_infrared)),
            abi.encode(false)
        );

        vm.expectRevert(Errors.SetWithdrawAddressFailed.selector);

        _wibgtVault.changeRewardsWithdrawAddress(ALICE);

        vm.clearMockedCalls();
    }

    function testChangeWithdrawAddress() public prank(DEFAULT_ADMIN) {
        // Mock the precompile to succeed.
        vm.mockCall(
            address(_rewardsPrecompile),
            abi.encodeWithSelector(_rewardsPrecompile.setDepositorWithdrawAddress.selector, address(ALICE)),
            abi.encode(true)
        );

        _wibgtVault.changeRewardsWithdrawAddress(ALICE);
    }

    // /*//////////////////////////////////////////////////////////////
    //          Change Distribution Withdraw Address
    // //////////////////////////////////////////////////////////////*/

    function testChangeDistrWithdrawAddressAuth() public prank(ALICE) {
        vm.expectRevert();
        _wibgtVault.changeRewardsWithdrawAddress(ALICE);
    }

    function testCannotChangeDistrWithdrawAddressWithZeroAddress() public prank(DEFAULT_ADMIN) {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wibgtVault.changeRewardsWithdrawAddress(address(0));
    }

    function testCannotDistrChangeWithdrawAddressIfPrecompileFails() public prank(DEFAULT_ADMIN) {
        // Mock the precompile to fail.
        vm.mockCall(
            address(_distributionPrecompile),
            abi.encodeWithSelector(_distributionPrecompile.setWithdrawAddress.selector, address(_wibgtVault)),
            abi.encode(false)
        );

        vm.expectRevert(Errors.SetWithdrawAddressFailed.selector);
        _wibgtVault.changeDistributionWithdrawAddress(ALICE);

        vm.clearMockedCalls();
    }

    function testChangeDistrWithdrawAddress() public prank(DEFAULT_ADMIN) {
        // Mock the precompile to succeed.
        vm.mockCall(
            address(_distributionPrecompile),
            abi.encodeWithSelector(_distributionPrecompile.setWithdrawAddress.selector, address(ALICE)),
            abi.encode(true)
        );

        _wibgtVault.changeDistributionWithdrawAddress(ALICE);
        vm.clearMockedCalls();
    }

    /*//////////////////////////////////////////////////////////////
                        Add Reward Tokens
  //////////////////////////////////////////////////////////////*/

    function testAddRewardTokenAuth() public prank(ALICE) {
        vm.expectRevert();

        address[] memory _tokens = new address[](1);
        _tokens[0] = address(_dai);
        _wibgtVault.addRewardTokens(_tokens);
    }

    function testAddRewardTokenZeroAddress() public prank(DEFAULT_ADMIN) {
        vm.expectRevert(Errors.ZeroAddress.selector);

        address[] memory _tokens = new address[](1);
        _tokens[0] = address(0);
        _wibgtVault.addRewardTokens(_tokens);
    }

    function testAddRewardTokens() public prank(DEFAULT_ADMIN) {
        address[] memory _tokens = new address[](1);
        _tokens[0] = address(10); // NEW TOKEN MOCK.
        _wibgtVault.addRewardTokens(_tokens);

        address[] memory _expected = new address[](3);
        _expected[0] = address(_ibgt);
        _expected[1] = address(_dai);
        _expected[2] = address(10); // NEW TOKEN MOCK.

        address[] memory _actual = _wibgtVault.rewardTokens();
        assertEq(_actual.length, _expected.length);

        for (uint256 _i; _i < _actual.length; _i++) {
            assertEq(_actual[_i], _expected[_i]);
        }
    }
}
