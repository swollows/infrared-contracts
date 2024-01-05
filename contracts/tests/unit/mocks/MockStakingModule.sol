// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

contract MockStakingModule {
    // Mock state variables to track calls
    mapping(address => uint256) public delegatedAmounts;
    mapping(address => uint256) public undelegatedAmounts;
    mapping(address => uint256) public redelegatedAmounts;
    mapping(address => uint256) public canceledUnbondingAmounts;

    uint256 public test = 123;

    // Mock delegate function
    function delegate(address _validator, uint256 _amt)
        external
        payable
        returns (bool)
    {
        delegatedAmounts[_validator] += _amt;
        return true;
    }

    // Mock undelegate function
    function undelegate(address _validator, uint256 _amt)
        external
        payable
        returns (bool)
    {
        undelegatedAmounts[_validator] += _amt;
        return true;
    }

    // Mock beginRedelegate function
    function beginRedelegate(address _from, address _to, uint256 _amt)
        external
        payable
        returns (bool)
    {
        redelegatedAmounts[_to] += _amt;
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
