+++
title = "Ethereum's Merkle Patricia Trie (Part 1/2)"
date = 2026-02-03
description = "How Ethereum stores its state, commits it to a single hash, and why that design is hitting its limits"

[taxonomies]
tags = ["crypto"]

[extra]
katex = true
+++

Ethereum is the second-largest blockchain by market cap, securing hundreds of billions of dollars in value. Everyone knows it's a distributed ledger. But how does it actually store all that data? Hundreds of millions of accounts, each with token balances. Smart contracts with their own persistent storage: token balances, NFT ownership records, DeFi positions. Over 100 GB of state, replicated across nearly a million validators worldwide, growing every day. The answer is a data structure called the Merkle Patricia Trie.

That's about to change. The Hegota hard fork, slated for late 2026, aims to migrate Ethereum's state to a new structure called Verkle trees. It would be the biggest change to how Ethereum represents state since genesis. But to understand why it's being considered, we first need to understand what's there today, and why it's hitting its limits.

## The World State

Ethereum maintains a **world state**: a key-value store where each key is an address and each value is an account.

There are two account types. **Externally owned accounts** (EOAs) are controlled by private keys and can initiate transactions. **Contract accounts** hold code and are triggered by transactions. Both types share the same four data fields:

- **nonce**: a counter that increments with each transaction
- **balance**: native ETH held[^1]
- **codeHash**: hash of the account's bytecode (empty for EOAs)
- **storageRoot**: hash pointing to the contract's storage (empty for EOAs)

Contracts separate storage from code. Storage (token balances, ownership records, configuration) lives in its own key-value store, nested within the world state via `storageRoot`. Code is stored on-chain but outside the world state, referenced by `codeHash`. We'll revisit the nested storage when we discuss proofs.

[^1]: Other tokens like USDC are tracked in contract storage.

## Why a Tree?

If you were building this at a typical tech company, you'd probably use a key-value store: address as the key, account data as the value. Lookups are fast, updates are straightforward, and the tooling is mature. Why does Ethereum need anything more complex?

Ethereum is a distributed system. Nearly a million validators execute the same transactions and must arrive at identical state. To verify consensus, every node produces a **commitment**: a short value that represents the entire state. For now, think of it as a 32-byte hash. This commitment goes in the block header. If yours doesn't match everyone else's, you're on the wrong chain.

This creates two key requirements that a simple key-value store can't satisfy.

### 1. Efficient commitment

To compute a commitment from a key-value store, you'd need to serialize all entries in some deterministic order and hash them together. Now every time you change one balance, you re-serialize and re-hash the entire state. That's O(n) work per block on 100+ GB of data.

A tree fixes this. Each node's hash is computed from its children's hashes. Change a leaf, and only the hashes along the path to the root need updating. That's O(log n) operations instead of O(n).

### 2. Partial proofs

Alice wants to check her balance without trusting anyone. She can't store 100+ GB of state. With a flat key-value store, the only way to verify a value is to recompute the commitment yourself, which requires having the entire state.

A tree fixes this too. To prove a value exists, you provide the path from that leaf to the root, plus enough information (a proof) at each level to recompute the hashes. The verifier reconstructs the root hash from this small proof and checks it against the known root. We'll see exactly how this works when we discuss proofs.

## Tries: Keys as Paths

We've established that we need a tree. We have a key-value store (addresses → accounts) to organize into a tree. How? By using a **trie** (pronounced "try," from re**trie**val).

A trie uses the key itself as the path through the tree. Each character in the key determines which branch to take. For an address like `0x4a7f...`, you start at the root, branch on `4`, then `a`, then `7`, then `f`, and so on until you reach the account data. You don't store keys explicitly; the path *is* the key.

```
                      (root)
                     /  |  \
                    4   8   f
                    |
                    a
                   / \
                  7   c
                  |   |
                 ...  ...
                  |    |
              0x4a7... 0x4ac...
              (acct)   (acct)
```

<!-- FEEDBACK: placeholder note to depict the Patricia optimization in the final diagram -->

Ethereum uses a **hexary** trie: one child per hex digit (0-F), giving a maximum **width** of 16. The **depth** depends on key length. An Ethereum address is 20 bytes (40 hex characters), so the world state trie has a maximum depth of 40. Contract storage tries (referenced by `storageRoot`) use 32-byte keys (64 hex characters), so their maximum depth is 64. The **Patricia** variant used by Ethereum compresses the trie to reduce depth in practice.

## Merkle Patricia Tries

We have the trie structure. Now we add the **Merkle** part.

In a plain trie, each node represents a hex digit in the key. In a Merkle trie, each node also has a hash computed from its children's hashes. Change any leaf, and every node on the path to the root gets a new hash.

How is each node's hash computed? For a branch node, concatenate the hashes of all 16 children (512 bytes = 16 × 32 bytes, using an empty hash for missing children) and hash the result with keccak256, Ethereum's hash function (a variant of SHA-3). The output is a single 32-byte hash.

```
                      ┌─────────────────┐
                      │   Root Hash     │ ← in block header
                      │   0x7d3f...     │
                      └────────┬────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
    ┌────┴────┐           ┌────┴────┐           ┌────┴────┐
    │    4    │           │    8    │           │    f    │
    │ 0xa2b1..│           │ 0x91c4..│           │ 0x55e2..│
    └────┬────┘           └─────────┘           └─────────┘
         │
    ┌────┴────────────────┐
    │                     │
┌───┴────┐           ┌────┴───┐
│   4a   │           │   4c   │
│0x8f7e..│           │0x2d91..│
└───┬────┘           └────┬───┘
    │                     │
    ▼                     ▼
┌────────────┐      ┌────────────┐
│ 0x4a7b...  │      │ 0x4c2f...  │
│ balance:   │      │ balance:   │
│ 1.5 ETH    │      │ 3.2 ETH    │
└────────────┘      └────────────┘
```

The root hash (a single 32-byte value) commits to the entire state. It goes in every block header. Any validator can compute the state root after executing a block's transactions and verify it matches. And because only the path from a changed leaf to the root needs rehashing, we get the O(log n) updates promised earlier—efficient commitment.

Why does this work? **Collision resistance**. It's computationally infeasible to find two different states that produce the same keccak256 root. The root hash uniquely identifies the state.

The actual Ethereum implementation is more complex: RLP encoding to serialize nodes before hashing, three node types (branch, leaf, and extension) where extension nodes implement the Patricia compression. The core idea remains the same.

## Merkle Proofs

We claimed earlier that a tree enables partial proofs: verifying a single value without the full state. Here's how.

Alice wants to verify her Ethereum balance from her phone's wallet. The full state is 100+ GB; she can't store it. She could ask [Infura](https://www.infura.io/) (a third-party service that queries Ethereum for you), but they could be compromised, or lying, or hacked. She'd have no way to know.

The Merkle structure offers an alternative. Ethereum batches transactions into blocks, and each block includes a small header containing metadata, including the state root. Alice (**the verifier**) stores just these headers (a few KB per block). She asks *any* full node (**the prover**) for her balance *plus a proof*. She recomputes the root from the proof. If it matches the header, the balance is correct, mathematically guaranteed.

### Proof and Verification

Consider a trie of depth $d$ and a path $k = (k_0, k_1, \ldots, k_{d-1})$ where each $k_i$ is a hex digit in the account's address. To prove the value at this path, the prover provides:

- The leaf value $v$ (all four account fields)
- At each depth $i$, up to 15 sibling hashes $S_i = \lbrace h_{i,j} : j \neq k_i \rbrace$

Verification reconstructs the root bottom-up. Hash the leaf, then work up the tree, combining with siblings at each level:

$$H_0 = \text{hash}(v)$$

$$H_i = \text{hash}(h_0 \| h_1 \| \cdots \| h_{15})$$

$$\text{where } h_j = \left\lbrace \begin{array}{ll} H_{i-1} & \text{if } j = k_{i-1} \\\ S_i[j] & \text{otherwise} \end{array} \right.$$

If $H_d$ matches the state root, the proof is valid. Note that the prover must supply the full account: if any field were wrong, the leaf hash would differ, and the proof would fail.

```
                         ┌─────────────┐
                         │ H₃ = root?  │  ← check against block header
                         └──────┬──────┘
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
   [0] [1] [2] [3]        [*4*: H₂]        [5] ... [f]     ← 15 siblings + H₂
                                │                    \
        ┌───────────────────────┼────────────┐        \
        │                       │            │        (other
   [0] [1] ... [9]        [*a*: H₁]     [b]...[f]      accounts...)
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
   [0] [1] ... [6]        [*7*: H₀]        [8] ... [f]
                                │
                         ┌──────┴──────┐
                         │   Alice's   │
                         │   account   │  → H₀ = hash(account)
                         │  (4 fields) │
                         └─────────────┘
```

**Walkthrough.** For address `0x4a7...`, the path is $k = (4, a, 7)$. The proof contains Alice's account data plus up to 45 sibling hashes (15 at each of the 3 levels). Verification proceeds bottom-up:

1. Hash the account data → $H_0$
2. Slot $H_0$ into position 7 among its siblings, hash all 16 → $H_1$
3. Slot $H_1$ into position `a` among its siblings, hash all 16 → $H_2$
4. Slot $H_2$ into position `4` among its siblings, hash all 16 → $H_3$
5. Check: does $H_3$ match the state root in the block header?

The verifier never sees the rest of the state, just the sibling hashes needed to reconstruct the path. Those siblings could represent millions of accounts, compressed into 32-byte hashes.

## Smaller Proofs, Bigger Possibilities

Alice can verify a single state value with a Merkle proof. Validators do something similar thousands of times per block: read state, execute transactions, compute a new state root.

Ethereum's core commitment is decentralization. As Vitalik Buterin [put it](https://decrypt.co/154990/future-ethereum-upgrades-could-allow-full-nodes-to-run-on-mobile-phones-vitalik-buterin): "In the longer term there's a plan to maintain fully verified Ethereum nodes where you could literally run it on your phone." Validation should be accessible to ordinary hardware, not just data centers.

Currently the world state [grows by roughly a gigabyte per week](https://www.theblock.co/post/383156/ethereum-foundation-researchers-warn-of-storage-burden-from-state-bloat). As it grows, validators must perform more random disk reads to traverse the trie. As I covered in [a previous article](@/blog/understanding-parquet-files.md), access latency dominates: finding the data on disk takes longer than reading it. To meet Ethereum's 12-second slot constraint, validators need faster storage (SSDs at minimum, increasingly NVMe-class), pushing costs upward and working against the decentralization goals.

But what if validators didn't store state at all? Instead of reading from disk, they could receive proofs for every value a block touches. The same trick Alice used, scaled up.

The problem is proof size. Each proof requires sibling hashes at every level: 15 siblings × 40 levels × 32 bytes ≈ 19 KB worst case, [\~3 KB on average](https://vitalik.eth.limo/general/2021/06/18/verkle.html). With current blocks using [\~30M gas](https://etherscan.io/chart/gasused) and cold state reads costing [2100 gas each](https://eips.ethereum.org/EIPS/eip-2929),[^2] a block easily touches thousands of values. At \~3 KB average, that's several MB of additional bandwidth per block. 10 MB incremental network I/O per block would be over 2 TB/month per validator: the kind of overhead that pushes solo stakers toward data centers.

So proof size is a binding constraint. Shrink the proofs, and stateless validation becomes more viable.

<details>
  <summary>Could we shrink Merkle proofs by reshaping the tree?</summary>

You could by reducing tree width, but it wouldn't be worth it. Each level of trie traversal is a random disk read: the root node points to a child at one location, which points to another child elsewhere. A hexary trie with effective depth ~8-10 means 8-10 random reads per lookup. A binary trie would have depth ~30-40. Even on NVMe, random reads cost tens of microseconds each. Multiply by thousands of state accesses per block, and going binary would blow through the 12-second slot time. Hexary branching was a natural fit for hex-encoded keys, while keeping the trie shallow enough for fast lookups.

And the payoff isn't even that good. A binary trie needs only 1 sibling hash per level instead of 15, but it's 4× deeper. The narrower width helps, but doesn't compensate fully: binary proofs end up about 4× smaller. If hexary proofs run ~10 MB per block, binary gets you to ~2.5 MB... still a significant network overhead.

</details>

[^2]: EIP-2929 distinguishes cold reads (first access, 2100 gas) from warm reads (subsequent, 100 gas). Using cold cost here underestimates total accesses.

## What's Next

Enter Verkle trees, the structure proposed for the Hegota hard fork. They replace sibling hashes with **polynomial commitments**, shrinking proofs from several KB to around 100 bytes each.

Part 2 will cover how Verkle trees work and the cryptography behind them: polynomial commitments, KZG proofs, and how they achieve small proofs without sacrificing security. The math builds on finite fields and elliptic curves, which I covered in [The Math Behind Your Private Key](@/blog/math-behind-private-key.md).

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
