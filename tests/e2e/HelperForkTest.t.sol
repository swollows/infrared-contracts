// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import "forge-std/Test.sol";

import {IBeraChef} from "@berachain/pol/interfaces/IBeraChef.sol";
import {IBeaconDeposit as IBerachainBeaconDeposit} from
    "@berachain/pol/interfaces/IBeaconDeposit.sol";
import {IDistributor as IBerachainDistributor} from
    "@berachain/pol/interfaces/IDistributor.sol";
import {IBerachainRewardsVaultFactory} from
    "@berachain/pol/interfaces/IBerachainRewardsVaultFactory.sol";
import {IBerachainBGT} from "@interfaces/IBerachainBGT.sol";
import {IBerachainBGTStaker} from "@interfaces/IBerachainBGTStaker.sol";
import {IFeeCollector as IBerachainFeeCollector} from
    "@berachain/pol/interfaces/IFeeCollector.sol";

import {IWBERA} from "@interfaces/IWBERA.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

contract HelperForkTest is Test {
    string constant BARTIO_RPC_URL = "https://bartio.rpc.berachain.com/";

    // the identifiers of the forks
    uint256 bartioFork;

    // berachain contract addresses
    IBerachainBGT public bgt;
    IBerachainRewardsVaultFactory public rewardsFactory;
    IBeraChef public beraChef;
    IBerachainFeeCollector public feeCollector;
    IBerachainBGTStaker public bgtStaker;
    IBerachainBeaconDeposit public beaconDeposit;

    IWBERA public wbera;
    IERC20 public honey;
    IERC20 public lpToken;
    IERC20 public vdHoneyToken;
    IBerachainDistributor public berachainDistributor;

    // berachain constants
    uint32 public constant HISTORY_BUFFER_LENGTH = 8191;

    //Access variables from .env file via vm.envString("varname")
    //Replace ALCHEMY_KEY by your alchemy key or Etherscan key, change RPC url if need
    //inside your .env file e.g:
    //MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/ALCHEMY_KEY'
    //string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    //string OPTIMISM_RPC_URL = vm.envString("OPTIMISM_RPC_URL");

    // create a bartio fork during setup
    function setUp() public virtual {
        bartioFork = vm.createFork(BARTIO_RPC_URL);
        vm.selectFork(bartioFork);

        // store relevant berachain core contract addresses
        bgt = IBerachainBGT(0xbDa130737BDd9618301681329bF2e46A016ff9Ad);
        rewardsFactory = IBerachainRewardsVaultFactory(
            0x2B6e40f65D82A0cB98795bC7587a71bfa49fBB2B
        );
        beraChef = IBeraChef(0xfb81E39E3970076ab2693fA5C45A07Cc724C93c2);
        feeCollector =
            IBerachainFeeCollector(0x9B6F83a371Db1d6eB2eA9B33E84f3b6CB4cDe1bE);
        bgtStaker =
            IBerachainBGTStaker(0x791fb53432eED7e2fbE4cf8526ab6feeA604Eb6d);
        beaconDeposit = IBerachainBeaconDeposit(address(0)); // TODO: fix

        wbera = IWBERA(0x7507c1dc16935B82698e4C63f2746A2fCf994dF8);
        honey = IERC20(0x0E4aaF1351de4c0264C5c7056Ef3777b41BD8e03);
        lpToken = IERC20(0xd28d852cbcc68DCEC922f6d5C7a8185dBaa104B7);
        vdHoneyToken = IERC20(0x1339503343be5626B40Ee3Aee12a4DF50Aa4C0B9);
        berachainDistributor =
            IBerachainDistributor(0x2C1F148Ee973a4cdA4aBEce2241DF3D3337b7319);
    }

    function testSetUp() public virtual {
        address _staker = address(bgt.staker());
        assertEq(_staker, 0x791fb53432eED7e2fbE4cf8526ab6feeA604Eb6d);
    }

    /// @notice Simulates rolling of chain forward to block `number` distributing POL rewards for each block to `coinbase` in the process
    /// @dev `number` must be greater than the current `block.number`
    /// @param coinbase address  The address of the coinbase to distribute POL for at each block
    /// @param number   uint256  The block number to roll to
    function rollPol(address coinbase, uint256 number) public {
        require(number > block.number, "rolling number <= block.number");
        uint256 delta = number - block.number;
        for (uint256 i = 1; i < delta + 1; i++) {
            vm.roll(block.number + i);
            distributePol(coinbase);
        }
    }

    /// @notice Simulates distribution of POL for current block.number
    /// @param coinbase address  The address of the coinbase to distribute POL for
    function distributePol(address coinbase) public {
        uint256 blockNumber = block.number; // TODO: fix for berachain distributor updates
            /* TODO: fix .. vm.startPrank(berachainDistributor.prover());
        berachainDistributor.distributeFor(coinbase, blockNumber);
        vm.stopPrank();
        */
    }
}
