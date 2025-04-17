-include .env

build:; forge build 

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_AL) --private-key $(PRIVATE_KEY_META) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
