+++
title = "What Does Turing Complete Really Mean?"
date = 2026-01-10
description = "Why brains and AI are 'approximate Turing machines'"
draft = true

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

In [Part 1](@/blog/turing-machines.md), we explored what a Turing machine is: an abstract model of computation with a tape, a head, and a finite set of states. Now let's tackle the question that prompted this exploration: what does it mean for something to be "Turing complete"?

## Turing Completeness

A system $S$ is **Turing complete** if it can simulate any Turing machine.

That's it. If you can build a Turing machine emulator inside your system, your system is Turing complete. Python, JavaScript, C, Excel (yes, really), Conway's Game of Life, and even PowerPoint have all been shown to be Turing complete.

### The Requirements

For a system to be Turing complete, it generally needs:

1. **Unbounded memory**: Not infinite, but capable of growing without a predetermined limit
2. **Conditional branching**: The ability to do different things based on what it reads
3. **Read/write/state modification**: Can inspect memory, change memory, and track computation progress

There's an equivalent definition from mathematical logic: a system is Turing complete if it can compute all **partial recursive functions**, which are functions built from basic operations (zero, successor, projection) plus composition, primitive recursion, and the minimization operator. The details don't matter here; what matters is that every formalization of "computable function" turns out to describe exactly the same class of functions.

## The Universal Turing Machine

Here's where things get interesting. A **Universal Turing Machine** (UTM) is a *specific* Turing machine $U$ that takes as input an encoding of another machine $M$ plus an input $w$, written $\langle M, w \rangle$, and simulates $M$ running on $w$:

$$U(\langle M, w \rangle) = M(w)$$

Think of it as an interpreter. Just as a Python interpreter takes Python source code and executes it, a UTM takes a description of a Turing machine and executes it.

### UTM vs Turing Completeness

This distinction confused me at first. The clarification:

- **UTM**: A *thing*, a specific construction with concrete states and transitions
- **Turing completeness**: A *property*, whether a system has enough expressive power

Analogy:
- A Python interpreter written in Python is like a UTM (a specific program that runs other programs)
- Asking "is JavaScript Turing complete?" is asking about the language's expressive power

**Connection**: One way to *prove* a system is Turing complete is to build a UTM inside it. But you could also prove it by showing it computes all partial recursive functions, or by simulating some other system already known to be Turing complete.

## The Church-Turing Thesis

> A function is computable (in the intuitive sense) if and only if it's computable by a Turing machine.

This isn't a theorem; it's a *thesis*, almost a definition. The evidence for it: every formalism mathematicians have invented for "computation" (Turing machines, lambda calculus, recursive functions, register machines) turned out to compute exactly the same class of functions. Nothing has exceeded what Turing machines can do.

**Turing completeness is the ceiling of computability.** You can't do "more" than a Turing machine can. You might do it faster, more conveniently, with less code, but not more.

## The Limits: Undecidability

If Turing machines are so powerful, can they solve everything? No.

The **Halting Problem** asks: given an encoding $\langle M, w \rangle$, does machine $M$ halt on input $w$, or does it run forever?

Turing proved no algorithm can solve this. The proof is a beautiful diagonal argument, the same technique Cantor used to prove the reals are uncountable (and that I explored in [a previous post](@/blog/four-proofs-by-diagonalization.md)).

**Proof sketch**: Assume a halting-decider $H$ exists. Construct a diabolical machine $D$ that on input $\langle M \rangle$:
1. Runs $H(\langle M, \langle M \rangle \rangle)$
2. If $H$ says "halts," loop forever
3. If $H$ says "loops," halt immediately

What does $D(\langle D \rangle)$ do?
- If it halts → $H$ said "halts" → $D$ loops. Contradiction.
- If it loops → $H$ said "loops" → $D$ halts. Contradiction.

Therefore $H$ cannot exist. $\blacksquare$

This has profound implications. **Rice's Theorem** generalizes it: *any* non-trivial property of what a program computes is undecidable. You can't write a program to reliably detect bugs, verify security properties, or determine if two programs do the same thing. Not in full generality.

## Back to Demis

Now we can understand what Hassabis meant when he said "the human brain (and AI foundation models) are approximate Turing Machines."

**What Turing completeness gives you**: Any problem that's solvable at all can be solved by your system. You're not limited like a finite automaton (which can't even detect palindromes). You have the *character* of general-purpose computation.

**What Turing completeness doesn't give you**:
- **Efficiency**: A Turing machine simulation might be astronomically slow
- **Convenience**: Writing a web server as TM state transitions would be nightmarish
- **Decidability**: The halting problem is still unsolvable

**What "approximate" means**: Real systems have finite memory and finite time. My laptop can't actually run forever or store infinitely many symbols. We say Python is "Turing complete" under the idealization of unlimited resources. In reality, every computer is just a very large finite automaton.

Hassabis's point is that brains and AI have the *architecture* for general computation (not specialized like a pocket calculator) but operate under real constraints. They're close enough to the theoretical ideal that they can, in principle, learn to solve any computable problem given enough time, memory, and data.

This is what distinguishes "general intelligence" from narrow, specialized computation like a thermostat or a chess-specific chip. The brain isn't optimal (Magnus Carlsen isn't better than Stockfish), but it's *general*: capable of learning chess, writing poetry, and inventing new domains entirely.

## Takeaway

Turing machines define the boundary of what's computable. Being Turing complete means having full computational power, at least in principle: any solvable problem is expressible in your system.

Real systems (brains, AI models, laptops) are "approximate" Turing machines: they have the architecture for general computation but operate under finite constraints. That approximation is close enough for practical generality, which is why we can invent chess, build 747s, and train AI to do the same.

The limits are real too. Some problems (like the Halting Problem) are provably unsolvable by *any* Turing machine, and therefore by any computer, any brain, any AI. Computability has a ceiling, and we've mapped it precisely.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
