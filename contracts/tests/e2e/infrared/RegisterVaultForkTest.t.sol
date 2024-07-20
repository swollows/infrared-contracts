// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.22;

import {IBerachainRewardsVault} from
    "@berachain/interfaces/IBerachainRewardsVault.sol";
import {IInfraredVault} from "@interfaces/IInfraredVault.sol";
import {IMultiRewards} from "@interfaces/IMultiRewards.sol";

import {InfraredForkTest} from "../InfraredForkTest.t.sol";

contract RegisterVaultForkTest is InfraredForkTest {
/* TODO: fix for bytes validators
    function testRegisterVaultWithoutRewardsVault() public {
        vm.startPrank(admin);

        // priors checked
        assertEq(
            address(infrared.vaultRegistry(address(stakingToken))), address(0)
        );
        assertEq(rewardsFactory.getVault(address(stakingToken)), address(0));

        address[] memory _rewardTokens = new address[](1);
        _rewardTokens[0] = address(ibgt);

        IInfraredVault _newVault =
            infrared.registerVault(address(stakingToken), _rewardTokens);

        // check vault stored in registry
        assertTrue(
            address(infrared.vaultRegistry(address(stakingToken))) != address(0)
        );
        assertEq(
            address(infrared.vaultRegistry(address(stakingToken))),
            address(_newVault)
        );

        // check berachain rewards vault created
        IBerachainRewardsVault _newRewardsVault = _newVault.rewardsVault();
        assertEq(
            address(_newRewardsVault),
            rewardsFactory.getVault(address(stakingToken))
        );

        // check infrared rewards vault sets infrared as operator
        assertEq(
            _newRewardsVault.operator(address(_newVault)), address(infrared)
        );

        // check reward added to multirewards in infrared vault
        (
            address _distributor,
            uint256 _duration,
            uint256 _periodFin,
            uint256 _rate,
            uint256 _last,
            uint256 _stored
        ) = IMultiRewards(address(_newVault)).rewardData(address(ibgt));
        assertEq(_distributor, address(infrared));
        assertEq(_duration, rewardsDuration);
        assertEq(_periodFin, 0);
        assertEq(_rate, 0);
        assertEq(_last, 0);
        assertEq(_stored, 0);

        vm.stopPrank();
    }

    function testRegisterVaultWithRewardsVault() public {
        vm.startPrank(admin);

        // priors checked
        assertEq(
            address(infrared.vaultRegistry(address(vdHoneyToken))), address(0)
        );

        address rewardsVaultAddress =
            rewardsFactory.getVault(address(vdHoneyToken));
        assertTrue(rewardsVaultAddress != address(0));

        address[] memory _rewardTokens = new address[](1);
        _rewardTokens[0] = address(ibgt);

        IInfraredVault _newVault =
            infrared.registerVault(address(vdHoneyToken), _rewardTokens);

        // check vault stored in registry
        assertTrue(
            address(infrared.vaultRegistry(address(vdHoneyToken))) != address(0)
        );
        assertEq(
            address(infrared.vaultRegistry(address(vdHoneyToken))),
            address(_newVault)
        );

        // check berachain rewards vault created
        IBerachainRewardsVault _newRewardsVault = _newVault.rewardsVault();
        assertEq(address(_newRewardsVault), rewardsVaultAddress);

        // check infrared rewards vault sets infrared as operator
        assertEq(
            _newRewardsVault.operator(address(_newVault)), address(infrared)
        );

        // check reward added to multirewards in infrared vault
        (
            address _distributor,
            uint256 _duration,
            uint256 _periodFin,
            uint256 _rate,
            uint256 _last,
            uint256 _stored
        ) = IMultiRewards(address(_newVault)).rewardData(address(ibgt));
        assertEq(_distributor, address(infrared));
        assertEq(_duration, rewardsDuration);
        assertEq(_periodFin, 0);
        assertEq(_rate, 0);
        assertEq(_last, 0);
        assertEq(_stored, 0);

        vm.stopPrank();
    }
    */
}
