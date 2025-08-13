//SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {CustomLogic} from "../src/CustomLogic.sol";

contract DeployTimeBased is Script {
    function run() external {
        vm.startBroadcast();
        new CustomLogic(100);
        vm.stopBroadcast();
    }
}
