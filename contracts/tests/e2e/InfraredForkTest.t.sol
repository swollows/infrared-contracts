// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ERC20PresetMinterPauser} from
    "../../src/vendors/ERC20PresetMinterPauser.sol";

import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";

import {IBGT} from "@core/IBGT.sol";
import {Infrared} from "@core/Infrared.sol";
import {InfraredBribes} from "@core/InfraredBribes.sol";
import {BribeCollector} from "@core/BribeCollector.sol";

import {IInfraredVault} from "@interfaces/IInfraredVault.sol";
import {IMultiRewards} from "@interfaces/IMultiRewards.sol";

import {HelperForkTest} from "./HelperForkTest.t.sol";

contract InfraredForkTest is HelperForkTest {
    address public admin = makeAddr("admin");
    uint256 public rewardsDuration = 60 days;
    uint256 public bribeCollectorPayoutAmount = 10 ether;
    address public infraredValidator = makeAddr("validator");

    IBGT public ibgt;
    ERC20PresetMinterPauser public ired;
    ERC20PresetMinterPauser public stakingToken;

    BribeCollector public collector;
    InfraredBribes public bribes;
    Infrared public infrared;

    IInfraredVault public lpVault;

    function setUp() public virtual override {
        super.setUp();

        ibgt = new IBGT(address(bgt));
        ired = new ERC20PresetMinterPauser("Infrared Token", "iRED");
        stakingToken = new ERC20PresetMinterPauser("Staking Token", "STAKE");

        // mint and deal lp and staking tokens
        stakingToken.mint(address(this), 1000 ether);
        deal(address(lpToken), address(this), 1000 ether);

        collector = BribeCollector(setupProxy(address(new BribeCollector())));
        bribes = InfraredBribes(setupProxy(address(new InfraredBribes())));
        infrared = Infrared(
            setupProxy(
                address(
                    new Infrared(
                        address(ibgt),
                        address(rewardsFactory),
                        address(beraChef),
                        address(wbera),
                        address(ired)
                    )
                )
            )
        );

        // initialize proxies
        // @dev must initialize collector before bribes
        collector.initialize(
            admin,
            address(wbera),
            address(collector),
            bribeCollectorPayoutAmount
        );
        bribes.initialize(admin, address(infrared), address(collector));
        infrared.initialize(
            admin, address(collector), address(bribes), rewardsDuration
        );

        // grant infrared ibgt minter role
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        // deploy an infrared vault for berachain whitelisted lp token
        address[] memory _rewardTokens = new address[](2);
        _rewardTokens[0] = address(ibgt);
        _rewardTokens[1] = address(ired);

        vm.prank(admin);
        lpVault = infrared.registerVault(address(lpToken), _rewardTokens);

        // set validator operator in berachef as infrared
        vm.prank(infraredValidator);
        beraChef.setOperator(address(infrared));
    }

    function setupProxy(address implementation)
        internal
        returns (address proxy)
    {
        proxy = address(new ERC1967Proxy(implementation, ""));
    }

    function testSetUp() public virtual override {
        super.testSetUp();

        assertEq(address(infrared.ibgt()), address(ibgt));
        assertEq(address(infrared.ired()), address(ired));

        assertEq(address(infrared.collector()), address(collector));
        assertEq(address(infrared.bribes()), address(bribes));

        IInfraredVault _ibgtVault = infrared.vaultRegistry(address(ibgt));
        assertTrue(address(_ibgtVault) != address(0));
        assertEq(address(_ibgtVault), address(infrared.ibgtVault()));
        assertEq(address(_ibgtVault.infrared()), address(infrared));

        assertTrue(infrared.hasRole(infrared.DEFAULT_ADMIN_ROLE(), admin));
        assertTrue(infrared.hasRole(infrared.KEEPER_ROLE(), admin));
        assertTrue(infrared.hasRole(infrared.GOVERNANCE_ROLE(), admin));

        assertEq(stakingToken.balanceOf(address(this)), 1000 ether);
        assertEq(lpToken.balanceOf(address(this)), 1000 ether);

        assertEq(
            address(lpVault.rewardsVault()),
            rewardsFactory.getVault(address(lpToken))
        );
        assertEq(beraChef.getOperator(infraredValidator), address(infrared));
    }
}
