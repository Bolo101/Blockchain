pragma solidity >=0.7.0 <0.9.0;

import "./ContractB.sol";

contract A {
    address addressB;

    function setAddressB(address _addressB) external{
        addressB = _addressB;
    }

    function callGetNumber() external view returns(uint){
        interfaceB b = interfaceB(addressB);
        return b.getNumber();
    }

    function callSetNumber(uint _number) external{
        interfaceB b = interfaceB(addressB);
        b.setNumber(_number);
    }
}

