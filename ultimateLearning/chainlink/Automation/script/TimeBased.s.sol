//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {TimeBased} from "../src/TimeBased.sol";

contract DeployTimeBased is Script {
    function run() external {
        vm.startBroadcast();
        new TimeBased();
        vm.stopBroadcast();
    }
}
