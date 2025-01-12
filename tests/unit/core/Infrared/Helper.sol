// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// Testing Libraries.
import "forge-std/Test.sol";

// external
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {BeaconDeposit} from "@berachain/pol/BeaconDeposit.sol";

import {Voter} from "src/voting/Voter.sol";
import {VotingEscrow} from "src/voting/VotingEscrow.sol";
import {InfraredBERA} from "src/staking/InfraredBERA.sol";
import {InfraredBERAClaimor} from "src/staking/InfraredBERAClaimor.sol";
import {InfraredBERADepositor} from "src/staking/InfraredBERADepositor.sol";
import {InfraredBERAWithdrawor} from "src/staking/InfraredBERAWithdrawor.sol";
import {InfraredBERAWithdraworLite} from
    "src/staking/InfraredBERAWithdraworLite.sol";
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
import {BeaconDepositMock, POLTest} from "@berachain/../test/pol/POL.t.sol";

abstract contract Helper is POLTest {
    Infrared public infrared;
    InfraredBGT public ibgt;
    RED public red;

    Voter public voter;
    VotingEscrow public ired;

    InfraredBERA public ibera;
    InfraredBERADepositor public depositor;
    InfraredBERAWithdrawor public withdrawor;
    InfraredBERAWithdraworLite public withdraworLite;
    InfraredBERAClaimor public claimor;
    InfraredBERAFeeReceivor public receivor;

    BribeCollector internal collector;
    InfraredDistributor internal infraredDistributor;

    address internal admin;
    address internal keeper;
    address internal infraredGovernance;

    // MockERC20 internal bgt;
    MockERC20 internal wibera;
    MockERC20 internal honey;
    address internal beraVault;

    MockERC20 internal mockPool;
    // address internal chef = makeAddr("chef");

    string vaultName;
    string vaultSymbol;
    // address[] rewardTokens;
    address stakingAsset;
    address poolAddress;

    IInfraredVault internal ibgtVault;
    InfraredVault internal infraredVault;

    address validator = address(888);
    address validator2 = address(999);

    function setUp() public virtual override {
        super.setUp();

        address depositContract = address(new BeaconDeposit());

        wibera = new MockERC20("WIBERA", "WIBERA", 18);
        honey = new MockERC20("HONEY", "HONEY", 18);

        // Set up addresses for roles
        admin = address(this);
        keeper = address(1);
        infraredGovernance = address(2);

        stakingAsset = address(wbera);

        // Set up bera bgt distribution for mockPool
        beraVault = factory.createRewardVault(stakingAsset);

        // initialize Infrared contracts
        infrared = Infrared(payable(setupProxy(address(new Infrared()))));

        // ibera = new InfraredBERA(address(infrared));
        // InfraredBERA
        ibera = InfraredBERA(setupProxy(address(new InfraredBERA())));

        depositor = InfraredBERADepositor(
            setupProxy(address(new InfraredBERADepositor()))
        );
        withdraworLite = InfraredBERAWithdraworLite(
            payable(setupProxy(address(new InfraredBERAWithdraworLite())))
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

        collector.initialize(infraredGovernance, address(wbera), 10 ether);
        infraredDistributor.initialize(infraredGovernance, address(ibera));

        voter = Voter(setupProxy(address(new Voter(address(infrared)))));

        Infrared.InitializationData memory data = Infrared.InitializationData(
            infraredGovernance,
            keeper,
            address(bgt),
            address(factory),
            address(beraChef),
            payable(address(wbera)),
            address(honey),
            address(collector),
            address(infraredDistributor),
            address(voter),
            address(ibera),
            1 days
        );
        infrared.initialize(data);
        ibgt = new InfraredBGT(
            address(bgt), data._gov, address(infrared), data._gov
        );

        infrared.setIBGT(address(ibgt));

        // initialize ibera proxies
        depositor.initialize(
            infraredGovernance, keeper, address(ibera), depositContract
        );
        withdraworLite.initialize(infraredGovernance, keeper, address(ibera));

        claimor.initialize(infraredGovernance, keeper, address(ibera));

        receivor.initialize(
            infraredGovernance, keeper, address(ibera), address(infrared)
        );

        // init deposit to avoid inflation attack
        uint256 _value = InfraredBERAConstants.MINIMUM_DEPOSIT
            + InfraredBERAConstants.MINIMUM_DEPOSIT_FEE;

        ibera.initialize{value: _value}(
            infraredGovernance,
            keeper,
            address(infrared),
            address(depositor),
            address(withdraworLite),
            address(receivor)
        );

        red = new RED(
            address(ibgt), address(infrared), data._gov, data._gov, data._gov
        );

        // ired voting

        ired = new VotingEscrow(
            address(this), address(red), address(voter), address(infrared)
        );
        voter.initialize(address(ired), infraredGovernance, keeper);

        uint16 feeShareholders = 4; // 25% of fees

        vm.prank(infraredGovernance);
        ibera.setFeeDivisorShareholders(feeShareholders);

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
        vm.label(address(beraChef), "chef");
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

    function _credential(address addr) internal pure returns (bytes memory) {
        return abi.encodePacked(bytes1(0x01), bytes11(0x0), addr);
    }

    function _create96Byte() internal pure returns (bytes memory) {
        return abi.encodePacked(bytes32("32"), bytes32("32"), bytes32("32"));
    }

    function _create48Byte() internal pure returns (bytes memory) {
        return abi.encodePacked(bytes32("32"), bytes16("16"));
    }
}
