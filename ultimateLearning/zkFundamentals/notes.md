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

- Trusted Setup : It is a procedure that is done once to generate data that must be used every time some cryptographic protocol is run

- Toxic waste : leaked secret that can be used bu attacker to forge fake proofs

- Common reference string : A set of public parameters that both the prover and the verifier use in the proof generation and verification processes

- Structured Reference String : Structured data (can be a point on an elliptic curve)

- Multi-Party Computation : Use of several parties to compute to get final secret. The overall secret (τ) remains secure and unrecoverable as long as at least one participant acts honestly and destroys their secret contribution.

- Powers of Tau : "Powers of Tau" refers to a specific type of trusted setup ceremony (and the resulting SRS) commonly used in SNARKs like Groth16 and PLONK. The SRS generated contains a series of elliptic curve points representing successive powers of the secret tau, such as G, τ·G, τ²·G, ..., τᵏ·G, where G is a generator point of an elliptic curve.

- Polynomial Commitment Schemes : A polynomial commitment scheme is a cryptographic tool that allows a prover to commit to a polynomial P(x) in a way that hides its coefficients, yet allows them to later prove certain properties about P(x) (like its evaluation at a specific point) without revealing the entire polynomial.

- SNARK : A SNARK in the context of zero-knowledge proofs stands for Succinct Non-interactive ARgument of Knowledge. It is a cryptographic protocol that lets one party (the prover) convince another party (the verifier) that they know a secret or that a computation was performed correctly—without revealing any details about the secret itself.

## Proof of computation

More than just proving a knowledge, ZKPs can be used to prove a computation.

Proof of compuation implies proof of knowledge of the private inputs

## Requirements of zeo-knowledge

- Completeness : if a statement is valid, a prover must always be able to convince a verifier if they have knowledge of the witness

- Soundness : it must be practically impossible for a dishonest prover to convince an honest verifier with an invalid witness

- Zero-Knowledge : the verifier must learn nothing other than the provers knowledge of a witness to the statement

## Create a ZKP

- Front-End : Arithmetization & contraint system written in a language like Noir in ACIR. Code is compiled to generate the witness

- Back-End : Proof generation using the ACIR and create a proof of execution. It demonstrates knowledge of the correct solution to the circuit without revealing the secret. The verifier checks the proof against to prover as a verification