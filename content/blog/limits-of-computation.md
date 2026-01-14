+++
title = "The Limits of Computation (Part 3/3)"
date = 2026-01-11
description = "What Turing machines can't do, and why it matters"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

In [Part 2](@/blog/turing-completeness.md), we established that Turing completeness is the ceiling of computational power. Every reasonable formalism for "computation" turns out to be equivalent. You can't build something stronger than a Turing machine.

But can Turing machines solve *everything*?

No. And the proof is surprisingly elegant. It will also lead us, almost immediately, to one of the most famous results in mathematics: Gödel's Incompleteness Theorem.

## The Halting Problem

Here's a simple question: given a program, will it ever finish running?
In our formalism from [Part 1](@/blog/turing-machines.md), a "program" is an encoding $\langle M, w \rangle$: a Turing machine $M$ together with its input $w$, written as data on a tape. So the halting question is: does $M$ halt on $w$?

Imagine a *Halt Decider*, $H$. Feed it your code and it tells you "this terminates (halts)" or "this loops forever." If it existed, you could use it on any program to catch infinite loops before deployment, verify that critical software always returns an answer, guarantee any recursive function won't recurse forever. Incredibly useful.

The **Halting Problem** asks: can we build such $H$? Not for one specific program, but a general procedure that correctly answers for *all* $\langle M, w \rangle$.

Turing proved no such procedure can exist.

## Intuition

It's useful to notice that "yes" and "no" answers to the halting question are fundamentally different.

For "yes" answers, just run the program long enough. If it halts after a week, you can say confidently "yes, it halts." 

"no" answers are different. Suppose you've been running a program for a thousand years and it still hasn't halted. Can you say "no, it won't ever halt"? You can't. Maybe it'll halt in a thousand and one years. At no point does running the program entitle you to say "no."

This asymmetry hints at the impossibility. Let's now prove it.

## The Diagonal Argument

Suppose, toward contradiction, that we have a procedure $H$ that solves the halting problem. Given any program $P$ and input, $H$ correctly tells us whether $P$ halts.

Now I'll use $H$ as a subroutine to build a new program. Call it $Q$. Program $Q$ takes another program $P$ as input and does the following:

1. Ask $H$: "Would $P$ halt if we ran it on $P$ itself?"
2. If $H$ says "yes, $P$ halts on $P$" → $Q$ loops forever
3. If $H$ says "no, $P$ doesn't halt on $P$" → $Q$ halts immediately

That's it. $Q$ asks whether $P$ halts on itself, then does the *opposite*.

Step 1 is the diagonal part: we're feeding $P$ its own description as input. This is the same self-referential trick behind [Russell's paradox](@/blog/russells-paradox.md) and Cantor's diagonal argument we explored in [Three Proofs by Diagonalization](@/blog/three-proofs-by-diagonalization.md).

Now comes the punch line. $Q$ is a program. What happens when we run $Q$ on *itself*?

- If $Q$ halts on $Q$, then $H$ must have said "$Q$ halts on $Q$," so by step 2, $Q$ loops forever. Contradiction.
- If $Q$ doesn't halt on $Q$, then $H$ must have said "$Q$ doesn't halt on $Q$," so by step 3, $Q$ halts. Contradiction.

$Q$ halts on $Q$ if and only if $Q$ doesn't halt on $Q$. That's impossible. So $H$ cannot exist.

The halting problem is **undecidable**. $\blacksquare$

## Why This Matters

What does "undecidable" mean? **A problem is decidable if there exists a procedure that always halts and always gives the correct yes/no answer.** The halting problem is undecidable: no such procedure exists. For any would-be halt decider, there's some program it gets wrong (or runs forever on).

The halting problem might seem like a contrived edge case. But it is only the tip of the iceberg. [Rice's Theorem](https://en.wikipedia.org/wiki/Rice%27s_theorem), proved in 1953 by Henry Gordon Rice, generalized it: *any* non-trivial property of what a program computes is undecidable. Want to know if a program ever outputs a specific value? Undecidable. Ever accesses the network? Undecidable. Contains a security vulnerability? Undecidable.

This explains why static analysis tools sometimes produce false positives, why compilers can't always eliminate dead code, and why antivirus software can't catch all malware. Perfect program analysis is mathematically impossible.

## Gödel's Incompleteness Theorem

The halting problem immediately proves one of the most famous results in mathematics.

In the early 20th century, David Hilbert proposed an ambitious goal: find a finite set of axioms from which every true statement about numbers could be mechanically derived. Start with basic axioms like "$0$ is a number" and "$x + 0 = x$," add rules of inference, and in principle you could prove any true arithmetic statement.

Here we need to distinguish two concepts:
- A statement is **true** if it accurately describes actual numbers (e.g., "there is no largest prime")
- A statement is **provable** if it can be derived from axioms via inference rules

These aren't obviously the same thing. Truth is about what's actually the case; provability is about what follows from your starting assumptions. Hilbert's dream, called **Hilbert's program**, was to make them coincide for arithmetic: every true statement should be provable, and every provable statement should be true.[^1]

If such a system existed, you could build a theorem-proving machine: start from the axioms, apply inference rules in every possible way, and output each theorem as you derive it.[^2] $1 + 1 = 2$. Every prime has a larger prime. One by one, every true statement about numbers.

Here's the key insight: **such a machine would solve the halting problem.** Whether a program halts is a question about finite sequences of state transitions—exactly the kind of thing arithmetic can express. If the axiom system were complete, then for any program $M$ and input $w$, either "$M$ halts on $w$" or "$M$ doesn't halt on $w$" would be provable. The enumeration machine would eventually find whichever proof exists, and we'd have our answer.

But we already proved the halting problem is undecidable. So the system cannot be complete.

> **Gödel's First Incompleteness Theorem**: Any computable axiom system[^3] capable of expressing basic arithmetic is incomplete. There exist true statements that the system cannot prove.

This is the punchline: **truth outruns provability.** No matter what axioms you choose, some statements will be *independent*—neither provable nor refutable within the system.

[^1]: The second half—every provable statement is true—is called *soundness*, and we definitely want it. An unsound system proves false things, which is useless. The first half—every true statement is provable—is called *completeness*. Gödel showed completeness is impossible.

[^2]: Why can we enumerate theorems? A proof is a finite sequence of steps, each following mechanically from axioms or previous steps. Enumerate all finite sequences, check each for validity, output the conclusion of valid proofs. Every provable statement eventually appears.
[^3]: The system must also be *consistent*: it never proves both $P$ and $\neg P$. An inconsistent system can prove anything (including contradictions), making "completeness" trivially achievable but meaningless.

## Takeaway

We've traced a boundary between what's computable and what isn't. In Part 2, we saw that Turing completeness is the ceiling: you can't compute more than a Turing machine can. But now we've seen that this ceiling has holes. Some problems have no procedure that always halts with the correct answer.

**Inside**: any yes/no problem for which we can write a terminating procedure. Is this number prime? Trial division will tell you. What's 347 × 892? Long multiplication gives the answer. Sort this list? Mergesort terminates with the correct ordering. These are decidable: we have procedures that always halt with correct answers.

**Outside**: the halting problem is just the beginning. Rice's theorem tells us that *any* interesting question about program behavior is undecidable. Does this code have a bug? Will it ever access the network? Is it equivalent to this other program? No single general algorithm can answer these for **all programs**. And Gödel tells us the problem runs deeper: some true statements about numbers can never be proven from any finite set of axioms.

This boundary doesn't depend on technology. Faster computers, quantum computers, whatever comes next: the halting problem will still be undecidable, and arithmetic will still be incomplete. There are truths that no mechanical procedure can discover. That's a deep fact about the nature of computation itself.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
