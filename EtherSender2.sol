pragma solidity 0.8.7;
contract EtherSender2{
    struct data{
        uint balance;
        uint interactions;
    }
    mapping(address => data) Sender;
    receive() external payable{
        Sender[msg.sender].balance += msg.value;
        Sender[msg.sender].balance += 1;
    }

    function getBalance(address _client) public view returns(uint){
        return Sender[_client].balance;
    }

    function getInteractions(address _client) public view returns(uint){
        return Sender[_client].interactions;
    }
}