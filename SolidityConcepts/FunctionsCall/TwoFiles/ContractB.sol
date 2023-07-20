pragma solidity >=0.7.0 <0.9.0;
/*
In this contract we will the two contracts A and B into two different files. 
To do so we will add an interface in contractB containing function declarations
Then we will import contractB in contractA and point to contract B via the interface
*/

interface interfaceB {
    function getNumber() external view returns(uint);
    function setNumber(uint _number) external;
/*
The interface enable to ensure the security of the contract, only public functions can be called and you cannot access private variables as example.
It is also easier to read and understand than just importing a targetted contract. 
It is also more scalable if you need to update your main contract.
Using a common interface is also a way to improve interoperability with contract developped by other developpers.
Less gas consumption
*/
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