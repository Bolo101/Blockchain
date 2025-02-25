# View and Pure Functions in Solidity and Vyper 🔍🧪

## Overview 🌐
Smart contract functions can be categorized based on how they interact with blockchain state. Two important modifiers are `view` and `pure`, which help optimize gas usage and clarify function behavior.

## View Functions 👁️
- **Definition**: Functions that read state variables or global variables but do not modify blockchain state
- **Gas Usage**: Free when called externally (no transaction needed) 💰
- **Use Cases**: Retrieving data, performing calculations based on stored values
- **Global Variables Access**: Can access block data (timestamp, number), msg data, etc.

## Pure Functions ✨
- **Definition**: Functions that neither read from nor modify blockchain state
- **Gas Usage**: Free when called externally (no transaction needed) 💰
- **Use Cases**: Performing calculations, validating inputs, utility functions
- **Limitations**: Cannot access:
  - State variables
  - Block information
  - Transaction information
  - Other contract data

## Comparison 📊

| Feature | View | Pure |
|---------|------|------|
| Read State Variables | ✅ | ❌ |
| Read Global Variables (block.timestamp, etc.) | ✅ | ❌ |
| Modify State | ❌ | ❌ |
| Gas Cost (External Call) | Free 🆓 | Free 🆓 |
| Gas Cost (Internal Call) | Low | Lowest |

## Examples in Vyper 🐍

```vyper
# State variable
count: public(uint256)

@external
@pure
def add(x: uint256, y: uint256) -> uint256:
    # Pure function - only uses parameters
    return x + y

@external
@view
def add_to_count(x: uint256) -> uint256:
    # View function - reads state variable and block information
    return x + self.count + block.timestamp
```

## Examples in Solidity 💎

```solidity
// State variable
uint256 public count;

// Pure function - only uses parameters
function add(uint256 x, uint256 y) public pure returns (uint256) {
    return x + y;
}

// View function - reads state variable and block information
function addToCount(uint256 x) public view returns (uint256) {
    return x + count + block.timestamp;
}
```

## Common Mistakes ⚠️

1. **Attempting to modify state in view/pure functions**:
   ```solidity
   // This will cause a compilation error
   function incrementCount(uint256 x) public view returns (uint256) {
       count += x; // Error: cannot modify state
       return count;
   }
   ```

2. **Accessing state variables in pure functions**:
   ```solidity
   // This will cause a compilation error
   function readCount() public pure returns (uint256) {
       return count; // Error: cannot read state
   }
   ```

3. **Forgetting to mark eligible functions as view/pure**:
   - Not using these modifiers when applicable misses gas optimization opportunities
   - Modern compilers will suggest these modifiers when appropriate

## Best Practices 🚀

1. Always mark functions as `view` or `pure` when applicable
2. Use `pure` for utilities and helpers that don't need blockchain state
3. Remember that internal calls to `view`/`pure` functions still cost gas ⛽
4. Clearly separate state-changing logic from read-only operations