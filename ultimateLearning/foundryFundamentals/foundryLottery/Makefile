-include .env

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :; forge install cyfrin/foundry-devops@0.2.2 --no-git && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-git && forge install foundry-rs/forge-std@v1.8.2 --no-git && forge install transmissions11/solmate@v6 --no-git

deploy-sepolia :
	@forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url $(SEPOLIA_AL) --account metamask --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv