+++
title = "The Limits of Computation"
date = 2026-01-11
description = "What Turing machines can't do, and why it matters"
draft = true

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

In [Part 2](@/blog/turing-completeness.md), we established that Turing completeness is the ceiling of computational power. Every reasonable formalism for "computation" turns out to be equivalent. You can't build something stronger than a Turing machine.

But that raises a question: can Turing machines solve *everything*?

No. And the proof is surprisingly elegant.

## The Halting Problem

Here's a simple question: given a program, will it ever finish running?

This seems like something we should be able to answer. You'd feed your code to an analyzer, and it would tell you "this terminates" or "this loops forever." Incredibly useful. You could catch infinite loops before running code, verify that critical software terminates, prove programs correct without exhaustive testing.

The **Halting Problem** asks: can we build such an analyzer? Given an encoding of a Turing machine $M$ and an input $w$, written $\langle M, w \rangle$, does $M$ halt on $w$?

Turing proved no such analyzer can exist. The proof uses a **diagonal argument**, the same technique Cantor used to prove the reals are uncountable (which I explored in [Four Proofs by Diagonalization](@/blog/four-proofs-by-diagonalization.md)). And it hinges on self-reference: what happens when a machine analyzes *itself*?

## The Diagonal Argument

Suppose a halting-decider $H$ exists. Given any $\langle M, w \rangle$, it tells us whether $M$ halts on $w$.

Here's the key trick. An encoding $\langle M \rangle$ is just a string of symbols (say, 0s and 1s). And a Turing machine will run on *any* string you put on its tape. It might reject strange inputs, or loop forever, or do something unexpected, but it will do *something*. So we can feed a machine its own encoding as input: run $M$ on the string $\langle M \rangle$. In our $\langle M, w \rangle$ notation, this is $\langle M, \langle M \rangle \rangle$: machine $M$, input $\langle M \rangle$.

If $H$ exists, we could build a table answering this for every machine. Let $M_1, M_2, M_3, \ldots$ be all Turing machines. Each cell shows what $H$ says about machine $M_i$ running on input $\langle M_j \rangle$:

| Machine | Input $\langle M_1 \rangle$ | Input $\langle M_2 \rangle$ | Input $\langle M_3 \rangle$ | ... |
|---|:---:|:---:|:---:|:---:|
| $M_1$ | **H** | L | H | |
| $M_2$ | L | **L** | H | |
| $M_3$ | H | H | **L** | |
| ... | | | | |

Read this table row by row: each row is a machine, each column is an input. The cell at row $M_i$, column $\langle M_j \rangle$ shows whether $M_i$ halts (H) or loops (L) on input $\langle M_j \rangle$.

The diagonal (bolded) answers a special question: does $M_i$ halt on $\langle M_i \rangle$? Does each machine halt when fed its own description?

Now construct a machine $D$ that does the *opposite* of the diagonal:

1. Take input $\langle M \rangle$
2. Use $H$ to check: does $M$ halt on input $\langle M \rangle$?
3. If $H$ says "halts," loop forever
4. If $H$ says "loops," halt immediately

$D$ is a Turing machine. We've built it from computable pieces: run $H$, check the result, branch accordingly. It inverts the diagonal: where $M_1$ halts on itself, $D$ loops; where $M_2$ loops on itself, $D$ halts.

But $D$ is in our list of all machines. What does $D$ do on input $\langle D \rangle$?

- If $D$ halts → $H$ said "$D$ halts on $\langle D \rangle$" → but then $D$ loops. Contradiction.
- If $D$ loops → $H$ said "$D$ loops on $\langle D \rangle$" → but then $D$ halts. Contradiction.

There's no consistent answer. $D$ can't behave consistently, which means $H$ can't exist. $\blacksquare$

## Why This Matters

The halting problem might seem like a contrived edge case. Who cares about machines analyzing themselves? But it has real consequences.

**Rice's Theorem** generalizes the halting problem: *any* non-trivial property of what a program computes is undecidable. "Non-trivial" means some programs have the property and some don't. If you want to know whether a program ever outputs a specific value, or ever accesses the network, or ever enters an infinite loop, no analyzer can tell you in general.

Take a concrete example: does this program ever write to disk? For a *specific* program, you might be able to tell by inspection. But undecidability means something stronger: there is no single analyzer that correctly answers this for *all* possible programs. No matter how clever the tool, some program will defeat it.

This explains phenomena programmers encounter daily:

- **Static analysis tools produce false positives.** They must sometimes say "might be a bug" when there isn't one, because perfect accuracy is impossible. If a tool claims zero false positives, it's missing real bugs.

- **Compilers can't always eliminate dead code.** Whether code is reachable depends on runtime behavior, which can't be determined statically in general.

- **Formal verification works only for restricted domains.** Full correctness proofs are possible when you limit what programs can do. General-purpose verification hits undecidability walls.

- **Antivirus can't catch all malware.** If virus detection were decidable, malware authors could test their code against the detector until it passed.

## The Boundary

Here's the deeper insight: we've precisely mapped the boundary between what's computable and what isn't.

Inside the boundary: sorting, searching, arithmetic, chess, protein folding, training neural networks. Any well-defined problem with a finite description.

Outside the boundary: determining program behavior in general. Not because we haven't found a clever enough algorithm; because no algorithm can exist. It's a mathematical impossibility, as certain as $\sqrt{2}$ being irrational.

This boundary doesn't depend on technology. Faster computers, quantum computers, whatever comes next: none of it changes what's computable. The halting problem will still be undecidable.

## Takeaway

Turing completeness is powerful; it captures all of computation. But "all of computation" has limits.

Some problems are provably unsolvable by *any* Turing machine, and therefore by any computer, any brain, any AI. The halting problem is just the simplest example. Rice's theorem tells us the pattern generalizes: determining what programs *do* is fundamentally harder than running them.

This isn't a failure of engineering. It's a deep fact about the nature of computation itself.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
