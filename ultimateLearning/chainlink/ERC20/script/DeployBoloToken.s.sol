// script/Deploy.s.sol
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/myERC20.sol";

contract DeployBoloToken is Script {
    function run() external {
        vm.startBroadcast();

        BoloToken token = new BoloToken();

        vm.stopBroadcast();

        console.log("BoloToken deployed at:", address(token));
    }
}
