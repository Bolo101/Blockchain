-include .env

build:; forge build 

snapshot :; forge snapshot

format :; forge fmt

test :; forge test

clean  :; forge clean

deploy:
	@forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

ifeq ($(findstring --network sepolia,$(ARGS)),--network sepolia)
	NETWORK_ARGS := --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
endif
#Network args --account is private key stored in cast wallet keystore


deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_AL) --private-key $(PRIVATE_KEY_META) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

withdraw:
	@forge script script/Interactions.s.sol:WithdrawFundMe --sender $(SENDER_ADDRESS) $(NETWORK_ARGS)
#Sender is account address. Network args --account is private key stored in cast wallet keystore