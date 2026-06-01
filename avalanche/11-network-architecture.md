# Network Architecture
To create an Avalanche L1, you follow three main steps:

1. Create a Subnet record on the P-Chain with a `CreateSubnet` transaction.
2. Add one or more chains to that Subnet with a `CreateChain` transaction.
3. Convert the Subnet into an L1 and add the initial validators with a `ConvertSubnetToL1` transaction. [docs.avax](https://docs.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/07-convert-subnet-l1)
## Validators in a Multi-Chain Network
Validators are nodes that secure a blockchain by validating transactions and participating in consensus. In Avalanche, each L1 has its own validator set, and those validators run the AvalancheGo client. A single node can validate multiple chains within the same L1, depending on how that L1 is configured. [build.avax](https://build.avax.network/docs/nodes/architecture)

This model gives each L1 sovereignty while still keeping it part of the broader Avalanche ecosystem. The validator set is not shared in the same way as on a monolithic blockchain, which is what allows Avalanche L1s to be more isolated and customizable. [github](https://github.com/ava-labs/builders-hub/blob/master/content/docs/quick-start/avalanche-l1s.mdx)
## Platform Chain
The Platform Chain, or P-Chain, is the metadata and coordination layer of Avalanche. It keeps track of validators, staking, subnets, and chain creation, and it is the registry used to manage the network structure. The P-Chain runs PlatformVM, which is not EVM-based, so interacting with it requires a compatible wallet such as Core. [build.avax](https://build.avax.network/academy/l1-validator-management/01-recap/01-pchain)

For each validator, the P-Chain stores key information such as:

- A unique node ID.
- A BLS public key.
- Stake weight.
- The validator’s balance for continuous interoperability fees. [docs.gogopool](https://docs.gogopool.com/minipool/avalanche-bls-keys)

Builders use the P-Chain to create and manage new L1 blockchains by issuing transactions such as `CreateSubnetTx`. Even though L1 validators track the P-Chain state, they do not participate in P-Chain consensus itself; they only sync its latest validator-set information. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/03-network-architecture)
## Subnets and L1s
Earlier Avalanche architecture used the concept of Subnets, which were blockchains validated by a subset of Primary Network validators. A validator could belong to multiple Subnets, and each Subnet could have multiple validators. In that older model, validators also had to satisfy the Primary Network staking requirements, and they could not opt out of validating the Primary Network. [build.avax](https://build.avax.network/academy/l1-validator-management/01-recap/01-pchain)

That terminology is still present in the codebase and transaction names, but new deployments are generally recommended to use the L1 model instead. An L1 gives the same general idea of an independent validator set and custom blockchain logic, while fitting the newer Avalanche architecture more cleanly. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/03-network-architecture)
## Converting a Subnet to an L1
The final step is the `ConvertSubnetToL1` transaction. This one-time transaction transforms the Subnet into a sovereign L1 and adds the initial validators at the same time. After the conversion, the subnet owner loses its special privileges, and the L1 is controlled by a validator manager contract that manages the validator set. [docs.avax](https://docs.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/07-convert-subnet-l1)

The conversion transaction includes:

- The Subnet ID.
- The validator manager blockchain ID.
- The validator manager address.
- The initial validators for the L1. [docs.avax](https://docs.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/07-convert-subnet-l1)

This conversion step is what turns a registered Subnet into a fully fledged Avalanche L1 with its own validator management and operating rules. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/01-creating-an-l1)
## Why This Architecture Matters
This architecture separates coordination, execution, and validator management into different layers. The P-Chain handles metadata and validator registration, while each L1 handles its own execution and consensus environment. That separation is what allows Avalanche to support many different blockchains without forcing them all to share the same execution path. [build.avax](https://build.avax.network/docs/nodes/architecture)

The result is a network that is modular, scalable, and easier to extend. Builders can create specialized chains without changing the behavior of the entire system, while still benefiting from the interoperability and validator infrastructure of the Avalanche ecosystem. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/04-creating-an-l1/03-network-architecture)