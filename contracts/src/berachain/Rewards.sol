// SPDX-License-Identifier: MIT
//
// Copyright (C) 2023, Berachain Foundation. All rights reserved.
// Use of this software is govered by the Business Source License included
// in the LICENSE file of this repository and at www.mariadb.com/bsl11.
//
// ANY USE OF THE LICENSED WORK IN VIOLATION OF THIS LICENSE WILL AUTOMATICALLY
// TERMINATE YOUR RIGHTS UNDER THIS LICENSE FOR THE CURRENT AND ALL OTHER
// VERSIONS OF THE LICENSED WORK.
//
// THIS LICENSE DOES NOT GRANT YOU ANY RIGHT IN ANY TRADEMARK OR LOGO OF
// LICENSOR OR ITS AFFILIATES (PROVIDED THAT YOU MAY USE A TRADEMARK OR LOGO OF
// LICENSOR AS EXPRESSLY REQUIRED BY THIS LICENSE).
//
// TO THE EXTENT PERMITTED BY APPLICABLE LAW, THE LICENSED WORK IS PROVIDED ON
// AN “AS IS” BASIS. LICENSOR HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS,
// EXPRESS OR IMPLIED, INCLUDING (WITHOUT LIMITATION) WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, AND
// TITLE.

pragma solidity 0.8.20;

import {Cosmos} from '../polaris/CosmosTypes.sol';

/* solhint-disable */

interface IRewardsModule {
    /**
     * @dev Returns the address of the withdraw address.
     */
    function setDepositorWithdrawAddress(address withdrawAddress) external returns (bool);

    /**
     * @dev Returns the address of the withdraw address.
     */
    function getDepositorWithdrawAddress(address depositor) external view returns (address);

    /**
     * @dev returns the rewards for the given delegator and receiver.
     * @param depositor The delegator address.
     * @param receiver The receiver address.
     * @return rewards rewards.
     */
    function getCurrentRewards(address depositor, address receiver) external view returns (Cosmos.Coin[] memory);

    /**
     * @dev Withdraws the rewards for the given delegator and receiver.
     * @param depositor The delegator address.
     * @param receiver The receiver address.
     * @return rewards rewards.
     */
    function withdrawDepositorRewards(address depositor, address receiver) external returns (Cosmos.Coin[] memory);

    /**
     * @dev Emitted when a deposit is initialized.
     * @param caller The caller address.
     * @param depositor The owner address.
     * @param assets The assets.
     * @param shares The shares.
     */
    event InitializeDeposit(
        address indexed caller,
        address indexed depositor,
        Cosmos.Coin[] assets,
        Cosmos.Coin shares
    );

    /**
     * @dev Emitted when a withdraw is made.
     * @param withdrawer the address that withdrawed the rewards.
     * @param rewardAmount the rewards that were withdrawen.
     */
    event WithdrawDepositRewards(address indexed withdrawer, Cosmos.Coin[] rewardAmount);

    /**
     * @dev Emitted when a withdraw address is set.
     * @param depositor The owner address.
     * @param withdrawAddress The withdraw address.
     */
    event SetDepositorWithdrawAddress(address indexed depositor, address indexed withdrawAddress);
}

/* solhint-enable */
