// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {BoloToken} from "./MyERC20.sol";

contract TokenShop is Ownable {
    AggregatorV3Interface internal immutable i_priceFeed;
    BoloToken public immutable i_token;

    uint256 public constant TOKEN_DECIMALS = 18;
    uint256 public constant TOKEN_USD_PRICE = 2 * 10 ** TOKEN_DECIMALS; //USD price with 18 decimals

    event BalanceWithdrawn();

    error TokenShop__ZeroETHSent();
    error TokenShop__CouldNotWithdraw();

    constructor(address tokenAddress) Ownable(msg.sender) {
        i_token = BoloToken(tokenAddress);
        /**
         * Network: Sepolia
         * Aggregator: ETH/USD
         * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
         */
        i_priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    receive() external payable {
        if (msg.value == 0) {
            revert TokenShop__ZeroETHSent();
        }
        i_token.mint(msg.sender, amountToMint(msg.value));
    }

    function amountToMint(uint256 amountInETH) public view returns (uint256) {
        uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer()) * 10 ** 10; // ETH/USD price with 8 decimal places -> 18 decimals
        uint256 ethAmountInUsd = (amountInETH * ethUsd) / 10 ** 18; //ETH with 18 decimals
        return ((ethAmountInUsd * 10 ** TOKEN_DECIMALS) / TOKEN_USD_PRICE);
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        (, /*uint80 roundID*/ int price, , , ) = /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/
        i_priceFeed.latestRoundData();
        return price;
    }
}
