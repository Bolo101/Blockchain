//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {EventEmitter} from "../src/EventEmitter.sol";
import {LogTrigger} from "../src/LogTrigger.sol";

contract DeployLogTrigger is Script {
    function run() external {
        vm.startBroadcast();
        new EventEmitter();
        new LogTrigger();
        vm.stopBroadcast();
    }
}
