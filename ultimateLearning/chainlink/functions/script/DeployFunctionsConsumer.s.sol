// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {FunctionsConsumer} from "src/FunctionsConsumer.sol";

contract DeployFunctionsConsumer is Script {
    function deploy() external {
        FunctionsConsumer consumer = new FunctionsConsumer();
        console.log("FunctionsConsumer deployed to:", address(consumer));
    }
}
