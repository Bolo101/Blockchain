-include .env

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install https://github.com/OpenZeppelin/openzeppelin-contracts@v5.2.0 --no-git && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-git

deployLocal :; forge create MyERC20 --account myaccount --rpc-url $(LOCAL_RPC_URL) --broadcast

mintLocal :
	cast send $(CONTRACT_ADDRESS) "mint(address,uint256)" $(WALLET_ADDRESS) $(shell cast --to-wei 133220) --rpc-url $(LOCAL_RPC_URL) --account myaccount

deploySepo :; forge create MyERC20 --account metamask --rpc-url $(SEPOLIA_AL) --broadcast

mintSepo :
	cast send $(CONTRACT_ADDRESS) "mint(address,uint256)" $(WALLET_ADDRESS) $(shell cast --to-wei 133220) --rpc-url $(SEPOLIA_AL) --account metamask

deploynft :
	forge script DeployCrazyBolo --rpc-url $(LOCAL_RPC_URL)

deploybt :
	forge script DeployBoloToken --rpc-url $(LOCAL_RPC_URL) --broadcast --account myaccount

deployShop :
	forge script DeployTokenShop --rpc-url $(LOCAL_RPC_URL) --broadcast --account myaccount