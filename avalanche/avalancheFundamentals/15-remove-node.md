# Removing a Node from Your Avalanche L1

## Overview

After you have finished testing your Avalanche Layer 1 (L1) blockchain, you may want to stop and remove the node. This is particularly useful for two main reasons:

1. **Resource Management**: Freeing up system resources (CPU, memory, disk space) that the node is consuming
2. **Clean Restart**: Starting fresh with a new node configuration using different parameters

---

## Step 1: Stop the Node

To gracefully stop your running Avalanche node, use the following Docker command:

```bash
docker stop avago
```

### What Happens When You Stop the Node?

When you execute this command, Docker sends a termination signal to the container, allowing it to shut down cleanly. Importantly, **no data is lost** during this process.

### Understanding Data Persistence

The node's critical data is stored in a specific directory on your host machine:

- **Location**: `~/.avalanchego` (in your home directory)
- **What's stored there**:
  - **Node credentials**: cryptographic keys and identity information
  - **Blockchain state**: the current state of your L1 blockchain, including all transactions and blocks

This means that when you want to resume your work later, you can simply restart the node with:

```bash
docker start avago
```

The node will automatically pick up exactly where it left off, with all your blockchain data intact.

---

## Step 2: Remove the Node Container

If you want to completely remove the Docker container (not the data), use:

```bash
docker rm avago
```

### Important Distinction

This command **only removes the Docker container itself**. It does **not** delete:
- The blockchain state
- The node credentials
- Any data stored in `~/.avalanchego`

---

## Step 3: Complete Removal (Optional)

If you want to permanently delete everything—including all blockchain data and credentials—you must manually remove the data directory:

```bash
rm -rf ~/.avalanchego
```

**Warning**: This action is irreversible. Once deleted, your blockchain state and node identity cannot be recovered.

---

## Technical Terms Defined

| Term | Definition |
|------|------------|
| **Docker Container** | A lightweight, standalone package that includes everything needed to run an application (in this case, your Avalanche node). Think of it as a virtual environment isolated from your host system. |
| **Node** | A computer running blockchain software that participates in the network. In Avalanche, nodes validate transactions and maintain copies of the blockchain state. |
| **Blockchain State** | The complete current condition of the blockchain, including all account balances, smart contract states, and transaction history. |
| **Layer 1 (L1)** | The base layer of a blockchain network. Avalanche L1 allows you to create your own custom blockchain with its own rules, while still benefiting from Avalanche's security and infrastructure. |
| **Credentials** | Cryptographic keys and identifiers that prove your node's identity on the network. These are essential for your node to participate in consensus. |
| **Persistence** | The ability of data to survive beyond the runtime of a program. Here, it means your blockchain data is saved to disk and remains available even after the node stops. |
| **Host Machine** | The physical or virtual computer on which Docker is running. In your case, this is your personal computer or server. |

---

## Summary of Commands

| Action | Command | Data Preserved? |
|--------|---------|-----------------|
| Stop node | `docker stop avago` | ✅ Yes |
| Restart node | `docker start avago` | ✅ Yes (resumes from saved state) |
| Remove container only | `docker rm avago` | ✅ Yes |
| Remove everything | `rm -rf ~/.avalanchego` | ❌ No (permanent deletion) |

---

## Best Practices

1. **Stop before removing**: Always use `docker stop` before `docker rm` to ensure clean shutdown
2. **Backup before deletion**: If you plan to delete `~/.avalanchego`, consider backing it up first if the data might be valuable
3. **Resource monitoring**: Keep an eye on your system resources while the node is running, especially if you're running on a machine with limited RAM or CPU