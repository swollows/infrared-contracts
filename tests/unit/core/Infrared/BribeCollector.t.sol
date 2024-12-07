// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./Helper.sol";

contract BribeCollectorTest is Helper {
    function testSetPayoutAmount() public {
        vm.startPrank(infraredGovernance);
        collector.setPayoutAmount(1 ether);
        vm.stopPrank();
    }

    function testSetPayoutAmountWhenNotGovernor() public {
        vm.startPrank(keeper);
        vm.expectRevert();
        collector.setPayoutAmount(1 ether);
        vm.stopPrank();
    }

    function testClaimFeesSuccess() public {
        address searcher = address(777);

        // Arrange
        address recipient = address(3);
        address[] memory feeTokens = new address[](2);
        feeTokens[0] = address(wibera);
        feeTokens[1] = address(honey);

        uint256[] memory feeAmounts = new uint256[](2);
        feeAmounts[0] = 1 ether;
        feeAmounts[1] = 2 ether;

        // simulate bribes collected by the collector contract
        deal(address(wibera), address(collector), 1 ether);
        deal(address(honey), address(collector), 2 ether);

        address payoutToken = collector.payoutToken();
        uint256 payoutAmount = collector.payoutAmount();

        // searcher approves payoutAmount to the collector contract
        deal(payoutToken, searcher, payoutAmount);

        // Act
        vm.startPrank(searcher);
        ERC20(payoutToken).approve(address(collector), payoutAmount);
        collector.claimFees(recipient, feeTokens, feeAmounts);
        vm.stopPrank();

        // Assert
        assertEq(wibera.balanceOf(recipient), 1 ether);
        assertEq(honey.balanceOf(recipient), 2 ether);
    }
}
