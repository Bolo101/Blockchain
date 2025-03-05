# Storage Variables, Constants, and Immutable Variables 💾

## Introduction 🌟
Smart contract languages provide different ways to store and manage data. Understanding the nuances between storage variables, constants, and immutable variables is crucial for efficient and secure smart contract development.

## Storage Variables 🗄️

### Vyper Storage Variables 🐍

```vyper
# Basic storage variable
counter: uint256

# Initialized storage variable
total_supply: uint256 = 1000000

# Mapped storage variable
balances: HashMap[address, uint256]

# Storage variable with visibility
public_value: public(uint256)
```

### Solidity Storage Variables 💎

```solidity
// Basic storage variable
uint256 counter;

// Initialized storage variable
uint256 totalSupply = 1000000;

// Mapped storage variable
mapping(address => uint256) balances;

// Storage variable with visibility
uint256 public publicValue;
```

## Characteristics of Storage Variables 📊

| Feature | Vyper | Solidity |
|---------|-------|----------|
| Declared at Contract Level | ✅ | ✅ |
| Stored Permanently on Blockchain | ✅ | ✅ |
| Modifiable During Contract Execution | ✅ | ✅ |
| Gas Cost for Storage | High | High |

## Constants 🔒

### Vyper Constants 🐍

```vyper
# Compile-time constants
MAX_SUPPLY: constant(uint256) = 1000000
OWNER: constant(address) = 0x1234567890123456789012345678901234567890

# Using constants
@external
def check_supply(amount: uint256) -> bool:
    return amount <= MAX_SUPPLY
```

### Solidity Constants 💎

```solidity
// Compile-time constants
uint256 constant MAX_SUPPLY = 1000000;
address constant OWNER = 0x1234567890123456789012345678901234567890;

// Using constants
function checkSupply(uint256 amount) external pure returns (bool) {
    return amount <= MAX_SUPPLY;
}
```

## Immutable Variables 🔐

### Vyper Immutable Variables 🐍

```vyper
# Immutable variables (set in constructor)
owner: immutable(address)

@external
def __init__(_owner: address):
    self.owner = _owner

@external
def get_owner() -> address:
    return owner
```

### Solidity Immutable Variables 💎

```solidity
// Immutable variables (set in constructor)
address public immutable owner;

constructor(address _owner) {
    owner = _owner;
}
```

## Comparison of Storage Mechanisms 🔍

| Characteristic | Storage Variables | Constants | Immutable Variables |
|---------------|-------------------|-----------|---------------------|
| Modifiable After Deployment | ✅ | ❌ | ❌ |
| Stored on Blockchain | ✅ | ❌ | ✅ |
| Compile-Time Value | ❌ | ✅ | ❌ |
| Set in Constructor | ❌ | ❌ | ✅ |
| Gas Cost | High | Lowest | Medium |

## Best Practices 🏆

1. **Use Constants for Fixed Values** 
   - Reduce gas costs for truly unchanging values
   - Improve code readability
   - Prevent accidental modifications

2. **Leverage Immutable Variables for Constructor-Set Values**
   - More gas-efficient than storage variables
   - Secure one-time initialization
   - Clear intent of single-set variables

3. **Minimize Storage Variable Usage**
   - Each storage read/write is expensive
   - Use memory or calldata for temporary computations
   - Optimize storage layout

## Common Mistakes to Avoid ⚠️

1. Overusing storage variables
2. Forgetting gas implications of storage operations
3. Incorrectly using constants vs. immutable variables
4. Not understanding the subtle differences between languages

## Gas Optimization Tips ⛽

- Constants are replaced at compile-time, costing virtually no gas
- Immutable variables are more gas-efficient than storage variables
- Group storage variables to reduce storage slots
- Use `view` and `pure` functions to read values cheaply

## Advanced Example: Token Contract 🚀

```vyper
# Vyper Token Example
owner: immutable(address)
total_supply: constant(uint256) = 1000000
balances: HashMap[address, uint256]

@external
def __init__(_owner: address):
    owner = _owner
```

```solidity
// Solidity Equivalent
contract Token {
    address public immutable owner;
    uint256 public constant TOTAL_SUPPLY = 1000000;
    mapping(address => uint256) balances;

    constructor(address _owner) {
        owner = _owner;
    }
}
```

## Key Takeaways 💡
- Choose the right variable type based on your specific use case
- Always consider gas efficiency
- Understand the nuanced differences between Vyper and Solidity
- Prioritize code clarity and security