# Foundry FundMe

## Foundry imports

Contrary to Remix, Foundry cannot import code from online ressources.
To get the AggregatorV3 Interface we have to download the file from Github using forge:

```bash
forge install smartcontractkit/chainlink-brownie-contracts@1.1.0 --no-commit
```

The contracts being on [Chainlink Github repo](https://github.com/smartcontractkit/chainlink-brownie-contracts) 

Once downloaded, we need to create a remapping in the foundry.toml to replace the online import ressources call by local code downloaded.

```toml
remappings = ["@chailink/contracts/=lib/chainlink-brownie-contracts/contracts/"]
```

## Foundry testing

Here is a basic test 

```solidity
// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    uint number = 1;

    function setUp() external {
        number++;
    }

    function testDemo() public view {
        console.log(number);
        console.log("Hello");
        assertEq(number, 2);
    }
}
```
The display of logs is made using option **-vv**

```bash
forge test --vv
```

