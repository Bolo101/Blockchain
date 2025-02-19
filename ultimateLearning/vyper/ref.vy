# pragma version 0.4.0
# @license MIT

# Fixed size array
nums: public(uint256(10))

# Dynamic arrays

# Mapping
myMap: public(HashMap[address, uint256])

# Struct
struct Person:
    name: String[10]
    age: uint256

person: public(Person)


@deploy
def __init__():
    self.nums[0] = 123
    self.nums[1] = 493

    self.myMap[msg.sender] = 1
    self.myMap[msg.sender] = 11

    self.person.name = "vyper"
    self.person.age = 12

    p: Person = self.person
    p.name = "solidity"
    p.age = 21