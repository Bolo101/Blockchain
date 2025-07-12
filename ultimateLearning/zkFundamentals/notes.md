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

- Claim / Statement : an assertion that something is true. In ZKPs it refers to the property being proven without being revealed

- Private and public inputs : 
1. Private inputs are inputs to the system which are only known to the prover and not the verifier
2. Public inputs are inputs known to both the prover and the verifier

- Constraint : Mathematical condition which must be satisfied in order for the claim to be valid. It defines the rules the inputs must follow

- Circuit : A system of constraints makes up the circuit. The circuit defines how the contraints work together

- Witness : The set of private values that allow a prover to demonstrate that their claim is valid. The witness must satisfy the contraints of the circuit and can integrate intermediary calculation

- Prover : Entity that generates the proof of computation to demonstrate knowledge of the witness while satisfying the circuit constraints

- Verifier : Entity that checks whether the proof is valid or not