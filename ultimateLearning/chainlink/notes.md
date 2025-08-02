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

## Token Shop

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
