# Essential Foundry Cheatcodes Guide 🛠️

## Introduction 🌟
Foundry provides powerful cheatcodes that allow you to manipulate the EVM state during testing. These tools are essential for creating comprehensive and realistic test scenarios for your smart contracts.

## vm.expectEmit - Testing Events 🎯

### Basic Syntax 📏
```solidity
vm.expectEmit(checkTopic1, checkTopic2, checkTopic3, checkData);
```

### Parameters Explained 🔍
- `checkTopic1` (bool): Check the first indexed parameter
- `checkTopic2` (bool): Check the second indexed parameter  
- `checkTopic3` (bool): Check the third indexed parameter
- `checkData` (bool): Check non-indexed parameters (data)

### Example ⚙️
```solidity
contract EventTest is Test {
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    function testEventEmission() public {
        address from = address(0x123);
        address to = address(0x456);
        uint256 amount = 100;
        
        // Expect the Transfer event
        vm.expectEmit(true, true, false, true);
        emit Transfer(from, to, amount);
        
        // Call function that emits the event
        myContract.transfer(from, to, amount);
    }
}
```

## vm.prank - Impersonating Addresses 🎭

### Basic Syntax 📏
```solidity
vm.prank(address); // Next call only
vm.startPrank(address); // All subsequent calls
vm.stopPrank(); // Stop pranking
```

### Single Call Prank 🎪
```solidity
function testPrankSingleCall() public {
    address alice = address(0x123);
    
    // Next call will be made as alice
    vm.prank(alice);
    myContract.withdraw(); // This call is made by alice
    
    // This call is made by the test contract again
    myContract.deposit();
}
```

### Multi-Call Prank 🎨
```solidity
function testPrankMultipleCalls() public {
    address alice = address(0x123);
    
    // Start pranking as alice
    vm.startPrank(alice);
    myContract.deposit(100);
    myContract.withdraw(50);
    myContract.transfer(address(0x456), 25);
    vm.stopPrank();
    
    // Back to test contract as caller
    myContract.checkBalance();
}
```

## vm.roll - Manipulating Block Number 🎲

### Basic Syntax 📏
```solidity
vm.roll(blockNumber);
```

### Example ⚙️
```solidity
contract TimeBasedContract {
    uint256 public creationBlock;
    
    constructor() {
        creationBlock = block.number;
    }
    
    function isMatured() public view returns (bool) {
        return block.number >= creationBlock + 100;
    }
}

contract TimeBasedTest is Test {
    TimeBasedContract public timeContract;
    
    function setUp() public {
        timeContract = new TimeBasedContract();
    }
    
    function testMaturityAfter100Blocks() public {
        // Initially not matured
        assertFalse(timeContract.isMatured());
        
        // Fast forward 100 blocks
        vm.roll(block.number + 100);
        
        // Now it should be matured
        assertTrue(timeContract.isMatured());
    }
}
```

## vm.warp - Manipulating Timestamp ⏰

### Basic Syntax 📏
```solidity
vm.warp(timestamp);
```

### Example ⚙️
```solidity
contract TimeLock {
    uint256 public unlockTime;
    address public owner;
    uint256 public lockedAmount;
    
    constructor(uint256 _lockDuration) payable {
        owner = msg.sender;
        unlockTime = block.timestamp + _lockDuration;
        lockedAmount = msg.value;
    }
    
    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        require(block.timestamp >= unlockTime, "Still locked");
        
        payable(owner).transfer(lockedAmount);
        lockedAmount = 0;
    }
}

contract TimeLockTest is Test {
    TimeLock public timeLock;
    address public owner = address(0x123);
    
    function setUp() public {
        vm.deal(owner, 1 ether);
        vm.prank(owner);
        timeLock = new TimeLock{value: 1 ether}(1 days);
    }
    
    function testCannotWithdrawBeforeUnlock() public {
        vm.prank(owner);
        vm.expectRevert("Still locked");
        timeLock.withdraw();
    }
    
    function testCanWithdrawAfterUnlock() public {
        // Fast forward 1 day + 1 second
        vm.warp(block.timestamp + 1 days + 1);
        
        vm.prank(owner);
        timeLock.withdraw();
        
        assertEq(timeLock.lockedAmount(), 0);
    }
}
```

## vm.expectRevert - Testing Reverts 💥

### Basic Syntax 📏
```solidity
vm.expectRevert(); // Expect any revert
vm.expectRevert("Revert message"); // Expect specific message
vm.expectRevert(CustomError.selector); // Expect custom error
```

### Testing Different Revert Types 🚨

```solidity
contract VaultContract {
    mapping(address => uint256) public balances;
    address public owner;
    
    error InsufficientBalance(uint256 requested, uint256 available);
    error NotOwner();
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }
    
    function withdraw(uint256 amount) external {
        if (balances[msg.sender] < amount) {
            revert InsufficientBalance(amount, balances[msg.sender]);
        }
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
    
    function emergencyStop() external onlyOwner {
        // Emergency function
    }
}

contract VaultTest is Test {
    VaultContract public vault;
    address public user = address(0x123);
    
    function setUp() public {
        vault = new VaultContract();
    }
    
    // Test string revert message
    function testWithdrawInsufficientBalance() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);
        
        vault.deposit{value: 0.5 ether}();
        
        // Expect revert with custom error
        vm.expectRevert(
            abi.encodeWithSelector(
                VaultContract.InsufficientBalance.selector,
                1 ether,
                0.5 ether
            )
        );
        vault.withdraw(1 ether);
        
        vm.stopPrank();
    }
    
    // Test custom error
    function testOnlyOwnerModifier() public {
        vm.prank(user);
        vm.expectRevert(VaultContract.NotOwner.selector);
        vault.emergencyStop();
    }
    
    // Test any revert
    function testGenericRevert() public {
        vm.expectRevert(); // Any revert is acceptable
        vault.withdraw(1 ether); // Will revert due to insufficient balance
    }
}
```

## Combining Cheatcodes 🔗

### Complex Test Scenario 🎪
```solidity
contract ComplexTest is Test {
    MyToken public token;
    address public alice = address(0x123);
    address public bob = address(0x456);
    
    function setUp() public {
        token = new MyToken();
        vm.deal(alice, 10 ether);
        vm.deal(bob, 10 ether);
    }
    
    function testComplexScenario() public {
        // 1. Alice mints tokens at block 100
        vm.roll(100);
        vm.prank(alice);
        token.mint(1000);
        
        // 2. Fast forward 30 days and 50 blocks
        vm.warp(block.timestamp + 30 days);
        vm.roll(150);
        
        // 3. Alice transfers to Bob, expect event
        vm.expectEmit(true, true, false, true);
        emit Transfer(alice, bob, 500);
        
        vm.prank(alice);
        token.transfer(bob, 500);
        
        // 4. Bob tries to transfer more than he has, should revert
        vm.prank(bob);
        vm.expectRevert("Insufficient balance");
        token.transfer(alice, 600);
    }
}
```

## Best Practices ⭐

### 1. Clear State Management 🧹
```solidity
function testWithCleanState() public {
    vm.startPrank(alice);
    // ... do operations as alice
    vm.stopPrank(); // Always stop prank when done
    
    // Clear state if needed
    vm.roll(1); // Reset to block 1
    vm.warp(1); // Reset timestamp
}
```

### 2. Descriptive Test Names 📝
```solidity
function testCannotWithdrawMoreThanBalanceAfter30Days() public {
    // Test implementation
}

function testEmitsTransferEventWhenTokensAreSent() public {
    // Test implementation  
}
```

### 3. Use setUp for Common State 🏗️
```solidity
function setUp() public {
    // Initialize contracts
    token = new MyToken();
    
    // Set up test accounts
    alice = address(0x123);
    bob = address(0x456);
    
    // Give them some ETH
    vm.deal(alice, 10 ether);
    vm.deal(bob, 10 ether);
    
    // Initial token distribution
    vm.prank(alice);
    token.mint(1000);
}
```

## Common Mistakes to Avoid ⚠️

1. **Forgetting to stop prank**: Always call `vm.stopPrank()` after `vm.startPrank()`
2. **Wrong expectRevert placement**: `vm.expectRevert()` must be called immediately before the reverting call
3. **Incorrect event parameters**: Ensure event parameters match exactly in `vm.expectEmit()`
4. **Not considering state persistence**: Remember that `vm.roll()` and `vm.warp()` persist across test functions
5. **Overcomplicating tests**: Keep individual tests focused on single behaviors

## Gas Considerations ⛽

Cheatcodes themselves don't consume gas in tests, but they help you:
- Test gas-intensive operations at different block numbers
- Simulate time-based gas optimizations
- Test functions that depend on block properties without waiting