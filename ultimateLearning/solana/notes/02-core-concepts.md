# Ethereum vs. Solana: A Comprehensive Technical Comparison for Developers

---

## Introduction: The Mental Model Shift

Transitioning from Ethereum to Solana requires more than learning new syntax—it demands a **fundamental shift** in how you conceptualize blockchain architecture. While both ecosystems enable decentralized applications, their underlying mechanisms for storage, execution, and deployment differ drastically.

**The Core Difference:**
- **Ethereum:** Coupled architecture where code and state live together
- **Solana:** Decoupled architecture where code and state are separate entities

This guide breaks down the five critical differences and explains Solana's unique account model in detail.

---

## Part 1: The Five Critical Differences

### 1. Language and Compilation Standards

#### Ethereum Ecosystem

**Languages:**
- **Solidity** (most common) - JavaScript-like syntax
- **Vyper** - Python-like syntax, more security-focused

**Compilation:**
```
Solidity/Vyper Code → EVM Bytecode → Ethereum Virtual Machine
```

**Characteristics:**
- Languages designed specifically for blockchain
- Compile to EVM (Ethereum Virtual Machine) Bytecode
- EVM is a single, standardized execution environment

---

#### Solana Ecosystem

**Languages:**
- **Rust** (primary focus of this course)
- **Python** (via Seahorse framework)

**Compilation:**
```
Rust/Python Code → SBF (Solana Bytecode Format) → Solana Runtime
```

**Key Components:**

| Component | Description |
|-----------|-------------|
| **SBF** | Solana Bytecode Format - the machine language your Rust programs compile to |
| **Anchor Framework** | Industry-standard framework that abstracts low-level complexities (serialization/deserialization) |
| **BPF Loader** | Native program that manages and executes all custom smart contracts |

**Developer Note:** You'll frequently see "SBF" in terminal commands. This is the compiled bytecode format that Solana validators execute.

---

### 2. Architecture: Coupled vs. Decoupled Model

This is the **most significant conceptual leap** for Ethereum developers.

---

#### Ethereum: The "Contract" Model

**Formula:**
```
Contract = Code + State
```

**How it works:**
- A single contract address contains both:
  - **Logic** (the code/functions)
  - **State** (the data/variables)

**Example - ERC-20 Token:**
```
┌─────────────────────────────────────┐
│     ERC-20 Token Contract           │
│     Address: 0x123...               │
├─────────────────────────────────────┤
│  CODE (Logic):                      │
│  - transfer()                       │
│  - approve()                        │
│  - balanceOf()                      │
│                                     │
│  STATE (Data):                      │
│  - balances[alice] = 100            │
│  - balances[bob] = 50               │
│  - totalSupply = 150                │
└─────────────────────────────────────┘
```

**Key Characteristic:** The contract owns and manages its own data.

---

#### Solana: The "Program & Account" Model

**Formula:**
```
App = Programs (Code) + Accounts (State)
```

**How it works:**
- **Programs:** Hold **Code only** - stateless executable logic
- **Accounts:** Hold **State (data)** - separate from programs

**Example - Token System:**
```
┌─────────────────────────────────────┐
│     Token Program                   │
│     Address: TokenProgramID         │
├─────────────────────────────────────┤
│  CODE ONLY:                         │
│  - transfer()                       │
│  - approve()                        │
│  - balanceOf()                      │
│                                     │
│  NO STATE DATA HERE!                │
└─────────────────────────────────────┘
              ↓ owns
┌─────────────────────────────────────┐
│     Alice's Token Account           │
│     Address: AccountA               │
├─────────────────────────────────────┤
│  DATA ONLY:                         │
│  - balance = 100                    │
│  - owner = Alice                    │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│     Bob's Token Account             │
│     Address: AccountB               │
├─────────────────────────────────────┤
│  DATA ONLY:                         │
│  - balance = 50                     │
│  - owner = Bob                      │
└─────────────────────────────────────┘
```

**Key Characteristic:** Programs process instructions but don't store data. Data lives in separate accounts owned by programs.

---

#### Native Programs on Solana

Solana includes built-in programs that handle fundamental operations:

| Program | Purpose |
|---------|---------|
| **System Program** | Handles SOL transfers and account creation |
| **BPF Loader** | Handles deployment of executable code |
| **Token Program** | Manages SPL tokens (Solana's ERC-20 equivalent) |
| **Clock Sysvar** | Provides time information |

---

### 3. Execution Models: Sequential vs. Parallel

The architectural differences directly influence how transactions are processed.

---

#### Ethereum: Sequential Execution

**How it works:**
- The EVM creates a **single-threaded** environment
- Transactions are executed **one after another**
- Ensures safety but creates bottlenecks

**Visual:**
```
Time →
[Transaction 1] → [Transaction 2] → [Transaction 3] → [Transaction 4]
     ↓                 ↓                  ↓                  ↓
   Executed         Executed           Executed           Executed
```

**Consequences:**
- High network activity → higher gas fees
- Limited throughput (~15-30 transactions per second)
- No transaction can start until the previous one completes

---

#### Solana: Parallel Execution

**How it works:**
- Solana creates a **multi-threaded** environment
- Thousands of transactions can be processed **simultaneously**
- Only transactions accessing the same data must wait for each other

**The Key Requirement:**
When constructing a transaction, you must **explicitly declare every account** that the transaction will access or modify.

**Visual:**
```
Time →

Transaction A: [Alice, Counter Account]     Transaction B: [Carol, Bob]
     ↓                                           ↓
   Executed                                   Executed
   (Parallel - no overlap)

Transaction C: [Alice, Counter Account]
     ↓
   Must wait for A to complete
   (Overlap with A)
```

**How Parallel Execution Works:**

```
┌─────────────────────────────────────────────────────────────┐
│                    SOLANA RUNTIME (Sealevel)                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Step 1: Analyze Account Lists                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ TX A:       │  │ TX B:       │  │ TX C:       │         │
│  │ [Alice,     │  │ [Carol,     │  │ [Alice,     │         │
│  │  Counter]   │  │  Bob]       │  │  Counter]   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│                                                             │
│  Step 2: Identify Dependencies                             │
│  - TX A and TX B: No overlap → Execute in parallel         │
│  - TX A and TX C: Both use Counter → Sequential            │
│                                                             │
│  Step 3: Execute                                            │
│  ┌─────────────┐  ┌─────────────┐                          │
│  │ TX A        │  │ TX B        │  ← Parallel              │
│  │ Executing   │  │ Executing   │                          │
│  └─────────────┘  └─────────────┘                          │
│         ↓                                                 │
│  ┌─────────────┐                                           │
│  │ TX C        │  ← Waits for A to complete               │
│  │ Executing   │                                           │
│  └─────────────┘                                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Benefits:**
- High throughput (~65,000 transactions per second)
- Lower fees during high activity
- Efficient resource utilization

---

### 4. Deployment Economics: Gas vs. Rent

The cost model for putting code and data on-chain differs significantly.

---

#### Ethereum: Gas Fees

**How it works:**
- Pay **gas fees** to execute deployment transaction
- Once deployed, code lives on-chain **permanently**
- **No ongoing maintenance costs** for storage
- No concept of "rent"

**Cost Structure:**
```
Deployment Cost = Gas Used × Gas Price
```

**Example:**
- Deploy a contract: Pay 0.1 ETH in gas
- Contract lives forever at no additional cost
- Only pay gas when executing functions

---

#### Solana: Rent System

**How it works:**
- Storage on a high-performance blockchain is expensive
- Network requires you to **lock up SOL** proportional to data size
- This locked SOL is called **Rent**

**Key Concepts:**

| Concept | Description |
|---------|-------------|
| **Rent** | SOL locked in an account to pay for storage space |
| **Rent-Exempt** | Account holds enough SOL for 2+ years of storage |
| **Proportional Cost** | Larger data = more SOL required |
| **Refundable** | SOL is refunded when account is closed/deleted |

**Cost Structure:**
```
Rent Required = Data Size × Rent Rate
```

**Example:**
```
Account A: 100 bytes of data
  → Requires 0.001 SOL locked as rent

Account B: 10,000 bytes of data
  → Requires 0.1 SOL locked as rent

If you close Account B:
  → 0.1 SOL is refunded to your wallet
```

**Why Rent?**
- Prevents blockchain bloat
- Ensures validators are compensated for storage
- Encourages efficient data management

---

### 5. Mutability and Upgrades

The default approach to code permanence differs between the chains.

---

#### Ethereum: Immutable by Default

**Philosophy:** "Code is Law"

**How it works:**
- Once deployed, contracts are **immutable**
- Code cannot be changed
- To upgrade, you must use **Proxy Patterns**

**Proxy Pattern Architecture:**
```
┌─────────────────────────────────────┐
│     Proxy Contract                  │
│     Address: 0xProxy                │
├─────────────────────────────────────┤
│  - delegatecall() to implementation │
│  - Points to: 0xImplV1              │
└─────────────────────────────────────┘
              ↓ delegatecall
┌─────────────────────────────────────┐
│     Implementation V1               │
│     Address: 0xImplV1               │
├─────────────────────────────────────┤
│  - functionA()                      │
│  - functionB()                      │
└─────────────────────────────────────┘

To upgrade:
1. Deploy Implementation V2 at 0xImplV2
2. Update Proxy to point to 0xImplV2
```

**Challenges:**
- Adds complexity
- Potential security risks
- Higher gas costs for delegate calls

---

#### Solana: Upgradable by Default

**Philosophy:** Programs are like traditional software

**How it works:**
- Programs are **upgradable by default**
- The authority that deployed the program can update the code
- No proxy patterns needed

**Upgrade Process:**
```
┌─────────────────────────────────────┐
│     Counter Program                 │
│     Address: ProgramID              │
│     Authority: Alice                │
├─────────────────────────────────────┤
│  CODE (Version 1):                  │
│  - increment()                      │
│  - decrement()                      │
└─────────────────────────────────────┘

Alice (authority) can:
1. Compile new version of code
2. Call upgrade() function
3. ProgramID now contains Version 2 code
```

**Benefits:**
- Simple bug fixes
- Easy feature iteration
- No complex proxy architecture
- Lower gas costs

**Security Note:** As long as the authority key is retained, upgrades are possible. If the authority key is lost, the program becomes immutable.

---

## Summary Comparison Table

| Feature | Ethereum | Solana |
|---------|----------|--------|
| **Language** | Solidity, Vyper | Rust, Python |
| **Bytecode** | EVM Bytecode | Solana Bytecode Format (SBF) |
| **Architecture** | Code & State Coupled (Contracts) | Code & State Decoupled (Programs + Accounts) |
| **Execution** | Sequential | Parallel (Requires account declaration) |
| **Deployment Cost** | Gas Fees (No Rent) | Rent (SOL locked proportional to data size) |
| **Upgradability** | Immutable (Requires Proxy) | Upgradable by default |

---

## Part 2: Understanding Solana Accounts

### The Golden Rule of Solana Development

**All data on Solana is stored in accounts.**

Whether you're looking at:
- A user's wallet balance
- A deployed smart contract
- The metadata of an NFT

You are interacting with a **Solana Account**.

---

### The Anatomy of a Solana Account

At the lowest level, every Solana account follows this structure:

```rust
struct Account {
    lamports: u64,        // Balance in lamports
    data: Vec<u8>,        // Raw byte data
    owner: Pubkey,        // Owning program's address
    executable: bool,     // Is this a program?
}
```

Let's break down each field:

---

#### 1. Lamports: Managing Balance and Rent

**Definition:** The account's balance in lamports.

**Conversion Rate:**
```
1 SOL = 1,000,000,000 (1 Billion) Lamports
```

**The Concept of Rent:**

On Solana, storage is not free. When you create an account, you consume physical storage space on validators' hardware.

**Rent Requirements:**
- Account must hold minimum lamports based on data size
- **Rent-empt:** If account holds enough SOL for 2+ years of storage
- **Proportional:** Larger data = more SOL required

**Visual:**
```
┌─────────────────────────────────────┐
│     Account Structure               │
├─────────────────────────────────────┤
│  lamports: 1,000,000,000            │  ← 1 SOL
│  data: [100 bytes]                  │
│  owner: ProgramID                   │
│  executable: false                  │
└─────────────────────────────────────┘
         ↓
Rent Required: 0.001 SOL
Account is rent-exempt ✓
```

---

#### 2. Data: Storage vs. Logic

**Definition:** A byte array (`Vec<u8>`) holding arbitrary information.

**Two Types of Data:**

| Account Type | Data Field Contains | Example |
|--------------|-------------------|---------|
| **Storage Account** | Variables and state | Counter value, user profile |
| **Program Account** | Compiled bytecode | Executable smart contract code |

**Separation of Concerns:**

```
┌─────────────────────────────────────┐
│     Token Program (Executable)      │
├─────────────────────────────────────┤
│  data: [0x01, 0x02, 0xFF, ...]     │  ← Compiled bytecode
│  executable: true                   │
└─────────────────────────────────────┘
              ↓ owns
┌─────────────────────────────────────┐
│     Alice's Token Account           │
├─────────────────────────────────────┤
│  data: [balance: 100, owner: Alice]│  ← State data
│  executable: false                  │
└─────────────────────────────────────┘
```

**Key Point:** Program accounts store immutable bytecode. Data accounts store mutable state.

---

#### 3. Owner: The Security Boundary

**Definition:** The public key address of the program that owns this account.

**The Ownership Rules:**

1. **Only the Owner can modify** the data inside the account
2. **Only the Owner can deduct** lamports from the balance

**Security Model:**
```
┌─────────────────────────────────────┐
│     Alice's Account                 │
├─────────────────────────────────────┤
│  owner: System Program              │
│  lamports: 1,000,000,000            │
└─────────────────────────────────────┘
         ↓
Only System Program can:
- Modify data
- Deduct lamports
```

**Why This Matters:**
- Prevents malicious actors from overwriting your data
- Ensures only authorized programs can move funds
- Creates a clear chain of authority

---

#### 4. Executable: Program vs. State

**Definition:** Boolean flag indicating if the account contains executable code.

| Value | Meaning | Use Case |
|-------|---------|----------|
| `true` | Contains executable bytecode | Smart Contract (Program) |
| `false` | Contains passive data | Data Account (State) |

**Visual:**
```
┌─────────────────────────────────────┐
│     Program Account                 │
├─────────────────────────────────────┤
│  executable: true                   │  ← This is code
│  data: [compiled bytecode]          │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│     Data Account                    │
├─────────────────────────────────────┤
│  executable: false                  │  ← This is data
│  data: [state variables]            │
└─────────────────────────────────────┘
```

---

### Practical Examples of Solana Accounts

#### Example 1: The Standard User Wallet

When Alice creates a wallet to hold SOL:

```
┌─────────────────────────────────────┐
│     Alice's Wallet Account          │
│     Address: AlicePubkey            │
├─────────────────────────────────────┤
│  lamports: 1,000,000,000            │  ← 1 SOL balance
│  data: []                           │  ← Empty (no custom data)
│  owner: System Program              │  ← Owned by System Program
│  executable: false                  │  ← Not a smart contract
└─────────────────────────────────────┘
```

**Key Takeaway:** Even a basic wallet is "owned" by a program. Because the System Program is the owner, only the System Program can debit this account (when Alice signs a transfer transaction).

---

#### Example 2: Deploying a Smart Contract

Bob writes a "Counter Program" in Rust and deploys it:

```
┌─────────────────────────────────────┐
│     Counter Program Account         │
│     Address: CounterProgramID       │
├─────────────────────────────────────┤
│  lamports: 100,000                  │  ← Rent for code size
│  data: [0x01, 0x02, 0xFF, ...]     │  ← Compiled SBF bytecode
│  owner: BPF Loader                  │  ← Owned by BPF Loader
│  executable: true                   │  ← This is runnable code
└─────────────────────────────────────┘
```

**Key Takeaway:** The owner is the BPF Loader (Berkeley Packet Filter Loader). This native Solana program owns, manages, and executes all custom smart contracts.

---

#### Example 3: Storing Program State

Bob's Counter Program needs to store the actual count. Since the Program Account is executable and immutable, it cannot store changing variables. It must create a separate account for state:

```
┌─────────────────────────────────────┐
│     Counter State Account           │
│     Address: CounterStateAddr       │
├─────────────────────────────────────┤
│  lamports: 1,000                    │  ← Rent for data size
│  data: [0, 0, 0, 1]                 │  ← The number "1" in bytes
│  owner: Counter Program ID          │  ← Owned by Bob's Program
│  executable: false                  │  ← This is data
└─────────────────────────────────────┘
```

**Key Takeaway:** The owner of this data account is Bob's Counter Program. This is the critical security link:

- Only the Counter Program can change the number in the data field
- No other program or user can directly edit the count
- This enforces data integrity and security

---

### Summary of Account Hierarchy

Understanding ownership allows you to visualize the chain of command on Solana:

```
┌─────────────────────────────────────────────────────────────┐
│                    ACCOUNT OWNERSHIP CHAIN                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  System Program                                             │
│       ↓ owns                                                │
│  ┌─────────────────────────────────────┐                   │
│  │  User Wallets                       │                   │
│  │  (Alice, Bob, Carol...)             │                   │
│  └─────────────────────────────────────┘                   │
│                                                             │
│  BPF Loader                                                 │
│       ↓ owns                                                │
│  ┌─────────────────────────────────────┐                   │
│  │  Custom Programs                    │                   │
│  │  (Counter, Token, NFT...)           │                   │
│  └─────────────────────────────────────┘                   │
│       ↓ owns                                                │
│  ┌─────────────────────────────────────┐                   │
│  │  Data Accounts (State)              │                   │
│  │  (Counter values, Token balances)   │                   │
│  └─────────────────────────────────────┘                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**By mastering this structure, you understand how Solana achieves:**
- High throughput (parallel execution)
- Strict security (ownership model)
- Efficient resource management (rent system)

---

## Part 3: Understanding Solana Programs

### The Executable Stateless Account

To master Solana development, you must understand its unique program architecture.

**Definition:** A Program on Solana is an **Executable Stateless Account**.

**Two Key Characteristics:**

1. **Executable:** Like everything on Solana, a program is stored in an account with `executable: true`
2. **Stateless:** Programs do **not** store user data, variables, or state within their own accounts

---

### Instructions vs. Transactions

#### The Instruction (ix)

**Definition:** A function call to a program.

**Represents:** A specific directive telling a targeted program exactly what logic to execute.

**Example:**
```
ix = "call counter program with instruction: increment"
```

---

#### The Transaction (tx)

**Definition:** A bundle of instructions.

**Represents:** The atomic unit sent to the network.

**Characteristics:**
- Can contain **one or multiple** instructions
- Instructions can invoke the same program multiple times
- Instructions can interact with different programs sequentially
- **Atomic:** If any instruction fails, the entire transaction fails

**Example:**
```
tx = {
    instructions: [
        "call counter program: increment",
        "call token program: transfer",
        "call system program: create account"
    ],
    accounts: [Alice, Bob, Counter, TokenAccount, SystemProgram],
    signatures: [Alice's signature]
}
```

---

### The Structure of a Transaction

Let's look at how Alice initializes a counter program:

```
┌─────────────────────────────────────────────────────────────┐
│                    TRANSACTION STRUCTURE                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  tx = {                                                     │
│      instructions: [                                        │
│          "call counter program",                            │
│          "initialize counter state"                         │
│      ],                                                     │
│      accounts: [                                            │
│          Alice,              // Signer/Payer               │
│          Counter Account,    // Where state will be stored  │
│          System Program      // Required to create account  │
│      ],                                                     │
│      signatures: [Alice]                                    │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**The Logic Behind Account Declaration:**

You must declare **every account** upfront. This is not arbitrary—it powers parallel execution.

**How It Works:**

```
Transaction A: [Alice, Counter Account]
Transaction B: [Carol, Bob]

No overlap → Execute in parallel ✓

Transaction C: [Alice, Counter Account]
Overlap with A → Must wait for A to complete
```

**By inspecting the accounts list before execution, the Solana runtime (Sealevel) can:**
1. Determine transaction dependencies without running code
2. Identify non-overlapping transactions
3. Execute them simultaneously

---

### Step-by-Step Execution: Initializing a Counter Program

Let's trace the complete execution flow:

---

#### Step 1: Submission

Alice constructs the transaction:
```
tx = {
    instructions: ["initialize counter state"],
    accounts: [Alice, Counter Account, System Program],
    signatures: [Alice]
}
```

She signs the transaction (authorizing fee/rent payment) and broadcasts it to the Solana cluster.

---

#### Step 2: Program Invocation

The Solana runtime receives the transaction and:
1. Identifies the target: Counter Program
2. Invokes it with instruction data: `ix = init counter state`

---

#### Step 3: Creating the State Account

The Counter Program executes its logic. It needs to store the integer `0`.

**Constraint:** Generic programs cannot simply generate new accounts. Only the **System Program** can create new accounts.

---

#### Step 4: Cross-Program Call (CPI) to System Program

The Counter Program performs a **Cross-Program Invocation (CPI)**:

```
Counter Program → CPI → System Program
Request: "create account"
```

**During this step:**
- System Program requires payment for **Rent**
- Alice (declared as signer) pays this rent
- Rent amount is proportional to the data size

---

#### Step 5: Ownership Assignment

The System Program creates the new "Counter Account" and:

**Crucially:** Assigns the **Owner** of this new account to be the **Counter Program**.

This adheres to Solana's security model:
- Only the owner of an account is permitted to modify its data
- By assigning ownership to the Counter Program, the System Program grants it authority to write to this account

---

#### Step 6: Writing State

Now that the "Counter Account" is created and ownership is assigned:

```
Counter Program writes: count = 0
Into: Counter Account's data field
```

The transaction succeeds, and the state is persisted on the blockchain.

---

### Complete Execution Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│              INITIALIZING A COUNTER PROGRAM                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. SUBMISSION                                              │
│     ↓                                                       │
│     Alice signs and broadcasts transaction                  │
│     tx = {                                                  │
│         instructions: ["init counter"],                     │
│         accounts: [Alice, Counter, SystemProgram]          │
│     }                                                       │
│                                                             │
│  2. PROGRAM INVOCATION                                      │
│     ↓                                                       │
│     Runtime identifies target: Counter Program              │
│     Invokes with: ix = init counter state                   │
│                                                             │
│  3. STATE CREATION NEEDED                                   │
│     ↓                                                       │
│     Counter Program needs to store "0"                      │
│     Cannot create account directly                          │
│                                                             │
│  4. CROSS-PROGRAM CALL (CPI)                                │
│     ↓                                                       │
│     Counter Program → System Program                        │
│     Request: "create account"                               │
│     Alice pays rent for storage                             │
│                                                             │
│  5. OWNERSHIP ASSIGNMENT                                    │
│     ↓                                                       │
│     System Program creates Counter Account                  │
│     Sets owner = Counter Program ID                         │
│     Only Counter Program can modify this account            │
│                                                             │
│  6. WRITING STATE                                           │
│     ↓                                                       │
│     Counter Program writes count = 0                        │
│     Into Counter Account's data field                       │
│                                                             │
│  7. SUCCESS                                                 │
│     ↓                                                       │
│     Transaction completes                                   │
│     State persisted on blockchain                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

### Key Takeaways

| Concept | Explanation |
|---------|-------------|
| **Stateless Architecture** | Logic (Program) and Data (State Account) are completely decoupled |
| **Rent** | Creating state requires storage bytes; cost paid in SOL by transaction initiator |
| **Efficiency via Declaration** | Declaring all accounts upfront enables parallel execution |
| **Ownership Rules** | Data security enforced via ownership; programs can only write to accounts they own |

---

## Final Summary

### Ethereum vs. Solana: At a Glance

| Aspect | Ethereum | Solana |
|--------|----------|--------|
| **Mental Model** | Contract = Code + State | App = Programs + Accounts |
| **Data Storage** | Inside contracts | In separate accounts |
| **Execution** | Sequential | Parallel |
| **Cost Model** | Gas fees | Rent system |
| **Upgradability** | Immutable (proxy needed) | Upgradable by default |
| **Throughput** | ~15-30 TPS | ~65,000 TPS |

### The Solana Account Model

**Every piece of data lives in an account with:**
- `lamports`: Balance (pays rent)
- `data`: The actual information
- `owner`: Who can modify it
- `executable`: Is it code or data?

**The Ownership Chain:**
```
System Program → User Wallets
BPF Loader → Custom Programs → Data Accounts
```

### The Transaction Model

**Transactions bundle instructions and declare all accounts upfront:**
- Enables parallel execution
- Ensures atomicity
- Powers Solana's high throughput
