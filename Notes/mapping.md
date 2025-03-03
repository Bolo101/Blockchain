# Mappings in Smart Contracts 🗺️

## Introduction 🌟
Mappings are key-value data structures that allow efficient lookups in blockchain smart contracts. They function similarly to hash tables or dictionaries in other programming languages, providing O(1) access time regardless of size.

## Mappings in Vyper 🐍

### Basic Syntax 📏
In Vyper, mappings are declared with the following syntax:
```vyper
# Simple mapping
balances: public(HashMap[address, uint256])

# Nested mapping
allowances: public(HashMap[address, HashMap[address, uint256]])
```

### Example Implementation ⚙️

```vyper
# pragma version 0.4.0

# Simple mapping of address to balance
balances: public(HashMap[address, uint256])

# Mapping of address to a mapping of address to allowance amount
# This is commonly used for token approvals
allowances: public(HashMap[address, HashMap[address, uint256]])

@external
def __init__():
    # Initialize the contract creator with some tokens
    self.balances[msg.sender] = 1000

@external
def transfer(to: address, amount: uint256) -> bool:
    # Check if sender has enough balance
    if self.balances[msg.sender] >= amount:
        self.balances[msg.sender] -= amount
        self.balances[to] += amount
        return True
    return False

@external
def approve(spender: address, amount: uint256) -> bool:
    # Allow spender to withdraw from your account
    self.allowances[msg.sender][spender] = amount
    return True
```

### Key Characteristics in Vyper 🔑
- Vyper uses `HashMap` for mappings
- All mappings are initialized with zero values
- Keys that don't exist return default values (0, empty string, etc.)
- Cannot iterate over mappings or get their size directly
- Cannot delete entire mappings, only individual keys

## Mappings in Solidity 💎

### Basic Syntax 📏
In Solidity, mappings use the following syntax:
```solidity
// Simple mapping
mapping(address => uint256) public balances;

// Nested mapping
mapping(address => mapping(address => uint256)) public allowances;
```

### Example Implementation ⚙️

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MappingExample {
    // Simple mapping of address to balance
    mapping(address => uint256) public balances;
    
    // Mapping of address to a mapping of address to allowance amount
    // This is commonly used for token approvals
    mapping(address => mapping(address => uint256)) public allowances;
    
    constructor() {
        // Initialize the contract creator with some tokens
        balances[msg.sender] = 1000;
    }
    
    function transfer(address to, uint256 amount) public returns (bool) {
        // Check if sender has enough balance
        if (balances[msg.sender] >= amount) {
            balances[msg.sender] -= amount;
            balances[to] += amount;
            return true;
        }
        return false;
    }
    
    function approve(address spender, uint256 amount) public returns (bool) {
        // Allow spender to withdraw from your account
        allowances[msg.sender][spender] = amount;
        return true;
    }
}
```

### Key Characteristics in Solidity 🔑
- Uses `mapping` keyword
- All mappings are initialized with default values
- Cannot iterate over mappings natively
- Cannot get the size or length of a mapping
- Cannot delete entire mappings, only individual entries using `delete`

## Comparison Between Vyper and Solidity Mappings 🔍

| Feature | Vyper | Solidity |
|---------|-------|----------|
| Declaration | `HashMap[key_type, value_type]` | `mapping(key_type => value_type)` |
| Nested Mappings | `HashMap[type1, HashMap[type2, type3]]` | `mapping(type1 => mapping(type2 => type3))` |
| Visibility | Must be explicitly defined | Can be `public`, `private`, or `internal` |
| Auto Getter | Created with `public` | Created with `public` |
| Default Values | Zero values for all types | Zero values for all types |
| Iteration | Not possible directly | Not possible directly |

## Advanced Mapping Patterns 🧩

### Iterable Mappings (Both Languages) 🔄

To make mappings iterable, you need to maintain a separate array of keys:

**Vyper:**
```vyper
# Mapping from address to amount
balances: HashMap[address, uint256]

# Array of addresses for iteration
balance_holders: DynArray[address, 100]

# Keep track of addresses that have balances
@external
def set_balance(user: address, amount: uint256):
    # If this is a new user, add to our array
    if self.balances[user] == 0 and amount > 0:
        self.balance_holders.append(user)
    
    # Set the balance
    self.balances[user] = amount
```

**Solidity:**
```solidity
// Mapping from address to amount
mapping(address => uint256) private balances;

// Array of addresses for iteration
address[] private balanceHolders;

// Keep track of addresses in mapping
function setBalance(address user, uint256 amount) public {
    // If this is a new user, add to our array
    if (balances[user] == 0 && amount > 0) {
        balanceHolders.push(user);
    }
    
    // Set the balance
    balances[user] = amount;
}
```

## Best Practices ⭐

1. **Initialize mappings properly** - All mappings are automatically initialized with default values, but be aware of this behavior
2. **Check existence** - When a key doesn't exist, mappings return default values (0 for uint); add checks if needed
3. **Gas efficiency** - Mappings are gas-efficient for lookups but consider storage costs for writes
4. **Consider using structs** - For complex values, use structs instead of multiple mappings
5. **Avoid iteration needs** - Design contracts to avoid needing to iterate over all mapping keys

## Common Mistakes to Avoid ⚠️

1. Trying to iterate directly over mappings (not possible)
2. Forgetting that non-existent keys return default values (not null/undefined)
3. Not handling default values properly in business logic
4. Creating deeply nested mappings that become hard to manage
5. Not validating inputs before updating mappings

## Security Considerations 🔒

1. **Access control** - Ensure only authorized addresses can modify mapping values
2. **Integer overflow/underflow** - Use safe math operations when updating numeric values
3. **Re-entrancy** - Update mappings before external calls to prevent re-entrancy attacks
4. **Deletion** - Be careful when deleting mapping entries in complex data structures
5. **Default values** - Account for default value behavior in your contract logic