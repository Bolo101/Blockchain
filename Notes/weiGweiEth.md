# Ethereum Units: Wei, Gwei, and Ether 💰

## Introduction 🌟
Ethereum's native cryptocurrency (ETH) can be represented in different denominations. Understanding these units is essential for blockchain developers working with transactions, gas fees, and smart contracts.

## Unit Hierarchy 📊

| Unit | Wei Value | Ether Value |
|------|-----------|-------------|
| Wei | 1 | 0.000000000000000001 ETH |
| Kwei | 1,000 | 0.000000000000001 ETH |
| Mwei | 1,000,000 | 0.000000000001 ETH |
| Gwei | 1,000,000,000 | 0.000000001 ETH |
| Szabo | 1,000,000,000,000 | 0.000001 ETH |
| Finney | 1,000,000,000,000,000 | 0.001 ETH |
| Ether | 1,000,000,000,000,000,000 | 1 ETH |

## Primary Units 🔑

### Wei ⚛️
- The smallest unit of Ether
- Named after Wei Dai, a computer scientist and cryptographer
- Base unit for all calculations in Ethereum
- 1 Ether = 10^18 Wei (1,000,000,000,000,000,000 Wei)

### Gwei (Gigawei) ⛽
- Commonly used for representing gas prices
- 1 Gwei = 10^9 Wei (1,000,000,000 Wei)
- 1 Ether = 10^9 Gwei (1,000,000,000 Gwei)
- Also known as "Shannon" (named after Claude Shannon)

### Ether (ETH) 💎
- The primary unit of currency in Ethereum
- 1 Ether = 10^18 Wei
- The unit typically used in exchanges and wallet balances

## Implementation in Vyper 🐍

```vyper
# pragma version 0.4.0

@external
@pure
def wei_to_gwei(wei_amount: uint256) -> uint256:
    return wei_amount / 1000000000  # Divide by 10^9

@external
@pure
def gwei_to_wei(gwei_amount: uint256) -> uint256:
    return gwei_amount * 1000000000  # Multiply by 10^9

@external
@pure
def wei_to_ether(wei_amount: uint256) -> uint256:
    return wei_amount / 1000000000000000000  # Divide by 10^18

@external
@pure
def ether_to_wei(ether_amount: uint256) -> uint256:
    return ether_amount * 1000000000000000000  # Multiply by 10^18
```

## Implementation in Solidity 💎

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EthereumUnits {
    // Convert Wei to Gwei
    function weiToGwei(uint256 weiAmount) public pure returns (uint256) {
        return weiAmount / 1e9;  // Divide by 10^9
    }
    
    // Convert Gwei to Wei
    function gweiToWei(uint256 gweiAmount) public pure returns (uint256) {
        return gweiAmount * 1e9;  // Multiply by 10^9
    }
    
    // Convert Wei to Ether
    function weiToEther(uint256 weiAmount) public pure returns (uint256) {
        return weiAmount / 1e18;  // Divide by 10^18
    }
    
    // Convert Ether to Wei
    function etherToWei(uint256 etherAmount) public pure returns (uint256) {
        return etherAmount * 1e18;  // Multiply by 10^18
    }
}
```

## Units in Smart Contract Development 🛠️

### Solidity Built-in Units 🔧

Solidity provides built-in support for Ether units:

```solidity
// All of these represent the same value: 1 Ether
uint256 value1 = 1 ether;
uint256 value2 = 1000000000 gwei;
uint256 value3 = 1000000000000000000 wei;

// Gas price in Gwei
uint256 gasPrice = 50 gwei;
```

### Vyper Built-in Units 🐍

Vyper also supports Ether denominations:

```vyper
# All of these represent the same value: 1 Ether
value1: uint256 = 1 * 10**18  # 1 ether in wei
value2: uint256 = 1_000_000_000 * 10**9  # 1000000000 gwei
value3: uint256 = 1_000_000_000_000_000_000  # 1e18 wei

# Gas price in Gwei
gas_price: uint256 = 50 * 10**9  # 50 gwei in wei
```

## Common Use Cases 🔄

### Gas Fees ⛽
- Gas prices are typically specified in Gwei
- Total gas fee = Gas units × Gas price (in Gwei)
- Example: 21,000 gas units × 20 Gwei = 420,000 Gwei = 0.00042 ETH

### Smart Contract Values 📝
- State variables storing ETH amounts use Wei
- All monetary values in the EVM are handled in Wei
- Storing values in Wei prevents precision loss from decimal points

### User Interface Considerations 👨‍💻
- UIs typically display values in ETH
- Conversion to Wei happens when submitting transactions
- Applications must convert between units based on context

## Best Practices ⭐

1. **Always calculate in Wei** - Perform all calculations using Wei to avoid precision issues
2. **Use libraries for conversion** - Leverage existing libraries for safe conversions
3. **Be mindful of overflow** - Wei values can be very large and may cause overflow
4. **Use descriptive variable names** - Include the unit in variable names (e.g., `priceInWei`)
5. **Document expected units** - Clearly state expected units in function documentation

## Common Mistakes to Avoid ⚠️

1. **Mixing units** - Performing calculations with mixed units (e.g., adding Wei to Gwei)
2. **Incorrect conversion factors** - Using the wrong power of 10 for conversions
3. **Precision loss** - Dividing before multiplying can lead to unnecessary precision loss
4. **Overflow/underflow** - Not accounting for the size of Wei values
5. **Assuming fixed gas prices** - Hardcoding gas values without considering market fluctuations