-include .env

.PHONY: all test deploy

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install https://github.com/OpenZeppelin/openzeppelin-contracts@v5.2.0 --no-git

deployLocal :; forge create MyERC20 --account myaccount --rpc-url http://127.0.0.1:8545 --broadcast

mintLocal :
	cast send $(CONTRACT_ADDRESS) "mint(address,uint256)" $(WALLET_ADDRESS) $(shell cast --to-wei 133220) --rpc-url $(LOCAL_RPC_URL) --account myaccount

deploySepo :; forge create MyERC20 --account metamask --rpc-url $(SEPOLIA_AL) --broadcast

mintSepo :
	cast send $(CONTRACT_ADDRESS) "mint(address,uint256)" $(WALLET_ADDRESS) $(shell cast --to-wei 133220) --rpc-url $(SEPOLIA_AL) --account metamask