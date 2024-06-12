// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import "forge-std/Script.sol";

import {ERC1967Proxy} from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ERC20PresetMinterPauser} from
    "../src/vendors/ERC20PresetMinterPauser.sol";

import {IBGT} from "@core/IBGT.sol";
import {Infrared} from "@core/Infrared.sol";
import {InfraredBribes} from "@core/InfraredBribes.sol";
import {BribeCollector} from "@core/BribeCollector.sol";

contract InfraredDeployer is Script {
    IBGT public ibgt;
    ERC20PresetMinterPauser public ired;

    BribeCollector public collector;
    InfraredBribes public bribes;
    Infrared public infrared;

    function run(
        address _admin,
        address _bgt,
        address _berachainRewardsFactory,
        address _beaconDepositContract,
        address _beraChef,
        address _wbera,
        uint256 _rewardsDuration,
        uint256 _bribeCollectorPayoutAmount
    ) external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ibgt = new IBGT(_bgt);
        ired = new ERC20PresetMinterPauser("Infrared Token", "iRED"); // TODO: fix for actual IRED implementation

        collector = BribeCollector(setupProxy(address(new BribeCollector())));
        bribes = InfraredBribes(setupProxy(address(new InfraredBribes())));
        infrared = Infrared(
            setupProxy(
                address(
                    new Infrared(
                        address(ibgt),
                        _berachainRewardsFactory,
                        _beaconDepositContract,
                        _beraChef,
                        _wbera,
                        address(ired)
                    )
                )
            )
        );

        // initialize proxies
        // @dev must initialize collector before bribes
        collector.initialize(
            _admin, _wbera, address(collector), _bribeCollectorPayoutAmount
        );
        bribes.initialize(_admin, address(infrared), address(collector));
        infrared.initialize(
            _admin, address(collector), address(bribes), _rewardsDuration
        );

        vm.stopBroadcast();
    }

    function setupProxy(address implementation)
        internal
        returns (address proxy)
    {
        proxy = address(new ERC1967Proxy(implementation, ""));
    }
}
