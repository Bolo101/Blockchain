pragma solidity >=0.7.0 <0.9.0;
/*
String checker using to different methods. One converting the strings into bytes by calling bytes method and the other one by calling abi.encodePacked() method

*/

interface StringCkecher {
    function stringCkeckerBytes(string memory _test) external view returns(bool);
    function stringConvertAbi(string memory _test) external view returns(bool);
}

contract test{
    string pass = "test";
/*
Creates a bytes board. Every caracter is associated to its ASCII code. The hash function is then applied on the bytes board
*/
    function stringCkeckerBytes(string memory _test) external view returns(bool){
        if (keccak256(bytes(_test))== keccak256(bytes(pass))){
            return true;
        }
        else {
            return false;
        }
    }
/*
Creates an encoded representation of the string as a bytes sequence in hexadecimal byte. 
*/
    function stringConvertAbi(string memory _test) external view returns(bool){
        if (keccak256(abi.encodePacked(_test)) ==keccak256(abi.encodePacked(pass)) ){
            return true;
        }
        else{
            return false;
        }
    }
}