// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Initializable} from
    "@openzeppelin-upgradeable/proxy/utils/Initializable.sol";

import {ERC20PresetMinterPauser} from
    "../../src/vendors/ERC20PresetMinterPauser.sol";

import {IBerachainRewardsVault} from
    "@berachain/pol/interfaces/IBerachainRewardsVault.sol";

import {Voter} from "@voting/Voter.sol";
import {VotingEscrow} from "@voting/VotingEscrow.sol";

import {IBGT} from "@core/IBGT.sol";
import {Infrared} from "@core/Infrared.sol";
import {InfraredDistributor} from "@core/InfraredDistributor.sol";
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
    ERC20PresetMinterPauser public wibera;
    ERC20PresetMinterPauser public stakingToken;

    BribeCollector public collector;
    InfraredDistributor public distributor;
    Infrared public infrared;

    Voter public voter;
    VotingEscrow public veIRED;

    IInfraredVault public lpVault;

    uint256 internal constant FEE_UNIT = 1e6;
    uint256 internal constant COMMISSION_MAX = 1e3;

    function setUp() public virtual override {
        super.setUp();

        ibgt = new IBGT(address(bgt));
        ired = new ERC20PresetMinterPauser("Infrared Token", "iRED");
        wibera = new ERC20PresetMinterPauser("Wrapped Infrared Bera", "wiBERA");

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
                        address(wbera),
                        address(honey),
                        address(ired),
                        address(wibera)
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
        distributor.initialize();
        infrared.initialize(
            admin,
            address(collector),
            address(distributor),
            address(voter),
            rewardsDuration
        );
        voter.initialize(address(veIRED));

        // grant infrared ibgt minter role
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        // deploy an infrared vault for berachain whitelisted lp token
        address[] memory _rewardTokens = new address[](3);
        _rewardTokens[0] = address(ibgt);
        _rewardTokens[1] = address(ired);
        _rewardTokens[2] = address(honey);

        vm.prank(admin);
        lpVault = infrared.registerVault(address(lpToken), _rewardTokens);
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
        assertEq(address(infrared.distributor()), address(distributor));

        IInfraredVault _ibgtVault = infrared.vaultRegistry(address(ibgt));
        assertTrue(address(_ibgtVault) != address(0));
        assertEq(address(_ibgtVault), address(infrared.ibgtVault()));
        assertEq(address(_ibgtVault.infrared()), address(infrared));

        IInfraredVault _wiberaVault = infrared.vaultRegistry(address(wibera));
        assertTrue(address(_wiberaVault) != address(0));
        assertEq(address(_wiberaVault), address(infrared.wiberaVault()));
        assertEq(address(_wiberaVault.infrared()), address(infrared));

        address[] memory _rewardTokens = new address[](3);
        _rewardTokens[0] = address(ibgt);
        _rewardTokens[1] = address(ired);
        _rewardTokens[2] = address(honey);

        for (uint256 i = 0; i < _rewardTokens.length; i++) {
            address rewardToken = _rewardTokens[i];
            assertTrue(infrared.whitelistedRewardTokens(rewardToken));

            (, uint256 rewardDurationIbgt,,,,) =
                IMultiRewards(address(_ibgtVault)).rewardData(rewardToken);
            assertTrue(rewardDurationIbgt > 0);

            (, uint256 rewardDurationWibera,,,,) =
                IMultiRewards(address(_wiberaVault)).rewardData(rewardToken);
            assertTrue(rewardDurationWibera > 0);
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
        InfraredDistributor(distributorImplementation).initialize();

        address infraredImplementation = infrared.currentImplementation();
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        Infrared(infraredImplementation).initialize(
            admin,
            address(collector),
            address(distributor),
            address(voter),
            rewardsDuration
        );
    }
}
