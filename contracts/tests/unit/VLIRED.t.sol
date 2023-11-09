// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Helper, IBGT} from "./Helper.sol";
import {VLIRED} from "@core/VLIRED.sol";
import {ERC20} from "@solmate/tokens/ERC20.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";

contract TestVLIRED is Helper {
    uint256 lockAmount = 1e9;

    function testInitialState() public {
        string memory name = _vliRed.name();
        string memory symbol = _vliRed.symbol();
        uint8 decimals = _vliRed.decimals();
        uint256 lockedSupply = _vliRed.lockedSupply();
        uint256 lockDuration = _vliRed.LOCK_DURATION();
        uint256 epochDuration = _vliRed.EPOCH_DURATION();

        assertEq(name, "Value-Locked IRED", "Name should be Value-Locked IRED");
        assertEq(symbol, "vlIRED", "Symbol should be vlIRED");
        assertEq(decimals, 18, "Decimals should be 18");
        assertEq(lockedSupply, 0, "Locked supply should be 0");
        assertEq(
            lockDuration,
            epochDuration * 16,
            "Lock duration should be 16 times epoch duration"
        );
    }

    function testConstructor() public {
        ERC20 ired = _vliRed.IRED();
        assertEq(address(ired), address(_ired), "IRED address should be set");
    }

    function testShutdown() public prank(DEFAULT_ADMIN) {
        _vliRed.shutdown();
        bool isShutdown = _vliRed.isShutdown();
        assertEq(true, isShutdown, "Contract should be shut down");
    }

    function testLock() public prank(DEFAULT_ADMIN) {
        IBGT(address(_ired)).mint(DEFAULT_ADMIN, lockAmount);
        IBGT(address(_ired)).approve(address(_vliRed), lockAmount);
        _vliRed.lock(DEFAULT_ADMIN, lockAmount);

        uint256 lockedBalance = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);
        assertEq(
            lockedBalance,
            lockAmount,
            "Locked balance should match the locked amount"
        );
    }

    function testProcessExpiredLocksWithoutRelock()
        public
        prank(DEFAULT_ADMIN)
    {
        IBGT(address(_ired)).mint(DEFAULT_ADMIN, lockAmount);
        IBGT(address(_ired)).approve(address(_vliRed), lockAmount);
        _vliRed.lock(DEFAULT_ADMIN, lockAmount);

        uint256 iredBalanceBefore = _ired.balanceOf(DEFAULT_ADMIN);
        uint256 lockedBalanceBefore = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);

        (, uint256 unlockable,, VLIRED.LockedBalance[] memory lockData) =
            _vliRed.lockedBalances(DEFAULT_ADMIN);
        uint256 expectedUnlockable = unlockable + lockData[0].amount;

        // Simulate passing of time until the next lock expiry
        vm.warp(lockData[0].unlockTime);

        (, uint256 unlockableMid, uint256 locked,) =
            _vliRed.lockedBalances(DEFAULT_ADMIN);

        uint256 activeBalance = _vliRed.balanceOf(DEFAULT_ADMIN);
        uint256 pendingLock = _vliRed.pendingLockOf(DEFAULT_ADMIN);
        assertEq(unlockableMid, lockData[0].amount);
        assertEq(activeBalance, locked + pendingLock);

        _vliRed.processExpiredLocks(false);

        uint256 iredBalanceAfter = _ired.balanceOf(DEFAULT_ADMIN);
        uint256 lockedBalanceAfter = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);
        (, uint256 unlockableAfter,,) = _vliRed.lockedBalances(DEFAULT_ADMIN);

        assertEq(iredBalanceAfter, iredBalanceBefore + expectedUnlockable);
        assertEq(lockedBalanceAfter, lockedBalanceBefore - expectedUnlockable);
        assertEq(unlockableAfter, 0);
    }

    function testProcessExpiredLocksWithRelock() public prank(DEFAULT_ADMIN) {
        IBGT(address(_ired)).mint(DEFAULT_ADMIN, lockAmount);
        IBGT(address(_ired)).approve(address(_vliRed), lockAmount);
        _vliRed.lock(DEFAULT_ADMIN, lockAmount);

        uint256 iredBalanceBefore = _ired.balanceOf(DEFAULT_ADMIN);
        uint256 lockedBalanceBefore = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);

        (, uint256 unlockable,, VLIRED.LockedBalance[] memory lockData) =
            _vliRed.lockedBalances(DEFAULT_ADMIN);
        uint256 expectedUnlockable = unlockable + lockData[0].amount;
        uint256 expectedLocked = lockedBalanceBefore;

        // Simulate passing of time until the next lock expiry
        vm.warp(lockData[0].unlockTime);

        (, uint256 unlockableMid,,) = _vliRed.lockedBalances(DEFAULT_ADMIN);
        assertEq(unlockableMid, lockData[0].amount);

        _vliRed.processExpiredLocks(true);

        uint256 iredBalanceAfter = _ired.balanceOf(DEFAULT_ADMIN);
        uint256 lockedBalanceAfter = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);
        (, uint256 unlockableAfter, uint256 lockedAfter,) =
            _vliRed.lockedBalances(DEFAULT_ADMIN);

        assertEq(iredBalanceAfter, iredBalanceBefore);
        assertEq(lockedBalanceAfter, lockedBalanceBefore);
        assertEq(unlockableAfter, 0);
        assertEq(lockedAfter, expectedLocked);

        uint256 pendingLock = _vliRed.pendingLockOf(DEFAULT_ADMIN);
        assertEq(pendingLock, expectedUnlockable);
    }

    function testWithdrawTokensFromExpiredLocksWithoutRelock()
        public
        prank(DEFAULT_ADMIN)
    {
        IBGT(address(_ired)).mint(DEFAULT_ADMIN, lockAmount);
        IBGT(address(_ired)).approve(address(_vliRed), lockAmount);
        _vliRed.lock(DEFAULT_ADMIN, lockAmount);

        uint256 iredBalanceBefore = _ired.balanceOf(DEFAULT_ADMIN);
        uint256 lockedBalanceBefore = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);

        (, uint256 unlockable,, VLIRED.LockedBalance[] memory lockData) =
            _vliRed.lockedBalances(DEFAULT_ADMIN);
        uint256 expectedUnlockable = unlockable + lockData[0].amount;

        // Simulate passing of time until the next lock expiry
        vm.warp(lockData[0].unlockTime);

        (, uint256 unlockableMid,,) = _vliRed.lockedBalances(DEFAULT_ADMIN);
        assertEq(unlockableMid, lockData[0].amount);

        // Withdraw tokens from expired locks without relock
        _vliRed.withdrawExpiredLocksTo(DEFAULT_ADMIN);

        uint256 iredBalanceAfter = _ired.balanceOf(DEFAULT_ADMIN);
        uint256 lockedBalanceAfter = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);
        (, uint256 unlockableAfter,,) = _vliRed.lockedBalances(DEFAULT_ADMIN);

        assertEq(iredBalanceAfter, iredBalanceBefore + expectedUnlockable);
        assertEq(lockedBalanceAfter, lockedBalanceBefore - expectedUnlockable);
        assertEq(unlockableAfter, 0);

        uint256 pendingLock = _vliRed.pendingLockOf(DEFAULT_ADMIN);
        assertEq(pendingLock, 0);
    }

    function testRevertWhenCalledByUnauthorizedCaller() public prank(ALICE) {
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector, address(ALICE)
            )
        );
        _vliRed.shutdown();
    }

    function testShutdownAndForceUnlockAllTokens()
        public
        prank(DEFAULT_ADMIN)
    {
        IBGT(address(_ired)).mint(DEFAULT_ADMIN, lockAmount);
        IBGT(address(_ired)).approve(address(_vliRed), lockAmount);
        _vliRed.lock(DEFAULT_ADMIN, lockAmount);

        uint256 lockedBalanceBefore = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);
        uint256 iredBalanceBefore = _ired.balanceOf(DEFAULT_ADMIN);

        // Simulate the shutdown
        _vliRed.shutdown();

        // Attempt to lock, which should revert
        try _vliRed.lock(DEFAULT_ADMIN, 1) {
            revert("Expected revert: IsShutdown()");
        } catch Error(string memory) {}

        // Attempt to withdraw without any time skip
        _vliRed.withdrawExpiredLocksTo(DEFAULT_ADMIN);

        uint256 lockedBalanceAfter = _vliRed.lockedBalanceOf(DEFAULT_ADMIN);
        uint256 iredBalanceAfter = _ired.balanceOf(DEFAULT_ADMIN);
        (, uint256 unlockable,,) = _vliRed.lockedBalances(DEFAULT_ADMIN);

        assertEq(lockedBalanceAfter, 0);
        assertEq(iredBalanceAfter, iredBalanceBefore + lockedBalanceBefore);
        assertEq(unlockable, 0);
    }
}
