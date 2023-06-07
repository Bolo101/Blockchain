pragma solidity 0.8.7;

contract Arrays{
    uint[] nombre;//declaration hors d'une fonction, mode storage

    function addValue(uint _Value) public{
        nombre.push(_Value);
    }
    function updateValue(uint _Value, uint _index) public{
        nombre[_index] = _Value;
    }
    function deleteValue(uint _index) public{
        delete nombre[_index];
    }
    function getValue(uint _index) public view returns(uint){
        return nombre[_index];
    }
    function getNombrex2() public view returns(uint[] memory){//tableau retourné du type memory, on le specifie
        uint longueur = nombre.length;
        uint[] memory nombrex2 = new uint[](longueur);
        for(uint i = 0 ; i < longueur; i++) {
            nombrex2[i] = nombre[i] * 2;
        }
        return nombrex2;
    }
}