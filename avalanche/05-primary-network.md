# The Primary Network
The Primary Network is the foundational layer of the Avalanche ecosystem. It serves as the backbone that coordinates and secures activity across the network, including communication between different Avalanche L1s.

## What Is the Primary Network?
The Primary Network consists of three built-in blockchains that provide the core functionality of Avalanche:

- **P-Chain (Platform Chain)**: Coordinates validators, tracks active L1s, and manages staking.
- **C-Chain (Contract Chain)**: An EVM-compatible blockchain for smart contracts and DeFi applications.
- **X-Chain (Exchange Chain)**: Optimized for creating and transferring digital assets.

These three chains form the Primary Network, which all validators must validate. This shared validation model gives the ecosystem a common security base. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)

## Role in the Avalanche Ecosystem
The Primary Network plays several critical roles.

### Validator Coordination
All validators on Avalanche must validate the Primary Network. This creates a shared security model where the network benefits from the collective participation of all validators. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)

### L1 Registration and Management
When developers create an Avalanche L1, they register it on the P-Chain. This registration defines validator requirements, staking rules, and the L1’s relationship with the Primary Network. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)

### AVAX Token Management
AVAX is the native token of Avalanche. It is used for transaction fees, staking, and securing the network through Proof-of-Stake consensus. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)
### Interoperability Foundation

The Primary Network also supports interoperability between Avalanche L1s through Avalanche Interchain Messaging. In that context, BLS signatures are especially important because they allow validators to collectively sign messages in a compact and efficient way. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)

## BLS Signatures
BLS stands for Boneh-Lynn-Shacham. It is a cryptographic signature scheme designed for efficient multi-signature use, and it is especially useful in blockchain systems where many validators need to produce one verifiable collective signature. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)

The main advantage of BLS is **aggregation**:

- **Signature aggregation** combines many individual signatures into one short signature.
- **Public key aggregation** combines the corresponding public keys into a single aggregated key for verification. [build.avax](https://build.avax.network/academy/avalanche-fundamentals/05-interoperability/06-multi-signatures)

This makes verification and transmission much more efficient than handling many separate signatures. In Avalanche, this is useful for validator coordination and cross-chain messaging, where compact proof from a group of validators is more practical than collecting many separate signatures. [build.avax](https://build.avax.network/docs/nodes/maintain/cube-signer-sidecar)

## Why BLS Matters
BLS helps Avalanche scale trust-minimized communication across the ecosystem. Because the signature is compact and can represent multiple validators at once, it reduces bandwidth and simplifies verification. This is one of the reasons BLS is a good fit for systems like Avalanche Warp Messaging and other interchain workflows. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)

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

The main role of the Primary Network is to provide a stable and secure base that all Avalanche L1s can rely on, while BLS signatures help make validator-based interoperability efficient and compact. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/05-interoperability/06-multi-signatures)
