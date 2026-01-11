+++
title = "What It Means to Be Turing Complete"
date = 2026-01-10
description = "Why brains and AI are 'approximate Turing machines'"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

In [Part 1](@/blog/turing-machines.md), we built Turing machines (TM) from scratch: a tape, a head, a handful of states and transitions. Our palindrome detector had maybe a dozen states. Our even-1s counter had four.

I also teased the question that started this whole exploration: Demis Hassabis [claimed](https://x.com/demishassabis/status/2003097405026193809) that "the human brain (and AI foundation models) are approximate Turing Machines." But Hassabis must not have meant that brains are own little palindrome detector. He was making rather making a claim about computational *power*: brains can compute anything that's computable at all. The technical term for this property is **Turing complete**.

## Turing Completeness

A system is **Turing complete** if it can simulate any Turing machine. Give it a description of a TM and an input, and it can do whatever that TM would do.

Python is Turing complete. So is JavaScript, C, Excel (yes, really), [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), and even PowerPoint. These systems have all been proven capable of simulating any TM.

What do they have in common? Each one has:

1. **Unbounded storage**: Memory that can grow as needed
2. **Conditional branching**: The ability to do different things based on what it reads
3. **State modification**: Can read, write, and track progress

That's enough. If your system has these three properties, you can encode any Turing machine's logic inside it. The encoding might be absurd, but it works.

## The Universal Turing Machine

In Part 1, we built individual machines: one for palindromes, one for even-counting. Each was a fixed device, hardwired for one task. Want to check primes? Build a new machine. Want to sort numbers? Build another.

Turing asked: could we build *one* machine that does the job of all of them?

The answer is yes. A **Universal Turing Machine** (UTM) is a specific Turing machine $U$ that takes as input an encoding of another machine $M$ plus an input $w$, written $\langle M, w \rangle$, and simulates $M$ running on $w$:

$$U(\langle M, w \rangle) = M(w)$$

The encoding $\langle M, w \rangle$ is just data on the tape: states as numbers, the transition table as a list of rules, then the input $w$. The UTM reads this description and executes it step by step, tracking $M$'s state, head position, and tape contents on its own tape.

This is where "programmable" comes from. The UTM doesn't need to be rebuilt for each task; you just feed it a different program. Your laptop is a physical realization of this idea: the Python script you run is the encoded machine $M$, the file you feed it is the input $w$, and the CPU simulates $M$ on $w$, step by step.

The UTM was Turing's proof that a universal machine is possible. **Turing complete** is the term we now use for any system with this same power. Python is Turing complete; so is JavaScript, C, Excel, and Conway's Game of Life. They can all simulate any Turing machine, which means they're all equivalent in computational power.

## The Ceiling

But is Turing complete the *most* powerful a system can be? Could we build something stronger?

This question has roots in a 1928 challenge from the mathematician David Hilbert called the *Entscheidungsproblem* (decision problem): is there a mechanical procedure that can decide the truth or falsity of any mathematical statement? To answer this, mathematicians first needed to define what "mechanical procedure" even means. That's what Turing was doing when he invented his machine.

Turing came up with his tape-and-head model. Alonzo Church, working independently, invented a completely different formalism based on functions. Others proposed their own definitions. Remarkably, every reasonable definition turned out to compute exactly the same class of functions. Different starting points, same destination.

This convergence is the evidence behind the **Church-Turing Thesis**:

> A function is effectively computable if and only if it is computable by a Turing machine.

"Effectively computable" means: computable by *some* mechanical procedure, a step-by-step process that a human could follow given enough time and paper, without needing insight or creativity. The thesis says Turing machines capture *all* such procedures. If no Turing machine can compute something, no mechanical procedure can.

This answers our question. There's no "super-computer" beyond Turing completeness. You can build faster systems, more convenient systems, systems with better ergonomics. But you can't build a system that computes *more* than a Turing machine can.

**Turing completeness is the ceiling.**

## The Limits: Undecidability

If Turing machines are so powerful, can they solve everything?

No. To show this, we need to find a specific problem that no Turing machine can solve. Turing found one: the **Halting Problem**.

Here's the question: given an encoding $\langle M, w \rangle$, does machine $M$ halt on input $w$, or does it run forever?

This would be useful to solve. Imagine a tool that could analyze any program and tell you "this will finish" or "this will loop forever." You could catch infinite loops before running code, verify that critical software terminates, prove programs correct without exhaustive testing.

But no such tool can exist. No algorithm can decide halting in general. The proof uses a diagonal argument, the same technique Cantor used to prove the reals are uncountable, which I explored in [Four Proofs by Diagonalization](@/blog/four-proofs-by-diagonalization.md). And it hinges on self-reference: what happens when a machine analyzes *itself*?

### The Diagonal Argument

Suppose a halting-decider $H$ exists. Given any $\langle M, w \rangle$, it tells us whether $M$ halts on $w$.

Here's the key trick. An encoding $\langle M \rangle$ is just a string of symbols (say, 0s and 1s). And a Turing machine will run on *any* string you put on its tape. It might reject strange inputs, or loop forever, or do something unexpected, but it will do *something*. So we can feed a machine its own encoding as input: run $M$ on the string $\langle M \rangle$. In our $\langle M, w \rangle$ notation, this is $\langle M, \langle M \rangle \rangle$: machine $M$, input $\langle M \rangle$.

If $H$ exists, we could build a table answering this for every machine. Let $M_1, M_2, M_3, \ldots$ be all Turing machines. Each cell shows what $H$ says about machine $M_i$ running on input $\langle M_j \rangle$:

| Machine | Input $\langle M_1 \rangle$ | Input $\langle M_2 \rangle$ | Input $\langle M_3 \rangle$ | ... |
|---|:---:|:---:|:---:|:---:|
| $M_1$ | **H** | L | H | |
| $M_2$ | L | **L** | H | |
| $M_3$ | H | H | **L** | |
| ... | | | | |

The diagonal (bolded) answers: does $M_i$ halt on $\langle M_i \rangle$? Does each machine halt when fed its own description?

Now construct a machine $D$ that does the *opposite* of the diagonal:
 Take input $\langle M \rangle$
 Use $H$ to check: does $M$ halt on input $\langle M \rangle$?
 If $H$ says "halts," loop forever
 If $H$ says "loops," halt immediately

$D$ is a Turing machine: we've built it from computable pieces (run $H$, check the result, return loop or halt). It inverts the diagonal: where $M_1$ halts on itself, $D$ loops; where $M_2$ loops on itself, $D$ halts.

But $D$ is in our list of all machines. What does $D$ do on input $\langle D \rangle$?
- If $D$ halts → $H$ said "$D$ halts on $\langle D \rangle$" → but then $D$ loops. Contradiction.
- If $D$ loops → $H$ said "$D$ loops on $\langle D \rangle$" → but then $D$ halts. Contradiction.

There's no consistent answer. $D$ can't behave consistently, which means $H$ can't exist. $\blacksquare$

### Implications

The halting problem is just one example. **Rice's Theorem** generalizes it: *any* non-trivial property of what a program computes is undecidable.

Take a different question: does this program ever write to disk? For a *specific* program, you might be able to tell by inspection. But undecidability means something stronger: there is no single analyzer that correctly answers this for *all* possible programs. No matter how clever the tool, some program will defeat it.

This is why static analysis tools produce false positives: they must sometimes say "might be a bug" when there isn't one, because perfect accuracy is impossible. It's why compilers can't always eliminate dead code. It's why formal verification works only for carefully restricted domains.
## Back to Demis

Now we can understand what Hassabis meant when he said "the human brain (and AI foundation models) are approximate Turing Machines."

**What Turing completeness gives you**: Any problem that's solvable at all can be solved by your system. You're not limited like a finite automaton, which can't even detect palindromes (as we saw in Part 1). You have the *architecture* for general-purpose computation.

**What Turing completeness doesn't give you**:
- **Efficiency**: A Turing machine simulation might be astronomically slow
- **Convenience**: Writing a web server as TM state transitions would be nightmarish
- **Decidability**: The halting problem is still unsolvable

**What "approximate" means**: Real systems have finite memory and finite time. A Turing machine has an infinite tape; your laptop has 16GB of RAM. Our even-1s machine from Part 1 had 4 states; your brain has 86 billion neurons. Both are finite.

We say Python is "Turing complete" under the idealization of unlimited resources. Strictly speaking, every physical computer is just a very large finite automaton. But the finiteness rarely matters in practice: the tape is long enough, the memory is large enough, for any problem we actually care about.

Hassabis's point is that brains and AI have the *architecture* for general computation, not specialized like a thermostat or a chess chip. They're close enough to the theoretical ideal that they can, in principle, learn to solve any computable problem given enough time, memory, and training data.

This is what distinguishes "general intelligence" from narrow computation. The brain isn't optimal at any single task (Magnus Carlsen loses to Stockfish), but it's *general*: capable of learning chess, writing poetry, and inventing new domains entirely.

## Takeaway

We started with a question: what did Hassabis mean by "approximate Turing machines"?

Now we have an answer. Turing machines define the boundary of what's computable. Being Turing complete means having the architecture for general computation: any solvable problem can, in principle, be expressed in your system.

Real systems (brains, AI models, laptops) are "approximate" because they operate under finite constraints. But the approximation is close enough for practical generality, which is why we can invent chess, build 747s, and train AI to do the same.

The limits are real too. Some problems (like the Halting Problem) are provably unsolvable by *any* Turing machine, and therefore by any computer, any brain, any AI. Computability has a ceiling, and we've mapped it precisely.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
