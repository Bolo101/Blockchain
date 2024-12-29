//SPDX-License-Identifier: MIT 
pragma solidity 0.8.19;// add ^before compiler version if anything newer is accepted

contract SimpleStorage{
    //basic types: boolean, uint, int, address, bytes
    bool hasFavoriteNumber = true; //default value false
    uint256 favoriteNumber = 88; //default value 0
    string favoriteNumberInText = "eighty-eight";
    int256 favoriteInt = -88;
    bytes32 favoriteBytes = "cat";

    uint256 public myfavoriteNumber1;
    //uint[] listOfFavoriteNumbers;
    struct Person{
        uint256 favoriteNumber;
        string name;
    }
    Person[] public listOfPeople;

    mapping(string => uint) public nameTofavoriteNumber;

    //Person public myFriend = Person(7,"Pat");
    // Person public myFriend = Person({favoriteNumber: 7,name: "Pat"});
    // Person public Vin = Person({favoriteNumber: 7,name: "vin"});
    // Person public pati = Person({favoriteNumber: 7,name: "pati"});

    function store(uint _favoriteNumber) public{
        myfavoriteNumber1 = _favoriteNumber;
    }

    function retrieve() public view returns(uint256){
        return myfavoriteNumber1;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        listOfPeople.push(Person({favoriteNumber: _favoriteNumber, name : _name}));
        nameTofavoriteNumber[_name] = _favoriteNumber;
    }

}