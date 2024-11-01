// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@solmate/tokens/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory name_, string memory symbol_, uint8 decimals_)
        ERC20(name_, symbol_, decimals_)
    {}

    // Function to mint tokens - this is especially useful for testing
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    // Optional: You can also add a burn function for testing purposes
    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
}
