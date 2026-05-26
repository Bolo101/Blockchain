# Throughput vs. Time to Finality

To measure blockchain performance, two important metrics are used: throughput and time to finality. Throughput measures how many transactions are finalized per second, usually expressed in transactions per second, or TPS. Time to finality measures how long it takes for a transaction to move from being submitted to validators to becoming unchangeable. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

These two metrics are very different, but both matter. Blockchain builders want **high throughput** so the network can process many transactions, and **short time to finality** so users do not have to wait long for confirmation. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

## Highway Analogy

A useful way to understand these concepts is to imagine a highway. Each car represents a transaction, and all cars travel at the same speed. When you click *send* in your wallet, it is like a car entering the highway. When the transaction is finalized and no longer reversible, it is like the car reaching its destination. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

Throughput is similar to the number of lanes on the highway. More lanes allow more cars to pass in the same amount of time, which increases overall traffic capacity. In a blockchain network, increasing block capacity can play a similar role by allowing more transactions to be processed per unit of time. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

Time to finality is the time it takes for the car to travel from its starting point to its destination. Once the car arrives, it cannot turn around, just as a finalized transaction cannot be changed or canceled. The goal is therefore to build a system with many lanes and a fast arrival time: high throughput with low finality delay. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

## Network Comparison

| Network | Throughput | Time to Finality |
|---|---:|---:|
| Bitcoin | 7 TPS | 60 min |
| Ethereum | 30 TPS | 6.4 min |
| Avalanche / Avalanche L1 | 2500 TPS | ~0.8 seconds |  [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

This comparison shows why Avalanche is often presented as a network optimized for both speed and scalability. It combines high transaction capacity with very short confirmation times, which is a strong advantage for applications that need fast user feedback and rapid settlement. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)
