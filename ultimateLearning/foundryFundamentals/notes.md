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
cast send SimpleStorage_contract_address "store(uint256)" 123 --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

## Send eth to contract

```bash
cast send CONTRACT_ADDRESS "receive()" --value 0.5ether --rpc-url $RPC_URL --private_key $PRIVATE_KEY

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

## Storage 

Visualize storage loyout spots

```bash
forge inspect FundMe storageLayout
```

Alternatively

```bash
cast storage CONTRACT_ADDRESS SLOT
```

# FundMe Frontend

When connecting Metamask to website, Metamask injecte **window.ethereum** object.
Metamask signs transactions for us. The private key stays on Metamask.

## Function selector

All functions in Solidity are transformed into bytecode, EVM low-level code.
Metamask convert function such as "fund" into its function selector.

We can get a function signature using cast
```bash
cast sig "fund()"
```

When calling "fund()" function we can check for hex value and state it's the same.
Function signature can be used to highligth call of malicious function instead of legit one.

# Lottery Raffle

## Custom error

Custom errors reverting with if condition are less gas consumming than using a standart require.
Require use a stored string, causing high gas usage.
New version of Solidity since 0.8.26 enables to raise an error instead of a string in require.
Good practice is to include contract name in error code.

## Events

EVM can emit logs.
Events allows to print information to the logging structure in a more gas efficient way than writing it into a storage variable.

Events are used to "filter" request based on the event being listened.

Events include a new keyword for its parameters : **indexed**
Indexed paramaters (also called topics) are easier to query

Not indexed parameters are harder to search as they are ABI encoded, you need to decode them to search

Non indexed parameters cost less gas to print into the logs and are less searchable

Everytime we update a storage we want to emit an event

## block.timestamp


## VRF

### Chainlink VRF 2.5 Explained

Chainlink VRF (Verifiable Random Function) 2.5 is an upgraded version of Chainlink's random number generation service for blockchain applications. Here's a brief explanation:

Chainlink VRF 2.5 provides cryptographically secure, tamper-proof random numbers for smart contracts. The key improvements in version 2.5 include:

1. Enhanced subscription model that allows developers to fund VRF requests for multiple contracts from a single subscription
2. Significantly reduced gas costs compared to previous versions
3. Faster response times for random number delivery
4. Higher throughput capacity for applications requiring frequent randomness
5. Improved security through enhanced cryptographic proofs that verify the randomness is both unpredictable and unbiased

This random number generation is crucial for applications like NFT distribution, gaming mechanics, randomized rewards in DeFi, fair selection processes, and any blockchain use case requiring provably fair randomness.

The system works by combining on-chain user-provided seed data with off-chain cryptographic operations, then delivering verifiable proofs along with the random values to ensure transparency and security.

### Create Subscription

To be able to test our perforUpkeepk function we need to have a valid subscription ID.
To do so we can use the UI on vrf.chain.link or create a deploy script to automate process.
vrfCoordinator have a subscription ID creation function. We connect to the UI to create a subscription.

When verifying signatures we can use openchain.xyz to give hex and check in database if function is know. 
Otherwise from function name to hex we use **cast sig**

To create a signature we use the **createSubsription** function from **SubscriptionAPI.sol** imported in mock.

### Fund Subscription

On Sepolia testnet chain we are using will fund our subscription using link token.

- For Sepolia chain : We retrieve token contract address from [chainlink documentation](https://docs.chain.link/resources/link-token-contracts#sepolia-testnet)
- For local chain : we create a mock contract of chainlink token to fund subscription

### Forge coverage

To get details about uncovered lines:
```bash
forge coverage --report debug
```

This way we can see what tests need to be crafted

### Vm.Logs

After catching logs using **vm.recordLogs** we use Vm.Logs to get through the result.

The entries[0] is for events emitted by requestRandomWords from vrfCoordinator.
So entries[1] is for our event. topics[0] is a reserved slot, our topic starts at index 1.
Do not forget to import Vm from forge std library

## Fuzz testting

Use fuzzing instead of repeting manual incrementation

To do so add an uint256 argument to your test.
By adding this the test will be run 256 times by default (can be changed in toml file under **runs**)

## Forked test environment and private key

When trying to deploy smart contract on Sepolia testnet we receive a **MustBeSubOwner**
We can use **vm.startBroadcast()** and provide a private key
To do so we add a **address account** in our HelperConfig file. It is the address of our private key from test account. From **Base.sol** file we use default tx.origin address for local instance
