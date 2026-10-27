# Solana Core Concepts Cheatsheet

*For Ethereum devs · based on 02-core-concepts*

## The one-line mental model

**Ethereum:** Contract = Code + State (together). **Solana:** App = Programs (code only) + Accounts (state only).

## Glossary: every core concept defined

Read this first. Each term below is used in the sections that follow.

### Accounts and ownership

| Term | Definition |
| --- | --- |
| **Account** | The only place data lives on Solana. Wallets, programs, token balances and NFT metadata are all accounts with four fields: `lamports`, `data`, `owner`, `executable`. |
| **Address / Pubkey** | The public key that identifies an account (`Pubkey` in Rust). It is the account's location, like an Ethereum address. |
| **Lamport** | The smallest unit of SOL. 1 SOL = 1,000,000,000 lamports. The `lamports` field is the account's balance. |
| **Owner (owner program)** | The program whose address is stored in an account's `owner` field. It is the only program allowed to change that account's `data` or deduct its `lamports`. Any program can add lamports to it. An owner is always a program, never a person: Alice's wallet is owned by the System Program, and Alice proves control by signing. |
| **Executable** | A true/false flag. `true` means the account holds runnable program code. `false` means it holds plain data. |
| **Data** | The raw bytes (`Vec<u8>`) inside an account. In a program account it is compiled bytecode. In a data account it is your state (a counter value, a profile). |
| **Wallet account** | A user's account. Owner is the System Program, `data` is empty, `executable` is false. |
| **Program account** | An account with `executable: true` holding compiled code. Owner is the BPF Loader. |
| **Data (state) account** | An account with `executable: false` holding a program's state. Owner is the program that uses it. This is where Solana keeps what an Ethereum contract keeps in its own storage. |
| **Rent** | SOL locked in an account to pay for the storage it uses. Bigger data means more SOL locked. |
| **Rent-exempt** | Holding enough SOL to cover 2+ years of storage. Accounts must meet this minimum. |
| **Closing an account** | Deleting it and getting its locked rent SOL refunded. |

### Programs, instructions and transactions

| Term | Definition |
| --- | --- |
| **Program** | Solana's smart contract. An executable, stateless account: it holds code only and stores no user data in itself. |
| **Stateless** | The program keeps no variables of its own. State goes in separate data accounts that the program owns. |
| **Program ID** | The address of a program account. |
| **Instruction (ix)** | One function call to one program: "call the counter program: increment". |
| **Transaction (tx)** | A bundle of one or more instructions plus the accounts they touch and the signatures. It is the unit you send to the network. |
| **Atomic** | All or nothing. If any instruction in a transaction fails, the whole transaction fails. |
| **Signer** | An account that signed the transaction, proving authority. |
| **Writable** | An account the transaction is allowed to modify. |
| **Payer** | The signer who pays for rent and fees. In the counter example, Alice. |
| **Sealevel** | Solana's runtime. It reads each transaction's account list and runs non-overlapping transactions in parallel. |
| **Parallel execution** | Transactions touching different accounts run at the same time. Those sharing an account run in order. |
| **SBF** | Solana Bytecode Format. The machine code your Rust compiles to. |
| **BPF Loader** | Native program that deploys and runs custom programs. It owns every custom program account. |
| **System Program** | Native program that handles SOL transfers and is the only program that can create accounts. It owns all user wallets. |
| **Token Program (SPL)** | Native program that manages SPL tokens, Solana's ERC-20 equivalent. |
| **Clock Sysvar** | Built-in account that provides time information. |
| **Upgrade authority** | The key allowed to replace a program's code. If that key is lost, the program is effectively immutable. |

### Program Derived Addresses (PDAs)

| Term | Definition |
| --- | --- |
| **PDA** | An address with no private key, derived from a Program ID, seeds and a bump. Only the deriving program can sign for it, through the runtime. |
| **Seeds** | Inputs you choose for the derivation (strings, numbers, pubkeys). Different seeds give different PDAs. |
| **Bump** | An integer (starting at 255 and counting down) added so the derived address lands off the curve. |
| **Ed25519 curve** | The signature scheme Solana uses. Points on the curve have a private key. Wallet keys sit on it. |
| **Off-curve** | Not on the curve, so no private key can exist. This is what makes an address a valid PDA. |
| **Deterministic derivation** | The same inputs always give the same address, so clients can compute it before touching the chain. |
| **On-chain key-value store** | The PDA pattern of mapping a key (user pubkey plus seeds) to a data account. |

### Cross Program Invocations (CPIs)

| Term | Definition |
| --- | --- |
| **CPI** | One running program calling an instruction of another program. Like a server endpoint calling an internal API. |
| **Caller / callee** | The program making the CPI, and the program being invoked. |
| **Composability** | Apps building on each other like blocks. CPIs are what make it possible. |
| **Privilege extension** | Signer and writable permissions pass unchanged from caller to callee. |
| **PDA signing** | A program signing for its own PDA. That signer privilege also extends to the callee. |
| **Max CPI depth** | The cap on nested calls in one transaction, currently 4 (`MAX_INSTRUCTION_STACK_DEPTH`). |

### Anchor and the IDL

| Term | Definition |
| --- | --- |
| **Anchor** | The standard Rust framework for Solana. It handles serialization and deserialization and generates IDLs. |
| **IDL** | Interface Definition Language: a JSON file listing a program's instructions, accounts and errors. Equivalent to an Ethereum ABI. |
| **Bindings** | Rust code Anchor generates from an IDL so one program can call another with type safety. |
| **Seahorse** | Framework for writing Solana programs in Python. |
| **Proxy pattern** | The Ethereum way to upgrade immutable contracts. Not needed on Solana, where programs are upgradable by default. |

## Ethereum vs. Solana at a glance

|  | Ethereum | Solana |
| --- | --- | --- |
| Languages | Solidity, Vyper | Rust (Python via Seahorse) |
| Compiles to | EVM bytecode | SBF (Solana Bytecode Format) |
| Architecture | Code + state coupled | Code and state decoupled |
| Execution | Sequential, single-threaded (\~15-30 TPS) | Parallel, multi-threaded (\~65,000 TPS) |
| Cost model | Gas; storage is permanent, no rent | Rent: SOL locked proportional to data size, refundable on close |
| Upgrades | Immutable; needs proxy pattern (`delegatecall`) | Upgradable by default via upgrade authority |
| Interface file | ABI | IDL (Anchor) |
| Token standard | ERC-20 | SPL Token (Token Program) |

## Accounts: everything is an account

```rust
struct Account {
    lamports: u64,     // balance (1 SOL = 1,000,000,000 lamports)
    data: Vec<u8>,     // raw bytes: state OR compiled bytecode
    owner: Pubkey,     // program that controls this account
    executable: bool,  // true = program, false = data
}
```

**Ownership rules (the security boundary):**

- Only the **owner** program can modify an account's `data`.
- Only the **owner** program can deduct its `lamports`.
- Anyone can add lamports to an account.

**Rent:**

- Rent = SOL locked, scaling with data size.
- **Rent-exempt** = holding enough for 2+ years of storage; this is the standard requirement.
- Closing an account refunds the SOL.

### Common account types

| Account | owner | executable | data |
| --- | --- | --- | --- |
| User wallet | System Program | false | empty |
| Custom program | BPF Loader | true | compiled SBF bytecode |
| Program state (e.g. counter) | Your program | false | your variables |

### Ownership chain

```
System Program → User wallets
BPF Loader     → Custom programs → Data accounts (state)
```

### Native programs

| Program | Job |
| --- | --- |
| System Program | SOL transfers, **creating accounts** (only it can) |
| BPF Loader | Deploys and runs custom programs |
| Token Program | SPL tokens |
| Clock Sysvar | Time info |

## Programs, instructions, transactions

- **Program** = executable + stateless account. No user data inside it.
- **Instruction (ix)** = a function call to a program.
- **Transaction (tx)** = a bundle of 1+ instructions. It is **atomic**: if any ix fails, the whole tx fails.
- A tx contains instructions, a **list of all accounts it touches**, and signatures.

### Why declare all accounts upfront?

The runtime (**Sealevel**) reads the account lists *before* running any code:

- No overlapping accounts → run in **parallel**.
- Overlapping accounts (e.g. same Counter) → run **sequentially**.

### Flow: initializing a counter

1. Alice signs and broadcasts tx `[Alice, Counter, SystemProgram]`.
2. The runtime invokes the Counter Program.
3. The program needs a state account but can't create one itself.
4. **CPI** to the System Program: "create account" (Alice, as signer, pays rent).
5. The System Program creates the account and sets `owner = Counter Program`.
6. The Counter Program writes `count = 0` into the account's `data`.

## PDAs (Program Derived Addresses)

**A PDA is a public key with no private key.** Only the deriving program can "sign" for it, through the runtime.

```
PDA = hash(Program ID + Seeds + Bump)
```

| Input | What it is |
| --- | --- |
| Program ID | The program that owns and controls the PDA |
| Seeds | Developer-chosen inputs (strings, numbers, pubkeys) |
| Bump | Integer (255 downward) that pushes the address off the curve |

**Why they matter:**

- **Programmatic ownership:** only the program can move funds or modify data, with no key to manage.
- **Key-value store:** e.g. seeds `[user pubkey, id]` map a user to their data.
- **Deterministic addressing:** the client can compute the address before touching the chain.
- **Uniqueness:** add a seed (like an ID or random number) to give one user many PDAs.

**The bump, in short:**

- Standard wallet pubkeys sit **on** the Ed25519 curve (so a private key exists).
- PDAs must sit **off** the curve (so no private key can exist).
- About 50% of hashes land on the curve. The system starts at bump 255 and decrements (254, 253, ...) until the point is off-curve.

**Example (Lock Program):** Alice locks 1 SOL in a PDA seeded with her pubkey plus a number. She can't withdraw directly. The program checks the stored expiry timestamp and signs the withdrawal only when the time has passed.

## CPIs (Cross Program Invocations)

A CPI is one program calling another program's instruction. It's the mechanism behind **composability**, and it's like an internal API call in Web2.

**Privilege extension:** signer and writable flags carry through from caller to callee.

```
User (signer) → Program A → Program B   (B still sees the user as signer)
```

**PDA signing:** Program A can sign for its own PDA, and that signer privilege extends to the callee too.

**Max CPI depth = 4** (`MAX_INSTRUCTION_STACK_DEPTH`). This may change in future updates.

```
A → B (1) → C (2) → D (3) → E (4)   // E cannot call F
```

## Anchor and the IDL

**Native Rust problem:** the instruction definition must be duplicated in both the callee and the caller. This violates DRY, and the caller breaks if the callee changes.

**Anchor fix:** the **IDL** (Interface Definition Language) is a JSON blueprint of a program's instructions, accounts, and errors. It is the equivalent of an Ethereum ABI.

1. Compile Program B with Anchor, which auto-generates the IDL (JSON).
2. Import the IDL into Program A's project.
3. Anchor generates the Rust bindings.
4. Program A calls B with type safety and no duplicate code.

**Use cases:**

- **Internal composability:** you own both programs.
- **External integrations:** call a closed-source protocol using only its public IDL, with no source repo needed.

## Quick-recall checklist

- All data lives in accounts, and programs are stateless.
- Only the owner can write data or debit lamports.
- Only the System Program creates accounts, and it assigns the owner.
- Declare every account in a tx (this enables parallelism).
- Transactions are atomic.
- PDA = off-curve address with no private key, derived from Program ID + Seeds + Bump.
- CPI keeps signer/writable privileges, with a max depth of 4.
- IDL (Anchor) is the ABI equivalent and removes CPI code duplication.
- Programs are upgradable by default, and losing the authority key makes one immutable.
