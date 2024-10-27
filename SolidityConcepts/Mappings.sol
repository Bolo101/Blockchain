pragma solidity 0.8.7;
contract mappings{
    mapping(address => uint) Balances;//on lie une adresse à un uint. On definit la balance disponible pour une adresse
                                      //à partir de l'argent envoyé par l'adresse sur le contrat
    /**
    address lastPerson;
    uint balance;
    */
    receive() external payable{
        /**
        lastPerson = msg.sender;
        balance = msg.value;
        */
        Balances[msg.sender] = msg.value;
    }

    function getBalance(address _monadresse) public view returns(uint){
        return Balances[_monadresse];
    }
}