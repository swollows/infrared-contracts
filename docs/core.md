# Core Contracts - Infrared Protocol

The `core` folder in the Infrared Protocol provides essential contracts for managing validators, distributing Proof-of-Liquidity (POL) rewards, accumulating bribes, and supporting liquid staking. A primary focus is on the interaction between `InfraredVaults` and Berachain’s reward infrastructure, facilitating BGT (Berachain Governance Token) accumulation and conversion to IBGT. The protocol enables users to participate efficiently in Berachain's [Proof-of-Liquidity inflation](https://docs.berachain.com/learn/what-is-proof-of-liquidity#what-is-proof-of-liquidity).

---

## Concepts

### Validator Management

The `Infrared` contract (`Infrared.sol`) manages the protocol's validator set through functions like `addValidators`, `removeValidators`, and `replaceValidator`. Each validator is associated with a commission rate and can participate in boost rewards through `queueBoosts` and `activateBoosts`. The contract interfaces with Berachain's POL system through the `BribeCollector` to manage reward distribution.

### InfraredVaults and BerachainRewardsVaults Integration

`InfraredVaults` are responsible for staking user assets directly into specific `BerachainRewardsVaults`, integrating seamlessly with Berachain’s Proof-of-Liquidity system. This connection allows users to earn iBGT rewards from staking, while `InfraredVaults` simplify the staking experience by managing these interactions on behalf of users.

- **Reward Accumulation and Centralized Claiming**: While `InfraredVaults` handle the staking process, `Infrared` consolidates BGT reward claims from all vaults. This centralized approach ensures efficient reward management and reduces operational complexity for individual vaults.

- **BGT to IBGT Conversion**: After claiming BGT from Berachain on behalf of the vaults, `Infrared` converts these rewards to IBGT—a liquid, transferable version of BGT.

### Bribe Collection via Auctions

`BribeCollector.sol` implements a mechanism to auction bribes from BerachainRewardsVaults:
- Uses a fixed payout token and amount for each auction
- Collects bribes through `claimFees` function
- Forwards collected bribes to Infrared via `collectBribes`
- Maintains configurable payout parameters through governor-controlled functions

---

## Key Actors

1. **User**: Users deposit assets in `InfraredVaults` to participate in Berachain’s staking and reward system. They earn IBGT rewards based on the vault’s interaction with `BerachainRewardsVaults`.

2. **InfraredVault**: `InfraredVault.sol` extends `MultiRewards` to provide staking functionality with support for multiple reward tokens. Key features:
   - Staking into BerachainRewardsVaults for BGT rewards
   - Managing up to 10 different reward tokens per vault
   - Integration with `Infrared` for centralized reward claiming
   - Built-in pause functionality for emergency scenarios

3. **Validator**: Validators registered in `Infrared` participate in Berachain Governance and execute block proposals that may harvest rewards and bribes.

4. **Keeper**: A trusted actor who manages essential maintenance operations, such as updating validator configurations, distributing rewards, triggering BGT claims, and ensuring seamless interaction with Berachain contracts.

---

## Core Contracts

### 1. `Infrared.sol`

The `Infrared` contract serves as the primary coordination contract in the protocol, overseeing validator registration, handling BGT claims, and converting rewards to IBGT. It also facilitates the flow of reward tokens to stakeholders.

- **Validator Registration and Cutting Board Configuration**: `Infrared` registers validators and configures their cutting boards, specifying which `BerachainRewardsVaults` will be rewarded with BGT once they propose blocks. This enables validators to harvest bribe rewards on these vaults, which flow back to the `Infrared` contract.

- **Centralized BGT Claiming and Conversion to IBGT**: `Infrared` consolidates reward claims from all `InfraredVaults`, collecting BGT from staking activities on Berachain. Once accumulated, BGT is converted to IBGT to offer a liquid form of governance tokens. This process enables efficient reward distribution and enhances governance participation.

- **Fee and Reward Distribution**: After collecting rewards, `Infrared` distributes them to vault participants and validators according to the protocol’s rules. A portion of these rewards is allocated to protocol fees, supporting Infrared’s operational needs.

- **harvestBase**: This function is responsible for harvesting base rewards, which include the accumulated base rewards and commission rewards, both denominated in BGT. These rewards are split between two main entities:
    - **wiBERA Vault**: A portion of the base rewards is directed to the wiBERA vault.
    - **Validator Distributor**: The remaining base rewards are directed toward the operator reward distributor
  - **Fee Structure**: A total fee and a protocol-specific fee are applied to the rewards, supporting protocol operations.

- **harvestBoostRewards**: This function collects **boost rewards** associated with validator boosting and distributes them to IBGT holders. These rewards incentivize users participating in staking their iBGT tokens.
  - **Fee Structure**: Similar to `harvestBase`, fees are applied to the rewards, which are allocated based on protocol-defined parameters.

### 2. `InfraredVault`

Each `InfraredVault` is responsible for staking assets on behalf of users into specific `BerachainRewardsVaults`, accumulating rewards, and facilitating centralized BGT claims through `Infrared`.

- **Staking in BerachainRewardsVaults**: `InfraredVaults` stake assets in designated `BerachainRewardsVaults` to earn BGT as part of Berachain’s Proof-of-Liquidity system.
  
- **Reward Accumulation**: By managing interactions with Berachain on behalf of users, `InfraredVaults` simplify staking, enabling efficient reward accumulation. Each vault defers BGT claiming to `Infrared`, which manages reward claims for all vaults in the protocol.

### 3. `BribeCollector`

`BribeCollector.sol` implements a mechanism to auction bribes from BerachainRewardsVaults:
- Uses a fixed payout token and amount for each auction
- Collects bribes through `claimFees` function
- Forwards collected bribes to Infrared via `collectBribes`
- Maintains configurable payout parameters through governor-controlled functions

### 4. `MultiRewards`

The `MultiRewards` contract enables each vault to offer multiple reward tokens, providing a flexible reward distribution mechanism.

- **Diverse Reward Support**: By managing up to 10 reward tokens, `MultiRewards` offers vault participants varied incentives across the protocol.

---

## Flow of Funds in Infrared

The `Infrared` contract manages various fund flows within the protocol, particularly through interactions with `InfraredVaults`, `BribeCollector`, and Berachain. Here is an overview of the primary fund flows:

1. **User Deposits and Staking**:
   - Users deposit assets into `InfraredVaults`, which stake these assets in designated `BerachainRewardsVaults`. This staking process triggers reward accumulation in the form of BGT, which flows back to `Infrared` via centralized claiming.

2. **BGT Accumulation and Conversion to IBGT**:
   - BGT rewards accumulate in `InfraredVaults` through their interaction with BerachainRewardsVaults. Rather than each vault claiming rewards independently, `Infrared` aggregates BGT claims from all vaults, simplifying the reward process.
   - Once BGT is claimed, `Infrared` converts it to IBGT, which is then distributed to vault participants as liquid governance tokens. This approach ensures users can access governance without BGT’s transfer restrictions.

3. **Base Rewards and Boost Rewards Distribution**:
   - **Base Rewards**: Through `harvestBase`, BGT rewards from base and commission allocations are split between the wiBERA vault and the validator distributor. This flow incentivizes validator participation while rewarding the wiBERA vault.
   - **Boost Rewards**: Through `harvestBoostRewards`, additional BGT rewards earned from boosting validators are directed to the IBGT vault. This structure supports IBGT holders and incentivizes liquid staking in the protocol.

4. **POL Bribe Collection and Auction**:
   - `BribeCollector` gathers protocol-owned liquidity (POL) bribes from BerachainRewardsVaults specified in each validator’s cutting board. These bribes are held and auctioned by `BribeCollector`, generating additional funds.
   - Proceeds from these auctions are allocated to validators, protocol stakeholders, and potentially reserved for operational costs, enhancing the reward distribution model.

5. **Fee and Reward Allocation**:
   - After reward collection, `Infrared` allocates a portion of the rewards as protocol fees to support operational expenses. The remaining rewards are distributed to vault participants and validators based on their contributions and validator configuration.

---

## Contract Dependencies

The core contracts have the following dependency structure:
- `Infrared.sol`: Central contract that coordinates with all other core contracts
- `InfraredVault.sol`: Depends on MultiRewards and interfaces with BerachainRewardsVault
- `BribeCollector.sol`: Interacts with Infrared for bribe distribution
- `MultiRewards.sol`: Base contract for reward distribution logic

---

## Access Control

The contracts implement role-based access control:
- `KEEPER_ROLE`: Manages operational tasks like harvesting rewards and updating validator configurations
- `GOVERNANCE_ROLE`: Controls protocol parameters and critical functions
- Function-specific access control for vault operations and reward distributions
