# Avalanche L1 Course Cheatsheet

Essential concepts from the full course: consensus, L1 architecture, creating an L1, interoperability (ICM/ICTT), and BLS signatures.

## 1. Consensus Basics

- **Consensus** = how validators agree on one shared ledger state and on the **order** of transactions (no central authority).
- **Double-spend**: same funds spent twice in conflicting transactions (e.g. Alice sends the same 5 AVAX to Bob and Charlie). Consensus makes sure only one is accepted.
- Timestamps alone are not enough: validators may receive transactions in different orders, so the network must agree on a shared ordering.

## 2. Avalanche Consensus (Snow family)

**Core idea:** repeated **random sub-sampling**. Each validator asks a small random subset of validators for their preference, adopts a strong majority, and repeats until confident. No all-to-all communication.

| Protocol | Role |
| --- | --- |
| **Snowball** | Core metastable voting on conflicting choices |
| **Snowman** | Extends Snowball to a **linear chain of blocks** (used by Avalanche execution chains) |

### Parameters

| Symbol | Name | Meaning | Real-world value |
| --- | --- | --- | --- |
| n | Participants | Total validators | n/a |
| **k** | Sample size | Validators queried per round | 20 |
| **α** | Quorum | Min. agreeing responses to count a round / change preference | 14 |
| **β** | Decision threshold | Consecutive successful rounds to finalize | 20 |

*(Teaching example in the course uses k=5, α=3, β=8.)*

### How a round works

1. Sample k validators and ask their preference.
2. If ≥ α agree on an option, adopt it. The round is a success.
3. Repeat. After **β consecutive successes**, the decision is final.
4. Honest nodes cluster on one choice via a **positive feedback loop**, and the conflicting option is rejected.

**Mini-example:** k=20, 16 votes for Block A and 4 for B. 16 ≥ α=14, so prefer A. After 20 consecutive such rounds, A is finalized.

### Key properties

- **Transitive voting:** a vote for a block counts for its ancestors too, which boosts throughput.
- **Stake-weighted:** validators bond AVAX, and higher stake means being sampled more often (Sybil resistance).
- Guarantee (with high probability, depending on parameters): if one honest validator accepts, all honest validators eventually will.
- Benefits: fast finality, low communication overhead, strong scalability.

## 3. Throughput vs. Time to Finality

| Metric | Definition | Highway analogy |
| --- | --- | --- |
| **Throughput** | Transactions finalized per second (TPS) | Number of lanes |
| **Time to finality (TTF)** | Time from submission until irreversible | Travel time to destination |

Goal: **high throughput AND short TTF**.

| Network | Throughput | Time to finality |
| --- | --- | --- |
| Bitcoin | 7 TPS | 60 min |
| Ethereum | 30 TPS | 6.4 min |
| **Avalanche / L1** | **2,500 TPS** | **\~0.8 s** |

*(Illustrative figures from the course.)*

## 4. Network Architecture

### Primary Network (3 built-in chains)

| Chain | Purpose |
| --- | --- |
| **P-Chain** (Platform) | Metadata/coordination: validators, staking, subnets/L1s, chain creation. Runs PlatformVM (not EVM), so use a compatible wallet such as Core |
| **C-Chain** (Contract) | EVM-compatible smart contracts and DeFi |
| **X-Chain** (Exchange) | Creating and transferring digital assets |

- **AVAX** is the native token: fees, staking, and securing the network (Proof-of-Stake).
- P-Chain stores per validator: **Node ID, BLS public key, stake weight, balance** (for continuous fees).
- L1 validators sync P-Chain validator-set info but do **not** participate in P-Chain consensus.
- The Primary Network provides the base for interoperability (ICM). Note that the older model required all validators to validate it, whereas the newer L1 model gives L1s their own validator sets.

### Avalanche L1

An **independent blockchain** with its own validator set, consensus, tokenomics, execution logic, fee structure, state, networking, and security model. L1s do not share execution resources with each other or with the Primary Network.

| Feature | Primary Network | Avalanche L1 |
| --- | --- | --- |
| Validator set | All Avalanche validators | Custom |
| Gas token | AVAX | Custom token or AVAX |
| VM | Fixed built-in chains | Customizable |
| Security | Shared | Independent |
| Access | Permissionless | Permissionless or permissioned |

**Subnet (legacy) vs L1:** Subnets were blockchains validated by a subset of Primary Network validators, who also had to stake on the Primary Network. The terminology remains in transaction names, but **new deployments should use the L1 model**.

## 5. Features & Benefits of L1s

| Benefit | Summary |
| --- | --- |
| **Scalability** | Horizontal scaling by adding more chains (many parallel highways), with no new untested consensus needed |
| **Independence** | Congestion or fees on one L1 (NFT drop, game launch) do not affect others |
| **Customizability** | Custom gas token, VM (WASM, Move, Subnet-EVM, or custom via SDKs), multiple VMs per L1, restricted access |
| **Privacy & compliance** | Optional selective transparency, transaction encryption, granular access control |
| **Interoperability** | Native cross-chain messaging (ICM) and token transfers (ICTT) |

Monolithic chain drawbacks: costly validator hardware (centralization), shared blockspace and overcrowding, and one disruption halts everything.

## 6. Avalanche L1s vs. Layer 2 Rollups

| Aspect | Avalanche L1 | L2 Rollup |
| --- | --- | --- |
| Security source | Own validator set | Ethereum mainnet |
| Isolation | Compromise in one L1 does not affect others | Mainnet breach can affect all L2s |
| Flexibility | Custom rules, VMs, tokenomics | Limited by Ethereum compatibility |
| Parallelism | True parallel across L1s | Settles sequentially on L1 |
| Withdrawals | Independent, no L1 dependency | Often delayed (challenge periods) |
| Gas token | Independent from AVAX | Coupled to Ethereum gas |

**Choose L1** for sovereignty and customization. **Choose L2** for Ethereum's shared security and ecosystem compatibility.

## 7. Creating an L1: 3 Transactions on the P-Chain

| Step | Transaction | What it does |
| --- | --- | --- |
| 1 | **`CreateSubnetTx`** | Creates the Subnet. Its ID is the tx hash. One parameter: the **owner** |
| 2 | **`CreateChainTx`** | Registers the blockchain and links it to the Subnet. Its ID is the tx hash |
| 3 | **`ConvertSubnetToL1Tx`** | Turns the Subnet into a sovereign L1 and adds the initial validators |

**CreateChainTx params:** `name`, `subnetID`, `vmID`, `genesisData`.

- The owner can add chains and convert the Subnet. After conversion the owner **loses all privileges**, so a multisig is not strictly needed if converting immediately.
- Genesis Builder configures permissioning, tokenomics, and the fee mechanism. The exercise keeps the defaults: **View Genesis JSON**, then **Create Chain**.
- After step 2 the chain exists on the P-Chain but has **no validators**, so you can't connect a wallet or send transactions yet.

### Running validator nodes

| Option | Notes |
| --- | --- |
| **Managed testnet node** | Free, one-click, no Docker needed. Testnet only, and **shuts down after 3 days** |
| **Self-hosted (Docker)** | Full control, for longer testing and production. AvalancheGo must **track the Subnet** with the right L1 config |

P-Chain records *define* the blockchain, and running validators make it *live*.

### ConvertSubnetToL1

- **One-time and irreversible.** Only the Subnet owner can run it, and afterwards the L1 is controlled by the **Validator Manager Contract (VMC)**.
- Done via the `ConvertToL1` tool in the Builder Console.

| Parameter | Value |
| --- | --- |
| Subnet ID | From the `CreateSubnetTx` hash |
| Validator Manager Blockchain ID | Typically the new L1's chain ID (or C-Chain / another L1) |
| Validator Manager Address | Pre-deployed proxy `0xfacade0000000000000000000000000000000000` (OpenZeppelin TransparentUpgradeableProxy from `genesis.json`) |
| Validators | The node you launched |

- After conversion, deploy the actual `ValidatorManager` implementation and point the proxy to it.
- Prerequisites: test AVAX on **both C-Chain and P-Chain**, and a running node tracking the Subnet.
- Test by deploying an ERC-20 with the Builder Tooling.

### Removing a node (Docker)

| Action | Command | Data kept? |
| --- | --- | --- |
| Stop | `docker stop avago` | Yes |
| Restart | `docker start avago` | Yes |
| Remove container | `docker rm avago` | Yes |
| Delete everything | `rm -rf ~/.avalanchego` | **No** (irreversible: node credentials and chain state) |

Data lives in `~/.avalanchego`. Stop before removing, and back up before deleting.

## 8. Interoperability: The Big Picture

**Interoperability** = chains communicating, sharing data and assets natively (without third-party bridges).

Why it matters: liquidity for new chains, developer adoption, and user access.

Use cases: asset bridging, cross-chain DAO voting, shared liquidity pools, oracle data feeds, cross-chain contract calls.

### The stack (bottom to top)

| Layer | Role | Analogy |
| --- | --- | --- |
| **Validators + BLS signatures** | Cryptographic trust | Tamper-proof seal |
| **AWM / ICM** (Warp Precompile) | Native message creation, signing, verification | Postal infrastructure |
| **Relayers** | Collect signatures and deliver messages | Mail carriers |
| **ICM Contracts (Teleporter)** | Developer-friendly interface | Post office counter |
| **ICTT** | Token transfer application | Package delivery service |

### Source, Message, Destination

- **Source chain:** where the event happens, the message is created, and validators sign.
- **Message:** (1) **metadata** (source/destination chain IDs, timestamp, message ID), (2) **encoded data** (transfer, vote, call, oracle update, or any arbitrary data), (3) **signature** (validator proof).
- **Destination chain:** receives the message as a transaction, verifies signatures, executes the action, and updates state.
- **Signatures give:** proof of origin, proof of validity, tamper resistance, and non-repudiation.

### ICM message flow (6 steps)

1. A contract calls the **Warp Precompile** to create a message.
2. The chain emits an event.
3. Source validators **sign** the message.
4. A **relayer** detects it and collects the signatures.
5. The relayer submits the message and signatures to the destination chain.
6. The destination verifies the signatures, then accepts and processes the message.

### Warp Precompile

A **precompile** is a contract built into the node software. The Warp Precompile is pre-installed on every chain, at the **same address** everywhere, written in **Go**, fast, and callable by any contract.

### Teleporter (ICM Contracts)

Solves the hard parts of raw ICM: encoding, signature verification, tracking, relayer fees, and replay protection.

- Simple call: `sendCrossChainMessage(destinationChainID, destinationAddress, messageData, gasLimit, relayerFee)`.
- Same address on every chain, standardized API, **replay protection**, delivery tracking, relayer fee management.

### Relayers

| Does | Characteristics |
| --- | --- |
| Monitor chains, collect signatures, submit destination txs, pay gas | **Permissionless** (anyone can run one), needs capital for gas on destination chains, configurable per route, earns fees via Teleporter, competitive (several can race) |

### ICTT (Interchain Token Transfer)

A **ready-made application** (not core infrastructure) built on ICM, Teleporter, and relayers.

- **Lock-and-mint:** (1) **Lock** tokens on Chain A, (2) **Mint** wrapped tokens on Chain B, (3) **Burn** wrapped tokens to return, (4) **Unlock** originals on A. Total supply stays constant.
- Components: **Token Home** (original tokens on native chain), **Token Remote** (wrapped version elsewhere), and transfer logic.
- Supports native tokens and ERC-20s.
- **Send-and-call:** transfer tokens and trigger a contract on arrival (e.g. swap, add liquidity, or stake).

## 9. Digital Signature Schemes

**Three properties:**

| Property | Meaning |
| --- | --- |
| **Authenticity** | Proves the message came from the holder of the private key |
| **Non-repudiation** | Signer cannot deny having signed |
| **Integrity** | Any change to the message (even 1 bit) breaks verification |

**Asymmetric cryptography:** the **private key** (secret) is used to sign, and the **public key** (shareable) is used to verify. You cannot derive the private key from the public key.

### The 3 algorithms

| Method | Input to Output |
| --- | --- |
| `GenerateKeyPair()` | none to (private key, public key) |
| `Sign(message, privateKey)` | to signature |
| `Verify(message, signature, publicKey)` | to Valid / Invalid |
| *(optional)* `Recover(message, signature)` | to public key (e.g. ECDSA in Ethereum) |

### Hands-on takeaways

- Keys and signatures are bit strings shown as **hex**. Long keys (e.g. 256-bit private key) make brute force infeasible.
- Signing is **deterministic**: the same message and key always produce the same signature.
- Change one character and the signature changes completely.
- `Verify` is INVALID if the message is modified, the signature is from a different message, or the wrong public key is used.
- Example course message: *"Per consensum ad astra"*.
- Everywhere: blockchain txs, email (PGP), software updates, TLS, legal documents, and Avalanche cross-chain messaging.

## 10. Multi-Signature Schemes

**Multi-sig:** multiple parties, each with their own private key, must sign. A **threshold** (e.g. 3-of-5) is needed to authorize an action.

| Benefit | Why |
| --- | --- |
| No single point of failure | One stolen key is not enough |
| Distributed trust | Checks and balances, and insiders can't act alone |
| Flexibility | Only a subset needs to be available |
| Limited blast radius | A single vulnerability doesn't compromise everything |

Examples: corporate treasury (3-of-5 executives), DAO (51% approval), family account (2-of-4). Also used in wallets, smart contracts, DeFi vaults, governance, and access control.

## 11. BLS Multi-Signatures and Aggregation

**BLS = Boneh-Lynn-Shacham.** Two key features:

1. **Signature aggregation:** many signatures *on the same message* combine into **one** signature of the same size.
2. **Public key aggregation:** many public keys combine into **one** key of the same size.

### Traditional vs. BLS

| Aspect | Traditional multi-sig | BLS |
| --- | --- | --- |
| Signature size | Grows with signers (O(n)) | Constant |
| Verification | O(n) | **O(1)** |
| Storage / bandwidth | High | Low |
| Scalability | Degrades | Excellent |

### The 1,000-validator example (from the course)

Sizes used: message 64 B, signature 96 B, public key 128 B.

|  | Without aggregation | With BLS |
| --- | --- | --- |
| Signatures | 96,000 B | 96 B |
| Public keys | 128,000 B | 128 B |
| **Total payload** | **224,064 B** | **288 B** (about 778x smaller) |
| Verification operations | 1,000 | **1** |

Aggregation is **order independent**, and works whether you have 2 signers or 1,000,000.

### Why it matters for Avalanche

- Cross-chain messages signed by many validators stay **tiny and cheap to verify**.
- Lower gas, less bandwidth, faster verification, and more validators can participate without bottlenecks.
- BLS public keys are stored on the P-Chain, so destination chains can verify source-chain validator signatures.
- Other BLS uses: validator consensus, staking proofs, MPC, distributed key generation, and threshold decryption.

## 12. Quick Glossary

| Term | One-liner |
| --- | --- |
| **Validator** | Node that validates transactions and participates in consensus |
| **Sybil attack** | Many fake identities, mitigated by stake-weighting |
| **P-Chain / C-Chain / X-Chain** | Coordination / EVM contracts / asset exchange |
| **ConvertSubnetToL1** | One-time irreversible tx that makes a Subnet a sovereign L1 |
| **Validator Manager Contract** | Manages an L1's validator set after conversion |
| **ICM** | Interchain Messaging: native cross-chain messaging protocol |
| **AWM** | Avalanche Warp Messaging: the underlying signed-message protocol |
| **Warp Precompile** | Built-in Go contract at the same address on every chain |
| **Teleporter** | Main ICM Contract for easy cross-chain messaging |
| **Relayer** | Permissionless service that delivers signed messages and earns fees |
| **ICTT** | Interchain Token Transfer: lock-and-mint token app |
| **Wrapped token** | Representation of a token locked on another chain |
| **Replay protection** | Prevents the same message from being processed twice |
| **Precompile** | Contract built into node software |
| **Threshold** | Minimum signatures needed in a multi-sig |

## 13. Last-Minute Memory Aids

- **L1 creation = Subnet, then Chain, then Convert.** After converting, the owner loses power and the VMC takes over.
- **Snowman: k samples, α agree, β in a row** (20 / 14 / 20 in practice).
- **Avalanche finality is about 0.8 s at about 2,500 TPS** (vs. Ethereum 6.4 min and Bitcoin 60 min).
- **Cross-chain = Sign, Aggregate, Relay, Verify.** Validators sign, BLS aggregates, a relayer delivers, and the destination verifies once.
- **ICTT is an app, not infrastructure.** ICM is the postal system and ICTT is a delivery service on top.
- **BLS = constant size and constant verification time**, no matter how many signers.
