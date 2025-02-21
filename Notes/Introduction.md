# Resolving the Double-Spending Problem  
The Bitcoin blockchain was the first to propose a solution to this issue. The idea is to ensure that when a file is sent, the sender does not retain a copy of the file.  

The blockchain must also enable the correct transfer of value from one node to another.  

## Eliminating Intermediaries in Transactions  
Value can be transferred using smart contracts (ownership, assets, etc.).  

## Blockchain as a Ledger  
The blockchain serves as a ledger for all transactions of a virtual currency.  

## Blockchain Expansion  
The blockchain grows as new blocks are added.  

## Transaction Processing  
New transactions are processed by computers connected to the network (nodes).  

## Block Integrity  
Each block contains the fingerprint (hash) of previous blocks, meaning that modifying one block results in changes to all subsequent blocks.  

## Types of Nodes  
There are two types of nodes:  
- **Full nodes**: Store a complete copy of the blockchain.  
- **Light nodes**: Host a minimal version of the blockchain, sufficient for participating in the network.  

## Miners' Role  
Miners:  
- Store a full copy of the blockchain.  
- Add new transaction lists.  
- Execute smart contracts on the blockchain.  
- Ensure the blockchain’s integrity.  
- Generate new tokens.  

## Transaction Data  
A transaction includes the following data:  
- **From** (Sender’s address)  
- **To** (Recipient’s address)  
- **Value** (in Wei, where 1 Ether = 10¹⁸ Wei)  
- **Gas** (miner's fee)  
- **GasPrice** (amount of Wei per gas unit)  
- **Nonce** (a security integer to prevent replay attacks)  
- **Data** (ABI string in byte format)  

## Ethereum Account and Keys  
- Each account is represented by an address, which is a hash of the public key.  
- Every Ethereum network account has a **public key** and a **private key**.  
- The **private key** is used to sign transactions and must be kept secure and confidential.  
- The public key can be derived from the private key.  

## Blockchain and Hashing  
- The blockchain only stores **data fingerprints (hashes)**, not the actual data.  
- Hash functions are **deterministic**—the same input will always produce the same output.  
- All blocks are linked by their hashes and are copied across all nodes in the network.  
- To falsify a piece of data, one would have to alter all blocks on all nodes, making it extremely difficult.  

---

# Smart Contracts  
- Smart contracts are **bytecode** stored directly on the blockchain.  
- Written in a high-level language, typically **Solidity**.  
- Compiled into bytecode and executed within the **Ethereum Virtual Machine (EVM)**.  
- Once deployed, a smart contract **cannot be modified or deleted**.  

---

# Additional Concepts  

## Gateway  
A blockchain gateway facilitates interactions with decentralized applications (dApps).  

## Ethereum Name Service (ENS)  
ENS functions like a **DNS for Ethereum**. It is an open-source, distributed, and extensible naming system based on the Ethereum blockchain. ENS maps human-readable names (e.g., `alice.eth`) to:  
- Ethereum addresses  
- Other cryptocurrency addresses  
- Content hashes  
- Metadata  

ENS also supports **reverse resolution**, associating metadata (such as canonical names or interface descriptions) with Ethereum addresses.  

## Pod  
Pods are a lightweight permissions system built around a **Safe multi-signature wallet**. Pods manage signers through **membership NFTs**.  
- If an address holds a membership NFT, it automatically gains signing rights on the pod’s multi-sig wallet.  
- When creating a pod or "podifying" an existing Safe, it is assigned a name like `.pod.xyz`.  
- Example: If the Safe is named `"test"`, its podified version is `test.pod.xyz`.  
- As a pod interacts with web3 applications, it is labeled with its ENS name instead of the Safe address.  

## Safe (Gnosis Safe Multi-Sigs)  
A **Gnosis Safe** is a **smart contract wallet** that requires multiple people to approve a transaction before it can be executed on-chain.  
