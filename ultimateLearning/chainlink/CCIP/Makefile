-include .env

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install https://github.com/OpenZeppelin/openzeppelin-contracts@v5.2.0 --no-git && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-git
	