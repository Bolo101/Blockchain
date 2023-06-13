pragma solidity 0.8.7;
/**
Only the owner, the person who first deployed the contract, can set a number
A pause system is set up so that interactions are only available if not paused
*/
contract Owner{
    address owner;
    bool paused;
    uint nombre;

    constructor(){//constructor is a special function executed only when the contract is being deployed
        owner=msg.sender;//owner is the address who deployed the contract
    }

    function setBool(bool _paused) public {
        require(msg.sender == owner,"Not the owner");
        paused = _paused;
    }
    function setNombre(uint _nombre) public{
        require(!paused,"Contract is paused");
        require(msg.sender == owner,'Not the owner');
        nombre = _nombre; 
    }
    function getNombre() public view returns(uint){
        require(!paused,"Contract is paused");
        return nombre;
    }
    function destroy(address payable _to)public{    //when deleting a contract all funds must be withdrawed
        require(msg.sender == owner, "Not the owner");
        selfdestruct(_to);
    }
}