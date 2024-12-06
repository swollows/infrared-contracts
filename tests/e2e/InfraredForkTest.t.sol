// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Initializable} from
    "@openzeppelin-upgradeable/proxy/utils/Initializable.sol";

import {ERC20PresetMinterPauser} from
    "../../src/vendors/ERC20PresetMinterPauser.sol";

import {IRewardVault as IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IRewardVault.sol";

import {Voter} from "src/voting/Voter.sol";
import {VotingEscrow} from "src/voting/VotingEscrow.sol";

import {IBGT} from "src/core/IBGT.sol";
import {Infrared} from "src/core/Infrared.sol";
import {InfraredDistributor} from "src/core/InfraredDistributor.sol";
import {BribeCollector} from "src/core/BribeCollector.sol";

import {IInfraredVault} from "src/interfaces/IInfraredVault.sol";
import {IMultiRewards} from "src/interfaces/IMultiRewards.sol";

import {HelperForkTest} from "./HelperForkTest.t.sol";

contract InfraredForkTest is HelperForkTest {
    address public admin = makeAddr("admin");
    uint256 public rewardsDuration = 60 days;
    uint256 public bribeCollectorPayoutAmount = 10 ether;
    address public infraredValidator = makeAddr("validator");

    IBGT public ibgt;
    ERC20PresetMinterPauser public ired;
    ERC20PresetMinterPauser public ibera;
    ERC20PresetMinterPauser public stakingToken;

    BribeCollector public collector;
    InfraredDistributor public distributor;
    Infrared public infrared;

    Voter public voter;
    VotingEscrow public veIRED;

    IInfraredVault public lpVault;

    uint256 internal constant FEE_UNIT = 1e6;

    function setUp() public virtual override {
        super.setUp();

        ibgt = new IBGT(address(bgt));
        ired = new ERC20PresetMinterPauser("Infrared Token", "iRED");
        ibera = new ERC20PresetMinterPauser("iBERA", "iBERA");

        stakingToken = new ERC20PresetMinterPauser("Staking Token", "STAKE");

        // mint and deal lp and staking tokens
        stakingToken.mint(address(this), 1000 ether);
        deal(address(lpToken), address(this), 1000 ether);

        infrared = Infrared(
            setupProxy(
                address(
                    new Infrared(
                        address(ibgt),
                        address(rewardsFactory),
                        address(beraChef),
                        payable(address(wbera)),
                        address(honey)
                    )
                )
            )
        );

        collector = BribeCollector(
            setupProxy(address(new BribeCollector(address(infrared))))
        );
        distributor = InfraredDistributor(
            setupProxy(address(new InfraredDistributor(address(infrared))))
        );

        // IRED voting
        voter = Voter(setupProxy(address(new Voter(address(infrared)))));
        veIRED = new VotingEscrow(
            admin, address(ired), address(voter), address(infrared)
        );

        // initialize proxies
        collector.initialize(admin, address(wbera), bribeCollectorPayoutAmount);
        distributor.initialize(address(ibera));
        infrared.initialize(
            admin,
            address(collector),
            address(distributor),
            address(voter),
            address(ibera),
            rewardsDuration
        );
        voter.initialize(address(veIRED));

        // grant infrared ibgt minter role
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        vm.prank(admin);
        lpVault = infrared.registerVault(address(lpToken));
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

        assertEq(address(infrared.collector()), address(collector));
        assertEq(address(infrared.distributor()), address(distributor));

        IInfraredVault _ibgtVault = infrared.vaultRegistry(address(ibgt));
        assertTrue(address(_ibgtVault) != address(0));
        assertEq(address(_ibgtVault), address(infrared.ibgtVault()));
        assertEq(address(_ibgtVault.infrared()), address(infrared));

        address[] memory _rewardTokens = new address[](2);
        _rewardTokens[0] = address(ibgt);
        _rewardTokens[1] = address(honey);

        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            address rewardToken = _rewardTokens[i];
            assertTrue(infrared.whitelistedRewardTokens(rewardToken));

            (, uint256 rewardDurationIbgt,,,,,) =
                IMultiRewards(address(_ibgtVault)).rewardData(rewardToken);
            assertTrue(rewardDurationIbgt > 0);
        }

        assertTrue(infrared.hasRole(infrared.DEFAULT_ADMIN_ROLE(), admin));
        assertTrue(infrared.hasRole(infrared.KEEPER_ROLE(), admin));
        assertTrue(infrared.hasRole(infrared.GOVERNANCE_ROLE(), admin));

        assertEq(stakingToken.balanceOf(address(this)), 1000 ether);
        assertEq(lpToken.balanceOf(address(this)), 1000 ether);

        assertEq(
            address(lpVault.rewardsVault()),
            rewardsFactory.getVault(address(lpToken))
        );

        // test implementations disabled
        address collectorImplementation = collector.currentImplementation();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        BribeCollector(collectorImplementation).initialize(
            admin, address(wbera), bribeCollectorPayoutAmount
        );

        address distributorImplementation = distributor.currentImplementation();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        InfraredDistributor(distributorImplementation).initialize(
            address(ibera)
        );

        address infraredImplementation = infrared.currentImplementation();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        Infrared(infraredImplementation).initialize(
            admin,
            address(collector),
            address(distributor),
            address(voter),
            address(ibera),
            rewardsDuration
        );
    }
}
