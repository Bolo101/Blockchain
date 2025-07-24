-include .env

.PHONY: all test deploy

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install https://github.com/OpenZeppelin/openzeppelin-contracts@v5.2.0 --no-git

create :; forge create MyERC20 --account myaccount --rpc-url http://127.0.0.1:8545 --broadcast

mint :
	cast send $(CONTRACT_ADDRESS) "mint(address,uint256)" $(WALLET_ADDRESS) $(shell cast --to-wei 13322000350) --rpc-url $(LOCAL_RPC_URL) --account myaccount