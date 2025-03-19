# What is foundry-zksync

Foundry-zksync is a specialized version of the Foundry development toolchain that's been modified to work with zkSync's Layer 2 scaling solution. It provides the familiar Foundry experience (forge, cast, anvil) while adding support for zkSync's unique features and infrastructure.

[GitHub Repository](https://github.com/matter-labs/foundry-zksync/tree/main?tab=readme-ov-file)

## Installation

Install foundry-zksync with the following command:

```bash
curl -L https://raw.githubusercontent.com/matter-labs/foundry-zksync/main/install-foundry-zksync | bash
```

## Switching Between Versions

To switch back to standard Foundry:
```bash
foundryup
```

To switch back to zkSync Foundry:
```bash
foundryup-zksync
```

## Build on zksync

Compile contract for zksync deploying:
```bash
forge build --zksync
```

## Launch anvil on zksync:

Run anvil for zksync node:
```bash
anvil-zksync
```

## Deploy on zksync:

Deploy smart contract on zksync locally running node:
```bash
foundry create scr/SimpleStorage.sol:SimpleStorage --rpc-url zksync-rpc-url --private-key $PRIVATE_KEY --zksync --legacy
```