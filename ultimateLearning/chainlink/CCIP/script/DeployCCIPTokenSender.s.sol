//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {CCIPTokenSender} from "../src/CCIPTokenSender.sol";

contract DeployCCIPTokenSender is Script {
    function run() external returns (CCIPTokenSender ccipTokenSender) {
        console.log("Deploying CCIPTokenSender contract...");
        vm.startBroadcast();
        ccipTokenSender = new CCIPTokenSender();
        vm.stopBroadcast();
        console.log("CCIPTokenSender deployed at:", address(ccipTokenSender));
    }
}
