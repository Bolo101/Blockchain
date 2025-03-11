# Forge and Anvil: Compiling and Deploying Smart Contracts

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
forge create --rpc-url http://localhost:8545 \
  --private-key  \
  src/Counter.sol:Counter \
  --constructor-args 42
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
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Counter(42);
        vm.stopBroadcast();
    }
}
```

Execute with:

```bash
forge script script/Deploy.s.sol:DeployCounter \
  --rpc-url http://localhost:8545 \
  --broadcast \
  --private-key 
```

- Automatically detects running Anvil instance if no RPC specified

## 6. Key Commands Cheatsheet

| Task | Command |
|------|---------|
| Start Anvil | `anvil` |
| Compile Contracts | `forge build` |
| Deploy Single Contract | `forge create --rpc-url ...` |
| Run Deployment Script | `forge script --broadcast ...` |
| Get Contract Value | `cast call  "function()" --rpc-url ...` |
| Send Transaction | `cast send  "function()" --rpc-url ...` |

---
Answer from Perplexity: pplx.ai/share