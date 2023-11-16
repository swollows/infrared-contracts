// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Helper, InfraredVault, WrappedIBGT} from "./Helper.sol";
import {Errors} from "@utils/Errors.sol";
import {console2} from "forge-std/Script.sol";

contract WIBGTTest is Helper {
    /*//////////////////////////////////////////////////////////////
                          Set Vault
    //////////////////////////////////////////////////////////////*/

    function testSetVaultAuth() public {
        vm.expectRevert();
        _wrappedIBGT.setVault(_wibgtVault);
    }

    function testSetVaultZeroAddress() public prank(DEFAULT_ADMIN) {
        vm.expectRevert();
        _wrappedIBGT.setVault(InfraredVault(address(0)));
    }

    function testSetVault() public prank(DEFAULT_ADMIN) {
        _wrappedIBGT.setVault(_wibgtVault);

        // Check that the vault is set.
        assertEq(address(_wrappedIBGT.wibgtVault()), address(_wibgtVault));
    }

    /*//////////////////////////////////////////////////////////////
                          Approve Vault
    //////////////////////////////////////////////////////////////*/

    function testApproveVaultAuth() public {
        vm.expectRevert();
        _wrappedIBGT.approveVault();
    }

    function testApproveVaultZeroAddress() public prank(DEFAULT_ADMIN) {
        // Deploy a new WIBGT Vault.
        WrappedIBGT _new = new WrappedIBGT(_ibgt);
        vm.expectRevert(Errors.ZeroAddress.selector);
        _new.approveVault();
    }

    function testApproveVault() public prank(DEFAULT_ADMIN) {
        _wrappedIBGT.setVault(_wibgtVault);
        _wrappedIBGT.approveVault();

        // Check the allowance of the vault share token.
        uint256 _allowance =
            _wibgtVault.allowance(address(_wrappedIBGT), address(_wibgtVault));
        assertEq(_allowance, type(uint256).max);

        // Check that the allowance of the WIBGT to the vault is max.
        _allowance =
            _wrappedIBGT.allowance(address(_wrappedIBGT), address(_wibgtVault));
        assertEq(_allowance, type(uint256).max);
    }

    /*//////////////////////////////////////////////////////////////
                        Deposit
    //////////////////////////////////////////////////////////////*/

    function testDepositZeroAmount() public {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _wrappedIBGT.deposit(0, GOVERNANCE);
    }

    function testDepositZeroAddress() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wrappedIBGT.deposit(1000 ether, address(0));
    }

    function testDeposit() public prank(GOVERNANCE) {
        // Mint some tokens to the governance address.
        _ibgt.mint(GOVERNANCE, 1000 ether);

        // Approve the wrapped token to transfer the tokens.
        _ibgt.approve(address(_wrappedIBGT), 1000 ether);

        // Deposit the tokens into the vault.
        _wrappedIBGT.deposit(1000 ether, GOVERNANCE);
    }

    /*//////////////////////////////////////////////////////////////
                     Mint
    //////////////////////////////////////////////////////////////*/

    function testMintZeroAmount() public {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _wrappedIBGT.mint(0, GOVERNANCE);
    }

    function testMintZeroAddress() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wrappedIBGT.mint(1000 ether, address(0));
    }

    function testMint() public prank(GOVERNANCE) {
        // Mint some tokens to the governance address.
        _ibgt.mint(GOVERNANCE, 10_000 ether);

        // Approve the wrapped token to transfer the tokens.
        _ibgt.approve(address(_wrappedIBGT), 1000 ether);

        // Mint the shares.
        _wrappedIBGT.mint(1000 ether, GOVERNANCE);

        // Check that the balance of the governance address is correct.
        assertEq(_wibgtVault.balanceOf(GOVERNANCE), 1000 ether);
    }

    /*//////////////////////////////////////////////////////////////
                        Withdraw
    //////////////////////////////////////////////////////////////*/

    function testWithdrawZeroAmount() public {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _wrappedIBGT.withdraw(0, GOVERNANCE, GOVERNANCE);
    }

    function testWithdrawZeroAddressReceiver() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wrappedIBGT.withdraw(1000 ether, address(0), GOVERNANCE);
    }

    function testWithdrawZeroAddressOwner() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wrappedIBGT.withdraw(1000 ether, GOVERNANCE, address(0));
    }

    function testWithdraw() public prank(GOVERNANCE) {
        // Mint some tokens to the governance address.
        _ibgt.mint(GOVERNANCE, 1000 ether);

        // Approve the wrapped token to transfer the tokens.
        _ibgt.approve(address(_wrappedIBGT), 1000 ether);

        // Deposit the tokens into the vault.
        uint256 _shares = _wrappedIBGT.deposit(1000 ether, GOVERNANCE);

        // Approve the _shares to be transferred.
        _wibgtVault.approve(address(_wrappedIBGT), _shares);

        // Withdraw the tokens.
        uint256 _assets = _wrappedIBGT.withdraw(_shares, GOVERNANCE, GOVERNANCE);

        // Check that the assets are correct.
        assertEq(_assets, 1000 ether);
    }

    /*//////////////////////////////////////////////////////////////
                     Redeem
    //////////////////////////////////////////////////////////////*/

    function testRedeemZeroAmount() public {
        vm.expectRevert(Errors.ZeroAmount.selector);
        _wrappedIBGT.redeem(0, GOVERNANCE, GOVERNANCE);
    }

    function testRedeemZeroAddress() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wrappedIBGT.redeem(1000 ether, address(0), GOVERNANCE);
    }

    function testRedeemZeroReceiver() public {
        vm.expectRevert(Errors.ZeroAddress.selector);
        _wrappedIBGT.redeem(1000 ether, GOVERNANCE, address(0));
    }

    function testRedeem() public prank(GOVERNANCE) {
        // Mint some tokens to the governance address.
        _ibgt.mint(GOVERNANCE, 1000 ether);

        // Approve the wrapped token to transfer the tokens.
        _ibgt.approve(address(_wrappedIBGT), 1000 ether);

        // Deposit the tokens into the vault.
        uint256 _shares = _wrappedIBGT.deposit(1000 ether, GOVERNANCE);

        // Approve the _shares to be transferred.
        _wibgtVault.approve(address(_wrappedIBGT), _shares);

        // Redeem the tokens.
        uint256 _assets = _wrappedIBGT.redeem(_shares, GOVERNANCE, GOVERNANCE);

        // Check that the assets are correct.
        assertEq(_assets, 1000 ether);
    }
}
