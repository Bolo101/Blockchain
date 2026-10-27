To convert your Subnet to a sovereign L1 and add your node as a validator, **use the `ConvertToL1` tool** in the Academy page (the `<ToolboxMdxWrapper>` with `walletMode="c-chain"`).

### What happens during conversion

| Aspect | What changes |
|--------|--------------|
| **Transaction** | Issues a `ConvertSubnetToL1Tx` on the **P-Chain** |
| **Result** | Transforms the Subnet into a **sovereign L1** with its own validator set |
| **Frequency** | **One-time only** — can only be executed once by the Subnet owner, irreversible |
| **Ownership** | After conversion, the Subnet owner **loses all privileges**; the L1 is controlled by the **Validator Manager Contract (VMC)** which manages the validator set |

### Parameters you need to provide

| Parameter | What to use |
|-----------|-------------|
| **Subnet ID** | Your Subnet's unique identifier (from the `CreateSubnetTx` transaction hash) |
| **Validator Manager Blockchain ID** | Typically your new L1's blockchain ID (can also be C-Chain or another L1) |
| **Validator Manager Address** | Pre-deployed proxy: `0xfacade0000000000000000000000000000000000` (OpenZeppelin TransparentUpgradeableProxy from `genesis.json`) |
| **Validators** | Add the node you just launched in the previous step |

### Important note about the Validator Manager

The Validator Manager Address starts as a **pre-deployed proxy contract** in your `genesis.json`. After conversion, you'll need to deploy the actual `ValidatorManager` implementation contract and update the proxy to point to it.

### Prerequisites

- Make sure you have **test AVAX on both the C-Chain and P-Chain** (claim from the Builder Console if needed)
- Your node should already be running and tracking the Subnet

After conversion, test your new L1 by deploying an ERC-20 token using the Builder Tooling.