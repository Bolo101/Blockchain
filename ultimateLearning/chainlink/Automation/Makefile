-include .env

.PHONY: all test deploy

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install https://github.com/OpenZeppelin/openzeppelin-contracts@v5.2.0 --no-git && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-git

deploySepo :; forge create TimeBased --account metamask --rpc-url $(SEPOLIA_AL) --broadcast

deployTime :
	forge script DeployTimeBased --rpc-url $(LOCAL_RPC_URL) --broadcast --account myaccount

deployCustomLogic :
	forge script DeployCustomLogic --rpc-url $(LOCAL_RPC_URL) --broadcast --account myaccount

deployCustomSepo :
	forge script DeployCustomLogic --rpc-url $(SEPOLIA_AL) --broadcast --account metamask

deployLogTrigger :
	forge script DeployLogTrigger --rpc-url $(LOCAL_RPC_URL) --broadcast --account myaccount

deployLogSepo :
	forge script DeployLogTrigger --rpc-url $(SEPOLIA_AL) --broadcast --account metamask