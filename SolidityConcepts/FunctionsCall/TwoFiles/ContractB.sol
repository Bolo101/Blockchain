pragma solidity >=0.7.0 <0.9.0;
/*
In this contract we will the two contracts A and B into two different files. 
To do so we will add an interface in contractB containing function declarations
Then we will import contractB in contractA and point to contract B via the interface
*/

interface interfaceB {
    function getNumber() external view returns(uint);
    function setNumber(uint _number) external;
}

contract B{
    uint number;

    function getNumber() external view returns(uint){
        return number;
    }

    function setNumber(uint _number) external{
        number = _number;
    }
}