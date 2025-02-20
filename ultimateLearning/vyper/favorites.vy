# This is how we state compiler version in Vyper and license:

# pragma version 0.4.0
# @license MIT

struct Person:
    favorite_number: uint256
    name: String[100]

my_name: public(String[100])
my_favorite_number: public(uint256) # 0

list_of_number: public(uint256[5]) #[0,0,0,0,0]
list_of_people: public(Person[5])
index: public(uint256)

name_to_favorite_number: public( HashMap[String[100], uint256])

# Constructor
@deploy
def __init__():
    self.my_favorite_number = 7
    self.index = 0
    self.my_name = "Bolo"

@external #decorator implies how the function can be called
def store(new_number: uint256):
    self.my_favorite_number = new_number

@external
@view #specify to not send a transaction
def retrieve() -> uint256: #execution cost only applied if called by the contract and not the user
    return self.my_favorite_number

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