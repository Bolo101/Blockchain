-include .env

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install smartcontractkit/chainlink-brownie-contracts@1.3.0 --no-git

deploy :
	forge script DeployFunctionsConsumer --rpc-url $(SEPOLIA_AL) --account metamask --broadcast --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv