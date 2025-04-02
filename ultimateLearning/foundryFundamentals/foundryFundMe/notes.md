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
forge test -mt testPriceFeedVersionIsAccurate -vvv --fork-url $SEPOLIA_AL
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
