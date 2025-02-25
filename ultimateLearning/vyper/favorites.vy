# This is how we state compiler version in Vyper and license:

# pragma version 0.4.0
# @license MIT

struct Person:
    favorite_number: uint256
    name: String[100]

struct Custom:
    value: uint256
    value1: uint256

my_name: public(String[100])
my_favorite_number: public(uint256) # 0

list_of_number: public(uint256[5]) #[0,0,0,0,0]
list_of_people: public(Person[5])
list_of_custom: public(Custom[5])
index_custom: public(uint256)
index: public(uint256)

name_to_favorite_number: public( HashMap[String[100], uint256])

# Constructor
@deploy
def __init__():
    self.my_favorite_number = 9
    self.index = 0
    self.my_name = "Bolo"

@external #decorator implies how the function can be called
def store(new_number: uint256):
    self.my_favorite_number = new_number

@external
@view
def retrieve_custom(index: uint256) -> (uint256, uint256):
    return self.list_of_custom[index].value, self.list_of_custom[index].value1

@external
def add_custom(_value: uint256, _value1: uint256):
    new_value: Custom = Custom(value = _value, value1 = _value1)
    self.list_of_custom[self.index_custom] = new_value
    self.index_custom = self.index_custom + 1


@external
@view #specify to not send a transaction
def retrieve() -> uint256: #execution cost only applied if called by the contract and not the user
    return self.my_favorite_number

@external
def add():
    self.my_favorite_number = self.my_favorite_number + 1

@external
def add_person(_name:String[100], _favorite_number: uint256):
    # Add favorite number to numbers list
    self.list_of_number[self.index] = _favorite_number

    # Add the person to the person's list
    new_person: Person = Person(favorite_number = _favorite_number, name = _name)
    self.list_of_people[self.index] = new_person

    # Add person to the hashmap
    self.name_to_favorite_number[_name] = _favorite_number
    self.index = self.index + 1