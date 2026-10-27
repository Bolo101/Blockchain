# Consensus Mechanisms

Consensus is essential in blockchain networks because it allows all validators to agree on the current state of the distributed ledger. In a decentralized system, there is no single central authority to decide which transactions are valid, so the network must rely on a consensus mechanism to establish one shared version of the truth. This common agreement ensures that every participant sees the same ledger state and that the blockchain remains consistent. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

Validators reach this agreement by following a set of rules known as a consensus protocol. The protocol defines how validators evaluate transactions, resolve disagreements, and decide which state changes should be accepted. Although different blockchains use different consensus mechanisms, they all pursue the same goal: making sure that the network converges on one valid state accepted by the majority of validators. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

## Ordering Through Consensus

Consensus is not only about deciding whether a transaction is valid, but also about determining the order in which transactions are processed. This ordering is critical because the state of a blockchain depends on the sequence of accepted transactions. When two transactions conflict, validators must agree on which one is applied first, since that choice determines the next valid state of the system. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

This is especially important in distributed systems, where there is only a limited notion of time. Even if two transactions are not created at exactly the same instant, validators across the network may receive them in different orders. Because of this, the blockchain cannot rely on simple timestamps alone and instead depends on consensus to establish a shared ordering. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

## Double-Spending Attack

A double-spending attack occurs when a user tries to spend the same funds more than once by creating multiple transactions that reference the same balance. The problem is that each transaction can appear valid when viewed in isolation, even though the user only has enough funds to support one of them. Consensus is what prevents both transactions from being accepted at the same time. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

For example, suppose Alice owns 5 AVAX. She creates one transaction sending 5 AVAX to Bob and another transaction sending the same 5 AVAX to Charly. Since both transactions use the same funds, only one of them can ultimately be included in the blockchain. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

Even if Alice does not send both transactions at the exact same moment, validators cannot always know which one was issued first. Different validators may receive different transactions first depending on network timing. As a result, the validators must collectively decide which transaction will be accepted as part of the next state and which one will be rejected. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

This is why consensus is so important: it ensures that all honest validators eventually agree on the same result. In the case of conflicting transactions, consensus allows the network to choose one valid outcome and reject the other, preserving the integrity of the ledger and preventing double spending. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)
