pragma solidity 0.8.7;

contract Owner{
    address owner;

    constructor(){
        owner = msg.sender;//deployer of the contract is the owner
    }

    modifier isOwner(){
        require(msg.sender == owner,"Not the owner");//condition setting the modifier to execute targeted functions
        _;
    }
}
contract FlatManagement is Owner{

    uint counter;//manual id setter

    enum propertyType{field,flat,house}//kind of estate

    struct property{
        uint id;//counter 
        string name;
        uint price;
        propertyType _propertyType;
    }

    mapping(address => property[]) Assets;//collection of property struct arrays linked to an address

    function addRealEstate(address _owner,string memory _name, uint _price, propertyType _propertyType) public isOwner{//only owner can execute
        require(uint(_propertyType) >= 0,"Not in the range, too low");//property type verification
        require(uint(_propertyType) <=2,">Not in the range, too high");
        Assets[_owner].push(property(counter,_name,_price,_propertyType));//property added to the array collection of targeted address
        counter ++;
    }

    function getProperties(address _owner) public view isOwner returns(property[] memory){//returns all data for a specific address
        return Assets[_owner];
    }

    function getPropertiesByID(uint _index, address _owner) public view isOwner returns(property memory){//return data for a specific ID
        property[] memory properties = Assets[_owner];//get data in memory struct 'properties'
        for(uint i = 0; i < properties.length; i++){//read data
            if(properties[i].id == _index){//check condition
                return properties[i];// if condition matched, result is returned
            }
        } 
        revert("Unknown ID");
    }
    function getPropertiesByName(string memory _name, address _owner) public view isOwner returns(property memory){
        property[] memory properties = Assets[_owner];
        for(uint i = 0; i < properties.length; i++){
            if(keccak256(bytes(properties[i].name)) == keccak256(bytes(_name))){//can not check strings with == ; can not compare string with == operator, byte error returned so converted data in bytes before hash function to check the output 
                return properties[i];
            }
        } 
        revert("Unknown ID");
    }
    
}