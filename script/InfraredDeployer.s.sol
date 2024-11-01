// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import "forge-std/Script.sol";

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ERC20PresetMinterPauser} from
    "../src/vendors/ERC20PresetMinterPauser.sol";

import {Voter} from "@voting/Voter.sol";
import {VotingEscrow} from "@voting/VotingEscrow.sol";

import {IBGT} from "@core/IBGT.sol";
import {Infrared} from "@core/Infrared.sol";
import {InfraredDistributor} from "@core/InfraredDistributor.sol";
import {BribeCollector} from "@core/BribeCollector.sol";

contract InfraredDeployer is Script {
    IBGT public ibgt;
    ERC20PresetMinterPauser public ired;
    ERC20PresetMinterPauser ibera;

    BribeCollector public collector;
    InfraredDistributor public distributor;
    Infrared public infrared;

    Voter public voter;
    VotingEscrow public veIRED;

    function run(
        address _admin,
        address _votingKeeper,
        address _bgt,
        address _berachainRewardsFactory,
        address _beraChef,
        address _beaconDeposit,
        address _wbera,
        address _honey,
        uint256 _rewardsDuration,
        uint256 _bribeCollectorPayoutAmount
    ) external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ibgt = new IBGT(_bgt);
        ired = new ERC20PresetMinterPauser("Infrared Token", "iRED"); // TODO: fix for actual IRED implementation
        ibera = new ERC20PresetMinterPauser("Infrared Bera", "iBERA"); // TODO: fix for actual IBERA implementation

        infrared = Infrared(
            setupProxy(
                address(
                    new Infrared(
                        address(ibgt),
                        _berachainRewardsFactory,
                        _beraChef,
                        _wbera,
                        _honey,
                        address(ired),
                        address(ibera)
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
            _votingKeeper, address(ired), address(voter), address(infrared)
        );

        // initialize proxies
        collector.initialize(_admin, _wbera, _bribeCollectorPayoutAmount);
        distributor.initialize();
        infrared.initialize(
            _admin,
            address(collector),
            address(distributor),
            address(voter),
            _rewardsDuration
        );
        voter.initialize(address(veIRED));

        // grant infrared ibgt minter role
        ibgt.grantRole(ibgt.MINTER_ROLE(), address(infrared));

        vm.stopBroadcast();
    }

    function setupProxy(address implementation)
        internal
        returns (address proxy)
    {
        proxy = address(new ERC1967Proxy(implementation, ""));
    }
}
