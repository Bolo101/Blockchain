# Foundry imports

Contrary to Remix, Foundry cannot import code from online ressources.
To get the AggregatorV3 Interface we have to download the file from Github using forge:

```bash
forge install smartcontractkit/chainlink-brownie-contracts@1.1.0 --no-commit
```

The contracts being on [Chainlink Github repo](https://github.com/smartcontractkit/chainlink-brownie-contracts) 

Once downloaded, we need to create a remapping in the foundry.toml to replace the online import ressources call by local code downloaded.

```toml
remappings = ["@chailink/contracts/=lib/chainlink-brownie-contracts/contracts/"]
```


