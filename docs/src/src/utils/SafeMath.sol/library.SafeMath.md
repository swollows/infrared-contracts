# SafeMath
[Git Source](https://github.com-infrared/infrared-dao/infrared-mono-repo/blob/1a33f96723b9edc4ba92aebe8d11b7108d5353c3/src/utils/SafeMath.sol)


## Functions
### add

*Returns the addition of two unsigned integers, reverting on
overflow.
Counterpart to Solidity's `+` operator.
Requirements:
- Addition cannot overflow.*


```solidity
function add(uint256 a, uint256 b) internal pure returns (uint256);
```

### sub

*Returns the subtraction of two unsigned integers, reverting on
overflow (when the result is negative).
Counterpart to Solidity's `-` operator.
Requirements:
- Subtraction cannot overflow.*


```solidity
function sub(uint256 a, uint256 b) internal pure returns (uint256);
```

### mul

*Returns the multiplication of two unsigned integers, reverting on
overflow.
Counterpart to Solidity's `*` operator.
Requirements:
- Multiplication cannot overflow.*


```solidity
function mul(uint256 a, uint256 b) internal pure returns (uint256);
```

### div

*Returns the integer division of two unsigned integers. Reverts on
division by zero. The result is rounded towards zero.
Counterpart to Solidity's `/` operator. Note: this function uses a
`revert` opcode (which leaves remaining gas untouched) while Solidity
uses an invalid opcode to revert (consuming all remaining gas).
Requirements:
- The divisor cannot be zero.*


```solidity
function div(uint256 a, uint256 b) internal pure returns (uint256);
```

### mod

*Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
Reverts when dividing by zero.
Counterpart to Solidity's `%` operator. This function uses a `revert`
opcode (which leaves remaining gas untouched) while Solidity uses an
invalid opcode to revert (consuming all remaining gas).
Requirements:
- The divisor cannot be zero.*


```solidity
function mod(uint256 a, uint256 b) internal pure returns (uint256);
```

