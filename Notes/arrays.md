# Arrays in Smart Contracts: Fixed vs Dynamic 📊

## Introduction 🌟
Arrays are fundamental data structures in smart contract development. Understanding the differences between fixed and dynamic arrays in both Vyper and Solidity is crucial for efficient contract design.

## Arrays in Vyper 🐍

### Fixed-Size Arrays 📏
Fixed-size arrays in Vyper have a predetermined length that cannot change after declaration.

```vyper
# Declaration syntax: <type>[<size>]
numbers: uint256[5]  # Fixed array of 5 uint256 elements

@external
def initialize_fixed():
    self.numbers[0] = 10
    self.numbers[1] = 20
    self.numbers[2] = 30
    self.numbers[3] = 40
    self.numbers[4] = 50
    # self.numbers[5] = 60  # Error: Index out of range
```

### Dynamic Arrays 🔄
Vyper supports dynamic arrays with variable lengths, though with some limitations compared to Solidity.

```vyper
# Declaration syntax: DynArray[<type>, <max_size>]
dynamic_numbers: DynArray[uint256, 10]  # Dynamic array with maximum of 10 elements

@external
def work_with_dynamic():
    # Push to array (append)
    self.dynamic_numbers.append(100)
    self.dynamic_numbers.append(200)
    
    # Get length
    length: uint256 = len(self.dynamic_numbers)
    
    # Pop last element
    last_value: uint256 = self.dynamic_numbers.pop()
```

### Important Vyper Array Characteristics ⚠️

1. Arrays in storage must have their type and size defined at compile time
2. DynArray requires a maximum size for gas estimation
3. Array bounds are checked at runtime to prevent overflow
4. Arrays as function parameters must be memory arrays with defined sizes
5. Vyper does not support nested dynamic arrays

## Arrays in Solidity 💎

### Fixed-Size Arrays 📏
Fixed-size arrays in Solidity have a predetermined length that cannot change after declaration.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FixedArrays {
    // Declaration syntax: type[size] visibilityOptional name
    uint256[5] public numbers;
    
    function initializeFixed() public {
        numbers[0] = 10;
        numbers[1] = 20;
        numbers[2] = 30;
        numbers[3] = 40;
        numbers[4] = 50;
        // numbers[5] = 60;  // Error: Index out of range
    }
}
```

### Dynamic Arrays 🔄
Solidity supports truly dynamic arrays without a maximum size constraint.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicArrays {
    // Declaration syntax: type[] visibilityOptional name
    uint256[] public dynamicNumbers;
    
    function workWithDynamic() public {
        // Push to array
        dynamicNumbers.push(100);
        dynamicNumbers.push(200);
        
        // Get length
        uint256 length = dynamicNumbers.length;
        
        // Pop last element
        dynamicNumbers.pop();
        
        // Resize array (Solidity specific)
        // dynamicNumbers.length = 10;  // Only works in Solidity < 0.6.0
    }
}
```

### Memory vs Storage Arrays 💾
Solidity distinguishes between memory and storage arrays:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayLocations {
    uint256[] storageArray;  // Storage array
    
    function memoryArrayExample() public pure returns (uint256[] memory) {
        // Memory arrays need fixed size when created
        uint256[] memory memoryArray = new uint256[](5);
        
        memoryArray[0] = 100;
        memoryArray[1] = 200;
        
        return memoryArray;
    }
}
```

## Comparison: Fixed vs Dynamic Arrays 🔍

| Feature | Fixed Arrays | Dynamic Arrays |
|---------|-------------|---------------|
| Size | Determined at compile time | Can change at runtime |
| Memory Usage | Constant, known at compile time | Variable, can grow |
| Gas Cost | Lower, predictable | Higher, varies with size |
| Usage | When size is known and won't change | When elements need to be added/removed |
| Initialization | All elements initialized to default value | Empty by default |
| Vyper Syntax | `type[size]` | `DynArray[type, max_size]` |
| Solidity Syntax | `type[size]` | `type[]` |

## Comparison: Vyper vs Solidity Arrays 📊

| Feature | Vyper | Solidity |
|---------|-------|----------|
| Dynamic Array Size | Requires max size | Unlimited (only by gas) |
| Bounds Checking | Strict, built-in | Available but less strict |
| Nested Arrays | Limited support | Fully supported |
| Push/Pop | Supported with `.append()` and `.pop()` | Supported with `.push()` and `.pop()` |
| Memory Arrays | Only fixed-size | Both fixed and dynamic |
| Syntax Approach | Python-like | C/JavaScript-like |

## Best Practices ⭐

1. **Use fixed arrays when possible** - Lower gas costs and more predictable behavior
2. **Be mindful of array size limits** - Especially in loops to avoid gas limit errors
3. **Check array bounds** - Even though Vyper does this automatically, defensive programming is good
4. **Consider using mappings instead** - For large or sparse arrays, mappings can be more gas-efficient
5. **Watch out for stack depth limits** - Arrays of arrays can quickly hit limits

## Common Mistakes to Avoid ⚠️

1. Forgetting that storage arrays persist between transactions
2. Not initializing memory arrays in Solidity
3. Assuming out-of-bounds access will revert in Solidity (older versions may not)
4. Creating arrays that are too large for the stack
5. Excessive array copying between storage and memory (high gas cost)

## Gas Considerations ⛽

- Accessing fixed-size arrays is cheaper than dynamic arrays
- Storage arrays are more expensive to operate on than memory arrays
- Pushing to a dynamic array has increasing gas cost as the array grows
- Reading array length is cheap, reading array elements costs more
- Loops over large arrays can hit block gas limits