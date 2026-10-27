# Features and Benefits of Avalanche L1s

## Scalability of the Avalanche Network

Every blockchain has a limited capacity for computation and data storage. That means the number of transactions it can process in a given time and the amount of state it can store are limited. To scale horizontally and offer more blockspace, Avalanche adds more blockchains to the network.

A useful analogy is a highway system. A single highway can only handle a certain number of cars at once. If too many cars try to enter at the same time, congestion occurs and vehicles must wait. Building many highways in parallel creates additional space for cars to drive, which allows more transactions to be processed in parallel and increases the overall throughput of the network.

The strength of this approach is its simplicity. It does not require new untested consensus innovations. The main challenge is optimizing how Avalanche L1s interoperate and making it easy to move between different L1s.

## Independence From Other Avalanche L1s

Splitting the ecosystem into different chains creates independence between them. If congestion builds on one chain due to high network activity, such as an NFT drop, high token price volatility, or a new game launch, other chains remain unaffected. One chain's congestion or rising fees will not impact other chains.

In the highway analogy, scaling through multiple chains is like building many short highways in parallel. If congestion builds up on one highway, the other highways are not directly affected. Some cars may choose to take a different highway, which can reduce the traffic bottleneck.

In single-chain systems like Ethereum, congestion and rising fees affect everyone, including parties that have nothing to do with the cause of the activity increase. While monolithic blockchain designs offer advantages such as unified liquidity, fewer bridges, and potential user experience benefits from co-located dApps, they also introduce notable drawbacks.

Validators must use powerful, costly machines to support a diverse array of applications, which increases centralization due to high operational costs. A lack of modularity can halt all on-chain activity during network disruptions, potentially causing significant financial losses. Additionally, each new dApp competes for the same blockspace as all others, leading to overcrowding.

## Customizability

The creator of an Avalanche L1 can customize it to meet their needs. This can include introducing a custom gas token, using a different virtual machine such as WASM or Move VM, or limiting access to the L1. This is very difficult in a single-chain system because it would require majority agreement from all users.

In the highway analogy, imagine travelers with a unique requirement: they want to travel by boat instead of by car. While technically possible to build a water lane on a single highway system, this would be challenging. However, when these custom requirements are met in an Avalanche L1, it is easy to do.

The ability to choose or create custom virtual machines offers unprecedented flexibility. Avalanche L1s allow developers to:

- Support multiple VMs: Unlike single-VM networks like Bitcoin or Ethereum, Avalanche L1s can host multiple blockchain instances with different virtual machines.
- Use existing VMs easily: Leverage existing VMs like Subnet-EVM or create entirely new custom VMs using Avalanche SDKs to suit specific needs.
- Create network effects: This flexible architecture creates network effects both within individual blockchains and across different Avalanche L1s and blockchains.

## Enhanced Privacy, Compliance, and Access Control

While public blockchains offer transparency, many business scenarios require controlled visibility of transaction data. Developers building an Avalanche L1 can optionally enable:

- Selective transparency: Private blockchains allow you to limit transaction visibility to authorized participants.
- Data protection: Implement transaction encryption to safeguard sensitive information.
- Granular access: Control which data is visible to which participants, supporting need-to-know access models.

## Interoperability

Avalanche L1s come with native interoperability. They can communicate with each other and transfer assets between chains while maintaining independence.

### Avalanche Interchain Messaging (ICM)

ICM is the core protocol that enables cross-chain communication in Avalanche. It allows one L1 to send messages to another L1, call smart contracts on different chains, and coordinate actions across multiple blockchains. ICM removes the need to build custom bridges for each pair of chains, because all L1s can communicate through the same standardized messaging protocol.

### Cross-Chain Communication

ICM facilitates seamless interaction between different custom blockchains in the Avalanche network. Developers can design multi-chain applications where different parts run on different L1s but still interact as a single system.

### Asset Bridges

Avalanche L1s can create efficient bridges for asset transfers between custom blockchains and other networks. Avalanche Interchain Token Transfer (ITT) is one such mechanism that enables asset portability between chains.

## Summary of Benefits

Avalanche L1s combine scalability, independence, customizability, privacy controls, and interoperability. This makes them useful for applications that need dedicated performance and specialized rules without giving up the ability to participate in a broader connected ecosystem.

The main idea is simple: instead of forcing every application onto one shared blockchain, Avalanche gives each use case the option to run on its own optimized chain while still remaining part of a connected network through ICM.