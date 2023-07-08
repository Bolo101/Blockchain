pragma solidity 0.8.7;
//can not convert an integer into a string directly on Solidity
import '@openzeppelin/contracts/utils/Strings.sol';//vetted library (https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/utils)

contract Library{
    function concatenate(string memory _string, uint _number1, uint _number2) external pure returns(string memory){
        string memory result = string(abi.encodePacked(_string,Strings.toString(_number1),Strings.toString(_number2)));//abi.encodePacked returnsa byte, need to convert it into a string
        return result;
    }
}
