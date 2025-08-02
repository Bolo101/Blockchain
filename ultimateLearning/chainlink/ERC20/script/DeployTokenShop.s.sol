// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {BoloToken} from "../src/MyERC20.sol";
import {TokenShop} from "../src/TokenShop.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";

contract DeployTokenShop is Script {
    function run() external returns (BoloToken, TokenShop) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();

        BoloToken token = new BoloToken();
        TokenShop tokenShop = new TokenShop(
            address(token),
            address(ethUsdPriceFeed)
        );

        token.grantRole(token.MINTER_ROLE(), address(tokenShop));

        vm.stopBroadcast();

        console.log("BoloToken deployed at:", address(token));
        console.log("TokenShop deployed at:", address(tokenShop));

        return (token, tokenShop);
    }
}
