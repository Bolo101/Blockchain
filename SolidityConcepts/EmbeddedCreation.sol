pragma solidity 0.8.7;
/*
Create a contract from another contract. Prevent vulnerabilitie exploitations.
*/
contract FactoryNumber {
    Number[] numbersContracts; //collection of Number type contract, not useful for now

    function createNumberContract() external returns(address){
        Number n = new Number(100);//100 is the argument for the Number's constructor
        numbersContracts.push(n);
        return address(n);
    }

    function getNumberByContract(Number _Contract) external view returns(uint){//get number by refering the contract and then applying
        return _Contract.getNumber();
    }

    function setNumberByContract(Number _Contract, uint _number) external {
        _Contract.setNumber(_number);
    }
}

contract Number {
    uint number;
    
    constructor(uint _number){ 
        number = _number;
    }

    function getNumber() external view returns(uint){
        return number;
    }

    function setNumber(uint _number) external {
        number = _number;
    }
}