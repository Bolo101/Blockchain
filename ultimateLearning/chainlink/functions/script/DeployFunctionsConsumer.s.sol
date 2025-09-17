// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {FunctionsConsumer} from "src/FunctionsConsumer.sol";

contract DeployFunctionsConsumer is Script {
    function run() external {
        vm.startBroadcast();
        FunctionsConsumer consumer = new FunctionsConsumer();
        vm.stopBroadcast();
        console.log("FunctionsConsumer deployed to:", address(consumer));
    }
}
