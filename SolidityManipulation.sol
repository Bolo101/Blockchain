pragma solidity 0.8.7;

contract SolidityManipulation {
    uint nombre;
    bool monBool;
    address monAdresse;
    string maPhrase;

    function getNombre() public view returns(uint){
        return nombre;
    }

    function setNombre(uint _nombre) public {
        nombre = _nombre;
    }

    function getBool() public view returns(bool){
        return monBool;
    }

    function setBool(bool _bool) public{
        monBool = _bool;
    }

    function getAdresse() public view returns(address){
        return(monAdresse);
    }

    function setAdresse(address _monAdresse) public {
        monAdresse = _monAdresse;
    }

    function getPhrase() public view returns(string memory){
        return maPhrase;
    }

    function setPhrase(string memory _maPhrase) public {
        maPhrase = _maPhrase;

    }
}
