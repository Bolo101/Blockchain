# Solidity


## Value type

Value types store their data directly when you assign a value type to another variable, you get a copy of the value.
This happens because value types (like integers, booleans, addresses, etc.) store their actual data directly in the variable. Each variable has its own separate copy of the data.


## Reference type

In Solidity, reference types (arrays, structs, strings, and mappings) are stored as pointers. When you pass these types around, Solidity doesn't copy all the data; it just references where the data is stored.

- storage: Permanent storage on the blockchain (expensive)

Used for state variables.

Data persists between function calls and transactions.

Most expensive in terms of gas costs.

- memory: Temporary storage during function execution (cheaper)

Only exists during function execution.

Cheaper than storage.

Used for function parameters, return values, and local variables.

- calldata: Read-only temporary storage for function parameters (most efficient)

Similar to memory but read-only.

Can't be modified.

Most gas-efficient.

Used primarily for external function parameters.

## Data box

- Be careful with loops in Solidity because each operation costs gas, and loops with too many iterations can exceed block gas limits. This is known as a denial of service (DoS).

- msg.value: The amount of ETH (in wei) sent with the function call. Only available if the function is marked as payable

- Events in Solidity are like announcements that your contract makes when something important happens. Events should be emitted when the contract state is updated

- The _ in the modifier represents where the function code will be executed. For example, if the _ is before the modifier logic, the function will be executed before the modifier logic.

- ABI : The ABI is like a smart contract's instruction manual that tells applications exactly how to talk to your contract on the blockchain.

It describes, using structured data, exactly what functions and data types are available for use in the contract and how to “call” or use them.
## Naming convention

- Contracts: PascalCase (like SimpleToken)

- Functions/variables: camelCase (like balanceOf)

- Private/internal state variables: prefix with _ (like _owner)

## Libraries and Inheritance

- Library : Libraries are reusable pieces of code that you can share across multiple contracts. Think of them as toolboxes containing helpful functions that your contracts can use.

1. Embedded Libraries: Use internal functions that get copied into your contract's code

2. Linked Libraries: Use external and public functions. These functions don't get copied into your contract's bytecode - instead, your contract makes calls to the deployed library

- Inheritance : Inheritance lets one contract build upon another. Think of it like building with blocks—you start with a foundation and add more features.

In Inheritance we can override functions or extend them using **super**

```solidity
contract ExtendedToken is BaseToken {
    function getTokenName() public override pure returns (string memory) {
        // Call the parent function and add to it using the super keyword
        return string.concat(super.getTokenName(), " Plus");
        // Returns "BaseToken Plus"
    }
}
```

When using inheritance parent contracts import order is important. If two contracts contain a function with the same name and child contract uses of super with the function name, then it will use function from first inherited contract

## Introduction to Oracles

Blockchains are deterministic system, meaning that given the same input the system will produce the same output. Due blockchain isolated nature, blockchains cannot directly access off-chain data. Blockchains process transactions with higher latency than traditional computing systems due to their need for global consensus. Blockchains cannot fetch real-world data independently, limiting smart contracts functionalities => Oracle problem

A blockchain oracle is an infrastructure component that enables secure data exchange between blockchains and external systems. Decentralized oracles provide a trust-minimizing mechanism for bringing off-chain data onto the blockchain and allow smart contracts to be executed based on real-world events or off-chain computation.

### Types of Blockchain Oracles
- Inbound Oracles: These oracles bring external data to the blockchain. For example, they deliver information such as weather conditions, sports scores, or stock prices into a smart contract.

- Outbound Oracles: These oracles send data from the blockchain to external systems. They enable smart contracts to communicate and interact with off-chain systems.

- Consensus Oracles: These oracles aggregate data from multiple sources and provide a single source of truth to the smart contract. This is done to improve the reliability and accuracy of the data.

- Cross-Chain Oracles: These oracles facilitate communication and data exchange between different blockchain networks (each of which is like an isolated “island”). Cross-chain oracles are essential for interoperability between different blockchains.

## Chainlink

Chainlink is a decentralized oracle network (DON) that provides smart contracts with off-chain and cross-chain data and computations in a reliable, secure, and decentralized manner.

### Chainlink services

Here's a concise resume of Chainlink's key services:

**Chainlink Services Overview**

Chainlink provides essential infrastructure services that connect blockchains to real-world data and enable advanced smart contract functionality:

**Core Data Services**
- **Price Feeds**: Deliver reliable cryptocurrency, commodity, and forex pricing data to DeFi platforms by aggregating information from multiple exchanges
- **Data Streams**: Provide high-frequency, low-latency market data on-demand for time-sensitive applications like prediction markets

**Automation & Computation**
- **Automation**: Automatically triggers smart contract functions when predefined conditions are met, such as liquidating under-collateralized loans
- **Chainlink Functions**: Executes custom off-chain computations and delivers verified results to smart contracts, handling calculations too expensive for on-chain processing

**Cross-Chain & Security**
- **CCIP (Cross-Chain Interoperability Protocol)**: Enables secure communication and token transfers between different blockchains
- **VRF (Verifiable Random Function)**: Generates provably fair random numbers for applications like NFT trait distribution and fair giveaways
- **Proof of Reserve**: Verifies that tokenized assets like stablecoins are backed by actual reserves

These services collectively solve the "oracle problem" by providing secure, decentralized ways for smart contracts to access external data, automate processes, and interact across different blockchain networks.

#### Chainlink Data Feeds

Chainlink Data Feeds enable smart contracts to access real-world data like asset prices, reserve balances, and Layer 2 sequencer health status.

**Types of Data Available:**
- **Price Feeds**: Aggregated cryptocurrency asset prices
- **SmartData Feeds**: Onchain data for tokenized real-world assets (RWAs)
- **Rate and Volatility Feeds**: Interest rates, rate curves, and asset volatility data
- **L2 Sequencer Uptime Feeds**: Layer 2 sequencer availability status

**Key Components:**
1. **Consumer**: Your smart contract that uses Chainlink services via the AggregatorV3Interface to retrieve data from Data Feeds

2. **Proxy Contract**: Acts as a pointer to the correct aggregator contract, enabling seamless upgrades without disrupting consuming contracts (example: EACAggregatorProxy.sol)

3. **Aggregator Contract**: Chainlink-managed smart contract that receives periodic updates from the decentralized oracle network, stores aggregated data onchain, and makes it publicly accessible and verifiable

The system is designed to provide reliable, transparent access to external data while maintaining upgradeability and uninterrupted service for applications that depend on this information.

Price feeds are a specific type of data feeds. They only relay price data for assets such as cryptocurrencies, commodities and so on.

## Token Shop / Price Feeds

This tutorial walks through building a **TokenShop smart contract** that allows users to purchase custom ERC-20 tokens using ETH, with pricing calculated via Chainlink's ETH/USD price feeds.

### Key Components

**Core Functionality:**
- Users send ETH directly to the contract and automatically receive tokens
- Uses Chainlink Data Feeds to get real-time ETH/USD exchange rates
- Calculates token amounts based on a fixed USD price ($2 per token)
- Mints tokens directly to the buyer's wallet

**Technical Implementation:**
- **Imports**: Chainlink's `AggregatorV3Interface`, OpenZeppelin's `Ownable`, and custom `MyERC20` contract
- **Access Control**: Uses OpenZeppelin's `Ownable` for contract ownership and role-based permissions
- **Price Integration**: Connects to Sepolia's ETH/USD price feed at address `0x694AA1769357215DE4FAC081bf1f309aDC325306`
- **Automatic Processing**: Uses a `receive()` function to handle direct ETH transfers

### Deployment Process

1. **Deploy TokenShop** with your MyERC20 contract address as constructor parameter
2. **Grant Permissions** by giving the TokenShop contract the `MINTER_ROLE` on your ERC-20 token
3. **Verify Setup** using the `hasRole()` function to confirm permissions

### Price Calculation Flow

1. User sends ETH → Contract receives it via `receive()` function
2. `amountToMint()` calls `getChainlinkDataFeedLatestAnswer()` for current ETH/USD price
3. Converts ETH amount to USD value using the price feed (8 decimal precision)
4. Calculates tokens to mint based on $2 USD token price
5. Mints and transfers tokens to buyer

The contract also includes an owner-only `withdraw()` function to extract accumulated ETH. This creates a simple, automated token sale system with real-world price integration.

## Automation

### What is Chainlink Automation?
Chainlink Automation is a decentralized service that automatically executes smart contract functions based on predefined conditions or scheduled intervals, operating continuously without manual intervention.

### The Core Problem
Smart contracts have a fundamental limitation: they cannot trigger their own functions and require external stimuli to execute. Manual monitoring and triggering is inefficient, unreliable, and cannot provide 24/7 coverage.

### The Solution
Chainlink Automation acts as a "vigilant operator" that continuously monitors smart contracts and automatically executes designated functions when specified conditions are met, providing reliable and precise automation that operates around the clock.

### Key Concept: Upkeeps
An "upkeep" is a registered job that tells the Automation network to monitor specific conditions (called "triggers") and execute a particular contract function when those conditions occur.

### Three Types of Automation Triggers

**Time-based triggers** execute functions on a schedule using cron expressions (e.g., daily at midnight or weekly). [Automation APP](https://automation.chain.link/)

**Custom logic triggers** use developer-defined logic through the `AutomationCompatibleInterface`, where contracts implement a `checkUpkeep` function to determine when execution should occur. In our example code with use external interface to ensure automation compatibility. When verifying contrat on Etherscan we need to provide a flattened contract include those external libraries [Hardhat flatten](https://hardhat.org/hardhat-runner/docs/advanced/flattening#flattening-your-contracts). You can also directly flatten contract from RemixIDE

For *checkUpkeep*: insert 0x00 on Etherscan

**Log triggers** monitor blockchain events and execute functions when specified events are emitted by smart contracts, enabling event-driven automation.

Log trigger automation in Chainlink allows smart contracts to automatically execute functions in response to on-chain events. This creates an event-driven automation system where emitted logs serve as triggers for automated contract interactions.

1. **EventEmitter Contract**: Emits a `WantsToCount` event when `emitCountLog()` is called
2. **LogTrigger Contract**: Contains an automated counter that increments when triggered by the event

**Interface Implementation**
The LogTrigger contract must inherit `ILogAutomation` interface, implementing two critical functions:

- **`checkLog()`**: A view function that Chainlink nodes simulate off-chain to determine if automation should execute. It receives log data and returns `performData` containing information needed for execution.

- **`performUpkeep()`**: The actual function executed on-chain by Chainlink Automation. It receives the `performData` from `checkLog()` and performs the desired automation logic.

**Event Detection Process**
```
Event Emission → Chainlink Nodes Detect → checkLog() Simulation → performUpkeep() Execution
```

**Automation Flow**
- EventEmitter emits `WantsToCount` event
- Chainlink nodes detect the specific log/event
- Nodes simulate `checkLog()` to validate automation should occur
- If validation passes, nodes call `performUpkeep()` on-chain
- Counter increments and confirmation event is emitted


### Network Architecture
The system consists of specialized Automation nodes coordinated by the Automation Registry smart contract, which manages upkeep registrations and node compensation. The network operates using Chainlink's OCR3 protocol in a peer-to-peer system where nodes continuously scan for eligible upkeeps, reach consensus, generate cryptographically signed reports, and have those reports validated before execution.

### Key Benefits
The architecture provides cryptographic execution guarantees, built-in redundancy across multiple nodes, resistance to network congestion through sophisticated gas management, and reliable performance during gas price spikes or blockchain reorganizations. Internal monitoring and alerting mechanisms ensure high network reliability and performance.

## CCIP (Chainlink Cross-Chain Interoperability Protocol)

### Overview
CCIP is a cross-chain messaging solution that enables developers to build secure cross-chain applications capable of transferring tokens, sending arbitrary messages (data), or executing programmable token transfers between different blockchains. It implements a defense-in-depth security approach powered by Chainlink's decentralized oracle networks (DONs), which have securely facilitated over $15 trillion in transaction value.

### Core Capabilities

**1. Arbitrary Messaging**
- Send any data to smart contracts on different blockchains
- Encode custom instructions or parameters as needed
- Trigger specific actions on receiving contracts (rebalancing indices, minting NFTs, etc.)
- Bundle multiple instructions within a single message to orchestrate complex multi-chain tasks

**2. Token Transfers**
- Move tokens securely across blockchain networks
- Transfer to smart contracts or directly to user wallets (EOAs)
- Benefit from configurable rate-limiting for enhanced risk management
- Improve token composability with dApps and bridges using CCIP's standardized interface

**3. Programmable Token Transfers**
- Combine token transfers with execution instructions in a single transaction
- Send tokens with specific instructions on how they should be used
- Create cross-chain DeFi interactions (lending, swapping, staking)
- Execute complex financial operations in a unified transaction

### Core Security Features
- Multiple independent nodes run by independent key holders
- Three decentralized oracle networks (DONs) commit, execute, and verify cross-chain transactions
- Separation of responsibilities via distinct Chainlink node operators (nodes not shared between transactional DONs and Risk Management Network)
- Increased decentralization with two separate codebases in different languages for software client diversity
- Novel risk management system with level-5 security that adapts to emergent risks or attacks

### CCIP Architecture Components

**Router**
- Primary user-facing smart contract deployed on each blockchain
- Initiates cross-chain interactions
- Manages token approvals for transfers
- Routes instructions to appropriate destination-specific OnRamp
- Delivers tokens to user accounts or messages to receiver contracts

**Sender**
- EOA (externally owned account) or smart contract that initiates CCIP transaction
- Can send tokens, messages, or both

**Receiver**
- EOA or smart contract that receives the cross-chain transaction
- May differ from sender depending on use case
- Only smart contracts can receive data

### Fee Structure

CCIP uses a single fee on the source chain and handles destination chain execution automatically.

**Total Fee Formula:**
```
fee = blockchain fee + network fee
```

**Blockchain Fee Components:**
```
blockchain fee = execution cost + data availability cost
execution cost = gas price × gas usage × gas multiplier
```

**Gas Usage Calculation:**
```
gas usage = gas limit + destination gas overhead + destination gas per payload + gas for token transfers
```

**Key Fee Notes:**
- Fee token can be blockchain's native token (including wrapped versions) or LINK
- Unspent gas from user-set limit is NOT refunded
- Gas multiplier ensures reliable execution during gas spikes (Smart Execution)
- Data availability cost applies to L2 rollups

### CCIP Transaction Lifecycle

1. **Message Initiation**: Sender initiates CCIP message on source blockchain (can include data, tokens, or both)

2. **Source Chain Finality**: Transaction must achieve finality on source blockchain (varies by blockchain - some have deterministic finality, others require block confirmations)

3. **Committing DON Actions**: DON observes finalized transaction, aggregates multiple transactions into batch, computes Merkle root, records it on CommitStore contract

4. **Risk Management Network Blessing**: RMN reviews committed Merkle root, "blesses" it upon verification to signal authentication

5. **Execution on Destination Chain**: Executing DON initiates transaction execution, delivers message to receiver, handles token minting/unlocking

6. **Smart Execution and Gas Management**: Monitors network conditions, adjusts gas prices, ensures delivery within ~8 hours (manual execution may be required for extreme congestion)

### Token Pool Contracts
- Each token on each chain has its own associated Token Pool contract
- Responsible for managing token supply across source and destination chains
- Controls token transfer regardless of bridging mechanism (mint/burn or lock/unlock)
- Acts as vault for locked tokens or manages custody for bridging

### Blockchain Interoperability Overview

**Token Bridging Mechanisms:**

1. **Lock and Mint**
   - Source: Lock tokens in smart contract
   - Destination: Mint wrapped tokens (1:1 backed representations)
   - Return: Burn wrapped tokens, unlock originals

2. **Burn and Mint**
   - Source: Permanently destroy tokens
   - Destination: Mint equivalent new tokens
   - Ideal for native tokens with minting authority

3. **Lock and Unlock**
   - Source: Lock tokens in smart contract
   - Destination: Release from existing liquidity pool
   - Requires sufficient liquidity and incentivized providers

4. **Burn and Unlock**
   - Source: Permanently burn tokens
   - Destination: Unlock from reserve pool
   - Combines finality with pre-existing liquidity requirements

### Cross-chain Messaging
- Enables complex interactions beyond token transfers
- Functions: State synchronization, function triggering, governance decisions
- Handles message verification, delivery confirmation, and execution

### Security Considerations
Cross-chain systems face unique security challenges requiring tradeoffs between:
- **Security**: Resistance to attacks
- **Trust assumptions**: Reliance on external validators/oracles
- **Configuration flexibility**: Adaptability to different blockchain architectures

Cross-chain applications require more rigorous security design than single-chain systems.

### Importance of Finality
Finality determines when a transaction is irreversible and permanently recorded. Different blockchains have varying finality concepts:
- Some achieve deterministic finality quickly
- Others require multiple block confirmations
- CCIP waits for appropriate finality on source blockchain before proceeding
- Ensures integrity and reliability of the protocol