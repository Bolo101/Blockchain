# Installation

https://solana.com/docs/intro/installation


## Goal of this lesson

- Set up a **Solana development environment** ready for:
  - Rust smart contracts
  - Solana CLI workflows
  - Anchor-based development  
- Work with:
  - Local validator (localhost)
  - Public test network (Devnet) 

***

## Core tools to install

You need **three main components** on your machine:

- **Rust**
- **Solana CLI**
- **Anchor CLI** 

Recommended versions for this course:

- Rust: **1.87.0**
- Solana CLI: **3.0.10 or 3.0.13**
- Anchor CLI: **0.31.1**  
  - Tutorials may mention older versions (e.g. 0.29.0), but this course assumes **0.31.1**.

Always rely on the **official Solana Installation Documentation** for OS-specific install steps (macOS / Linux / Windows). 

**Verify installs:**

```bash
rustc --version       # Rust
solana --version      # Solana CLI
anchor --version      # Anchor CLI
```

***

## Solana CLI basics

The **Solana CLI** is the main control interface:

- Decides **which cluster** you interact with:
  - Localhost (local validator)
  - Devnet (public testnet)
- Stores configuration: RPC URL, WebSocket URL, keypair file path. 

Check current configuration:

```bash
solana config get
```

***

## Choosing the cluster (network)

You must explicitly tell the CLI where to send transactions.

- **Localhost**
  - For **fast local development and testing**
  - Uses `solana-test-validator` running on your machine. 

- **Devnet**
  - For **public test network deployments**
  - Behaves like mainnet but with test SOL. 

**Switch to Localhost:**

```bash
solana config set --url localhost
solana config set -ul      # short form
```

**Switch to Devnet:**

```bash
solana config set --url devnet
solana config set -ud      # short form
```

***

## File-system wallet (CLI wallet)

Solana CLI uses a **file-system wallet**:

- Private key stored as a **JSON file** on disk (default: `~/.config/solana/id.json`). 
- Used to:
  - Sign transactions
  - Pay fees (gas) for deployment and execution

**Generate a new default wallet:**

```bash
solana-keygen new
```

Notes:

- If `~/.config/solana/id.json` already exists, Solana will **refuse to overwrite it** by default.
- You must either:
  - Move the existing wallet file, or
  - Use a force flag (only if you really want to overwrite the old keys). 

**Check wallet details:**

```bash
solana address   # print public key (wallet address)
solana balance   # check current SOL balance
```

***

## Getting test SOL (airdrop) on Devnet

On Solana, you can request test SOL **directly via the CLI** (no need for a faucet website). 

**Workflow:**

1. Make sure you are on **Devnet**:

   ```bash
   solana config set -ud
   ```

2. Request SOL:

   ```bash
   solana airdrop 2
   ```

3. If you see a **rate limit error**:
   - It means the Devnet faucet is busy.
   - Wait a bit and retry the command until it succeeds. 

***

## Running a local Solana validator

For most of your development cycle (tests, local deployments):

- Use the **Test Validator**:
  - Runs a high-performance **local Solana blockchain**.
  - Ideal for quick iteration and integration tests. 

**Steps:**

1. Set config to **Localhost**:

   ```bash
   solana config set -ul
   ```

2. Start the validator:

   ```bash
   solana-test-validator
   ```

**Important workflow note:**

- `solana-test-validator` **blocks the current terminal**:
  - Do **not** close this terminal as long as you need the local chain.
  - As long as it runs, your local blockchain is “alive”.
- For other commands (build, deploy, tests), open a **new terminal tab/window**. 


