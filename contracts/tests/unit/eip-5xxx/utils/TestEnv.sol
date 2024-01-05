// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.22;

/* Testing Framework */
import "@forge-std/Vm.sol";
import "@forge-std/Test.sol";
import "@forge-std/console2.sol";

/* External */
import "@solmate/utils/FixedPointMathLib.sol";
import "@solmate/utils/SafeTransferLib.sol";
import "@solmate/utils/SafeCastLib.sol";

/* Internal */
import "../mocks/MockPayable.sol";

contract TestEnv is Test {
    address payable alice;
    address payable bob;
    address payable claire;
    address payable doug;
    address payable elmo;

    function setUp() public virtual {
        alice = payable(new MockPayable());
        bob = payable(new MockPayable());
        claire = payable(new MockPayable());
        doug = payable(new MockPayable());
        elmo = payable(new MockPayable());
    }

    receive() external payable {}

    // add custom global behaviour here
}
