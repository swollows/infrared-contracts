// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@core/IBGT.sol";
import "@core/InfraredVault.sol";
import "@core/Infrared.sol";

import "forge-std/Test.sol";
import "@mocks/MockERC20.sol";

contract Governance is Test {
    Infrared public infrared;
    address public governance;

    uint256 public totalDelegatedBgt;

    mapping(bytes => uint256) public validatorDelegatedBgt;

    bytes[] public validtors;
    bytes public signature;

    constructor(Infrared _infrared, address _governanced) public {
        infrared = _infrared;
        governance = _governanced;

        validtors.push(abi.encodePacked(address(0x91)));
        validtors.push(abi.encodePacked(address(0x92)));
        validtors.push(abi.encodePacked(address(0x93)));

        DataTypes.Validator[] memory newValidators =
            new DataTypes.Validator[](3);
        newValidators[0] = DataTypes.Validator({
            pubKey: validtors[0],
            coinbase: address(infrared)
        });
        newValidators[1] = DataTypes.Validator({
            pubKey: validtors[1],
            coinbase: address(infrared)
        });
        newValidators[2] = DataTypes.Validator({
            pubKey: validtors[2],
            coinbase: address(infrared)
        });

        vm.startPrank(governance);
        infrared.addValidators(newValidators);
        vm.stopPrank();

        signature = abi.encodePacked("signature");
    }

    function delegateBGT(uint256 amount, uint256 seed) public {
        uint256 bgtBalance =
            ERC20(infrared.ibgt().bgt()).balanceOf(address(infrared));
        amount = bound(amount, 0, bgtBalance - totalDelegatedBgt);

        amount = bound(amount, 0, type(uint64).max);

        if (amount == 0) {
            return;
        }

        bytes memory _pubKey;
        if (seed % 3 == 0) {
            _pubKey = validtors[0];
        } else if (seed % 3 == 1) {
            _pubKey = validtors[1];
        } else {
            _pubKey = validtors[2];
        }

        totalDelegatedBgt += amount;

        vm.startPrank(governance);
        infrared.delegate(_pubKey, uint64(amount), signature);
        vm.stopPrank();
    }

    function redelegate(uint64 amount, uint256 seed) public {
        bytes memory _pubKey;
        bytes memory _pubKey2;
        if (seed % 3 == 0) {
            _pubKey = validtors[0];
            _pubKey2 = validtors[1];
        } else if (seed % 3 == 1) {
            _pubKey = validtors[1];
            _pubKey2 = validtors[2];
        } else {
            _pubKey = validtors[2];
            _pubKey2 = validtors[0];
        }

        amount = uint64(bound(amount, 0, validatorDelegatedBgt[_pubKey]));

        if (amount == 0) {
            return;
        }
        if (validatorDelegatedBgt[_pubKey] == 0) {
            return;
        }

        vm.startPrank(governance);
        infrared.redelegate(_pubKey, _pubKey2, uint64(amount));
        vm.stopPrank();

        validatorDelegatedBgt[_pubKey] -= amount;
        validatorDelegatedBgt[_pubKey2] += amount;

        console.log("Redelegated BGT: ", amount);
    }

    // function undelegateBGT(uint256 amount) public {
    //     vm.assume(totalDelegatedBgt >= amount);
    //     totalDelegatedBgt -= amount;

    //     // infrared.undelegate(validator, amount);
    // }
}
