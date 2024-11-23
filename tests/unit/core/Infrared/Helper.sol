// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Testing Libraries.
import "forge-std/Test.sol";

// external
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {Voter} from "@voting/Voter.sol";
import {VotingEscrow} from "@voting/VotingEscrow.sol";

import {InfraredDistributor} from "@core/InfraredDistributor.sol";
import {BribeCollector} from "@core/BribeCollector.sol";

// internal
import "@core/Infrared.sol";
import "@core/InfraredDistributor.sol";
import "@core/IBGT.sol";
import "@core/InfraredVault.sol";
import "@utils/DataTypes.sol";

import "@interfaces/IInfrared.sol";

// mocks
import "@mocks/MockERC20.sol";
import "@berachain/pol/rewards/RewardVaultFactory.sol";
// import "@mocks/MockBeaco nDepositContract.sol";
// TODO: fix import "@mocks/MockBerachef.sol";
import {POLTest} from "@berachain/../test/pol/POL.t.sol";

abstract contract Helper is POLTest {
    Infrared public infrared;
    IBGT public ibgt;

    Voter public voter;
    VotingEscrow public veIRED;

    BribeCollector public collector;
    InfraredDistributor public infraredDistributor;

    address public admin;
    address public keeper;
    address public infraredGovernance;

    // MockERC20 public bgt;
    MockERC20 public ired;
    MockERC20 public wibera;
    MockERC20 public honey;
    address public beraVault;

    MockERC20 public mockPool;
    // MockBerachainRewardsVaultFactory public rewardsFactory;
    // MockBeraChef public chef; // TODO: fix for chef
    address public chef = makeAddr("chef");

    string vaultName;
    string vaultSymbol;
    address[] rewardTokens;
    address stakingAsset;
    address poolAddress;

    IInfraredVault public ibgtVault;
    InfraredVault public infraredVault;

    address validator = address(888);
    address validator2 = address(999);

    // New declaration for mock pools
    MockERC20[] public mockPools;

    function setUp() public virtual override {
        super.setUp();

        ibgt = new IBGT(address(bgt));
        ired = new MockERC20("IRED", "IRED", 18);
        wibera = new MockERC20("WIBERA", "WIBERA", 18);
        honey = new MockERC20("HONEY", "HONEY", 18);

        // Set up addresses for roles
        admin = address(this);
        keeper = address(1);
        infraredGovernance = address(2);

        // TODO: mock contracts
        // mockPool = new MockERC20("Mock Asset", "MAS", 18);
        stakingAsset = address(wbera);

        // deploy a rewards vault for IBGT
        // rewardsFactory = new MockBerachainRewardsVaultFactory(address(bgt));
        address rewardsVault = factory.createRewardVault(address(ibgt));
        assertEq(rewardsVault, factory.getVault(address(ibgt)));

        // Set up bera bgt distribution for mockPool
        beraVault = factory.createRewardVault(stakingAsset);
        // rewardsFactory.increaseRewardsForVault(stakingAsset, 1000 ether);

        // initialize Infrared contracts
        infrared = Infrared(
            setupProxy(
                address(
                    new Infrared(
                        address(ibgt),
                        address(factory),
                        address(chef),
                        payable(address(wbera)),
                        address(honey)
                    )
                )
            )
        );
        collector = BribeCollector(
            setupProxy(address(new BribeCollector(address(infrared))))
        );
        infraredDistributor = InfraredDistributor(
            setupProxy(address(new InfraredDistributor(address(infrared))))
        );

        // IRED voting
        voter = Voter(setupProxy(address(new Voter(address(infrared)))));
        veIRED = new VotingEscrow(
            address(this), address(ired), address(voter), address(infrared)
        );

        collector.initialize(address(this), address(wbera), 10 ether);
        infraredDistributor.initialize();
        infrared.initialize(
            address(this),
            address(collector),
            address(infraredDistributor),
            address(voter),
            1 days
        ); // make helper contract the admin
        voter.initialize(address(veIRED));

        // set access control
        infrared.grantRole(infrared.KEEPER_ROLE(), keeper);
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), infraredGovernance);

        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(blockRewardController));

        vm.startPrank(governance);
        bgt.whitelistSender(address(factory), true);
        vm.stopPrank();

        infraredVault =
            InfraredVault(address(infrared.registerVault(stakingAsset)));

        ibgtVault = infrared.ibgtVault();

        labelContracts();
    }

    function labelContracts() public {
        // labeling contracts
        vm.label(address(infrared), "infrared");
        vm.label(address(ibgt), "ibgt");
        vm.label(address(bgt), "bgt");
        // vm.label(address(mockPool), "mockPool");
        vm.label(address(wbera), "wbera");
        vm.label(admin, "admin");
        vm.label(keeper, "keeper");
        vm.label(stakingAsset, "stakingAsset");
        vm.label(infraredGovernance, "infraredGovernance");
        vm.label(address(factory), "rewardsFactory");
        vm.label(address(chef), "chef");
        vm.label(address(ibgtVault), "ibgtVault");
        vm.label(address(collector), "collector");
    }

    function stakeInVault(
        address iVault,
        address asset,
        address user,
        uint256 amount
    ) internal {
        deal(asset, user, amount);
        vm.startPrank(user);
        IERC20(asset).approve(iVault, amount);
        InfraredVault(iVault).stake(amount);
        vm.stopPrank();
    }

    function isStringSame(string memory _a, string memory _b)
        internal
        pure
        returns (bool _isSame)
    {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);

        if (a.length != b.length) {
            return false;
        }

        for (uint256 i = 0; i < a.length; i++) {
            if (a[i] != b[i]) {
                return false;
            }
        }

        return true;
    }

    function setupProxy(address implementation)
        internal
        returns (address proxy)
    {
        proxy = address(new ERC1967Proxy(implementation, ""));
    }
}
