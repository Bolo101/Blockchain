// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

//import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256; //can use every function from the library as a method on any uint256 variable in our main contract code

    uint256 public constant MINIMUM_USD = 5e18; //add constant to limit gas fees because it no longer takes a storage spot. Only if the value is not modified

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner; //immutable as this value is not going to be modified. More gas efficient

    receive() external payable {
        //in case fund function is not used correctly
        fund();
    }

    fallback() external payable {
        //in case fund function is not used correctly
        fund();
    }

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        //payable means we can transfer funds
        //allow  users to send funds
        //set a minimum amount to pay
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Not enough eth to send"); // at leats one ether
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); //reset funder array with initial length of zero
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        revert();
    }

    modifier onlyOwner() {
        //require(msg.sender == i_owner, "Not the owner");
        // to be more gas efficient we can use custom error instead of require
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    // msg.sender = address and payable(msg;sender) = payable address
    //transfer  simplest one. (msg.sender.transfert(address(this).balance) this is the contract
    // transfer throw an error if gas are over 2300 for the operation and operation is reverted
    //send returns a boolean if gas are over 2300, only revert if we add a require
    // bool sendSucess = payable(msg.sender).send(address(this).balance);
    // require(sendSuccess, "Send failed");
    //call
    // payable(msg.sender).call{value: address(this).balance)("") call("") is for calling a function, we live it empty here.
    // call returns two variables
    // (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("")
    //dataReturned is useful if we call a function
    // (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("")
    // require(callSuccess, "Call failed");
}
