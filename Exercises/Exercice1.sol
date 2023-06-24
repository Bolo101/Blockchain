//Combine struct, mapping and array
//Gestion des eleves d'une classe
pragma solidity 0.8.7;
contract Exercice1{
    struct eleve{
        string nom;
        string prenom;
        uint[] notes;
    }
    mapping(address => eleve) Eleves;

    function addNote(address _eleve, uint _note) public{
        Eleves[_eleve].notes.push(_note);
    }
    function getNote(address _eleve) public view returns(uint[] memory){
        return Eleves[_eleve].notes;
    }
    function setNom(address _eleve, string memory _nom) public{
        Eleves[_eleve].nom = _nom;
    }
    function getNom() public view returns(string memory){
        return Eleves[msg.sender].nom;
    }

}