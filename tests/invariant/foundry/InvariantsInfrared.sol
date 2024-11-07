// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "forge-std/Test.sol";

// external
import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

import {InfraredDistributor} from "@core/InfraredDistributor.sol";
import {BribeCollector} from "@core/BribeCollector.sol";

import {Voter} from "@voting/Voter.sol";
import {VotingEscrow} from "@voting/VotingEscrow.sol";

// internal
import "@core/Infrared.sol";
import "@core/IBGT.sol";
import "@core/InfraredVault.sol";
import "@utils/DataTypes.sol";

// mocks
import "@mocks/MockERC20.sol";
import "@mocks/MockWbera.sol";
import "@berachain/pol/rewards/RewardVaultFactory.sol";
// import "@mocks/MockBeaconDepositContract.sol";
// TODO: fix import "@mocks/MockBerachef.sol";

import "./handlers/Governance.sol";
import "./handlers/Keeper.sol";
import "./handlers/User.sol";

import "@core/MultiRewards.sol";

contract InvariantsInfrared is Test {
    Infrared public infrared;
    IBGT public ibgt;

    BribeCollector public collector;
    InfraredDistributor public distributor;

    Voter public voter;
    VotingEscrow public veIRED;

    address public admin;
    address public keeper;
    address public governance;

    Keeper public keeperHandler;
    Governance public governanceHandler;
    User public userHandler;

    MockERC20 public bgt;
    MockERC20 public ired;
    MockERC20 public wibera;
    MockERC20 public honey;
    MockWbera public mockWbera;

    MockERC20 public mockPool;
    RewardVaultFactory public rewardsFactory;
    address public chef = makeAddr("chef"); // TODO: fix with mock chef

    string vaultName;
    string vaultSymbol;
    address[] rewardTokens;
    address stakingAsset;
    address poolAddress;

    // New declaration for mock pools
    MockERC20[] public mockPools;

    function setUp() public {
        // Mock non transferable token BGT token
        bgt = new MockERC20("BGT", "BGT", 18);
        // Mock contract instantiations
        ibgt = new IBGT(address(bgt));
        ired = new MockERC20("IRED", "IRED", 18);
        wibera = new MockERC20("WIBERA", "WIBERA", 18);
        honey = new MockERC20("HONEY", "HONEY", 18);
        mockWbera = new MockWbera();

        // Set up addresses for roles
        admin = address(this);
        keeper = address(1);
        governance = address(2);

        // TODO: mock contracts
        mockPool = new MockERC20("Mock Asset", "MAS", 18);
        stakingAsset = address(mockPool);

        // deploy a rewards vault for IBGT
        rewardsFactory = new RewardVaultFactory();

        // Set up the chef
        // TODO: fix chef

        // initialize Infrared contracts;
        infrared = Infrared(
            setupProxy(
                address(
                    new Infrared(
                        address(ibgt),
                        address(rewardsFactory),
                        address(chef),
                        payable(address(mockWbera)),
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
            address(this), address(ired), address(voter), address(infrared)
        );

        collector.initialize(address(this), address(mockWbera), 10 ether);
        distributor.initialize();
        infrared.initialize(
            address(this),
            address(collector),
            address(distributor),
            address(voter),
            1 days
        ); // make helper contract the admin

        // @dev must initialize after infrared so address(this) has keeper role
        voter.initialize(address(veIRED));

        // set access control
        infrared.grantRole(infrared.KEEPER_ROLE(), keeper);
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), governance);
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));
        /* Handler Setup */

        // deploy the handler contracts
        keeperHandler = new Keeper(infrared, keeper, rewardsFactory);

        governanceHandler = new Governance(infrared, governance);

        userHandler = new User(infrared, keeperHandler);

        bytes4[] memory keeperSelectors = new bytes4[](2);
        keeperSelectors[0] = keeperHandler.registerVault.selector;
        keeperSelectors[1] = keeperHandler.harvestVault.selector;

        bytes4[] memory governanceSelectors = new bytes4[](2);
        governanceSelectors[0] = governanceHandler.delegateBGT.selector;
        governanceSelectors[1] = governanceHandler.redelegate.selector;

        bytes4[] memory userSelectors = new bytes4[](3);
        userSelectors[0] = userHandler.deposit.selector;
        userSelectors[1] = userHandler.withdraw.selector;
        userSelectors[2] = userHandler.claim.selector;

        excludeArtifact("InfraredVault");
        // excludeArtifact("MockBerachainRewardsVault");
        excludeArtifact("tests/unit/mocks/MockERC20.sol:MockERC20");

        targetSelector(
            FuzzSelector({
                addr: address(keeperHandler),
                selectors: keeperSelectors
            })
        );
        targetContract(address(keeperHandler));

        targetSelector(
            FuzzSelector({
                addr: address(governanceHandler),
                selectors: governanceSelectors
            })
        );
        targetContract(address(governanceHandler));

        targetSelector(
            FuzzSelector({addr: address(userHandler), selectors: userSelectors})
        );
        targetContract(address(userHandler));
    }

    /// forge-config: default.invariant.fail-on-revert = false
    function invariant_ibgt_minted_equal_to_bgt_rewards() public {
        // assert that the total minted ibgt is equal to the total bgt rewards
        assertEq(
            ibgt.totalSupply(),
            bgt.balanceOf(address(infrared)),
            "Invariant: Minted IBGT should be equal to total BGT rewards"
        );
    }

    /// forge-config: default.invariant.fail-on-revert = false
    function invariant_delegated_amount_not_bigger_than_BGT_balance() public {
        // assert that the total delegated bgt is not bigger than the total bgt rewards
        assertLe(
            governanceHandler.totalDelegatedBgt(),
            ERC20(infrared.ibgt().bgt()).balanceOf(address(infrared))
        );
    }

    function setupProxy(address implementation)
        internal
        returns (address proxy)
    {
        proxy = address(new ERC1967Proxy(implementation, ""));
    }

    /// forge-config: default.invariant.fail-on-revert = false
    function invariant_delegated_amount_not_bigger_than_IBGT_total_supply()
        public
    {
        // assert that the total delegated bgt is not bigger than the total bgt rewards
        assertTrue(
            governanceHandler.totalDelegatedBgt() <= ibgt.totalSupply(),
            "Invariant: Delegated BGT amount should not be bigger than IBGT total supply"
        );
    }

    /*//////////////////////////////////////////////////////////////
                    User Invariants
    //////////////////////////////////////////////////////////////*/
    function invariant_user_earned_ibgt_rewards() public {
        // assert that the user earned ibgt rewards
        address[] memory users = userHandler.getUsers();
        uint256 userRewards;

        for (uint256 i = 0; i < users.length; i++) {
            userRewards += ibgt.balanceOf(users[i]);
        }

        assertTrue(
            userRewards <= ibgt.totalSupply(),
            "Invariant: Users should earn IBGT rewards"
        );
    }

    /*//////////////////////////////////////////////////////////////
                    Validator Rewards Invariants
    //////////////////////////////////////////////////////////////*/

    // function invariant_only_whitelisted_reward_tokens_are_distributed_to_IBGTVault(
    // ) public {
    //     address otherToken = ibgtVaultHandler.otherToken(); // non whitelisted token that can be part of the rewards array in the harvestValidator function
    //     // assert that only whitelisted reward tokens are distributed
    //     assertTrue(
    //         MultiRewards(address(infrared.ibgtVault())).rewardPerToken(
    //             otherToken
    //         ) == 0,
    //         "Invariant: Only whitelisted reward tokens should be distributed"
    //     );
    // }

    // function invariant_rewards_are_distributed_to_ibgt_vault() public {
    //     // MultiRewards ibgtVault = MultiRewards(address(infrared.ibgtVault()));
    //     // address ibgt = address(ibgtVaultHandler.ibgt());
    //     // address ired = address(ibgtVaultHandler.ired());
    //     // address wbera = address(ibgtVaultHandler.wbera());
    //     // assert that the total rewards are distributed to the ibgt vault
    //     // assertTrue(ibgtVaultHandler.ibgtRewards() > 0 && ibgtVault.rewardPerToken(ibgt) > 0 , "Invariant: Rewards should be distributed to IBGT vault");
    //     // assertTrue(ibgtVaultHandler.iredRewards() > 0 && ibgtVault.rewardPerToken(ired) > 0 , "Invariant: Rewards should be distributed to IBGT vault");
    //     // assertTrue(ibgtVaultHandler.wberaRewards() > 0 && ibgtVault.rewardPerToken(wbera) > 0 , "Invariant: Rewards should be distributed to IBGT vault");
    // }

    // function invariant_users_earn_ibgt_rewards() public {
    //     // assert that the users earn ibgt rewards
    //     uint256 user1Rewards = userHandler.userClaimed(userHandler.user1());
    //     assertTrue(
    //         ibgt.balanceOf(userHandler.user1()) == user1Rewards,
    //         "Invariant: Users should earn IBGT rewards"
    //     );
    // }
}
