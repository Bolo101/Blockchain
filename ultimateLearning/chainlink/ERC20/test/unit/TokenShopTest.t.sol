// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployTokenShop} from "script/DeployTokenShop.s.sol";
import {BoloToken} from "src/MyERC20.sol";
import {TokenShop} from "src/TokenShop.sol";
import {AccessControl} from "@openzeppelin/contracts@5.4.0/access/AccessControl.sol";

contract TokenShopTest is Test, AccessControl {
    TokenShop tokenShop;
    BoloToken token;
    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployTokenShop deployTokenShop = new DeployTokenShop();
        (token, tokenShop) = deployTokenShop.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testBoloTokenDeploy() public view {
        assertFalse(address(token) == address(0));
    }

    function testTokenShopDeploy() public view {
        assertFalse(address(tokenShop) == address(0));
    }

    function testMinterRoleAttribution() public view {
        // Test that TokenShop has the MINTER_ROLE using hasRole
        bool hasRole = token.hasRole(token.MINTER_ROLE(), address(tokenShop));
        assertTrue(hasRole);
    }

    function testPriceFeedAttribution() public view {
        assertFalse(address(tokenShop.getPriceFeedAddress()) == address(0));
    }

    function testReceiveRevertNotETH() public view {}
}
