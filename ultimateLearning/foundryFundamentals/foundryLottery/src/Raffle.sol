// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @title A simple Raffle contract
 * @author zkBolo
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */
contract Raffle {
    error Raffle_SendMoreToEnterRaffle(); //good practice is to include contract name in error code

    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        //require(msg.value >= i_entranceFee, "Not enough ETH sent!")
        // require(msg.value >= i_entranceFee, SendMoreToEnterRaffle()); since 0.8.26 but less gas efficient
        if (msg.value < i_entranceFee) {
            revert SendMoreToEnterRaffle();
        }
    }

    function pickWinner() public {}

    /**
     * Getters
     */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
