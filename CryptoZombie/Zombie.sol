pragma solidity  >=0.5.0 <0.6.0;

contract ZombieFactory {

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;//dnaModulus is equal to 1 followed by 16 0.

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    function _createZombie(string memory _name, uint _dna) private {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;//IMPORTANT:zombies.push(...) returns the lentgth of the array
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus; // the return is going to be a number between 0 and a sequence of 10¹⁶-1. So the maximum value is 9 999 999 999 999 999 (16 characters)
    }

    function createRandomZombie(string memory _name) public{
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
