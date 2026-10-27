# Hands-On Exercise: Using a Signature Scheme

## Overview

Now that we've learned the theory behind signature schemes, it's time to put that knowledge into practice! This hands-on exercise will guide you through the complete process of generating keys, signing a message, and verifying a signature. By following these steps, you'll see firsthand how the cryptographic concepts we've discussed work in real life.

This exercise demonstrates the three fundamental operations of any signature scheme:
1. **Generate Key Pair** - Creating your digital identity
2. **Sign Message** - Creating proof that you approved a message
3. **Verify Signature** - Confirming that a signature is authentic

---

## Step 1: Generate Keys

### What You'll Do

Start by generating a **Key Pair** consisting of a **Public Key** and a **Secret Key** (also called a Private Key).

### What's Happening Behind the Scenes

When you click the generate button, the following process occurs:

```
┌─────────────────────────────────────────────────────────────────┐
│                    KEY GENERATION PROCESS                       │
├─────────────────────────────────────────────────────────────────┤
n                                                                 │
│  1. RANDOM NUMBER GENERATION                                    │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  The algorithm generates a large, random number      │    │
│     │  using a cryptographically secure random generator   │    │
│     │  This randomness is crucial for security!            │    │
│     └─────────────────────────────────────────────────────┘    │
│                              ↓                                  │
│  2. PRIVATE KEY CREATION                                        │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  The random number becomes your Private Key          │    │
│     │  This key must be kept SECRET at all times           │    │
│     └─────────────────────────────────────────────────────┘    │
│                              ↓                                  │
│  3. PUBLIC KEY DERIVATION                                       │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  Using mathematical operations, the Public Key       │    │
│     │  is derived from the Private Key                    │    │
│     │  This key can be SHARED with anyone                  │    │
│     └─────────────────────────────────────────────────────┘    │
│                              ↓                                  │
│  4. KEY PAIR OUTPUT                                            │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  You now have:                                      │    │
│     │  • Private Key: Keep this secret!                   │    │
│     │  • Public Key: Share this freely                    │    │
│     └─────────────────────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### What You'll See

After generating the keys, you'll typically see something like:

**Secret Key (Private Key):**
```
0x7a9f2c8e4d1b6a3f5c8e2d1b4a7f9c2e8d1b4a7f9c2e8d1b4a7f9c2e8d1b4a
```

**Public Key:**
```
0x04b470edf87dc8decad6a39ed105a6a6411b88275c6a0ac06c0dea3144980eaf0635fabda79ceda360583acd0802adb27e
```

### Important Notes

| Aspect | Explanation |
|--------|-------------|
| **Uniqueness** | Each time you generate a new key pair, you get completely different keys |
| **Security** | The keys are generated using secure random number generation |
| **Relationship** | The public key is mathematically derived from the private key, but you cannot reverse this process |
| **Storage** | In a real application, you would securely store the private key (often encrypted) and share the public key |

### Why This Step Matters

This step creates your **digital identity**. Just as your physical identity allows you to sign documents in the real world, your key pair allows you to sign messages in the digital world. The private key is like your physical signature—only you can create it. The public key is like your signature on file—anyone can use it to verify that a signature is really yours.

---

## Step 2: Sign a Message

### What You'll Do

Now use the generated **Secret Key** to sign a **Message**. You can pick any message you want to sign—for example, a Latin phrase like *"Per consensum ad astra"* (Through consensus to the stars), which is fitting for a blockchain course!

### What's Happening Behind the Scenes

When you sign a message, the following cryptographic process occurs:

```
┌─────────────────────────────────────────────────────────────────┐
│                    MESSAGE SIGNING PROCESS                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INPUTS:                                                        │
│  • Message: "Per consensum ad astra"                           │
│  • Secret Key: [Your private key from Step 1]                   │
│                                                                 │
│  1. MESSAGE PROCESSING                                          │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  The message is converted into a numerical format    │    │
│     │  (often using a cryptographic hash function)        │    │
│     │  This ensures consistent representation             │    │
│     └─────────────────────────────────────────────────────┘    │
│                              ↓                                  │
│  2. SIGNATURE GENERATION                                       │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  The algorithm combines:                             │    │
│     │  • The processed message                            │    │
│     │  • Your secret key                                  │    │
│     │  Using complex mathematical operations              │    │
│     └─────────────────────────────────────────────────────┘    │
│                              ↓                                  │
│  3. SIGNATURE OUTPUT                                           │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  A unique signature is produced that is:             │    │
│     │  • Tied to this specific message                     │    │
│     │  • Tied to your specific secret key                  │    │
│     │  • Impossible to forge without your secret key       │    │
│     └─────────────────────────────────────────────────────┘    │
│                                                                 │
│  OUTPUT:                                                        │
│  • Signature: [A long hexadecimal string]                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### What You'll See

After signing the message, you'll see:

**Message:**
```
Per consensum ad astra
```

**Signature:**
```
0x8efb19ca904a1d061a84070d5bad61ce1ea44d0e1d9c0a2ecced89692a5546ea39bb02ff1563186767d0903901d5304c126c2ad97dc2efe97c2d528039aff266e9337646498e90b089a4ebfa624e2f353aceca545b7f14b7c2707f3340bd6827
```

### Key Properties of the Signature

| Property | Explanation |
|----------|-------------|
| **Uniqueness** | This signature is unique to both the message and your secret key |
| **Deterministic** | The same message + same secret key always produces the same signature |
| **Unforgeable** | Without your secret key, it's practically impossible to create this signature |
| **Message-Bound** | If you change even one character in the message, the signature changes completely |

### Try This Experiment

After signing your first message, try these variations to understand how signatures work:

1. **Change the message slightly**: Change "Per consensum ad astra" to "Per consensum ad astras" (add an 's')
   - Notice how the signature changes completely!
   - This demonstrates the **integrity** property

2. **Sign a completely different message**: Try signing "Hello, world!"
   - You'll get a completely different signature
   - This shows that signatures are **message-specific**

3. **Sign the same message again**: Sign "Per consensum ad astra" a second time
   - You'll get the same signature (deterministic)
   - This proves the signature is **reproducible**

### Why This Step Matters

This step creates **mathematical proof** that you approved the message. The signature serves as your digital endorsement—just like signing a paper document, but much more secure. Anyone who sees this signature can verify that you (the holder of the secret key) genuinely approved this specific message.

---

## Step 3: Verify the Signature

### What You'll Do

Anyone who has access to your **Public Key** (corresponding to the Private Key used for signing the message) can now verify the signature of the message. This verification confirms the **Authenticity**, **Non-Repudiation**, and **Integrity** of the message.

### What's Happening Behind the Scenes

When you verify a signature, the following process occurs:

```
┌─────────────────────────────────────────────────────────────────┐
│                   SIGNATURE VERIFICATION PROCESS                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  INPUTS:                                                        │
│  • Message: "Per consensum ad astra"                           │
│  • Signature: [The signature from Step 2]                       │
│  • Public Key: [Your public key from Step 1]                   │
│                                                                 │
│  1. MATHEMATICAL CHECK                                          │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  The algorithm performs mathematical operations to   │    │
│     │  check if the signature matches the message and      │    │
│     │  the public key                                     │    │
│     └─────────────────────────────────────────────────────┘    │
│                              ↓                                  │
│  2. THREE VALIDATION CHECKS                                    │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  ✓ AUTHENTICITY: Does the signature prove the        │    │
│     │    message came from the holder of this public key?  │    │
│     │                                                        │    │
│     │  ✓ INTEGRITY: Has the message been changed since     │    │
│     │    it was signed?                                     │    │
│     │                                                        │    │
│     │  ✓ NON-REPUDIATION: Can the signer deny having       │    │
│     │    signed this message? (No—they cannot!)            │    │
│     └─────────────────────────────────────────────────────┘    │
│                              ↓                                  │
│  3. VERIFICATION RESULT                                        │
│     ┌─────────────────────────────────────────────────────┐    │
│     │  Result: VALID ✓                                     │    │
│     │                                                        │    │
│     │  This means:                                          │    │
│     │  • The message is authentic                           │    │
│     │  • The message hasn't been tampered with             │    │
│     │  • The signer cannot deny their approval             │    │
│     └─────────────────────────────────────────────────────┘    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### What You'll See

When you verify the signature, you'll see one of two outcomes:

**Successful Verification:**
```
✓ Signature is VALID
```

**Failed Verification (if something is wrong):**
```
✗ Signature is INVALID
```

### What Verification Confirms

When verification succeeds, it confirms three critical security properties:

| Property | What It Means | Why It Matters |
|----------|---------------|----------------|
| **Authenticity** | The message genuinely came from the person who holds the private key corresponding to this public key | Prevents impersonation and fraud |
| **Integrity** | The message hasn't been altered since it was signed | Detects tampering and corruption |
| **Non-Repudiation** | The signer cannot deny having signed the message | Provides accountability and legal proof |

### Try These Verification Experiments

To understand verification better, try these scenarios:

1. **Verify the original signature**: Use the original message, signature, and public key
   - Result: **VALID** ✓
   - Everything is correct

2. **Modify the message**: Change one character in the message, then verify with the original signature
   - Result: **INVALID** ✗
   - This proves the **integrity** property—any change is detected

3. **Use a different signature**: Try verifying with a signature from a different message
   - Result: **INVALID** ✗
   - This shows signatures are **message-specific**

4. **Use a different public key**: Try verifying with someone else's public key
   - Result: **INVALID** ✗
   - This demonstrates the **authenticity** property—only the correct public key works

### Why This Step Matters

This step is what makes digital signatures useful in the real world. It allows **anyone** (not just you) to verify that a message is authentic and hasn't been tampered with. This is the foundation of trust in digital systems—from blockchain transactions to secure emails to software updates.

---

## The Complete Workflow: From Start to Finish

Let's visualize the entire process from key generation to verification:

```
┌─────────────────────────────────────────────────────────────────┐
│                    COMPLETE SIGNATURE WORKFLOW                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  STEP 1: GENERATE KEY PAIR                                      │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  You generate:                                          │   │
│  │  • Private Key: [Keep secret!]                          │   │
│  │  • Public Key: [Share freely]                           │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              ↓                                  │
│  STEP 2: SIGN MESSAGE                                          │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  You create a signature for:                             │   │
│  │  • Message: "Per consensum ad astra"                     │   │
│  │  • Using: Your Private Key                              │   │
│  │  • Result: Signature                                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              ↓                                  │
│  STEP 3: SHARE MESSAGE + SIGNATURE + PUBLIC KEY                │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  You send to others:                                    │   │
│  │  • Message: "Per consensum ad astra"                     │   │
│  │  • Signature: [The signature you created]               │   │
│  │  • Public Key: [Your public key]                        │   │
│  └─────────────────────────────────────────────────────────┘   │
│                              ↓                                  │
│  STEP 4: VERIFICATION (by anyone)                             │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  Anyone can verify:                                     │   │
│  │  • Using: Message + Signature + Public Key              │   │
│  │  • Result: VALID ✓                                      │   │
│  │  • Confirms: Authenticity, Integrity, Non-Repudiation   │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Real-World Applications

This simple three-step process is the foundation of countless real-world applications:

| Application | How It Uses Signatures |
|-------------|------------------------|
| **Blockchain Transactions** | Every transaction is signed with the sender's private key, proving they authorized it |
| **Secure Email** (PGP, S/MIME) | Emails are signed to prove they came from the claimed sender and weren't altered |
| **Software Updates** | Updates are signed by the developer to ensure they haven't been tampered with |
| **SSL/TLS Certificates** | Websites use certificates signed by trusted authorities to prove their identity |
| **Legal Documents** | Digital signatures on contracts provide legally binding proof of agreement |
| **Avalanche Cross-Chain Messaging** | Validators sign messages to prove events occurred on source chains |

---

## Technical Terms Defined

| Term | Definition |
|------|------------|
| **Key Pair** | A set of two mathematically related keys: a private key (kept secret) and a public key (shared freely). They are generated together and work in tandem for signing and verification. |
| **Secret Key** | Another term for private key. It must be kept secret and is used to create digital signatures. Only the owner should have access to it. |
| **Public Key** | A cryptographic key that can be freely shared with anyone. It is used to verify signatures created with the corresponding private key. |
| **Sign** | The process of creating a digital signature for a message using a private key. This creates mathematical proof that the message was approved by the private key holder. |
| **Verify** | The process of checking whether a digital signature is valid for a given message and public key. This confirms authenticity, integrity, and non-repudiation. |
| **Signature** | A mathematical value generated by signing a message with a private key. It proves the message came from the private key holder and hasn't been altered. |
| **Authenticity** | The property of being genuine. In signature verification, authenticity confirms that the message truly originated from the claimed sender. |
| **Non-Repudiation** | The assurance that the signer cannot deny having signed a message. Digital signatures provide mathematical proof that the sender authorized the message. |
| **Integrity** | The assurance that data has not been modified. Signature verification ensures that any change to a message, no matter how small, will be detected. |
| **Deterministic** | A property where the same inputs always produce the same output. The same message signed with the same private key always produces the same signature. |
| **Cryptographic Hash** | A mathematical function that converts data of any size into a fixed-size string. Often used in signature schemes to process messages before signing. |
| **Unforgeable** | A property where it is practically impossible to create a valid signature without the private key. This is achieved through strong cryptography. |
| **Message-Bound** | A property where a signature is uniquely tied to a specific message. Changing the message requires a new signature. |

---

## Key Takeaways

- **Key Generation** creates your digital identity—a unique pair of keys that only you can use to sign
- **Signing** creates mathematical proof that you approved a specific message
- **Verification** allows anyone to confirm that a signature is authentic and the message hasn't been tampered with
- **Three security properties** are guaranteed: Authenticity (proves origin), Integrity (detects tampering), Non-Repudiation (prevents denial)
- **The process is deterministic**: Same message + same key = same signature
- **The process is sensitive**: Any change to the message produces a completely different signature
- **Anyone can verify**: You don't need secret information to check a signature—only the public key
- **This is the foundation** of trust in digital systems, from blockchain to secure communications
