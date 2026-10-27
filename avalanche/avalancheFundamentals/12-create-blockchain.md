# Create a Blockchain

Now that Core Wallet is set up and you have AVAX on the P-Chain, you can create a Subnet. You do this by issuing a `CreateSubnetTx` transaction. This transaction creates a Subnet that is uniquely identified by the transaction hash of the `CreateSubnetTx`. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/05-create-blockchain)

The `CreateSubnetTx` transaction has one main parameter: the owner of the Subnet. The owner can add blockchains to the Subnet and later convert it into an L1. Once the Subnet is converted into an L1, the owner loses those special privileges. For that reason, the owner only matters at creation time, and a multisig is not strictly necessary if you plan to convert the Subnet immediately. In this example, your P-Chain address is used as the owner. [build.avax](https://build.avax.network/academy/avalanche-l1/permissioned-l1s/03-create-an-L1/01-create-subnet)

## Create the Blockchain Record

After creating the Subnet, you issue a `CreateChainTx` transaction on the P-Chain to create the blockchain record. This transaction registers the blockchain and links it to the Subnet created in the previous step. The blockchain is uniquely identified by the transaction hash of the `CreateChainTx`. [build.avax](https://build.avax.network/docs/primary-network/platformvm-architecture)

The `CreateChainTx` includes four important parameters:

- `name`: the name of the chain.
- `subnetID`: the ID of the Subnet the chain belongs to.
- `vmID`: the ID of the virtual machine that will run the chain.
- `genesisData`: the genesis configuration for the chain. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/05-create-blockchain)

## Genesis Configuration

The Genesis Builder tool lets you configure many aspects of the blockchain, including permissioning, tokenomics, and the transaction fee mechanism. These settings define how the chain will behave from the moment it is launched. [build.avax](https://build.avax.network/academy/customizing-evm/05-genesis-configuration/02-create-your-genesis)

You can inspect the available configuration options, but for this exercise you should keep the defaults and simply click **View Genesis JSON**. After that, click **Create Chain** to create the P-Chain record and associate the blockchain with the Subnet created earlier. [build.avax](https://build.avax.network/academy/customizing-evm/05-genesis-configuration/02-create-your-genesis)

## What This Means

At this stage, you have created the blockchain record on the P-Chain, but the chain does not yet have validator nodes. That means you cannot connect a wallet to it or issue transactions on it yet. The next step is to add validators so the chain becomes an operational L1. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/03-network-architecture)
