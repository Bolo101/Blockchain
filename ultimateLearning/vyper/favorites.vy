# This is how we state compiler version in Vyper and license:

# pragma version 0.4.0
# @license MIT

my_favorite_number: public(uint256) # 0


@external #decorator implies how the function can be called
def store(new_number: uint256):
    self.my_favorite_number = new_number

@external
@view #specify to not send a transaction
def retrieve() -> uint256: #execution cost only applied if called by the contract and not the user
    return self.my_favorite_number