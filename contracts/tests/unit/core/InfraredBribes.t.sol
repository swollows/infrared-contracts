// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import "forge-std/Test.sol";

import {BribeCollector} from "@core/BribeCollector.sol";
import {InfraredBribes} from "@core/InfraredBribes.sol";

import {MockERC20} from "@mocks/MockERC20.sol";
import {MockInfrared} from "@mocks/MockInfrared.sol";

import {stdStorage, StdStorage} from "forge-std/Test.sol";

contract InfraredBribesTest is Test {
    MockERC20 public token;
    MockInfrared public infrared;

    BribeCollector public collector;
    InfraredBribes public bribes;

    address public admin = makeAddr("admin");
    address public user = makeAddr("user");
    address public validator1 = makeAddr("validator1");
    address public validator2 = makeAddr("validator2");
    address public ibgt = makeAddr("iBGT");
    address public rewardsFactory = makeAddr("rewardsFactory");

    function setUp() public {
        // Initialize mock contracts
        token = new MockERC20("Token", "TOK", 18);
        infrared = new MockInfrared(ibgt, rewardsFactory);

        // collector, bribes
        collector = BribeCollector(setupProxy(address(new BribeCollector())));
        bribes = InfraredBribes(setupProxy(address(new InfraredBribes())));

        collector.initialize(admin, address(token), address(bribes), 1 ether);
        bribes.initialize(admin, address(infrared), address(collector));

        // Set up initial state for tests
        deal(address(token), user, 1000 ether);

        vm.prank(user);
        require(token.approve(address(bribes), 1000 ether));
        assertEq(token.allowance(user, address(bribes)), 1000 ether);
    }

    function setupProxy(address implementation)
        internal
        returns (address proxy)
    {
        proxy = address(new ERC1967Proxy(implementation, ""));
    }

    function testInitialize() public {
        assertEq(address(bribes.infrared()), address(infrared));
        assertEq(address(bribes.collector()), address(collector));
        assertEq(address(bribes.token()), address(token));

        assertEq(bribes.hasRole(bribes.KEEPER_ROLE(), admin), true);
        assertEq(bribes.hasRole(bribes.GOVERNANCE_ROLE(), admin), true);
        assertEq(bribes.hasRole(bribes.DEFAULT_ADMIN_ROLE(), admin), true);

        assertEq(bribes.amountsCumulative(), 1);
    }

    event Notified(uint256 amount, uint256 num);

    function testNotifyRewardAmount(uint256 amount) public {
        vm.assume(amount <= token.balanceOf(user));
        vm.assume(amount > 0);

        uint256 amountsCumulativeBefore = bribes.amountsCumulative();
        uint256 balanceBribesBefore = token.balanceOf(address(bribes));
        uint256 balanceUserBefore = token.balanceOf(address(user));

        // add 2 validators
        infrared.addValidator(validator1);
        infrared.addValidator(validator2);

        // notify reward amount
        vm.expectEmit();
        emit Notified(amount, 2);

        vm.prank(user);
        bribes.notifyRewardAmount(amount);

        // check amounts cumulative state changed
        assertEq(
            bribes.amountsCumulative(), amountsCumulativeBefore + amount / 2
        );

        // check token transferred in to bribes from user
        assertEq(token.balanceOf(address(bribes)), balanceBribesBefore + amount);
        assertEq(token.balanceOf(user), balanceUserBefore - amount);
    }

    event Added(address validator, uint256 amountCumulative);

    function testAdd() public {
        vm.expectEmit();
        emit Added(validator1, 1);

        vm.prank(address(infrared));
        bribes.add(validator1);

        (uint256 last1, uint256 fin1) = bribes.bribes(validator1);
        assertEq(last1, 1);
        assertEq(fin1, 0);

        // now notify reward amount for next validator
        infrared.addValidator(validator1);
        vm.prank(user);
        bribes.notifyRewardAmount(10 ether);

        // add second validator and check cumulative last set to accumulator
        assertEq(bribes.amountsCumulative(), 10 ether + 1);

        vm.expectEmit();
        emit Added(validator2, 10 ether + 1);

        vm.prank(address(infrared));
        bribes.add(validator2);

        // @dev need this for infrared.numInfraredValidators to be correct
        infrared.addValidator(validator2);

        (uint256 last2, uint256 fin2) = bribes.bribes(validator2);
        assertEq(last2, 10 ether + 1);
        assertEq(fin2, 0);
    }

    event Removed(address validator, uint256 amountCumulative);

    function testRemove() public {
        testAdd();

        // notify again for second round of bribes shared equally
        assertEq(infrared.numInfraredValidators(), 2);

        vm.prank(user);
        bribes.notifyRewardAmount(20 ether);

        assertEq(bribes.amountsCumulative(), 20 ether + 1); // 10 / 1 + 20 / 2

        vm.expectEmit();
        emit Removed(validator1, 20 ether + 1);

        vm.prank(address(infrared));
        bribes.remove(validator1);

        // @dev need this for infrared.numInfraredValidators to be correct
        infrared.removeValidator(validator1);

        (uint256 last1, uint256 fin1) = bribes.bribes(validator1);
        assertEq(last1, 1);
        assertEq(fin1, 20 ether + 1);
    }

    event Claimed(address recipient, uint256 amount);

    function testClaim() public {
        testRemove();

        // notify again for third round of bribes to only validator 2
        assertEq(infrared.numInfraredValidators(), 1);

        vm.prank(user);
        bribes.notifyRewardAmount(30 ether);

        assertEq(bribes.amountsCumulative(), 50 ether + 1); // 10 / 1 + 20 / 2 + 30 / 1
        assertEq(token.balanceOf(address(bribes)), 60 ether);

        // claim for validator 1
        vm.expectEmit();
        emit Claimed(validator1, 20 ether); // 10 / 1 + 20 / 2

        vm.prank(validator1);
        bribes.claim(validator1);

        (uint256 last1, uint256 fin1) = bribes.bribes(validator1);
        assertEq(last1, 20 ether + 1);
        assertEq(fin1, 20 ether + 1);

        assertEq(token.balanceOf(validator1), 20 ether);
        assertEq(token.balanceOf(address(bribes)), 40 ether);

        // claim for validator 2
        vm.expectEmit();
        emit Claimed(validator2, 40 ether); // 20 / 2 + 30 / 1

        vm.prank(validator2);
        bribes.claim(validator2);

        (uint256 last2, uint256 fin2) = bribes.bribes(validator2);
        assertEq(last2, 50 ether + 1);
        assertEq(fin2, 0);

        assertEq(token.balanceOf(validator2), 40 ether);
        assertEq(token.balanceOf(address(bribes)), 0);
    }
}
