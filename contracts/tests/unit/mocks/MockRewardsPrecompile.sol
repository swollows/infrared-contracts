// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Cosmos} from "@polaris/CosmosTypes.sol";
import {StdCheats, Test} from "forge-std/Test.sol";
import "./MockERC20BankModule.sol";
import {PureUtils} from "@utils/PureUtils.sol";

contract MockRewardsPrecompile is Test {
    Cosmos.Coin[] private mockRewards;
    mapping(address => address) public withdrawAddresses;
    MockERC20BankModule bank;

    constructor(address _bank) {
        bank = MockERC20BankModule(_bank);
        StdCheats.deal(address(this), type(uint256).max);
    }

    /**
     * @dev Set the mock rewards for testing.
     * @param _mockRewards The array of Cosmos.Coin to return as rewards.
     */
    function setMockRewards(Cosmos.Coin[] memory _mockRewards) public {
        delete mockRewards;
        for (uint256 i = 0; i < _mockRewards.length; i++) {
            mockRewards.push(_mockRewards[i]);
        }
    }

    /**
     * @dev Simulate withdrawing all depositor rewards.
     * @param depositor The depositor address.
     * @return Cosmos.Coin[] memory The mock rewards.
     */
    function withdrawAllDepositorRewards(address depositor)
        external
        returns (Cosmos.Coin[] memory)
    {
        // deal rewards to depositor
        for (uint256 i = 0; i < mockRewards.length; i++) {
            Cosmos.Coin memory reward = mockRewards[i];
            if (PureUtils.isStringSame(reward.denom, "abera")) {
                StdCheats.deal(depositor, reward.amount);
            } else {
                StdCheats.deal(
                    bank.erc20AddressForCoinDenom(reward.denom),
                    depositor,
                    reward.amount,
                    false
                );
            }
        }
        return mockRewards;
    }

    /**
     * @dev Sets the caller's withdraw address.
     *
     */
    function setDepositorWithdrawAddress(address withdrawTO)
        external
        returns (bool)
    {
        withdrawAddresses[msg.sender] = withdrawTO;
        emit LogSetWithdrawAddress(msg.sender, withdrawTO);
        return true;
    }

    event LogSetWithdrawAddress(
        address indexed caller, address indexed withdrawTO
    );

    function getDepositorWithdrawAddress(address depositor)
        external
        view
        returns (address)
    {
        return withdrawAddresses[depositor];
    }
}
