// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// Testing Libraries.
import "forge-std/Test.sol";

// external
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

import {TransparentUpgradeableProxy} from
    "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

// internal
import {Infrared, Errors, IInfraredVault} from "@core/upgradable/Infrared.sol";
import "@core/IBGT.sol";
import "@core/InfraredVault.sol";

// mocks
import "../../mocks/MockPool.sol";
import "../../mocks/MockERC20.sol";
import "../../mocks/MockDistributionPrecompile.sol";
import "../../mocks/MockERC20BankModule.sol";
import "../../mocks/MockWbera.sol";
import "../../mocks/MockRewardsPrecompile.sol";
import "../../mocks/MockStakingModule.sol";
import "../../mocks/MockBankModulePrecompile.sol";

contract Helper is Test {
    Infrared public infrared;
    IBGT public ibgt;

    address public admin;
    address public keeper;
    address public governance;

    MockERC20 public bgt;
    MockERC20 public ired;
    MockERC20 mockAsset;
    MockERC20 mockRewardToken;
    MockERC20 mockPool;
    MockDistributionPrecompile mockDistribution;
    MockERC20BankModule mockErc20Bank;
    MockWbera mockWbera;
    MockRewardsPrecompile mockRewardsPrecompile;
    MockStakingModule mockStaking;
    MockBankModule mockBankModule;

    string vaultName;
    string vaultSymbol;
    address[] rewardTokens;
    address stakingAsset;
    address poolAddress;

    InfraredVault public ibgtVault;

    //
    address validator = address(888);
    address validator2 = address(999);

    // New declaration for mock pools
    MockERC20[] public mockPools;

    function setUp() public {
        // Mock non transferable token BGT token
        bgt = new MockERC20("BGT", "BGT", 18);
        // Mock contract instantiations
        ibgt = new IBGT();
        ired = new MockERC20("IRED", "IRED", 18);

        mockAsset = new MockERC20("Mock Asset", "MAS", 18);
        mockRewardToken = new MockERC20("Mock Reward Token", "MRT", 18);
        mockPool = new MockERC20("Mock Asset", "MAS", 18);
        vaultName = "Test Vault";
        vaultSymbol = "TVT";
        rewardTokens = new address[](2);
        rewardTokens[0] = address(ibgt); // all Infrared vaults will only receive ibgt as rewards
        rewardTokens[1] = address(ired);
        stakingAsset = address(mockPool);
        poolAddress = address(mockAsset);

        // Set up addresses for roles
        admin = address(this);
        keeper = address(1);
        governance = address(2);

        // Mock contracts
        mockErc20Bank = new MockERC20BankModule();
        mockWbera = new MockWbera();
        mockRewardsPrecompile =
            new MockRewardsPrecompile(address(mockErc20Bank));
        mockDistribution =
            new MockDistributionPrecompile(address(mockErc20Bank));
        mockStaking = new MockStakingModule(address(bgt));
        mockBankModule = new MockBankModule(bgt);

        // deploy Infrared Implementation contracts
        address infraredImpl = address(new Infrared());
        // deploy Infrared Proxy contracts
        address infraredProxy = address(new ERC1967Proxy(infraredImpl, ""));
        // initialize Infrared Proxy contracts
        infrared = Infrared(infraredProxy);
        infrared.initialize(
            address(this), // make helper contract the admin
            address(ibgt),
            address(mockErc20Bank),
            address(mockDistribution),
            address(mockWbera),
            address(mockStaking),
            address(mockRewardsPrecompile),
            address(ired),
            1 days,
            address(mockBankModule)
        );

        // Set up roles
        infrared.grantRole(infrared.KEEPER_ROLE(), keeper);
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), governance);

        vm.startPrank(governance);
        // Set up reward tokens
        infrared.updateWhiteListedRewardTokens(address(ibgt), true);
        infrared.updateWhiteListedRewardTokens(address(ired), true);
        infrared.updateWhiteListedRewardTokens(address(mockWbera), true);
        vm.stopPrank();

        ibgtVault = new InfraredVault(
            admin,
            address(ibgt),
            address(infrared),
            address(mockPool),
            address(mockRewardsPrecompile),
            address(mockDistribution),
            rewardTokens,
            1 days
        );

        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        address[] memory validatorAddresses = new address[](2);
        validatorAddresses[0] = validator;
        validatorAddresses[1] = validator2;

        vm.startPrank(governance);
        infrared.updateIbgtVault(address(ibgtVault));
        infrared.addValidators(validatorAddresses);
        vm.stopPrank();

        mockErc20Bank.setErc20AddressForCoinDenom("abgt", address(bgt));
        mockErc20Bank.setErc20AddressForCoinDenom(
            "abera", 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
        );
        mockErc20Bank.setErc20AddressForCoinDenom(
            "other", address(new MockERC20("Other", "Other", 18))
        );

        // // labeling contracts
        labelContracts();
    }

    function setupMockVault() public returns (address vault, address pool) {
        // Set up a number of mock pools
        MockERC20 newPool = new MockERC20("Mock Asset", "MAS", 18);
        mockPools.push(mockPool);

        // Register a vault for each mock pool
        vault = address(
            infrared.registerVault(stakingAsset, rewardTokens, address(newPool))
        );
        pool = address(newPool);
    }

    function labelContracts() public {
        // labeling contracts
        vm.label(address(infrared), "infrared");
        vm.label(address(ibgt), "ibgt");
        vm.label(address(mockAsset), "mockAsset");
        vm.label(address(mockRewardToken), "mockRewardToken");
        vm.label(address(mockPool), "mockPool");
        vm.label(address(mockDistribution), "mockDistribution");
        vm.label(address(mockErc20Bank), "mockErc20Bank");
        vm.label(address(mockWbera), "mockWbera");
        vm.label(address(mockRewardsPrecompile), "mockRewardsPrecompile");
        vm.label(address(mockStaking), "mockStaking");
        vm.label(admin, "admin");
        vm.label(keeper, "keeper");
        vm.label(stakingAsset, "stakingAsset");
    }
}
