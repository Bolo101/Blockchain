# Consensus in Blockchain

Consensus in a blockchain is the process by which a distributed network of nodes agrees on a single version of the truth. Because there is no central authority, participants must follow a consensus protocol to validate transactions and keep the ledger consistent across the network. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

One of the main problems consensus solves is the double-spending attack, where the same funds are spent more than once through conflicting transactions. A consensus protocol ensures that the network converges on one valid history and rejects conflicting outcomes. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

## Avalanche Consensus Mechanism

Avalanche uses a family of consensus protocols based on repeated random subsampling. Instead of asking every validator to vote on every decision, a validator queries a small random subset of other validators and observes their current preference. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

If a strong enough majority in the sample supports one option, the validator adopts that preference. The validator then repeats the process over multiple rounds until it sees the same result enough consecutive times to finalize the decision with high confidence. [build.avax](https://build.avax.network/academy/avalanche-l1/avalanche-fundamentals/02-avalanche-consensus-intro/03-snowman-consensus)

This design gives Avalanche fast finality, low communication overhead, and strong scalability because each validator communicates with only a small sample rather than the entire network. Avalanche documentation contrasts this with traditional all-to-all protocols such as PBFT, which scale less efficiently. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

## Example

Imagine Alice has 10 AVAX and tries to send the same 10 AVAX to Bob and to Charlie at nearly the same time. These two transactions conflict because only one of them can be accepted by the network. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

A validator that sees both transactions samples a small random group of validators and asks which transaction they currently prefer. If the sampled group mostly prefers the transfer to Bob, the validator updates its own preference to match. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

The validator repeats this process with new random samples. As honest validators continue to influence one another through repeated sampling, the network enters a positive feedback loop and rapidly converges on one transaction while rejecting the other. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

## More Technical View

The Snow family of protocols includes Snowball and Snowman. Snowball is the core metastable voting process for conflicting choices, while Snowman extends it to a linear chain of blocks, which is the model used by Avalanche's main execution chains today. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

Several parameters control the process. The sample size is commonly noted as \(k\), the quorum threshold as \(\alpha\), and the decision threshold as \(\beta\). Avalanche documentation lists default Snowman-style values such as \(K=20\), \(AlphaPreference=15\), \(AlphaConfidence=15\), and \(Beta=20\). [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

In practical terms, a validator queries 20 validators in one round. If at least 15 responses support the same block or transaction, the validator treats that option as preferred; if this same outcome is observed for 20 consecutive successful rounds, the item is finalized. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

Snowman also benefits from transitive voting: a vote for a block counts as support for its ancestors as well. This improves throughput because one vote helps reinforce multiple earlier decisions in the chain. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

Avalanche is also stake-weighted. Validators must bond AVAX to participate, and validators with more stake are sampled more often, which helps defend the network against cheap Sybil participation. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

## Technical Mini-Example

Suppose validator V is deciding between two conflicting blocks, Block A and Block B. V samples 20 validators and receives 16 votes for Block A and 4 votes for Block B. Because Block A reaches the threshold \(\alpha=15\), V switches or keeps its preference to Block A for that round. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

If V keeps seeing a quorum for Block A in the next 19 consecutive rounds, it reaches \(\beta=20\) and finalizes Block A. At that point, Block B is rejected by honest validators following the protocol. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)