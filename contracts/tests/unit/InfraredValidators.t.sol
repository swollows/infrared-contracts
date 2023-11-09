// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Helper} from "./Helper.sol";
import {Errors} from "@utils/Errors.sol";

contract InfraredValidatorsTest is Helper {
    /*//////////////////////////////////////////////////////////////
                      VIEW METHODS
    //////////////////////////////////////////////////////////////*/

    function testInfraredValidators() public {
        address[] memory expected = new address[](2);
        expected[0] = _val0;
        expected[1] = _val1;
        address[] memory actual = _infrared.infraredValidators();
        assertEq(actual.length, expected.length);

        for (uint256 _i; _i < actual.length; _i++) {
            assertEq(actual[_i], expected[_i]);
        }
    }

    function testIsInfraredValidator() public {
        assertTrue(_infrared.isInfraredValidator(_val0));
        assertFalse(_infrared.isInfraredValidator(ALICE));
    }
}
