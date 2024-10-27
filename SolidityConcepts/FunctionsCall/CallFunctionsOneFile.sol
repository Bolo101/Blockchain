pragma solidity >=0.7.0 <0.9.0;
/*
Every deployed contract has its own address. Here we want to use functions from a contract without having to import it
*/
contract A{
    address addressB;//the value with be assign after contract B's deployement

    function setAddressB(address _addresseB) external{
        addressB = _addresseB;
    }

    function callGetNumber() external view returns(uint){
        B b = B(addressB); //we create a b variable that is contract B type. It is a pointer to contract B. With B(addressB) we convert the address B into the contract B
        return b.getNumber();
    }

    function callSetNumber(uint _number) external{
        B b = B(addressB);
        b.setNumber(_number);
    } 
}

contract B{
    uint number;

    function getNumber() public view returns(uint){
        return number;
    }

    function setNumber(uint _number) external{
        number = _number;
    }
}