// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.22;

import "./EIP5XXX.b.sol";

contract TestEIPXXXX is TestEIPXXXXBase {
    function setUp() public virtual override {
        super.setUp();
    }

    function testPayoutLogic1() public {
        vault1.mint(alice, 500);
        supplyRewards(vault1, doug, reward, 150);

        vault1.mint(bob, 500);
        supplyRewards(vault1, doug, reward, 201);

        vault1.mint(claire, 1000);
        supplyRewards(vault1, doug, reward, 400);

        assertTrue(address(reward) != address(vault1.asset()));
        assertEq(vault1.maxClaimable(address(reward), alice), 350);
        assertEq(vault1.maxClaimable(address(reward), bob), 200);
        assertEq(vault1.maxClaimable(address(reward), claire), 200);
    }

    function testEmptyMaxPayout() public {
        assertEq(vault1.maxClaimable(address(reward), alice), 0);
    }

    function testMaxPayoutNoShares() public {
        vault1.mint(alice, 500);
        supplyRewards(vault1, doug, reward, 150 gwei);
        assertEq(vault1.maxClaimable(address(reward), bob), 0);
    }

    function testPayoutLogicEmpty() public {
        vault1.mint(alice, 500);
        supplyRewards(vault1, doug, reward, 150 ether);
        vault1.mint(bob, 500);
        supplyRewards(vault1, doug, reward, 200 ether);
        vault1.mint(claire, 1000);
        supplyRewards(vault1, doug, reward, 400 ether);

        vm.prank(alice);
        vault1.claim(address(reward), 350 ether, alice);

        assertEq(vault1.maxClaimable(address(reward), alice), 0);
        assertEq(vault1.maxClaimable(address(reward), bob), 200 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vm.prank(bob);
        vault1.claim(address(reward), 200 ether, bob);

        assertEq(vault1.maxClaimable(address(reward), alice), 0);
        assertEq(vault1.maxClaimable(address(reward), bob), 0);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vm.prank(claire);
        vault1.claim(address(reward), 200 ether, claire);

        assertEq(vault1.maxClaimable(address(reward), alice), 0);
        assertEq(vault1.maxClaimable(address(reward), bob), 0);
        assertEq(vault1.maxClaimable(address(reward), claire), 0);
    }

    function testPayoutLogicPartialWithdrawl() public {
        vault1.mint(alice, 500);
        supplyRewards(vault1, doug, reward, 150 ether);
        vault1.mint(bob, 500);
        supplyRewards(vault1, doug, reward, 200 ether);
        vault1.mint(claire, 1000);
        supplyRewards(vault1, doug, reward, 400 ether);

        vm.prank(alice);
        vault1.claim(address(reward), 250 ether, alice);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 200 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vm.prank(bob);
        vault1.claim(address(reward), 100 ether, bob);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vm.prank(claire);
        vault1.claim(address(reward), 175 ether, claire);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 25 ether);
    }

    function testPayoutLogicPartialWithdrawlRepeatDeposit() public {
        vault1.mint(alice, 500);
        supplyRewards(vault1, doug, reward, 150 ether);
        vault1.mint(bob, 500);
        supplyRewards(vault1, doug, reward, 200 ether);
        vault1.mint(claire, 1000);
        supplyRewards(vault1, doug, reward, 400 ether);

        vm.prank(alice);
        vault1.claim(address(reward), 250 ether, alice);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 200 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vm.prank(bob);
        vault1.claim(address(reward), 100 ether, bob);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vault1.mint(alice, 500);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        supplyRewards(vault1, doug, reward, 1000 ether);

        assertEq(vault1.maxClaimable(address(reward), alice), 500 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 300 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 600 ether);
    }

    function testTransferLogic() public {
        vault1.mint(alice, 500);
        supplyRewards(vault1, doug, reward, 150 ether);
        vault1.mint(bob, 500);
        supplyRewards(vault1, doug, reward, 200 ether);
        vault1.mint(claire, 1000);
        supplyRewards(vault1, doug, reward, 400 ether);

        vm.prank(alice);
        vault1.claim(address(reward), 250 ether, alice);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 200 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vm.prank(bob);
        vault1.claim(address(reward), 100 ether, bob);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vault1.mint(alice, 500);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        supplyRewards(vault1, doug, reward, 1000 ether);

        assertEq(vault1.maxClaimable(address(reward), alice), 500 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 300 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 600 ether);

        // transfer 500 shares to bob
        vm.prank(alice);
        vault1.transfer(bob, 500);

        assertEq(vault1.maxClaimable(address(reward), alice), 500 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 300 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 600 ether);

        supplyRewards(vault1, doug, reward, 500 ether);

        assertEq(vault1.maxClaimable(address(reward), alice), 600 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 500 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 800 ether);
    }

    function testTransferFromLogic() public {
        vault1.mint(alice, 500);
        supplyRewards(vault1, doug, reward, 150 ether);
        vault1.mint(bob, 500);
        supplyRewards(vault1, doug, reward, 200 ether);
        vault1.mint(claire, 1000);
        supplyRewards(vault1, doug, reward, 400 ether);

        vm.prank(alice);
        vault1.claim(address(reward), 250 ether, alice);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 200 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vm.prank(bob);
        vault1.claim(address(reward), 100 ether, bob);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        vault1.mint(alice, 500);

        assertEq(vault1.maxClaimable(address(reward), alice), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 100 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 200 ether);

        supplyRewards(vault1, doug, reward, 1000 ether);

        assertEq(vault1.maxClaimable(address(reward), alice), 500 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 300 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 600 ether);

        // transfer 500 shares to bob
        vault1.transferFrom(alice, bob, 500);

        assertEq(vault1.maxClaimable(address(reward), alice), 500 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 300 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 600 ether);

        supplyRewards(vault1, doug, reward, 500 ether);

        assertEq(vault1.maxClaimable(address(reward), alice), 600 ether);
        assertEq(vault1.maxClaimable(address(reward), bob), 500 ether);
        assertEq(vault1.maxClaimable(address(reward), claire), 800 ether);
    }

    function testMintEarnBurn() public {
        vault1.mint(alice, 1);
        supplyRewards(vault1, doug, reward, 1);
        vault1.burn(alice, 1);
        supplyRewards(vault1, doug, reward, 1);
        assertEq(vault1.maxClaimable(address(reward), alice), 1);
    }

    // "First truncation test on rounding of eps"
    function testEarningsRollForward() public {
        vault1.mint(alice, 39614081257132168796771975167);
        supplyRewards(vault1, doug, reward, 2);
        vault1.burn(alice, 0);
        supplyRewards(vault1, doug, reward, 39614081257132168796771975165);
        assertEq(
            vault1.maxClaimable(address(reward), alice),
            39614081257132168796771975167
        );
    }

    // "First truncation test on rounding of eps"
    function testSharesGoToZero() public {
        // [(0, 2, 3), (62, 0, 3), (253, 191, 3), (52, 191, 0)]]]
        vault1.mint(alice, 3);
        supplyRewards(vault1, doug, reward, 3);
        vault1.burn(alice, 3);
        vault1.mint(bob, 2);
        supplyRewards(vault1, doug, reward, 3);
        supplyRewards(vault1, doug, reward, 0);
        vault1.burn(bob, 2);
        vault1.mint(alice, 5);
        supplyRewards(vault1, doug, reward, 5);
        assertEq(vault1.maxClaimable(address(reward), alice), 8);
        assertEq(vault1.maxClaimable(address(reward), bob), 3);
    }

    // TODO: FIX THE FUZZER.
    // function testEverythingIsFucked(uint128 x, uint128 rewardPayout) public {
    //     vm.assume(x > 0);
    //     uint256 maxErr = x / 1e27 + 1;
    //     vm.assume(x == rewardPayout);
    //     vm.assume(rewardPayout % 3 != 0);
    //     vault1.mint(alice, x);
    //     vault1.mint(bob, x);
    //     vault1.mint(claire, x);
    //     supplyRewards(vault1, doug, reward, rewardPayout);
    //     console2.log(vault1.totalSupply());

    //     (uint256 eps, uint256 r) = vault1.currentEPW(address(reward));
    //     console2.log("eps", eps, "r", r);
    //     assertEq((eps * 3 * x + r) / 1e27, rewardPayout);
    //     assertApproxEqAbs(
    //         vault1.maxClaimable(address(reward), alice),
    //         rewardPayout / 3,
    //         maxErr
    //     );
    //     assertApproxEqAbs(
    //         vault1.maxClaimable(address(reward), bob), rewardPayout / 3, maxErr
    //     );
    //     assertApproxEqAbs(
    //         vault1.maxClaimable(address(reward), claire),
    //         rewardPayout / 3,
    //         maxErr
    //     );

    //     uint256 aliceMax = vault1.maxClaimable(address(reward), alice);
    //     uint256 bobMax = vault1.maxClaimable(address(reward), bob);
    //     uint256 claireMax = vault1.maxClaimable(address(reward), claire);
    //     uint256 sum = aliceMax + bobMax + claireMax;

    //     assertApproxEqAbs(sum + r / 1e27, rewardPayout, 3);
    //     assertTrue(sum <= rewardPayout); // round down always for safety

    //     vm.prank(alice);
    //     vault1.claim(address(reward), aliceMax, alice);
    //     assertEq(reward.balanceOf(alice), aliceMax);

    //     uint256 aliceMax2 = vault1.maxClaimable(address(reward), alice);
    //     uint256 bobMax2 = vault1.maxClaimable(address(reward), bob);
    //     uint256 claireMax2 = vault1.maxClaimable(address(reward), claire);

    //     assertEq(aliceMax2, 0);
    //     assertEq(bobMax2, bobMax);
    //     assertEq(claireMax2, claireMax);

    //     vm.prank(bob);
    //     vault1.claim(address(reward), bobMax, bob);
    //     assertEq(reward.balanceOf(bob), bobMax);

    //     uint256 aliceMax3 = vault1.maxClaimable(address(reward), alice);
    //     uint256 bobMax3 = vault1.maxClaimable(address(reward), bob);
    //     uint256 claireMax3 = vault1.maxClaimable(address(reward), claire);

    //     assertEq(aliceMax3, 0);
    //     assertEq(bobMax3, 0);
    //     assertEq(claireMax3, claireMax);

    //     vm.prank(claire);
    //     vault1.claim(address(reward), claireMax, claire);
    //     assertEq(reward.balanceOf(claire), claireMax);

    //     uint256 aliceMax4 = vault1.maxClaimable(address(reward), alice);
    //     uint256 bobMax4 = vault1.maxClaimable(address(reward), bob);
    //     uint256 claireMax4 = vault1.maxClaimable(address(reward), claire);
    //     assertEq(aliceMax4, 0);
    //     assertEq(bobMax4, 0);
    //     assertEq(claireMax4, 0);
    // }
}
