pragma solidity ^0.8.7;
/**
Separate the rights management part from the application part in two different contracts
*/

contract Owner{//set owner privilege

    address owner;
    
    constructor(){
        owner = msg.sender;//owner is the person who deployed the contract
    }

    modifier isOwner() {
        require(msg.sender == owner,"Not the owner");//condition to process
        _;//continue processing
    }
}



contract Heritage is Owner{//heritage from Owner of owner privilege required to process functions

    uint number;
    
     function getNumber() public view isOwner returns(uint){
         return number;
     }

     function setNumber(uint _number) public isOwner {
        number = _number;
     }
}
