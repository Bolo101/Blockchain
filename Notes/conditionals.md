# Conditionals in Smart Contracts 🔀

## Introduction 🌟
Conditionals allow smart contracts to execute different code paths based on specific conditions. Understanding how conditionals work in both Vyper and Solidity is essential for blockchain developers.

## Conditionals in Vyper 🐍

### Basic Syntax 📏
Vyper follows Python-like syntax with clean indentation:
```vyper
if <condition>:
    # code to execute if condition is true
elif <another_condition>:
    # code to execute if first condition is false but this one is true
else:
    # code to execute if all conditions are false
```

### Example Implementation ⚙️

```vyper
# pragma version 0.4.0

@external
@pure
def if_else(x: uint256) -> uint256:
    if x <= 10:
        return 1
    elif x <= 20:
        return 2
    else:
        return 0
```

### Explanation 📝
- Function takes a single parameter `x` of type `uint256`
- Returns `1` if x is less than or equal to 10
- Returns `2` if x is between 11 and 20 (inclusive)
- Returns `0` for all other values of x

### Advanced Vyper Example 🧩

```vyper
@external
@pure
def get_discount(purchase_amount: uint256, is_member: bool) -> uint256:
    if purchase_amount >= 1000 and is_member:
        return 20  # 20% discount
    elif purchase_amount >= 500 or is_member:
        return 10  # 10% discount
    elif purchase_amount >= 100:
        return 5   # 5% discount
    else:
        return 0   # No discount
```

## Conditionals in Solidity 💎

### Basic Syntax 📏
Solidity uses C-style syntax with curly braces:
```solidity
if (condition) {
    // code to execute if condition is true
} else if (anotherCondition) {
    // code to execute if first condition is false but this one is true
} else {
    // code to execute if all conditions are false
}
```

### Example Implementation ⚙️

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConditionalExample {
    function ifElse(uint256 x) public pure returns (uint256) {
        if (x <= 10) {
            return 1;
        } else if (x <= 20) {
            return 2;
        } else {
            return 0;
        }
    }
}
```

### Advanced Solidity Example 🧩

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RewardSystem {
    function getDiscount(uint256 purchaseAmount, bool isMember) public pure returns (uint256) {
        if (purchaseAmount >= 1000 && isMember) {
            return 20;  // 20% discount
        } else if (purchaseAmount >= 500 || isMember) {
            return 10;  // 10% discount
        } else if (purchaseAmount >= 100) {
            return 5;   // 5% discount
        } else {
            return 0;   // No discount
        }
    }
}
```

## Comparison Between Vyper and Solidity Conditionals 🔍

| Feature | Vyper | Solidity |
|---------|-------|----------|
| Syntax Style | Python-like (indentation-based) | C-like (curly braces) |
| Condition Delimiters | No parentheses required | Requires parentheses `()` |
| Block Delimiters | Indentation and colon `:` | Curly braces `{}` |
| Boolean Operators | `and`, `or`, `not` | `&&`, `\|\|`, `!` |
| Ternary Operator | Not supported | Supported: `condition ? trueValue : falseValue` |

## Best Practices for Both Languages ⭐

1. **Keep conditions simple** - Complex nested conditions can lead to bugs and security vulnerabilities
2. **Watch for integer overflow/underflow** - Both languages offer protection but be careful
3. **Consider gas efficiency** - Order conditions from most to least likely to be true
4. **Use explicit comparisons** - For clarity, especially when dealing with booleans
5. **Avoid deep nesting** - Extract complex logic into separate functions

## Common Mistakes to Avoid ⚠️

1. Using assignment operators instead of comparison operators (`=` vs `==`)
2. Creating overly complex nested conditions
3. Not considering all possible input values
4. In Solidity: forgetting curly braces for single-line statements (can lead to bugs)
5. In Vyper: incorrect indentation leading to unexpected behavior

## Gas Considerations ⛽

Each condition evaluation costs gas. To optimize:
- Order conditions by likelihood (most common cases first)
- Use short-circuit evaluation to your advantage
- Consider using bit operations for complex multi-state logic
- Extract frequently reused condition groups into helper functions