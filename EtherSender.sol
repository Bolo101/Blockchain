pragma solidity 0.8.7;

contract EtherSender{
    address lastSender;
    uint balance;

                                //payable indique que l'on transfère des fonds
                                // external indique que le contrat est appelé uniquement depuis l'exterieur
                                //public peut etre appele depuis l'interieur ou l'exterieur
    receive() external payable{ 
        lastSender = msg.sender; //msg.sender contient l'adresse de la dernière personne qui a envoyé de l'argent
        balance = balance + msg.value; //msg.value est l'argent envoyé sur le contrat intelligent
    } 

    function getLastSender() public view returns(address){
        return lastSender;
    }

    function getBalance() public view returns(uint){
        return balance;
    }
}