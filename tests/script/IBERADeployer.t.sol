// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {IBERADeployer} from "script/IBERADeployer.s.sol";
import {IBERA} from "@staking/IBERA.sol";

contract IBERADeployerTest is Test {
    IBERADeployer public deployer;
    IBERA public ibera;
    address public admin;

    function setUp() public {
        deployer = new IBERADeployer();
        admin = address(this);
    }

    function testDeploymentAndInitialization() public {
        address _infrared = address(0x123);

        // Call deploy script
        deployer.run(_infrared);

        // Fetch deployed contracts
        ibera = deployer.ibera();
        address depositor = address(deployer.depositor());
        address withdrawor = address(deployer.withdrawor());
        address claimor = address(deployer.claimor());
        address receivor = address(deployer.receivor());

        // Verify proxies are deployed
        assertTrue(isProxy(address(ibera)));
        assertTrue(isProxy(depositor));
        assertTrue(isProxy(withdrawor));
        assertTrue(isProxy(claimor));
        assertTrue(isProxy(receivor));

        // Verify initialization
        assertEq(ibera.infrared(), _infrared);
        assertEq(ibera.depositor(), depositor);
        assertEq(ibera.withdrawor(), withdrawor);
        assertEq(ibera.claimor(), claimor);
        assertEq(ibera.receivor(), receivor);
    }

    function testUpgradeability() public {
        address _infrared = address(0x123);

        // Deploy and initialize
        deployer.run(_infrared);
        ibera = deployer.ibera();

        // Deploy new implementation
        IBERA newImplementation = new IBERA();

        // Upgrade proxy
        vm.startPrank(admin);
        // Perform the upgrade by calling the proxy's `upgradeToAndCall` function
        (bool success,) = address(ibera).call(
            abi.encodeWithSignature(
                "upgradeToAndCall(address,bytes)",
                address(newImplementation),
                ""
            )
        );
        require(success, "Upgrade failed");
        vm.stopPrank();

        // Verify state is preserved
        assertEq(ibera.infrared(), _infrared);
    }

    function isProxy(address proxy) internal view returns (bool) {
        (bool success, bytes memory data) =
            proxy.staticcall(abi.encodeWithSignature("implementation()"));
        return success && data.length > 0;
    }
}
