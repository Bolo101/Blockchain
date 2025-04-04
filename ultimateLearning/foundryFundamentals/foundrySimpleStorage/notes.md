# Forge and Anvil: Compiling and Deploying Smart Contracts

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