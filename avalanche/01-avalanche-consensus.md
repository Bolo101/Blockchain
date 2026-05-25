# Consensus in Blockchain

Consensus in a blockchain is the process by which a distributed network of nodes agrees on a single version of the truth. Because there is no central authority, participants must follow a consensus protocol to validate transactions and keep the ledger consistent across the network. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

One of the main problems consensus solves is the double-spending attack, where the same funds are spent more than once through conflicting transactions. A consensus protocol ensures that the network converges on one valid history and rejects conflicting outcomes. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

## Avalanche Consensus Mechanism

Avalanche uses a family of consensus protocols based on repeated random subsampling. Instead of asking every validator to vote on every decision, a validator queries a small random subset of other validators and observes their current preference. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

If a strong enough majority in the sample supports one option, the validator adopts that preference. The validator then repeats the process over multiple rounds until it sees the same result enough consecutive times to finalize the decision with high confidence. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

This design gives Avalanche fast finality, low communication overhead, and strong scalability because each validator communicates with only a small sample rather than the entire network. Avalanche documentation contrasts this with traditional protocols that rely on broader communication patterns. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

## Example

Imagine Alice has 10 AVAX and tries to send the same 10 AVAX to Bob and to Charlie at nearly the same time. These two transactions conflict because only one of them can be accepted by the network. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

A validator that sees both transactions samples a small random group of validators and asks which transaction they currently prefer. If the sampled group mostly prefers the transfer to Bob, the validator updates its own preference to match. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

The validator repeats this process with new random samples. As honest validators continue to influence one another through repeated sampling, the network enters a positive feedback loop and rapidly converges on one transaction while rejecting the other. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

## More Technical View

The Snow family of protocols includes Snowball and Snowman. Snowball is the core metastable voting process for conflicting choices, while Snowman extends it to a linear chain of blocks, which is the model used by Avalanche's execution chains. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

Several parameters control the process. The sample size is commonly noted as \(k\), the quorum threshold as \(\alpha\), and the decision threshold as \(\beta\). Avalanche documentation describes small parameter values in practice, such as \(k=20\), \(\alpha=14\), and \(\beta=20\). [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

In practical terms, a validator queries 20 validators in one round. If at least 14 responses support the same block or transaction, the validator treats that option as preferred; if this same outcome is observed for 20 consecutive successful rounds, the item is finalized. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

Snowman also benefits from transitive voting: a vote for a block counts as support for its ancestors as well. This improves throughput because one vote helps reinforce multiple earlier decisions in the chain. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

Avalanche is also stake-weighted. Validators must bond AVAX to participate, and validators with more stake are sampled more often, which helps defend the network against cheap Sybil participation. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

## Time to Finality and Throughput

Two important performance metrics are throughput and time to finality. Throughput measures how many transactions are finalized per second, usually in TPS, while time to finality measures how long it takes for a submitted transaction to become unchangeable. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

Avalanche Builder Hub gives an illustrative figure of about 2,500 TPS and about 0.8 seconds time to finality for Avalanche / Avalanche L1 in its educational comparison table. Separately, the Snowman documentation describes sub-second immutable finality and says acceptance typically takes only a few seconds in practice. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

These two metrics should not be confused. A blockchain can have high throughput but still make users wait a long time before a transaction is irreversible, whereas Avalanche is designed to keep both throughput high and finality short. [build.avax](https://build.avax.network/docs/primary-network/avalanche-consensus)

In the context of consensus, repeated subsampling helps reduce communication cost per decision, while transitive voting helps one successful vote support an entire chain of ancestors. Together, these properties explain why Avalanche can combine low latency with strong throughput. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

## Technical Mini-Example

Suppose validator V is deciding between two conflicting blocks, Block A and Block B. V samples 20 validators and receives 16 votes for Block A and 4 votes for Block B. Because Block A reaches the threshold \(\alpha=14\), V switches or keeps its preference to Block A for that round. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)

If V keeps seeing a quorum for Block A in the next 19 consecutive rounds, it reaches \(\beta=20\) and finalizes Block A. At that point, Block B is rejected by honest validators following the protocol. [github](https://github.com/ava-labs/mastering-avalanche/blob/main/chapter_09.md)