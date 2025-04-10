# Foundry SimpleStorage

Install using :

```bash
curl -L https://foundry.paradigm.xyz | bash
```


## 1. Project Setup

Initialize a new Foundry project:

```bash
forge init my_project && cd my_project
```

- Remove boilerplate code for existing Git projects:  
  `forge init --no-commit`
- Directory structure:
  - `src/`: contracts
  - `script/`: deployment scripts
  - `test/`: tests

## 2. Compiling Contracts

Place your contract in `src/` (e.g., `Counter.sol`):

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;
    
    constructor(uint _initNumber) { number = _initNumber; }
    function increment() public { number++; }
}
```

Compile with:

```bash
forge build
```

- Outputs artifacts to `out/` directory

## 3. Using Anvil for Local Testing

Start a local Ethereum node:

```bash
anvil
```

- Runs at `http://localhost:8545` by default
- Provides 10 test accounts with 10k ETH each
- Private keys and addresses displayed in terminal

## 4. Deploying with Forge Create

### Basic Deployment

```bash
forge create SimpleStorage --interactive --broadcast
```

```bash
forge create --rpc-url http://localhost:8545 \
  --private-key  \
  src/Counter.sol:Counter \
  --constructor-args 42 \
  --broadcast
```

- `--constructor-args`: Pass initial value 42 to constructor
- Contract address and TX hash displayed on success

### Interactive Mode

For secure key entry:

```bash
forge create src/Counter.sol:Counter --interactive
```

- Paste Anvil private key when prompted

## 5. Deployment via Scripts

Create `script/Deploy.s.sol`:

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Counter} from "../src/Counter.sol";

contract DeployCounter is Script {
    function run() external {
        vm.startBroadcast();
        Counter counter = new Counter(42);
        vm.stopBroadcast();
        return counter
    }
}
```

The .s.sol is a Foundry convention.

**About the `vm` keyword:**
- `vm` is a special object provided by Foundry's testing framework (`forge-std`)
- It provides access to Foundry's cheatcodes and utilities that simplify testing and deployment
- `vm.startBroadcast()`: Begins recording transactions for later broadcast to the network
- `vm.stopBroadcast()`: Stops recording transactions
- All contract interactions between these calls are batched together and executed with the provided private key
- This allows for atomic deployment of multiple contracts or performing multiple operations in a single script

Execute with:

```bash
forge script script/DeploySimpleStorage.s.sol
```
If no RPC url is specified, the code is deployed on a temporary anvil instance.

```bash
forge script script/DeploySimpleStorage.s.sol \
  --rpc-url http://localhost:8545 \
  --broadcast \
  --private-key 
```

- Automatically detects running Anvil instance if no RPC specified


## 6. Manage your private key

Securely manage your private key implies to not have it stored or used in plaintext.
Do not use copy/paste it in your shell, do not use a .env file to store you key.

Inteads use `cast wallet`:

* Create keystore

```bash
cast wallet import defaultKey --interactive
```

A password will have to be set to access your keystore.

* List existing keystores:

```bash
cast wallet list
```

* Use keystore when deploying contract:

```bash
forge script script/DeploySimpleStorage.s.sol \
--rpc-url http://127.0.0.1:8545 \
--account defaultKey \
--sender address_of_sender \
--broadcast \
-vvvv
```

(-vvvv): Print execution traces for all tests, and setup traces for failing tests.

## Interact with contract using cast

```bash
cast send SimpleStorage_contract_address "store(uint256)" 123 --rppc-url $RPC_URL --private-key $PRIVATE_KEY
```

Only use environment variables for testing and using test keys without real funds

## Read data from contract

```bash
cast call SimplsimpleStorage_contract_address "retrieve()"
```

## 7. Key Commands Cheatsheet

| Task | Command |
|------|---------|
| Start Anvil | `anvil` |
| Compile Contracts | `forge build` |
| Deploy Single Contract | `forge create --rpc-url ...` |
| Run Deployment Script | `forge script --broadcast ...` |
| Get Contract Value | `cast call  "function()" --rpc-url ...` |
| Send Transaction | `cast send  "function()" --rpc-url ...` |
| Convert hex gas value to decimal | `cast --to-base hex_gas_value dec` |
| Store private key in keystore | `cast wallet import defaultKey --interactive`|
| Format code | `forge fmt`|

---

# Foundry FundMe

## Foundry Imports

### Chainlink Contracts Import
Unlike Remix, Foundry cannot directly import code from online resources. To integrate Chainlink's AggregatorV3 Interface, you need to:

1. Download the contracts using Forge:
```bash
forge install smartcontractkit/chainlink-brownie-contracts@1.1.0 --no-commit
```

2. Create a remapping in `foundry.toml` to resolve local import paths:
```toml
remappings = ["@chainlink/contracts/=lib/chainlink-brownie-contracts/contracts/"]
```

**Key Points:**
- Source: [Chainlink GitHub Repository](https://github.com/smartcontractkit/chainlink-brownie-contracts)
- The `--no-commit` flag prevents adding the installed library to your git repository
- Remappings allow you to use local copies of external contracts seamlessly

## Foundry Testing

### Basic Test Structure
Here's a basic test contract demonstrating Foundry testing principles:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    uint256 number = 1;

    function setUp() external {
        // This function runs before each test
        // Used for test setup and initialization
        number++;
    }

    function testDemo() public view {
        // Logging and assertions
        console.log(number);
        console.log("Hello");
        assertEq(number, 2);
    }
}
```

### Test Execution Commands

#### Running Tests
- Display logs with verbosity levels:
```bash
forge test -v    # Basic output
forge test -vv   # Detailed output with function calls
forge test -vvv  # Maximum verbosity with state changes
```

#### Running Specific Tests
Target specific test functions:
```bash
# Both commands are equivalent
forge test -mt testFunctionToExecute -vvv
forge test --match-test testFunctionToExecute -vvv
```

### Advanced Testing Techniques

#### Chain Forking
When testing contracts that interact with external protocols, use chain forking to simulate real-world environments:

```bash
# Fork Sepolia testnet for accurate testing
forge test --match-test testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_AL
```

**Benefits of Chain Forking:**
- Test interactions with live contracts
- Simulate real network conditions
- Validate contract behavior without deploying to mainnet

#### Test Coverage Analysis
Measure the extent of code covered by your tests:

```bash
# Generate test coverage report
forge coverage --fork-url $SEPOLIA_AL
```

## Refactoring code

Remove all hardcoded price feed address to specify price feed to use as a constructor parameter

As we have to change both our test and script contract to specify the price feed to use when deploying, we modify our test contract to import our deploy script which is reshaped to return the FundMe contract.
This way we only have to change hardcoded value in a single file and not two.

## Mock contract

We create on anvil our own mock contract (price feed) to avoid hardcoding an address in deploy script

This is going to be our HelperConfig.s.sol

In our mock contract we refer to Eth Sepolia and Eth mainnet addresses to get data feeds.
On our anvil no contract/data feed is deployed. We need to deploy the mock and return its address.

## Cheatcodes

### makeAddr

Create a new address called USER. User account is blank.

```solidity
address USER = makeAddr("user");
```

### vm.prank

Specify next transaction must be realised as USER

```solidity
vm.prank(USER);
```

### vm.expectRevert()

Specify that next transaction sould revert.

```solidity
vm.expectRevert(); // indicates next line sould revert
fundMe.fund(); //no value is passed otherwiser fundMe.fund{}()
```
### vm.deal

Send STARTING_BALANCE amount ETH to USER.

```solidity
vm.deal(USER, STARTING_BALANCE);
```

### hoax

Both prank and deal at the same time

```solidity
hoax(address(1), SEND_VALUE);
```
Next transaction will be initiated by address(1) and send SEND_VALUE amount in eth

If you want a number to generate addresses you need to use uint160
It has the same amount of bytes than an address

## Chisel

Write and test solidity directly in terminal.

```solidity
➜ uint256 cat = 1;
➜ cat
Type: uint256
├ Hex: 0x1
├ Hex (full word): 0x0000000000000000000000000000000000000000000000000000000000000001
└ Decimal: 1
```

## Estimate gas cost

Use **forge coverage**

```solidity
forge snapshot --m
atch-test testWithdrawnFromMultipleFunders
```
On anvil the default gas price is set to zero.

### txGasPrice
If we want to simulate the transaction with actual gas price we use **txGasPrice** cheatcode

### gasleft()

To calculate the amount of gas required to execute a transaction or run a function we use **gasleft** function in solidity

We need to determine **gasleft** amount before and after running the function.
