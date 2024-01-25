// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {Cosmos} from "@polaris/CosmosTypes.sol";
import "./MockERC20BankModule.sol";
import {StdCheats, Test} from "forge-std/Test.sol";
import {PureUtils} from "@utils/PureUtils.sol";
import {MockERC20} from "./MockERC20.sol";

contract MockDistributionPrecompile is Test {
    Cosmos.Coin[] private mockRewards;
    MockERC20BankModule bank;

    constructor(address _bank) {
        bank = MockERC20BankModule(_bank);
    }

    /**
     * @dev The caller (msg.sender) can set the address that will receive the
     * deligation rewards.
     * @param withdrawAddress The address to set as the withdraw address.
     */
    function setWithdrawAddress(address withdrawAddress)
        external
        returns (bool)
    {
        emit LogSetWithdrawAddress(msg.sender, withdrawAddress);
        return true;
    }

    event LogSetWithdrawAddress(
        address indexed caller, address indexed withdrawAddress
    );

    /**
     * @dev Withdraw the rewards accumulated by the caller (msg.sender).
     * Returns the mock rewards set by `setMockRewards`.
     * @param delegator The delegator to withdraw the rewards from.
     * @param validator The validator to withdraw the rewards from.
     * @return Cosmos.Coin[] memory The mock rewards.
     */
    function withdrawDelegatorReward(address delegator, address validator)
        external
        returns (Cosmos.Coin[] memory)
    {
        for (uint256 i = 0; i < mockRewards.length; i++) {
            Cosmos.Coin memory reward = mockRewards[i];

            if (PureUtils.isStringSame(reward.denom, "abera")) {
                StdCheats.deal(
                    msg.sender, address(msg.sender).balance + reward.amount
                );
            } else {
                address erc20Address =
                    bank.erc20AddressForCoinDenom(reward.denom);
                StdCheats.deal(
                    erc20Address,
                    msg.sender,
                    MockERC20(erc20Address).balanceOf(msg.sender)
                        + reward.amount,
                    false
                );
            }
        }
        return mockRewards;
    }

    /**
     * @dev Set the mock rewards for testing.
     * @param _mockRewards The array of Cosmos.Coin to return as rewards.
     */
    function setMockRewards(Cosmos.Coin[] memory _mockRewards) external {
        delete mockRewards;
        for (uint256 i = 0; i < _mockRewards.length; i++) {
            mockRewards.push(_mockRewards[i]);
        }
    }
}
