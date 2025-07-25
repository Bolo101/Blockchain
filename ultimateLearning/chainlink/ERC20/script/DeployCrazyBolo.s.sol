// script/Deploy.s.sol
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/myERC721.sol";

contract DeployCrazyBolo is Script {
    function run() external {
        vm.startBroadcast();

        CrazyBolo token = new CrazyBolo(msg.sender);

        vm.stopBroadcast();

        console.log("CrazyBolo deployed at:", address(token));
    }
}
