pragma solidity 0.8.7;
import './Owner.sol';
contract OwnerImported is Owner{
    uint number;

    function setNumber(uint _number) public isOwner {
        number = _number;
    }

    function getNumber() public view isOwner returns(uint){
        return number;
    }
    

}