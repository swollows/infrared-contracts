// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./Helper.sol";

contract BribeCollectorTest is Helper {
    function testSetPayoutAmount() public {
        vm.startPrank(governance);
        collector.setPayoutAmount(1 ether);
        vm.stopPrank();
    }

    function testSetPayoutAmountWhenNotGovernor() public {
        vm.startPrank(keeper);
        vm.expectRevert();
        collector.setPayoutAmount(1 ether);
        vm.stopPrank();
    }
}
