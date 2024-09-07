// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract FallbackExample {
    uint256 public result;

    receive() external payable {
        result = 1;
    }//can't add calldata in a receive. Calldate is for you looking for some function in your code
    //The default function is fallback function


    fallback() external payable {
        result = 2;
    }
}

contract FallbackFunction2 {

}