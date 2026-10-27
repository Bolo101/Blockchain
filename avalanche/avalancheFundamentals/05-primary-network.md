# The Primary Network

The Primary Network is the foundational layer of the Avalanche ecosystem. It serves as the backbone that coordinates and secures activity across the network, including communication between different Avalanche L1s.

## What Is the Primary Network?

The Primary Network consists of three built-in blockchains that provide the core functionality of Avalanche:

- **P-Chain (Platform Chain)**: Coordinates validators, tracks active L1s, and manages staking.
- **C-Chain (Contract Chain)**: An EVM-compatible blockchain for smart contracts and DeFi applications.
- **X-Chain (Exchange Chain)**: Optimized for creating and transferring digital assets.

These three chains form the Primary Network, which all validators must validate. This shared validation model gives the ecosystem a common security base.

## Role in the Avalanche Ecosystem

The Primary Network plays several critical roles.

### Validator Coordination

All validators on Avalanche must validate the Primary Network. This creates a shared security model where the network benefits from the collective participation of all validators.

### L1 Registration and Management

When developers create an Avalanche L1, they register it on the P-Chain. This registration defines validator requirements, staking rules, and the L1's relationship with the Primary Network.

### AVAX Token Management

AVAX is the native token of Avalanche. It is used for transaction fees, staking, and securing the network through Proof-of-Stake consensus.

### Interoperability Foundation

The Primary Network provides the foundation for interoperability between different Avalanche L1s through **Avalanche Interchain Messaging (ICM)**. ICM is the protocol that enables secure cross-chain communication directly between custom blockchains in the Avalanche network.

With ICM, an L1 can send messages to other L1s, call smart contracts on different chains, and coordinate actions across multiple blockchains. This allows developers to build multi-chain applications where different parts of the system run on different L1s but still work together seamlessly. ICM eliminates the need for custom bridges for each pair of chains, because all L1s can communicate through the same standardized messaging protocol. [知网:build.avax]

## BLS Signatures

BLS stands for **Boneh-Lynn-Shacham**. It is a cryptographic signature scheme designed for efficient multi-signature use, and it is especially useful in blockchain systems where many validators need to produce one verifiable collective signature.

The main advantage of BLS is **aggregation**:

- **Signature aggregation** combines many individual signatures into one short signature.
- **Public key aggregation** combines the corresponding public keys into a single aggregated key for verification.

This makes verification and transmission much more efficient than handling many separate signatures. In Avalanche, BLS signatures are useful for validator coordination and cross-chain messaging, where compact proof from a group of validators is more practical than collecting many separate signatures.

## Why BLS Matters for ICM

BLS helps Avalanche scale trust-minimized communication across the ecosystem through ICM. Because the signature is compact and can represent multiple validators at once, it reduces bandwidth and simplifies verification. This is particularly useful for ICM, where validators from different L1s need to verify messages originating from other chains in an efficient way.

BLS is therefore a good fit for systems like Avalanche Interchain Messaging and Avalanche Warp Messaging, which rely on compact validator signatures to enable cross-chain trust.

## Primary Network vs. Avalanche L1s

While Avalanche L1s provide flexibility and customization, the Primary Network provides stability and shared security.

| Feature | Primary Network | Avalanche L1s |
|---|---|---|
| Validator Set | All Avalanche validators | Custom validator set |
| Consensus Rules | Fixed Avalanche consensus | Customizable |
| Gas Token | AVAX | Custom token or AVAX |
| Virtual Machine | Fixed built-in chains | Customizable |
| Security Model | Shared across the ecosystem | Independent |
| Access Control | Permissionless | Permissionless or permissioned |

The main role of the Primary Network is to provide a stable and secure base that all Avalanche L1s can rely on, while ICM enables interoperability and BLS signatures make validator-based cross-chain messaging efficient and compact.