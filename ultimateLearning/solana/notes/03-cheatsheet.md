# 📘 Solana Development Cheatsheet
*Program IDs, Limitations & Getting Started — designed for full re-understanding after years without practice.*

---

## 1. Program ID — What Is It?

- **Definition:** The unique identifier of a deployed program (Solana's "smart contract").
- **Technically:** The **public key** of an Ed25519 keypair generated for the program.
- **Behaves like:** A wallet address, but it points to executable code (can hold funds, usually doesn't).
- **Why it matters:** Required to deploy, upgrade, and interact with the program; clients route transactions to it.

> 💡 **Ethereum comparison:** Ethereum derives contract addresses from sender address + nonce. Solana derives the Program ID from a **keypair file stored in your project**.

### Derivation flow
```
Random Private Key → Ed25519 → Public Key = Program ID
```

---

## 2. Files on Disk (the build output)

Build tools (Anchor or raw Rust) place artifacts in **`target/deploy/`**:

| File | Role |
|---|---|
| `hello.so` | Compiled bytecode (Shared Object) actually deployed on-chain |
| `hello-keypair.json` | Private key (raw int array) → derives the Program ID |

**Key file format:** a plain JSON array of integers — the private key material.
**Build flow:** read keypair.json → derive public key → deploy `.so` at that address.

### Why the private key matters (two roles)

| Role | What it does |
|---|---|
| **Developer (authority)** | Signer of upgrades. Lose the file = lose upgrade rights; you must redeploy under a **new** Program ID, breaking all front-end integrations |
| **End user (addressing)** | Users only ever need the public Program ID — it's public and shareable |

> ⚠️ **Security rule:** treat `target/deploy/*-keypair.json` like a wallet seed phrase. Testnet = disposable. **Mainnet = critical infrastructure asset.**

**Memory table:**

| Component | Location | Meaning |
|---|---|---|
| Private key | `target/deploy/[name]-keypair.json` | Ownership / upgrade authority |
| Public key | Derived | Identity = Program ID |
| `.so` binary | `target/deploy/[name].so` | Executable logic on-chain |

---

## 3. Runtime Limitations (the mindset shift)

Like Ethereum's Gas, Solana enforces strict limits to guarantee **determinism, consensus, speed**.

### 3.1 Determinism (core concept)
- Same input ⇒ **always the same output**.
- Every validator node must reach the same result — otherwise consensus breaks.
- Hence: no system time, no randomness, no network calls inside programs.

### 3.2 Banned standard libraries (no OS in the runtime!)

| Library | Why banned |
|---|---|
| `std::fs` | No filesystem access |
| `std::net` | No network / sockets / HTTP |
| `std::future` | No async |
| `std::process` | No spawning processes |
| `std::thread` | Single-threaded only |
| `rand` | Non-deterministic (use oracles for on-chain randomness) |

Also: importing heavy libraries can bloat the `.so` beyond the **max program size** limit.

### 3.3 Computational limits

| Constraint | Limit | Error | Meaning |
|---|---|---|---|
| **Compute Budget** | Per-transaction compute units | Tx fails + reverts | Solana's version of gas |
| **Call stack depth** | 64 frames | `CallDepthExceeded` | No deep recursion |
| **CPI depth** | 4 levels | `CallDepth` | Program A→B→C→D→E = limit reached |

CPI purpose: prevents dependency chains that lock the network, mitigates **reentrancy**.

### 3.4 Floating point
- Rust has `f32`/`f64`, but Solana hardware has **no native float execution on-chain** — floats run via software = expensive, eats Compute Budget.
- **Best practice:** prefer integer math; use floats sparingly.

### 3.5 Limits are dynamic
- Numbers above (64 / 4) are **not immutable** — the protocol evolves via network upgrades.
- ⚠️ Always check current Solana docs rather than trusting memorized values.

---

## 4. Hello Solana — Native Rust (no framework)

*The complete workflow: build → test → deploy → cleanup.*

### Prerequisites
Create an empty folder for your project.

### Build
```bash
cargo build-sbf
```
- Compiles Rust to **SBF** (Solana Bytecode Format).
- Generates the `.so` file under `target/deploy/`.

### Test locally

**1. Unit tests:**
```bash
cargo test -- --nocapture
```

**2. With a local validator:**
```bash
solana config set -ul          # -ul = use localnet
solana-test-validator
```

**3. Check the Program ID:**
```bash
solana address -k ./target/deploy/hello-keypair.json
```

**4. Deploy and run a demo script:**
```bash
solana program deploy ./target/deploy/hello.so

PROGRAM_ID=your_program_id
RPC=http://localhost:8899
KEYPAIR=path_to_your_keypair

cargo run --example demo $KEYPAIR $RPC $PROGRAM_ID
```

### Deploy to Devnet

| Step | Command |
|---|---|
| Configure devnet | `solana config set -ud` (-ud = use devnet) |
| Check balance | `solana balance` |
| Airdrop test SOL | `solana airdrop 1` |
| Build | `cargo build-sbf` |
| Deploy | `solana program deploy ./target/deploy/hello.so` |

Then run the demo script with `RPC=https://api.devnet.solana.com`, and verify the transaction signature on **Solana Explorer**.

### Close the program (reclaim SOL)
```bash
solana program close $PROGRAM_ID
```
- Closes the program account.
- **Returns the rent-exempt SOL** to your wallet — useful for cleaning up test deployments.

---

## 5. Hello Solana — Anchor

### Initialize the project
```bash
anchor init hello --test-template rust
```
- Creates the project structure + config files + template code.

**Optional — sync the Program ID:**
```bash
anchor keys sync
```

### Build
```bash
anchor build
```
- Compiles the program, generates the `.so` **and the IDL file** (Anchor's equivalent of Ethereum's ABI — the blueprint of exposed instructions/accounts/errors).

### Test locally
```bash
anchor test
```
> 🔧 **Troubleshooting:** if tests fail for no apparent reason, try `anchor clean` (reset).

### Deploy to Devnet

**1. `Anchor.toml`:**
```toml
[provider]
cluster = "Devnet"
wallet = "~/.config/solana/id.json"
```

**2. Solana CLI:**
```bash
solana config set -ud   # devnet
solana balance          # check balance
solana airdrop 1        # if needed
anchor build
anchor deploy           # simplified deploy
```

### Close the program
```bash
solana program close $PROGRAM_ID
```

---

## 6. Native vs Anchor — Choosing Your Tool

| Aspect | Native Rust | Anchor Framework |
|---|---|---|
| **Setup** | Manual configuration | `anchor init` automated |
| **Testing** | Manual scripts | Built-in test framework (`anchor test`) |
| **Deploy** | Manual CLI commands | Simplified `anchor deploy` |
| **IDL** | Manual generation | **Automatic** (via `anchor build`) |
| **Best for** | Learning fundamentals | Production development |

---

## 7. Universal Development Workflow (memo)

1. **Build** → compile to `.so`
2. **Test** → locally (local validator)
3. **Deploy** → local validator or Devnet
4. **Verify** → check transactions on the explorer
5. **Clean** → `solana program close` to reclaim SOL

---

## 8. 10-Year Refresher — One-Line Recall

1. **Program ID** = public key of a keypair stored in `target/deploy/`.
2. **keypair.json** = upgrade authority; losing it = losing the program.
3. **.so** = the deployed bytecode.
4. **Determinism** rules everything: no fs, net, threads, rand, async.
5. **Compute Budget** = gas; **stack 64**; **CPI 4**; **no floats** (use integers).
6. **Limits are dynamic** — always verify against official docs.
7. **Workflow**: build → test → deploy → verify → close.
8. **Native** (`cargo build-sbf`) for learning, **Anchor** (`anchor init/build/test/deploy` + auto IDL) for production.

---

## 9. Quick Self-Test (did it stick?)

1. What exactly is a Program ID technically? *(the public key of an Ed25519 keypair)*
2. What happens if you delete `hello-keypair.json` after deploying to mainnet? *(no more upgrade rights; must redeploy under a new ID)*
3. Why is `std::net` banned in a program? *(no OS; would break determinism/consensus)*
4. Max depth of program-to-program calls? *(4 CPI levels — error `CallDepth`)*
5. Why avoid floats? *(software-emulated = expensive, consumes Compute Budget)*
6. Which command compiles a native program? An Anchor program? *(cargo build-sbf / anchor build)*
7. What file does Anchor generate automatically, and what is it? *(the IDL — equivalent of Ethereum's ABI)*
8. Which command closes a program and reclaims the SOL? *(solana program close $PROGRAM_ID)*
9. What does `anchor keys sync` do? *(updates/syncs the Program ID declared in the project)*
10. What does `cargo build-sbf` do? *(compiles to Solana Bytecode Format → .so in target/deploy/)*