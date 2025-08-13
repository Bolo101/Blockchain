-include .env

.PHONY: all test deploy

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install https://github.com/OpenZeppelin/openzeppelin-contracts@v5.2.0 --no-git && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-git

deployLocal :; forge create TimeBased --account myaccount --rpc-url $(LOCAL_RPC_URL) --broadcast

deploySepo :; forge create TimeBased --account metamask --rpc-url $(SEPOLIA_AL) --broadcast

deployShop :
	forge script DeployTimeBased --rpc-url $(LOCAL_RPC_URL) --broadcast --account myaccount

deployCustomLogic :
	forge script DeployCustomLogic --rpc-url $(LOCAL_RPC_URL) --broadcast --account myaccount