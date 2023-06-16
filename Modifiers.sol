pragma solidity 0.8.7;
contract Modifiers{
    uint number;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier isOwner(){//modifier is used to execute a function that must only be accessed by the owner, it sets privilegies
        require(msg.sender == owner,"Not the owner");
        _;//continue execution
    }

    function setNumber(uint _number) public isOwner{
        number = _number;
    }
    /** same as 
    function setNumber(uint _number) public isOwner{
        require(msg.sender == owner,"Not the owner");
        number = _number;
    }
    */

    function getNumber() public view isOwner returns(uint){
        return number
    }
}