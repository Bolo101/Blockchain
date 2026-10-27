# Set Up Validator Nodes

Now that the P-Chain records are in place, you can start syncing a node with your Subnet. Avalanche offers two ways to do this: a free managed testnet option and a self-hosted option using Docker. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/06-run-a-node)

## Run Your L1 Node

For quick experimentation, you can use Avalanche’s managed testnet infrastructure. This lets you deploy a node with one click, automatically configure it for your Subnet, and monitor it through the Builder Console. It is free for testnet development and does not require Docker or a cloud provider account. [build.avax](https://build.avax.network/academy/avalanche-l1/permissioned-l1s/03-create-an-L1/01-create-subnet)

This managed infrastructure is convenient for learning and short-term testing, but it is not intended for production use. Managed nodes shut down automatically after 3 days. [build.avax](https://build.avax.network/academy/avalanche-l1/permissionless-l1s/04-speedrun-base-l1/01-create-l1-speedrun)

## Self-Hosted Infrastructure

If you need a production-like setup, longer runtime, or more complex testing, you should run the node on your own infrastructure with Docker. This gives you full control over the environment and is the recommended option for extended testing and production deployments. [build.avax](https://build.avax.network/academy/l1-validator-management/02-l1-creation/06-run-a-node)

To run an Avalanche L1 node, the node must track the correct Subnet and be configured with the right L1 data. In the self-hosted model, you typically prepare the system, install Docker, and launch AvalancheGo with the parameters needed to follow the L1 and participate in its validation. [build.avax](https://build.avax.network/docs/nodes/run-a-node/avalanche-l1-nodes)

## Why This Step Matters

At this point, the blockchain exists on the P-Chain, but it still needs validator nodes to become operational. Once the validators are running, the chain can sync, expose its APIs, and eventually accept wallet connections and transactions. [build.avax](https://build.avax.network/docs/nodes)

The distinction is important: the P-Chain records define the blockchain, but the running validator nodes make the blockchain live. Without active nodes, the L1 is only a registered network object and not yet a usable chain. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/06-run-a-node)