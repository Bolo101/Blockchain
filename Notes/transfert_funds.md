# Value Transfer Methods in Smart Contracts 💸

## Introduction 🌟
Transferring Ether between contracts and addresses is fundamental to blockchain applications. Both Solidity and Vyper offer several methods for transferring value, each with different characteristics, gas costs, and security implications.

## Value Transfer in Solidity 💎

### 1. `transfer()` Method 📤
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransferExample {
    function transferEther(address payable recipient) public payable {
        recipient.transfer(msg.value);
    }
}
```

**Parameters Explained:**
- `address payable recipient`: The receiving address that must be payable (able to receive Ether)
- `msg.value`: The amount of Ether sent with the transaction (in Wei)

### 2. `send()` Method 📨
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendExample {
    function sendEther(address payable recipient) public payable returns (bool) {
        bool success = recipient.send(msg.value);
        require(success, "Send failed");
        return success;
    }
}
```

**Parameters Explained:**
- `address payable recipient`: The receiving address that must be payable
- `msg.value`: The amount of Ether to send (in Wei)
- `bool success`: Return value indicating whether the transfer succeeded

### 3. Low-level `call()` Method 📞
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CallExample {
    function callEther(address payable recipient, uint256 amount) public payable returns (bool) {
        // You can specify an exact amount different from msg.value
        (bool success, bytes memory data) = recipient.call{value: amount, gas: 100000}("");
        require(success, "Call failed");
        return success;
    }
}
```

**Parameters Explained:**
- `address payable recipient`: The receiving address
- `uint256 amount`: Specific amount to send (can be different from msg.value)
- `value: amount`: The amount of Ether to send (in Wei)
- `gas: 100000`: Optional gas limit for the call (prevents gas exhaustion)
- `""`: Empty calldata (no function to call, just sending Ether)
- `bool success`: Return value indicating success or failure
- `bytes memory data`: Any return data from the call (usually empty for plain transfers)

## Value Transfer in Vyper 🐍

### 1. `send()` Method 📤
```vyper
# @version ^0.3.7

@external
@payable
def transfer_ether(recipient: address, amount: uint256):
    # Can send a specific amount, not just msg.value
    send(recipient, amount)
```

**Parameters Explained:**
- `recipient: address`: The receiving address
- `amount: uint256`: The amount of Ether to send (in Wei)
- Function marked as `@payable` to receive Ether

### 2. `raw_call()` Method 🛠️
```vyper
# @version ^0.3.7

@external
@payable
def raw_call_ether(recipient: address, amount: uint256, gas_limit: uint256) -> bool:
    success: bool = raw_call(
        recipient,  # Target address
        b"",        # Empty call data (no function call)
        value=amount,      # Amount to send
        gas=gas_limit,     # Gas limit for the call
        revert_on_failure=False  # Don't revert automatically
    )
    assert success, "Raw call failed"
    return success
```

**Parameters Explained:**
- `recipient: address`: Target contract or EOA
- `b""`: Empty bytes (no function to call)
- `value=amount`: Wei amount to send
- `gas=gas_limit`: Explicit gas limit
- `revert_on_failure=False`: Control whether to revert on failure
- `success: bool`: Return value indicating success/failure

## Reentrancy Deep Dive 🔄

### What is Reentrancy?

Reentrancy occurs when:
1. Contract A calls Contract B
2. Before Contract A completes execution, Contract B calls back into Contract A
3. Contract A's state hasn't been updated yet, allowing Contract B to exploit intermediate state

### Detailed Reentrancy Example

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Vulnerable contract
contract VulnerableBank {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");
        
        // VULNERABLE: Call external contract before updating state
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        // State update happens AFTER external call
        balances[msg.sender] = 0;
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

// Attacker contract
contract Attacker {
    VulnerableBank public vulnerableBank;
    uint256 public attackAmount;
    address public owner;
    
    constructor(address vulnerableBankAddress) {
        vulnerableBank = VulnerableBank(vulnerableBankAddress);
        owner = msg.sender;
    }
    
    // Function to start the attack
    function attack() public payable {
        require(msg.value >= 1 ether, "Need at least 1 ether to attack");
        attackAmount = msg.value;
        
        // Deposit into the vulnerable contract
        vulnerableBank.deposit{value: attackAmount}();
        
        // Trigger the withdrawal, which will cause reentrancy
        vulnerableBank.withdraw();
    }
    
    // Fallback function that gets triggered when receiving Ether
    receive() external payable {
        // Check if there's still Ether in the vulnerable contract
        if (address(vulnerableBank).balance >= attackAmount) {
            // Re-enter the withdraw function before the balance is updated
            vulnerableBank.withdraw();
        }
    }
    
    // Function to withdraw stolen funds
    function withdrawStolenFunds() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
```

**The Attack Flow:**
1. Attacker deposits 1 ETH into VulnerableBank
2. Attacker calls withdraw()
3. VulnerableBank sends 1 ETH to Attacker, triggering receive()
4. Before balances are updated to zero, Attacker calls withdraw() again
5. The cycle repeats until VulnerableBank is drained

### Multiple Reentrancy Protections

#### 1. Checks-Effects-Interactions Pattern

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SafeBank {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() public {
        // 1. CHECKS
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");
        
        // 2. EFFECTS (update state before interaction)
        balances[msg.sender] = 0;
        
        // 3. INTERACTIONS (external calls last)
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}
```

#### 2. Reentrancy Guard (Mutex)

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReentrancyGuard {
    // State variable to track reentrancy
    bool private _locked = false;
    
    modifier nonReentrant() {
        // Check reentrancy guard status
        require(!_locked, "Reentrant call detected");
        
        // Set the guard
        _locked = true;
        
        // Execute the function
        _;
        
        // Release the guard
        _locked = false;
    }
}

contract ProtectedBank is ReentrancyGuard {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    // Apply nonReentrant modifier to prevent reentrancy attacks
    function withdraw() public nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");
        
        // Even with state update after interaction, reentrancy is prevented
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
        
        balances[msg.sender] = 0;
    }
}
```

#### 3. Vyper's Built-in Protection

Vyper has built-in reentrancy protection through its `@nonreentrant` decorator:

```vyper
# @version ^0.3.7

balances: public(HashMap[address, uint256])

@external
@payable
def deposit():
    self.balances[msg.sender] += msg.value

@external
@nonreentrant("withdraw")  # Built-in reentrancy guard
def withdraw():
    amount: uint256 = self.balances[msg.sender]
    assert amount > 0, "Insufficient balance"
    
    # Update state before external call (following CEI pattern)
    self.balances[msg.sender] = 0
    
    # External call
    send(msg.sender, amount)
```

**Parameters Explained:**
- `@nonreentrant("withdraw")`: The string parameter is a unique identifier for the protected function

## Advanced Parameters for Value Transfer 🔧

### Solidity's `call()` Advanced Parameters

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdvancedCall {
    function executeCall(
        address payable target,
        bytes memory data,
        uint256 value,
        uint256 gasLimit
    ) public payable returns (bool, bytes memory) {
        // Full control over call parameters
        return target.call{value: value, gas: gasLimit}(data);
    }
    
    // Call a specific function with parameters on the target contract
    function callSpecificFunction(
        address payable target,
        uint256 value
    ) public payable returns (bool) {
        // Create function signature and arguments
        bytes memory data = abi.encodeWithSignature(
            "processPayment(address,uint256)",
            msg.sender,
            block.timestamp
        );
        
        (bool success, ) = target.call{value: value}(data);
        return success;
    }
}
```

**Parameters Explained:**
- `target`: The contract address to call
- `data`: The encoded function signature and parameters to call
- `value`: Amount of Ether to send (in Wei)
- `gasLimit`: Maximum gas to use for the call
- `abi.encodeWithSignature`: Creates the function selector and encodes parameters

### Vyper's `raw_call()` Advanced Parameters

```vyper
# @version ^0.3.7

@external
@payable
def execute_call(
    target: address,
    data: Bytes[1024],
    amount: uint256,
    gas_limit: uint256,
    should_revert: bool
) -> (bool, Bytes[1024]):
    success: bool = False
    response: Bytes[1024] = b""
    
    # Full control over call parameters
    success, response = raw_call(
        target,
        data,
        value=amount,
        gas=gas_limit,
        revert_on_failure=should_revert,
        is_delegate_call=False,  # Use normal call (not delegatecall)
        is_static_call=False     # Allow state modifications
    )
    
    return success, response

@external
@payable
def call_specific_function(target: address, amount: uint256) -> bool:
    # Create function signature and arguments
    data: Bytes[100] = _abi_encode_with_selector(
        method_id("processPayment(address,uint256)"),
        msg.sender,
        block.timestamp
    )
    
    success: bool = raw_call(
        target,
        data,
        value=amount,
        revert_on_failure=True
    )
    
    return success
```

**Parameters Explained:**
- `target`: The contract address to call
- `data`: The encoded function data
- `amount`: Wei to send
- `gas_limit`: Maximum gas to use
- `should_revert`: Whether to propagate reverts
- `is_delegate_call`: Executes in the context of the calling contract
- `is_static_call`: Similar to view/pure function calls
- `method_id()`: Generates the function selector
- `_abi_encode_with_selector`: Encodes parameters with the selector

## Cross-Contract Reentrancy Protection 🛡️

Protecting against reentrancy in multiple contracts:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Shared reentrancy guard for multiple contracts
abstract contract GlobalReentrancyGuard {
    // Shared between all inheriting contracts
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    
    // Slot is important for cross-contract protection
    uint256 private _status;
    
    constructor() {
        _status = _NOT_ENTERED;
    }
    
    modifier globalNonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

// Contract A implementing the guard
contract VaultA is GlobalReentrancyGuard {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdraw() public globalNonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Insufficient balance");
        
        balances[msg.sender] = 0;
        
        // This can call into VaultB, but VaultB won't be able to call back
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }
}

// Contract B implementing the same guard
contract VaultB is GlobalReentrancyGuard {
    mapping(address => uint256) public balances;
    
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    
    funct