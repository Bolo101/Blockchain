# Foundry Framework Guide 🛠️

## Introduction to Foundry 🌟
Foundry is a blazing fast, portable, and modular toolkit for Ethereum application development. It's written in Rust and designed to make smart contract development, testing, and deployment more efficient.

## Install

Run :

```bash
curl -L https://foundry.paradigm.xyz | bash
```

## Core Components 🧩

### Forge 🔨
The testing framework for Ethereum smart contracts.
```bash
# Create a new Foundry project
forge init my_project

# Compile contracts
forge build

# Run tests
forge test

# Run specific test
forge test --match-test testFunctionName
```

### Cast 🎭
A command-line tool for interacting with EVM smart contracts, sending transactions, and getting chain data.
```bash
# Get balance of an address
cast balance 0x742d35Cc6634C0532925a3b844Bc454e4438f44e

# Call a contract function
cast call 0xContractAddress "balanceOf(address)(uint256)" 0xUserAddress

# Estimate gas
cast estimate 0xContractAddress "transfer(address,uint256)" 0xRecipient 100
```

### Anvil ⚒️
A local Ethereum node designed for development with customizable options.
```bash
# Start a local node
anvil

# Start with specific chain ID
anvil --chain-id 1337

# Start with specific block number
anvil --fork-block-number 14000000
```

## Setting Up a Project 📂

```bash
# Install Foundry (if not already installed)
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Initialize a new project
forge init my_foundry_project
cd my_foundry_project

# Project structure
# ├── lib/             # Dependencies
# ├── script/          # Deployment scripts
# ├── src/             # Smart contracts
# └── test/            # Test files
```

## Writing Tests in Foundry ✅

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyContract.sol";

contract MyContractTest is Test {
    MyContract myContract;
    
    function setUp() public {
        myContract = new MyContract();
    }
    
    function testFunction() public {
        // Test logic here
        assertTrue(myContract.someFunction() == expectedValue);
    }
    
    function testFailFunction() public {
        // This test is expected to fail/revert
        myContract.functionThatShouldRevert();
    }
}
```

## Testing Features 🔍

### Assertions 🧐
```solidity
// Common assertions
assertEq(a, b);      // Assert a equals b
assertTrue(a);       // Assert a is true
assertFalse(a);      // Assert a is false
assertGt(a, b);      // Assert a > b
assertLt(a, b);      // Assert a < b
assertGe(a, b);      // Assert a >= b
assertLe(a, b);      // Assert a <= b
```

### Utilities 🛠️
```solidity
// Dealing with addresses
address user = makeAddr("user");  // Create address from string
deal(user, 100 ether);           // Give ETH to an address

// Working with tokens
deal(address(token), user, 1000); // Give tokens to an address

// Manipulating blockchain state
vm.prank(user);                   // Next call is from user
vm.startPrank(user);              // All calls are from user until stopPrank
vm.stopPrank();                   // Stop pranking

vm.roll(100);                     // Set block number
vm.warp(1000000);                 // Set timestamp
```

### Fuzz Testing 🌀
```solidity
// Fuzz test with random inputs
function testFuzz_Addition(uint256 a, uint256 b) public {
    // Foundry will test with many random inputs
    vm.assume(a + b >= a);  // Prevent overflow
    uint256 sum = myContract.add(a, b);
    assertEq(sum, a + b);
}
```

## Deployment with Foundry 🚀

### Writing Scripts 📝
```solidity
// script/Deploy.s.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/MyContract.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        
        MyContract myContract = new MyContract();
        
        vm.stopBroadcast();
    }
}
```

### Running Scripts 🏃‍♂️
```bash
# Run script on local node
forge script script/Deploy.s.sol --fork-url http://localhost:8545 --broadcast

# Run script on testnet
forge script script/Deploy.s.sol --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

## Foundry Configuration ⚙️

### foundry.toml 📄
```toml
[profile.default]
src = 'src'
out = 'out'
libs = ['lib']
solc_version = '0.8.13'
optimizer = true
optimizer_runs = 200

[profile.ci]
fuzz_runs = 1000
verbosity = 4

[etherscan]
goerli = { key = "${ETHERSCAN_API_KEY}" }
```

## Comparison with Other Frameworks 📊

| Feature | Foundry | Hardhat | Truffle |
|---------|---------|---------|---------|
| Language | Rust & Solidity | JavaScript | JavaScript |
| Testing | Native Solidity | JavaScript | JavaScript |
| Compilation Speed | ⚡⚡⚡ | ⚡⚡ | ⚡ |
| Gas Reporting | Built-in | Plugin | Plugin |
| Debugger | Built-in | Built-in | Built-in |
| Fuzz Testing | Built-in | Plugin | Plugin |
| Learning Curve | Medium | Low | Low |

## Best Practices 🏆

1. **Use Proper Error Handling** - Leverage custom errors for gas efficiency and clear debugging
2. **Leverage Cheatcodes** - Use Foundry's powerful cheatcodes for thorough testing
3. **Organize Tests** - Group related tests in separate contract files
4. **Use Test Fixtures** - Create reusable setUp functions for common test scenarios
5. **Document Tests** - Add comments explaining the purpose of complex tests
6. **Use Proper Gas Optimization** - Configure foundry.toml for optimal compilation settings
7. **Use Fuzz Testing** - Don't just test with static values, leverage fuzz testing

## Common Gotchas ⚠️

1. **Gas Reporting** - Make sure to use `--gas-report` flag to see gas usage
2. **Environment Variables** - Use `.env` files with `source .env` before running scripts
3. **Dependencies** - Don't forget to update dependencies with `forge update`
4. **Memory Leaks** - Be careful with large fuzz tests that might consume too much memory
5. **Block Timestamps** - Remember that `vm.warp()` only changes the timestamp, not the block number