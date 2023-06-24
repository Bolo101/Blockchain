pragma solidity 0.8.7;

contract EtherSender{
    address lastSender;
    uint balance;

                                //payable means we transfer funds
                                // external means the contract is called from the exterior
                                //public can be called from both inside and outside
    receive() external payable{ 
        lastSender = msg.sender; //msg.sender contains the address of the last person who sent money to the contract
        balance = balance + msg.value; //msg.value is the money sent on the intelligent contract
    } 

    function getLastSender() public view returns(address){
        return lastSender;
    }

    function getBalance() public view returns(uint){
        return balance;
    }
}