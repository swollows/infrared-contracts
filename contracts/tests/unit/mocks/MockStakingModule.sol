// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {MockERC20} from "./MockERC20.sol";

contract MockStakingModule {
    // Mock state variables to track calls
    mapping(address validators => mapping(address users => uint256 amounts))
        public delegatedAmounts;
    mapping(address => uint256) public undelegatedAmounts;
    mapping(address => uint256) public redelegatedAmounts;
    mapping(address => uint256) public canceledUnbondingAmounts;

    uint256 public test = 123;
    MockERC20 public BGT;

    constructor(address _bgt) {
        BGT = MockERC20(_bgt);
    }

    // Mock delegate function
    function delegate(address _validator, uint256 _amt)
        external
        payable
        returns (bool)
    {
        if (BGT.balanceOf(msg.sender) < _amt) {
            revert InsufficientBalance();
        }
        delegatedAmounts[_validator][msg.sender] += _amt;
        return true;
    }

    error InsufficientBalance();

    function getDelegatedAmount(address _validator, address _user)
        external
        view
        returns (uint256)
    {
        return delegatedAmounts[_validator][_user];
    }

    // Mock undelegate function
    function undelegate(address _validator, uint256 _amt)
        external
        payable
        returns (bool)
    {
        if (delegatedAmounts[_validator][msg.sender] < _amt) {
            revert InsufficientBalance();
        }
        delegatedAmounts[_validator][msg.sender] -= _amt;
        return true;
    }

    // Mock beginRedelegate function
    function beginRedelegate(address _from, address _to, uint256 _amt)
        external
        payable
        returns (bool)
    {
        if (delegatedAmounts[_from][msg.sender] < _amt) {
            revert InsufficientBalance();
        }
        delegatedAmounts[_from][msg.sender] -= _amt;
        undelegatedAmounts[_from] += _amt;
        redelegatedAmounts[_to] += _amt;
        delegatedAmounts[_to][msg.sender] += _amt;
        return true;
    }

    // Mock cancelUnbondingDelegation function
    function cancelUnbondingDelegation(
        address _validator,
        uint256 _amt,
        int64 _creationHeight
    ) external payable returns (bool) {
        canceledUnbondingAmounts[_validator] += _amt;
        return true;
    }
}
