# Zero-Knowledge Proof Fundamentals

## Introduction

Proving you know a secret without having to reveal this secret
This allow Alice to prove Bob she knows the answer to his problem without risking to have her solution stollen

ZKP is a cryptographic method that allows the prover to convince the verifier that they know an information without revealing that information itself

To be valid a SKP should be :

- Completeness : If the statement is true, an honest prover must be able to convice the verifier
- Soundness : If the statement is false, no dishonest prover can convince an honest verifier
- Zero-Knowledge : The verifier must learn nothing except the provers's statement is true

The key benefit of using Zero-knowledge Proofs in ZK-Rollups is to improve scalability by bunding transactions and verifying them with a single proof

## Interactive vs Non-Interactive ZKPs

Ali Baba cave puzzle
Interactive is for multiple rounds of communication where you have to repeat a challenge several times. By repeting the challenge (with some changes but still same result expected) correctly several times the odds of guessing decreases.

Interactive ZKPs are not suitable for blockchain purposes as you need to maintain a state between rounds and store all that data.

With non-interactive ZKPs you can prove a secret to all people in a single round.

## ZK Terminology