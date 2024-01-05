// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

// Testing Libraries.
import "forge-std/Test.sol";

// external
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

// internal
import {
    Infrared,
    Errors,
    IInfraredVault,
    AccessControl
} from "@core/immutable/Infrared.sol";
import "@core/immutable/IBGT.sol";
import "@core/immutable/InfraredVault.sol";
import {UpgradableRewardsHandler} from
    "@core/upgradable/UpgradableRewardsHandler.sol";
import "@core/upgradable/UpgradableStakingHandler.sol";

// mocks
import "../../mocks/MockPool.sol";
import "../../mocks/MockERC20.sol";
import "../../mocks/MockDistributionPrecompile.sol";
import "../../mocks/MockERC20BankModule.sol";
import "../../mocks/MockWbera.sol";
import "../../mocks/MockRewardsPrecompile.sol";
import "../../mocks/MockStakingModule.sol";

contract Helper is Test {
    Infrared public infrared;
    IBGT public ibgt;
    UpgradableRewardsHandler public rewardsHandlerProxy;
    UpgradableStakingHandler public stakingHandlerProxy;

    address public admin;
    address public keeper;
    address public governance;

    MockERC20 public bgt;
    MockERC20 mockAsset;
    MockERC20 mockRewardToken;
    MockERC20 mockPool;
    MockDistributionPrecompile mockDistribution;
    MockERC20BankModule mockErc20Bank;
    MockWbera mockWbera;
    MockRewardsPrecompile mockRewardsPrecompile;
    MockStakingModule mockStaking;

    string vaultName;
    string vaultSymbol;
    address[] rewardTokens;
    address poolAddress;

    InfraredVault public ibgtVault;

    //
    address validator = address(888);

    // New declaration for mock pools
    MockERC20[] public mockPools;

    function setUp() public {
        // Mock non transferable token BGT token
        bgt = new MockERC20("BGT", "BGT", 18);
        // Mock contract instantiations
        ibgt = new IBGT();
        address rewardsHandler = address(new UpgradableRewardsHandler());
        address stakingHandler = address(new UpgradableStakingHandler());
        rewardsHandlerProxy = UpgradableRewardsHandler(
            // address(new ERC1967Proxy(rewardsHandler, ""))
            rewardsHandler
        );
        // rewardsHandler

        stakingHandlerProxy = UpgradableStakingHandler(
            // address(new ERC1967Proxy(stakingHandler, ""))
            stakingHandler
        );
        // stakingHandler

        mockAsset = new MockERC20("Mock Asset", "MAS", 18);
        mockRewardToken = new MockERC20("Mock Reward Token", "MRT", 18);
        mockPool = new MockERC20("Mock Asset", "MAS", 18);
        vaultName = "Test Vault";
        vaultSymbol = "TVT";
        rewardTokens = new address[](1);
        rewardTokens[0] = address(ibgt); // all Infrared vaults will only receive ibgt as rewards
        poolAddress = address(mockPool);

        // Set up addresses for roles
        admin = address(this);
        keeper = address(1);
        governance = address(2);

        // Infrared contract instantiation
        infrared = new Infrared(
            address(rewardsHandlerProxy),
            address(stakingHandlerProxy),
            admin,
            address(ibgt)
        );

        // Set up roles
        infrared.grantRole(infrared.KEEPER_ROLE(), keeper);
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), governance);

        // Initialize UpgradableRewardsHandler and UpgradableStakingHandler
        // Mock contracts
        mockErc20Bank = new MockERC20BankModule();
        mockWbera = new MockWbera();
        mockRewardsPrecompile =
            new MockRewardsPrecompile(address(mockErc20Bank));
        mockDistribution =
            new MockDistributionPrecompile(address(mockErc20Bank));

        // Initialize the rewards handler with mock addresses
        rewardsHandlerProxy.initialize(
            address(mockRewardsPrecompile),
            address(mockDistribution),
            address(mockErc20Bank),
            address(mockWbera)
        );

        mockStaking = new MockStakingModule();

        stakingHandlerProxy.initialize(address(mockStaking));

        ibgtVault = new InfraredVault(
            address(ibgt),
            "IBGT Vault",
            "IBGT",
            rewardTokens,
            address(infrared),
            address(mockPool),
            address(rewardsHandlerProxy),
            admin
        );

        rewardsHandlerProxy.DISTRIBUTION_PRECOMPILE();
        rewardsHandlerProxy.ERC20_BANK_PRECOMPILE();

        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        address[] memory validatorAddresses = new address[](1);
        validatorAddresses[0] = validator;

        vm.startPrank(governance);
        infrared.updateIbgtVault(address(ibgtVault));
        infrared.addValidators(validatorAddresses);
        vm.stopPrank();

        mockErc20Bank.setErc20AddressForCoinDenom("abgt", address(bgt));
        mockErc20Bank.setErc20AddressForCoinDenom(
            "abera", 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
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
            infrared.registerVault(
                poolAddress,
                "Mock Vault",
                "MVLT",
                rewardTokens,
                address(newPool)
            )
        );
        pool = address(newPool);
        // for (uint256 i = 0; i < 3; i++) {
        //     MockERC20 newPool = new MockERC20("Mock Asset", "MAS", 18);
        //     mockPools.push(mockPool);
        //     // Register a vault for each mock pool
        //     vault = address(
        //         infrared.registerVault(
        //             poolAddress,
        //             "Mock Vault",
        //             "MVLT",
        //             rewardTokens,
        //             address(newPool)
        //         )
        //     );
        //     pool = address(newPool);
        // }
    }

    function labelContracts() public {
        // labeling contracts
        vm.label(address(infrared), "infrared");
        vm.label(address(ibgt), "ibgt");
        vm.label(address(rewardsHandlerProxy), "rewardsHandler");
        vm.label(address(stakingHandlerProxy), "stakingHandler");
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
        vm.label(poolAddress, "poolAddress");
    }
}
