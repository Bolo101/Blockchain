# Events in Smart Contracts 📣

## Introduction 🌟
Events provide a way for smart contracts to communicate with the outside world by logging information about contract actions. They're essential for frontends, off-chain services, and analytics tools to track and respond to on-chain activities.

## Events in Solidity 💎

### Basic Syntax 📏
In Solidity, events are declared and emitted as follows:
```solidity
// Declaring an event
event Transfer(address indexed from, address indexed to, uint256 value);

// Emitting an event
emit Transfer(msg.sender, recipient, amount);
```

### Example Implementation ⚙️

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    // Event declaration
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    mapping(address => uint256) balances;
    
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        
        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        // Emit the event
        emit Transfer(msg.sender, to, amount);
        
        return true;
    }
}
```

### Indexed Parameters 🔍
In Solidity, up to three parameters can be marked as `indexed`:
```solidity
event UserAction(
    address indexed user,     // Indexed parameter
    uint256 indexed actionId, // Indexed parameter
    string description        // Not indexed
);
```

Indexed parameters:
- Allow efficient filtering of events
- Are stored separately as "topics"
- Cannot be complex types (arrays, structs)

## Events in Vyper 🐍

### Basic Syntax 📏
In Vyper, events are declared and emitted as follows:
```vyper
# Declaring an event
event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256

# Emitting an event
log Transfer(msg.sender, receiver, amount)
```

### Example Implementation ⚙️

```vyper
# @version 0.3.7

# Event declarations
event Transfer:
    sender: indexed(address)
    receiver: indexed(address)
    value: uint256

event Approval:
    owner: indexed(address)
    spender: indexed(address)
    value: uint256

balances: public(HashMap[address, uint256])

@external
def transfer(to: address, amount: uint256) -> bool:
    assert self.balances[msg.sender] >= amount, "Insufficient balance"
    
    self.balances[msg.sender] -= amount
    self.balances[to] += amount
    
    # Emit the event
    log Transfer(msg.sender, to, amount)
    
    return True
```

### Indexed Parameters 🔍
In Vyper, up to three parameters can be marked as `indexed`:
```vyper
event UserAction:
    user: indexed(address)    # Indexed parameter
    action_id: indexed(uint256) # Indexed parameter
    description: String[100]  # Not indexed
```

## Comparison Between Solidity and Vyper Events 📊

| Feature | Solidity | Vyper |
|---------|----------|-------|
| Declaration Syntax | `event EventName(params)` | `event EventName: params` |
| Emission Syntax | `emit EventName(values)` | `log EventName(values)` |
| Indexed Keyword | `indexed` before type | `indexed()` wrapping type |
| Maximum Indexed | 3 parameters | 3 parameters |
| Anonymous Events | Supported via `anonymous` | Supported via `anonymous: True` |
| Event Inheritance | Supported | Supported |

## Using Events in dApps 💻

### Event Subscription in Web3.js
```javascript
// For Solidity or Vyper contracts
myContract.events.Transfer({
    filter: {
        from: userAddress // Filter by indexed parameter
    },
    fromBlock: 0
})
.on('data', event => {
    console.log('Transfer event:', event.returnValues);
})
.on('error', error => {
    console.error('Error:', error);
});
```

### Event Subscription in ethers.js
```javascript
// For Solidity or Vyper contracts
const filter = myContract.filters.Transfer(userAddress, null);
myContract.on(filter, (from, to, value, event) => {
    console.log(`${from} sent ${value} tokens to ${to}`);
});
```

## Best Practices ⭐

1. **Use events for important state changes** - Any significant action should emit an event
2. **Index parameters for filtering** - Parameters that will be used for filtering should be indexed
3. **Choose meaningful event names** - Events should clearly describe the action that occurred
4. **Document events clearly** - Include NatSpec comments explaining the purpose and parameters
5. **Include all relevant information** - Events should contain all data needed to understand the action
6. **Consider gas costs** - Emitting events costs gas, especially for large data

## Common Mistakes to Avoid ⚠️

1. **Forgetting to emit events** - Critical state changes without events can break dApp synchronization
2. **Over-indexing parameters** - Indexing more than necessary increases gas costs
3. **Indexing complex types** - Trying to index arrays or structs (not possible)
4. **Emitting too frequently** - Emitting events in loops can lead to excessive gas costs
5. **Emitting sensitive information** - Remember that events are public and permanently visible

## Gas Considerations ⛽

- Each event emission costs gas (approximately 375 gas base cost plus data costs)
- Indexed parameters cost more gas than non-indexed
- String and bytes data in events can be expensive
- Consider batching events if appropriate for your use case