# Scoping and Declarations in Smart Contracts 🔍

## Introduction 🌟
Understanding variable scope and declaration patterns is crucial for writing secure and efficient smart contracts. This guide explores how scoping and declarations work in both Vyper and Solidity.

## Variable Declarations 📝

### Vyper Declarations 🐍

In Vyper, variables must be declared with their type explicitly specified:

```vyper
# State variables (contract level)
balance: public(uint256)
owner: public(address)

# Constant variables
DECIMALS: constant(uint256) = 18
TOKEN_NAME: constant(String[20]) = "MyToken"

# Immutable variables (set once during deployment)
token_supply: immutable(uint256)

@external
def __init__(_token_supply: uint256):
    # Initialize immutable variables in constructor
    token_supply = _token_supply
    
@external
def example_function(input_value: uint256) -> uint256:
    # Local variable declaration
    local_value: uint256 = input_value * 2
    
    # Cannot reassign constant or immutable variables
    # DECIMALS = 19  # This would cause an error
    
    return local_value
```

### Solidity Declarations 💎

In Solidity, variables are declared with the type followed by the variable name:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScopeExample {
    // State variables (contract level)
    uint256 public balance;
    address public owner;
    
    // Constant variables
    uint256 constant DECIMALS = 18;
    string constant TOKEN_NAME = "MyToken";
    
    // Immutable variables (set once during deployment)
    uint256 immutable tokenSupply;
    
    constructor(uint256 _tokenSupply) {
        // Initialize immutable variables in constructor
        tokenSupply = _tokenSupply;
    }
    
    function exampleFunction(uint256 inputValue) public pure returns (uint256) {
        // Local variable declaration
        uint256 localValue = inputValue * 2;
        
        // Cannot reassign constant or immutable variables
        // DECIMALS = 19;  // This would cause an error
        
        return localValue;
    }
}
```

## Variable Scope Rules 🔭

### Vyper Scoping 🐍

Vyper has simpler scoping rules than Solidity:

```vyper
# State variables accessible throughout the contract
counter: public(uint256)

@external
def increment_counter() -> uint256:
    # Local scope begins
    local_var: uint256 = 100
    self.counter += local_var
    # Local scope ends when function ends
    return self.counter

@external
def another_function() -> uint256:
    # Cannot access local_var from increment_counter
    # But can access state variables
    return self.counter
```

### Solidity Scoping 💎

Solidity has block-level scoping with curly braces:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScopeRules {
    // State variables accessible throughout the contract
    uint256 public counter;
    
    function incrementCounter() public returns (uint256) {
        // Function scope begins
        uint256 localVar = 100;
        
        // Block scope begins
        if (localVar > 50) {
            uint256 blockVar = 200;
            counter += blockVar;
        }
        // blockVar is not accessible here
        
        counter += localVar;
        // Function scope ends
        return counter;
    }
    
    function anotherFunction() public view returns (uint256) {
        // Cannot access localVar from incrementCounter
        // But can access state variables
        return counter;
    }
}
```

## Constants vs Immutables 🔒

### Constants 📌

Constants are values fixed at compile-time and cannot be changed:

#### Vyper Constants
```vyper
# Constants must be initialized at declaration
MAX_SUPPLY: constant(uint256) = 1000000
TOKEN_SYMBOL: constant(String[5]) = "TOKEN"

@external
def get_max_supply() -> uint256:
    return MAX_SUPPLY  # Gas efficient, replaced with literal value at compile time
```

#### Solidity Constants
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConstantExample {
    // Constants must be initialized at declaration
    uint256 constant MAX_SUPPLY = 1000000;
    string constant TOKEN_SYMBOL = "TOKEN";
    
    function getMaxSupply() external pure returns (uint256) {
        return MAX_SUPPLY;  // Gas efficient, replaced with literal value at compile time
    }
}
```

### Immutables 🧱

Immutables are set once during contract deployment and cannot be changed afterward:

#### Vyper Immutables
```vyper
# Declare immutable variables
token_name: immutable(String[20])
admin_address: immutable(address)
initial_supply: immutable(uint256)

@external
def __init__(_name: String[20], _admin: address, _supply: uint256):
    # Set immutable variables during contract initialization
    token_name = _name
    admin_address = _admin
    initial_supply = _supply
    
@external
@view
def get_token_info() -> (String[20], address, uint256):
    # Immutables are gas efficient for reading
    return token_name, admin_address, initial_supply
```

#### Solidity Immutables
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImmutableExample {
    // Declare immutable variables
    string immutable tokenName;
    address immutable adminAddress;
    uint256 immutable initialSupply;
    
    // Immutables must be set in the constructor
    constructor(string memory _name, address _admin, uint256 _supply) {
        tokenName = _name;
        adminAddress = _admin;
        initialSupply = _supply;
    }
    
    function getTokenInfo() external view returns (string memory, address, uint256) {
        // Immutables are gas efficient for reading
        return (tokenName, adminAddress, initialSupply);
    }
}
```

### Differences Between Constants and Immutables ⚖️

| Feature | Constants | Immutables |
|---------|-----------|------------|
| Value Set | Compile-time | Contract deployment |
| Gas Cost | Lowest (replaced with literal) | Low (more efficient than state variables) |
| Dynamic Values | Cannot use dynamic values | Can use constructor parameters |
| Storage | Not stored in contract storage | Not stored in contract storage after deployment |
| Examples | Mathematical constants, fixed rates | Token addresses, configuration from deployment |

## Shadowing Variables ⚠️

### Vyper Shadowing 🐍

Vyper prevents variable shadowing to avoid confusion and bugs:

```vyper
total: uint256

@external
def calculate(total: uint256) -> uint256:
    # This would cause a compiler error in Vyper
    # Cannot shadow state variable "total" with a function parameter
    return total * 2
```

### Solidity Shadowing 💎

Solidity allows shadowing but it's considered a bad practice:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShadowingExample {
    uint256 total;
    
    function calculate(uint256 total) public pure returns (uint256) {
        // This compiles but is bad practice!
        // Parameter "total" shadows state variable "total"
        return total * 2;
    }
}
```

## Variable Visibility 👁️

### Vyper Visibility 🐍

```vyper
# Public state variable (generates getter)
balance: public(uint256)

# Private state variable (only accessible within contract)
_secret: uint256

@external
def set_secret(value: uint256):
    self._secret = value

@external
@view
def get_secret() -> uint256:
    return self._secret
```

### Solidity Visibility 💎

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VisibilityExample {
    // Public state variable (generates getter)
    uint256 public balance;
    
    // Private state variable (only accessible within contract)
    uint256 private _secret;
    
    // Internal state variable (accessible in this contract and derived contracts)
    uint256 internal _configValue;
    
    function setSecret(uint256 value) external {
        _secret = value;
    }
    
    function getSecret() external view returns (uint256) {
        return _secret;
    }
}
```

## Declaration Best Practices ⭐

1. **Name conventions** 📋
   - Constants: ALL_CAPS_WITH_UNDERSCORES
   - Private/internal variables: _camelCase with leading underscore
   - Public variables: camelCase
   - Parameters: _camelCase with leading underscore (common in Vyper)

2. **Type explicitness** 📌
   - Always specify types explicitly
   - Use the most restrictive type possible (uint8, uint16, etc.)
   - Be careful with type conversions

3. **Variable initialization** 🔄
   - Initialize variables when possible
   - Consider default values (0 for uint, false for bool, etc.)

4. **Gas considerations** ⛽
   - Declare variables at the narrowest possible scope
   - Reuse variables when possible to save gas
   - Consider using memory vs storage for complex data types
   - Use constants for fixed values (lowest gas cost)
   - Use immutables for values set at deployment (lower gas than state variables)

## Common Mistakes to Avoid 🚫

1. Shadowing variables between different scopes
2. Forgetting that memory arrays are fixed-size in Solidity
3. Not initializing variables explicitly
4. Using overly broad scopes for variables
5. Not considering storage vs memory for complex types
6. Accessing variables outside their scope
7. Using too many state variables (expensive for gas)
8. Using state variables when constants or immutables would be more appropriate
9. Trying to modify immutable variables after contract deployment