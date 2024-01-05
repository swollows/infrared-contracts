// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Test.sol";

contract MockERC20BankModule {
    mapping(string => address) private mockErc20Addresses;

    /**
     * @dev Set the mock ERC20 address for a given coin denomination.
     * @param denom The coin denomination.
     * @param erc20Address The mock ERC20 address to associate with the denomination.
     */
    function setErc20AddressForCoinDenom(
        string memory denom,
        address erc20Address
    ) public {
        mockErc20Addresses[denom] = erc20Address;
    }

    /**
     * @dev Get the ERC20 address associated with a coin denomination.
     * @param denom The coin denomination.
     * @return The mock ERC20 address associated with the denomination.
     */
    function erc20AddressForCoinDenom(string memory denom)
        external
        view
        returns (address)
    {
        return mockErc20Addresses[denom];
    }

    /**
     * @dev Simulate the transfer of coins to ERC20 tokens. This is a mock operation.
     * @param denom The coin denomination.
     * @param amount The amount of coins to transfer.
     * @return success A boolean indicating success or failure of the operation.
     */
    function transferCoinToERC20(string memory denom, uint256 amount)
        external
        returns (bool success)
    {
        // In a real implementation, you would transfer the coins and mint ERC20 tokens.
        // For this mock, we simply return true to simulate a successful operation.
        // You could add logic here to simulate failures for testing error handling.
        return true;
    }
}
