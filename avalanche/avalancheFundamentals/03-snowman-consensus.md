# Snowman Consensus

Snowman is the Avalanche consensus protocol used to order blocks in a linear chain. It relies on repeated sub-sampled voting, meaning that each validator repeatedly asks a small random subset of other validators for their current preference. Based on those responses, the validator may update its own preference until the network converges on a single outcome.

## Changing Preference

To understand how this works, imagine a validator trying to decide whether the next accepted block should support Charlie, represented by yellow, or Bob, represented by blue. At the beginning, each validator chooses a preference randomly. What matters is not which option is chosen first, but that all honest validators eventually converge on the same result.

The validator then samples five other nodes and receives two responses for yellow and three responses for blue. In Avalanche consensus, a validator changes its preference when an **α-majority** of the sampled validators supports another option. If we set \(\alpha = 3\), then three out of five votes are enough to switch preference. Since blue has three responses, the validator updates its own preference to blue.

From that point on, if another validator asks for its current preference, it will answer blue. This is how preferences gradually propagate through the network.

## Consecutive Successes

Avalanche consensus does not stop after a fixed number of rounds. Instead, it continues until the validator has seen its preference confirmed for \(\beta\) consecutive rounds. After the preference changes to blue, the validator queries five other nodes again. If three of them still support blue, that round is counted as a success.

This process repeats until the validator has seen the same preferred outcome for the required number of consecutive successful rounds. In the example, finality is reached after 8 consecutive confirmed rounds. The key idea is that repeated agreement increases confidence until the decision becomes final.

## Consensus Parameters

The protocol can be described using four parameters:

| Symbol | Name | Meaning |
|---|---|---|
| \(n\) | Number of participants | Total number of validators in the system. |
| \(k\) | Sample size | Number of validators queried in each round. |
| \(\alpha\) | Quorum size | Minimum number of sampled validators that must agree to trigger a preference change. |
| \(\beta\) | Decision threshold | Number of consecutive successful rounds needed to finalize the decision. |

These parameters let each node tune the protocol to balance speed, confidence, and network overhead.

## Finalization

In the common case, when a transaction has no conflict, finalization happens very quickly. When conflicts do exist, honest validators tend to cluster around one choice through repeated sampling, creating a positive feedback loop. As more validators adopt the same preference, the probability of the network converging on that outcome increases rapidly.

Avalanche consensus guarantees, with high probability and depending on the chosen parameters, that if one honest validator accepts a transaction, the other honest validators will eventually reach the same decision. This is what makes the protocol both fast and robust.

## Technical Summary

Snowman can be understood as a metastable voting process repeated over a chain of blocks. Validators do not need global communication with every other participant at every step. Instead, they rely on repeated local samples, preference updates, and consecutive confirmations to reach finality.

The result is a consensus protocol that is efficient, scalable, and well suited to block ordering in Avalanche-based networks.