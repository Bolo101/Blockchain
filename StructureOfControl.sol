pragma solidity 0.8.7;
contract StructureOfControl{
    //Check the conformity of user's input
    uint nombre;
    function setNombre(uint _nombre)public{
        if(_nombre ==10){
            revert('le nombre ne peut pas etre egal a 10');//revert stop the function and give back remaining gas
        }
        nombre = _nombre;
    }
    function getNombre() public view returns(uint){
        return nombre;
    }
    /**
    function setNombre(uint _nombre) public{
        require(_nombre !=10,"nombre ne peut pas etre egal a 10");//also give back remaining gas
        //validate execution if the user is owner or not. Validate transmitted user's data
    }    
    //can also use 'assert' for less important issues such as a division by 0. Do not give gas back
    */
}