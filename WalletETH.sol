pragma solidity 0.8.7;
contract walletETH{

    struct wallet{
        uint money;
        uint numPayments;
    }

    mapping(address => wallet) Wallets;

    receive() external payable{
        Wallets[msg.sender].money += msg.value;
        Wallets[msg.sender].numPayments += 1;
    }

    function getGlobalBalance() public view returns(uint){
        return address(this).balance;
    }
    function getBalance() public view returns(uint){
        return Wallets[msg.sender].money;
    }
    function withdrawAllMoney(address payable _to) public {
        uint _amount = Wallets[msg.sender].money;
        _to.transfer(_amount);
        Wallets[msg.sender].money = 0;
    }

}