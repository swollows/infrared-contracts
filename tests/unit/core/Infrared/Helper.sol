// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Testing Libraries.
import "forge-std/Test.sol";

// external
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {Voter} from "src/voting/Voter.sol";
import {VotingEscrow} from "src/voting/VotingEscrow.sol";
import {InfraredBERA} from "src/staking/InfraredBERA.sol";
import {InfraredBERAClaimor} from "src/staking/InfraredBERAClaimor.sol";
import {InfraredBERADepositor} from "src/staking/InfraredBERADepositor.sol";
import {InfraredBERAWithdrawor} from "src/staking/InfraredBERAWithdrawor.sol";
import {InfraredBERAFeeReceivor} from "src/staking/InfraredBERAFeeReceivor.sol";
import {InfraredBERAConstants} from "src/staking/InfraredBERAConstants.sol";

import {InfraredDistributor} from "src/core/InfraredDistributor.sol";
import {BribeCollector} from "src/core/BribeCollector.sol";

// internal
import {ERC20, Infrared} from "src/core/Infrared.sol";
import {InfraredDistributor} from "src/core/InfraredDistributor.sol";
import {InfraredBGT} from "src/core/InfraredBGT.sol";
import {RED} from "src/core/RED.sol";
import {IInfraredVault, InfraredVault} from "src/core/InfraredVault.sol";
import {DataTypes} from "src/utils/DataTypes.sol";

import {IInfrared} from "src/interfaces/IInfrared.sol";

// mocks
import {MockERC20} from "tests/unit/mocks/MockERC20.sol";
import {RewardVaultFactory} from "@berachain/pol/rewards/RewardVaultFactory.sol";
import {POLTest} from "@berachain/../test/pol/POL.t.sol";

abstract contract Helper is POLTest {
    Infrared public infrared;
    InfraredBGT public ibgt;
    RED public red;

    Voter public voter;
    VotingEscrow public ired;

    InfraredBERA public ibera;
    InfraredBERADepositor public depositor;
    InfraredBERAWithdrawor public withdrawor;
    InfraredBERAClaimor public claimor;
    InfraredBERAFeeReceivor public receivor;

    BribeCollector public collector;
    InfraredDistributor public infraredDistributor;

    address public admin;
    address public keeper;
    address public infraredGovernance;

    // MockERC20 public bgt;
    MockERC20 public wibera;
    MockERC20 public honey;
    address public beraVault;

    MockERC20 public mockPool;
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

        ibgt = new InfraredBGT(address(bgt));
        wibera = new MockERC20("WInfraredBERA", "WInfraredBERA", 18);
        honey = new MockERC20("HONEY", "HONEY", 18);

        // Set up addresses for roles
        admin = address(this);
        keeper = address(1);
        infraredGovernance = address(2);

        stakingAsset = address(wbera);

        // deploy a rewards vault for InfraredBGT
        address rewardsVault = factory.createRewardVault(address(ibgt));
        assertEq(rewardsVault, factory.getVault(address(ibgt)));

        // Set up bera bgt distribution for mockPool
        beraVault = factory.createRewardVault(stakingAsset);

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

        // ibera = new InfraredBERA(address(infrared));
        // InfraredBERA
        ibera = InfraredBERA(setupProxy(address(new InfraredBERA())));

        depositor = InfraredBERADepositor(
            setupProxy(address(new InfraredBERADepositor()))
        );
        withdrawor = InfraredBERAWithdrawor(
            payable(setupProxy(address(new InfraredBERAWithdrawor())))
        );
        claimor =
            InfraredBERAClaimor(setupProxy(address(new InfraredBERAClaimor())));
        receivor = InfraredBERAFeeReceivor(
            payable(setupProxy(address(new InfraredBERAFeeReceivor())))
        );

        collector = BribeCollector(
            setupProxy(address(new BribeCollector(address(infrared))))
        );
        infraredDistributor = InfraredDistributor(
            setupProxy(address(new InfraredDistributor(address(infrared))))
        );

        red = new RED(address(ibgt), address(infrared));

        // IRED voting
        voter = Voter(setupProxy(address(new Voter(address(infrared)))));
        ired = new VotingEscrow(
            address(this), address(red), address(voter), address(infrared)
        );

        collector.initialize(address(this), address(wbera), 10 ether);
        infraredDistributor.initialize(address(ibera));
        infrared.initialize(
            address(this),
            address(collector),
            address(infraredDistributor),
            address(voter),
            address(ibera),
            1 days
        ); // make helper contract the admin
        voter.initialize(address(ired));

        // initialize ibera proxies
        depositor.initialize(admin, address(ibera));
        withdrawor.initialize(admin, address(ibera));
        claimor.initialize(admin);
        receivor.initialize(admin, address(ibera), address(infrared));

        // init deposit to avoid inflation attack
        uint256 _value = InfraredBERAConstants.MINIMUM_DEPOSIT
            + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;

        ibera.initialize{value: _value}(
            admin,
            address(infrared),
            address(depositor),
            address(withdrawor),
            address(claimor),
            address(receivor)
        );

        ibera.grantRole(ibera.GOVERNANCE_ROLE(), address(this));

        uint16 feeShareholders = 4; // 25% of fees
        // address(this) is the governor
        ibera.setFeeShareholders(feeShareholders);

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
        ERC20(asset).approve(iVault, amount);
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
