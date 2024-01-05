// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.22;

/* Test Environment */
import "../../utils/TestEnv.sol";
import "@berachain/vaults/EIP5XXX.sol";
import "../../mocks/MockERC20.sol";
import "../../mocks/MockEIP5XXX.sol";

contract TestEIPXXXXBase is TestEnv {
    MockEIP5XXX internal vault1;
    MockERC20 internal underlying;
    MockERC20 internal reward;

    function setUp() public virtual override {
        super.setUp();
        underlying = new MockERC20("Underlying", "UND", 18);
        reward = new MockERC20("Reward", "REW", 18);

        address[] memory rewardTokens = new address[](1);
        rewardTokens[0] = address(reward);
        vault1 = new MockEIP5XXX(underlying, "Name", "Symbol", rewardTokens);

        vm.prank(alice);
        underlying.approve(address(this), type(uint256).max);
        vm.prank(alice);
        vault1.approve(address(this), type(uint256).max);
        vm.prank(bob);
        underlying.approve(address(this), type(uint256).max);
        vm.prank(bob);
        vault1.approve(address(this), type(uint256).max);
        vm.prank(claire);
        underlying.approve(address(this), type(uint256).max);
        vm.prank(claire);
        vault1.approve(address(this), type(uint256).max);
    }

    function supplyRewards(
        EIP5XXX vault,
        address from,
        MockERC20 token,
        uint256 amount
    ) internal {
        token.mint(from, amount);
        vm.prank(from);
        token.approve(address(vault), amount);
        vault.supply(from, address(token), amount);
    }
}
