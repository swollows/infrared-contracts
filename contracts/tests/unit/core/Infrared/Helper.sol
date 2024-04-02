// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// Testing Libraries.
import "forge-std/Test.sol";

// external
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

// internal
import "@core/Infrared.sol";
import "@core/IBGT.sol";
import "@core/InfraredVault.sol";
import "@utils/DataTypes.sol";
import "@utils/ValidatorUtils.sol";

import "@interfaces/IInfrared.sol";

// mocks
import "@mocks/MockERC20.sol";
import "@mocks/MockWbera.sol";
import "@mocks/MockBerachainRewardsVaultFactory.sol";
import "@mocks/MockBeaconDepositContract.sol";
import "@mocks/MockBerachef.sol";

contract Helper is Test {
    Infrared public infrared;
    IBGT public ibgt;

    address public admin;
    address public keeper;
    address public governance;

    MockERC20 public bgt;
    MockERC20 public ired;
    MockWbera public mockWbera;

    MockERC20 public mockPool;
    MockBerachainRewardsVaultFactory public rewardsFactory;
    MockBeaconDepositContract public depositor;
    MockBeraChef public chef;

    string vaultName;
    string vaultSymbol;
    address[] rewardTokens;
    address stakingAsset;
    address poolAddress;

    InfraredVault public ibgtVault;
    InfraredVault public infraredVault;

    //
    address validator = address(888);
    address validator2 = address(999);

    // New declaration for mock pools
    MockERC20[] public mockPools;

    function setUp() public {
        // Mock non transferable token BGT token
        bgt = new MockERC20("BGT", "BGT", 18);
        // Mock contract instantiations
        ibgt = new IBGT(address(bgt));
        ired = new MockERC20("IRED", "IRED", 18);
        mockWbera = new MockWbera();

        // Set up addresses for roles
        admin = address(this);
        keeper = address(1);
        governance = address(2);

        // TODO: mock contracts
        mockPool = new MockERC20("Mock Asset", "MAS", 18);
        stakingAsset = address(mockPool);

        // deploy a rewards vault for IBGT
        rewardsFactory = new MockBerachainRewardsVaultFactory(address(bgt));
        address rewardsVault = rewardsFactory.createRewardsVault(address(ibgt));
        assertEq(rewardsVault, rewardsFactory.getVault(address(ibgt)));

        // Set up bera bgt distribution for mockPool
        address beraVault = rewardsFactory.createRewardsVault(stakingAsset);
        rewardsFactory.increaseRewardsForVault(stakingAsset, 1000 ether);

        // Set up the depositor
        depositor = new MockBeaconDepositContract();

        // Set up the chef
        chef = new MockBeraChef();

        // initialize Infrared contracts
        address implementation = address(
            new Infrared(
                address(ibgt),
                address(rewardsFactory),
                address(depositor),
                address(chef),
                address(mockWbera),
                address(ired)
            )
        );
        address infraredProxy = address(new ERC1967Proxy(implementation, ""));
        infrared = Infrared(infraredProxy);
        infrared.initialize(address(this), 1 days); // make helper contract the admin

        // set access control
        infrared.grantRole(infrared.KEEPER_ROLE(), keeper);
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), governance);

        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        address[] memory _rewardTokens = new address[](2);
        _rewardTokens[0] = address(ibgt); // all Infrared vaults will only receive ibgt as rewards
        _rewardTokens[1] = address(ired);
        infraredVault = InfraredVault(
            address(infrared.registerVault(stakingAsset, _rewardTokens))
        );

        labelContracts();
    }

    function labelContracts() public {
        // labeling contracts
        vm.label(address(infrared), "infrared");
        vm.label(address(ibgt), "ibgt");
        vm.label(address(bgt), "bgt");
        vm.label(address(mockPool), "mockPool");
        vm.label(address(mockWbera), "mockWbera");
        vm.label(admin, "admin");
        vm.label(keeper, "keeper");
        vm.label(stakingAsset, "stakingAsset");
        vm.label(governance, "governance");
        vm.label(address(rewardsFactory), "rewardsFactory");
        vm.label(address(depositor), "depositor");
        vm.label(address(chef), "chef");
        vm.label(address(ibgtVault), "ibgtVault");
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
}
