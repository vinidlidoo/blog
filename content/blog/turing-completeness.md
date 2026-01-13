+++
title = "What It Means to Be Turing Complete (Part 2/3)"
date = 2026-01-10
description = "Why brains and AI are 'approximate Turing machines'"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

In [Part 1](@/blog/turing-machines.md), we built Turing machines (TM) from scratch: a tape, a head, a handful of states and transitions. Our palindrome detector had maybe a dozen states.

The quote that started this series was Demis Hassabis [claiming](https://x.com/demishassabis/status/2003097405026193809) that "the human brain (and AI foundation models) are approximate Turing Machines." But Hassabis surely didn't mean that our minds are like little palindrome detectors. He was rather making a claim about *computational power*: brains can compute anything that's computable at all, given enough time (compute) and memory. The technical term for this property is **Turing complete**.

## The Universal Turing Machine

In [Part 1](@/blog/turing-machines.md), we built individual machines for each problem: one for palindromes, one for even-counting. Each was a fixed device, hardwired for one task. Want to check primes? Build a new machine. Want to sort numbers? Build another.

Turing asked: could we build *one* machine that does the job of all of them?

The answer is yes. A **Universal Turing Machine** (UTM) is a specific Turing machine $U$ that takes an encoding $\langle M, w \rangle$ of another machine $M$ and input $w$, then simulates $M$ running on $w$:

$$U(\langle M, w \rangle) = M(w)$$

The encoding is just data on the tape: states as numbers, the transition table as a list of rules, then the input $w$. The UTM reads this description and executes it step by step, tracking $M$'s state, head position, and tape contents on its own tape.

This is where the term "program" comes from. The UTM doesn't need to be rebuilt for each task; you just feed it a different program (i.e., encoding). Your laptop works the same way: the Python script you run is the encoded machine $M$, the file you feed it is the input $w$, and the CPU simulates $M$ on $w$, step by step.

## Turing Completeness

Turing didn't physically build the UTM; he specified it precisely enough that it *could* be built. The specification itself is the proof saying: here's a concrete machine that simulates any other. We call any system with this power **Turing complete**: give it an encoding $\langle M, w \rangle$, and it can do whatever $M$ would do on $w$.

What does it take to be Turing complete? Three things:

1. **Unbounded read/write memory**: Storage that can grow without limit, with the ability to both read from and write to arbitrary locations (like the TM's infinite tape and read/write head)
2. **Conditional branching**: Different behavior based on data values (like the transition function: "if in state $q$ reading $s$, then...")
3. **Unbounded iteration**: The ability to repeat operations indefinitely, via loops, recursion, or equivalent (a TM can cycle through states as many times as needed)

That's enough. Python has these. So do JavaScript, C, Excel (yes, really), and even PowerPoint. The encoding might be absurd, but it will work.

## The Ceiling

But is Turing complete the *most* powerful a system can be? Could we build something stronger: a system that solves problems no Turing machine can?

A Turing machine computes a function: give it input $w$, and it produces output $M(w)$ (or runs forever). Different formalisms define "computable function" differently. Turing invented his tape-and-head model. Alonzo Church, working independently, defined computation using pure functions. Others proposed their own definitions. Remarkably, every reasonable formalization turned out to define exactly the same class of functions. Different starting points, same destination.

This convergence is the evidence behind the **Church-Turing Thesis**:

> A function is effectively computable if and only if it is computable by a Turing machine.

No one has ever found a counterexample.

The thesis answers our question. There's no "super-computer" beyond Turing completeness. You can build faster systems, systems with nicer syntax. But you can't build a system that computes *more* than a Turing machine can.

**Turing completeness is the ceiling.**

## Back to Demis

Brains and neural networks are Turing complete: they branch, loop, and can expand memory as needed. In theory, they can solve any computable problem.

"General intelligence" just means solving enough of them. How many depends on the definition you use. The gap between current AI and that goal isn't underlying capability, it is about solving enough computable problems **efficiently**. Humans and AI are "approximate" Turing machines because they're finite. A Turing machine has infinite tape and unlimited time; we have fixed parameters and deadlines. But for problems we actually care about, finite should be good enough, provided we get efficiency right.

What we don't yet know is the fastest path to get there: better data, more compute, smarter architectures? Probably all of the above. Thousands of researchers and billions of dollars are at work on exactly this question, day in and day out.

## What's Next

Turing completeness tells us what's *possible*. But it doesn't tell us what's *impossible*.

In [Part 3](@/blog/limits-of-computation.md), we'll open the ceiling and take a look above. Some problems are provably unsolvable: not just hard, but impossible for any Turing machine, any computer, any brain, any AI.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
