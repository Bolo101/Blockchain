// SPDX-License-Identifier: GPL-3.0-only
/*ETH wallet with automatic global withdrawal returning all ethers to each senders
User's balance can only be accessed by him 
Owner can destruct the contract and return all funds to sending addresses
Credit:Bolo101
18/06/2023
*/
pragma solidity 0.8.7;
contract WalletETH2{
    address owner;
    address[] registre;//store of contract user's address
    uint numberUsers;//number of people using the contract
    struct user{
        uint balance;//ethers transfered by the user
        uint numberOfTransact;//number of transactions realised by the user
    }
    mapping(address => user) Wallets;//link each address with the related user
    receive() external payable{
        Wallets[msg.sender].balance = Wallets[msg.sender].balance + msg.value;//balance update
        Wallets[msg.sender].numberOfTransact +=1;
        if(Wallets[msg.sender].numberOfTransact == 1){//add the user to register if it is the first transaction 
            registre.push(msg.sender);
        }
        numberUsers +=1;
        
    }
    constructor(){//set owner of the contract when deployed
        owner = msg.sender;
    
    }

    function getNumberOfTransacts(address _user) public view returns(uint){
        return Wallets[_user].numberOfTransact;//view number of realised transactions
    }

    function getGlobalBalance() public view returns(uint){//get global funds deposited on the contract
        return address(this).balance;
    }

    function getBalance() public view returns(uint){//get balance of the person calling the contract
        return Wallets[msg.sender].balance;
    }

    function withdrawAllMoneyGlobalRoot(bool _confirmation) public {//owner can returns all funds to users
        require(msg.sender == owner, "Not the owner");//only the owner of the contract can run this function
        require(_confirmation,"Need to confirm");//additionel confirmation to avoid manipulation mistake
        for (uint i = 0; i < registre.length; i++) {
            address target = registre[i];//get user's address from register 
            uint account = Wallets[target].balance;//get available amount deposited by each user on the contract
            require(payable(target).send(account), "Transfer failed");
            Wallets[target].balance = 0;//set balance to 0 after transfer is done
        }
    }

    function convertEtherToWei(uint _ether) private pure returns(uint){//convert ether to wei, user's input is in Wei and we want to obtain ethers
        uint amountInWei = _ether * 10**18;
        return amountInWei;
    }

    function withdrawSpecificAmount(uint _amount) external{//user wants to withdraw a specific amount from the contract
        uint amountF = convertEtherToWei(_amount);//convert amount to withdraw in ether
        require(amountF <= Wallets[msg.sender].balance,"Please enter a lower amount to withdraw");//check balance
        require(payable(msg.sender).send(amountF),"Transfer failed");//send funds back to the user's address
        Wallets[msg.sender].balance = Wallets[msg.sender].balance - amountF;//update balance
    }

    function withdrawAllToUser(address _user) public{//user can get all its funds back to its address
        require(_user == msg.sender, "Not your account");
        require(payable(msg.sender).send(Wallets[msg.sender].balance),"Transfer failed");
        Wallets[msg.sender].balance = 0;
    }

    function destroy(bool _confirmation) public {//destruct contract and return all funds to user's address
        require(msg.sender == owner,"Not the owner");//owner has the hand
        withdrawAllMoneyGlobalRoot(_confirmation);//return funds
        selfdestruct(payable(msg.sender));//terminate contract
    }

    
    
    /**
    function withdrawMoney(bool _confirmation) public{
        require(msg.sender == owner,"Not the owner");
        require(_confirmation,"Not confirmed");
        for(uint i = 0 ; i < registre.length ; i++){
            address target = registre[i];
            uint account = Wallets[target].balance;
            Wallets[target].balance = 0;
            (bool succes, ) = target.call{value : account}("");
            require(succes,"Transfer failed");
            //.call returns two outputs
            //(bool succes,bytes memory data) = target.call{value : account}("");
            //First is a boolean for succes or fail of the transfert. Second one is returned data from the function
            //("") stands for no additional calldata (argument of an external function called or external transaction. It is read only data 
        
            
        }
    
    
    }
    */

}