// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

//external

import "./Helper.sol";

contract TestUpdateBGT is Helper {
    /*//////////////////////////////////////////////////////////////
                IBGT Token Update Tests (updateIbgt)
    //////////////////////////////////////////////////////////////*/
    function testUpdateIbgtToken() public {
        // Set up a new mock IBGT token address
        IBGT newIbgt = new IBGT();

        // Grant GOVERNANCE_ROLE to this contract
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), address(this));

        vm.expectEmit();
        emit Infrared.IBGTUpdated(
            address(this), address(infrared.ibgt()), address(newIbgt)
        );
        // Update the IBGT token
        infrared.updateIbgt(address(newIbgt));

        // Assert that the IBGT token was updated
        assertEq(
            address(infrared.ibgt()),
            address(newIbgt),
            "IBGT token not updated correctly"
        );
    }

    function testFailUpdateIbgtWithZeroAddress() public {
        // Grant GOVERNANCE_ROLE to this contract
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), address(this));

        // Attempt to update the IBGT token with a zero address
        infrared.updateIbgt(address(0));

        // Expect a revert due to zero address
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailUpdateIbgtUnauthorized() public {
        IBGT newIbgt = new IBGT();

        // Expect a revert due to unauthorized access
        vm.expectRevert();

        // Attempt to update the IBGT token as an unauthorized user
        vm.prank(address(2)); // Simulate call from unauthorized address
        infrared.updateIbgt(address(newIbgt));
    }

    /*//////////////////////////////////////////////////////////////
               IBGT Vault Update Tests (updateIbgtVault)
    //////////////////////////////////////////////////////////////*/

    function testUpdateIbgtVault() public {
        // Set up a new mock IBGT vault address
        InfraredVault newIbgtVault = new InfraredVault(
            admin,
            address(ibgt),
            address(infrared),
            address(mockPool),
            address(mockRewardsPrecompile),
            address(mockDistribution),
            rewardTokens,
            1 days
        );

        // Grant GOVERNANCE_ROLE to this contract
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), address(this));

        vm.expectEmit();
        emit Infrared.IBGTVaultUpdated(
            address(this), address(infrared.ibgtVault()), address(newIbgtVault)
        );

        // Update the IBGT vault
        infrared.updateIbgtVault(address(newIbgtVault));

        // Assert that the IBGT vault was updated
        assertEq(
            address(infrared.ibgtVault()),
            address(newIbgtVault),
            "IBGT vault not updated correctly"
        );
    }

    function testFailUpdateIbgtVaultWithZeroAddress() public {
        // Grant GOVERNANCE_ROLE to this contract
        infrared.grantRole(infrared.GOVERNANCE_ROLE(), address(this));

        // Attempt to update the IBGT vault with a zero address
        infrared.updateIbgtVault(address(0));

        // Expect a revert due to zero address
        vm.expectRevert(Errors.ZeroAddress.selector);
    }

    function testFailUpdateIbgtVaultUnauthorized() public {
        // Attempt to update the IBGT vault as an unauthorized user
        InfraredVault newIbgtVault = new InfraredVault(
            admin,
            address(ibgt),
            address(infrared),
            address(mockPool),
            address(mockRewardsPrecompile),
            address(mockDistribution),
            rewardTokens,
            1 days
        );

        // Expect a revert due to unauthorized access
        vm.expectRevert();

        vm.prank(address(2)); // Simulate call from unauthorized address
        infrared.updateIbgtVault(address(newIbgtVault));
    }
}
