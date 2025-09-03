-include .env

.PHONY: all test deploy

build :; forge build

clean :; forge clean

test :
	forge test

install :
	forge install https://github.com/OpenZeppelin/openzeppelin-contracts@v5.2.0 --no-git && forge install smartcontractkit/chainlink-brownie-contracts@1.3.0 --no-git

deploy :
	forge script DeployCCIPTokenSender --rpc-url $(SEPOLIA_AL) --account metamask --broadcast 

balanceUSDC :
	cast call 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238 "balanceOf(address)" $(WALLET_ADDRESS) --rpc-url $(SEPOLIA_AL) --account metamask

approve:
	cast send 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238 "approve(address,uint256)" 0x16118C116daD9a94daB9e0cf7985eF0783FE340E 1000000 --rpc-url $(SEPOLIA_AL) --account metamask

feeCheck:
	cast call 0x16118C116daD9a94daB9e0cf7985eF0783FE340E "transferTokens(address,uint256)" $(WALLET_ADDRESS) 1000000 --rpc-url $(SEPOLIA_AL) --from $(WALLET_ADDRESS) --trace -vvvv

transfer:
	cast send 0x16118C116daD9a94daB9e0cf7985eF0783FE340E "transferTokens(address,uint256)" $(WALLET_ADDRESS) 500000 --rpc-url $(SEPOLIA_AL) --account metamask