+++
title = "The Limits of Computation"
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

Imagine a **Halt Decider**: feed your code to an analyzer $H$, and it tells you "this terminates" or "this loops forever." You could catch infinite loops before deployment, verify that critical software always returns an answer, guarantee your recursive function won't recurse forever. Incredibly useful.

The **Halting Problem** asks: can we build such an analyzer? Not for one specific program, but a general procedure that correctly answers for *all* $\langle M, w \rangle$.

Turing proved no such procedure can exist.

## The Yes/No Asymmetry

The "yes" and "no" answers to the problem are fundamentally different.

For "yes" answers, you don't need to understand the program at all. Just run it. If it halts after a week, you say "yes, it halted." Getting the yes answers is almost trivial.

But "no" answers are different. Suppose you've been running a program for a thousand years and it still hasn't halted. Can you say "no, it won't ever halt"? You can't. Maybe it'll halt in a thousand and one years. At no point does running the program entitle you to say "no."

To say "no, this program will never halt," you would need *deep insight* into what this particular program is doing. You need to understand its structure well enough to see that it can never finish. That's a fundamentally harder task than just running it and waiting.

This asymmetry hints at the impossibility. Let's prove it.

## The Diagonal Argument

Suppose, toward contradiction, that we have a procedure $H$ that solves the halting problem. Given any program $P$ and input, $H$ correctly tells us whether $P$ halts.

Now I'll use $H$ as a subroutine to build a new program. Call it $Q$. Program $Q$ takes another program $P$ as input and does the following:

1. Ask $H$: "Would $P$ halt if we ran it on $P$ itself?"
2. If $H$ says "yes, $P$ halts on $P$" → $Q$ loops forever
3. If $H$ says "no, $P$ doesn't halt on $P$" → $Q$ halts immediately

That's it. $Q$ asks whether $P$ halts on itself, then does the *opposite*.

Step 1 is the diagonal part: we're feeding $P$ its own description as input. This is the same self-referential trick behind Russell's paradox and Cantor's diagonal argument. (I explored these in [Four Proofs by Diagonalization](@/blog/four-proofs-by-diagonalization.md).)

Now comes the punch line. $Q$ is a program. What happens when we run $Q$ on *itself*?

- If $Q$ halts on $Q$, then $H$ must have said "$Q$ halts on $Q$," so by step 2, $Q$ loops forever. Contradiction.
- If $Q$ doesn't halt on $Q$, then $H$ must have said "$Q$ doesn't halt on $Q$," so by step 3, $Q$ halts. Contradiction.

$Q$ halts on $Q$ if and only if $Q$ doesn't halt on $Q$. That's impossible. So $H$ cannot exist.

The halting problem is **undecidable**. $\blacksquare$

## Why This Matters

What does "undecidable" mean? A problem is **decidable** if there's an algorithm that always halts and always gives the correct yes/no answer. The halting problem is undecidable: no such algorithm exists. For any would-be halt decider, there's some program it gets wrong (or runs forever on).

The halting problem might seem like a contrived edge case. But it is only the tip of the iceberg. [Rice's Theorem](https://en.wikipedia.org/wiki/Rice%27s_theorem) generalizes it: *any* non-trivial property of what a program computes is undecidable. Want to know if a program ever outputs a specific value? Undecidable. Ever accesses the network? Undecidable. Contains a security vulnerability? Undecidable.

This explains why static analysis tools produce false positives, why compilers can't always eliminate dead code, and why antivirus software can't catch all malware. Perfect program analysis is mathematically impossible.

## Gödel's Incompleteness Theorem

The halting problem immediately proves one of the most famous results in mathematics.

In the early 20th century, David Hilbert proposed an ambitious goal: write down a finite set of axioms from which every true statement about numbers could be mechanically derived. Start with basic axioms like "$0$ is a number" and "$x + 0 = x$," add rules of inference, and in principle you could prove any true arithmetic statement: that there are infinitely many primes, that every even number greater than 2 is the sum of two primes (if true), anything.

This was **Hilbert's program**. If it succeeded, mathematics would have a solid, computable foundation. You could build a theorem-enumeration machine: start from the axioms, apply inference rules in every possible way, and output each theorem as you derive it. $1 + 1 = 2$. Every prime has a larger prime. One by one, every true statement about numbers.

Here's the key insight: **such a machine would solve the halting problem**. Whether a program halts is a question about finite computation: does this sequence of state transitions eventually reach a halt state? That's a statement about numbers and their relationships, exactly the kind of thing arithmetic can express. But we already proved the halting problem is undecidable. Contradiction. Hilbert's program cannot succeed.

> **Gödel's First Incompleteness Theorem**: Any consistent, computable axiom system capable of expressing basic arithmetic is incomplete.[^1] There exist true statements that the system cannot prove.


Two definitions to unpack this:
- **Consistent**: The system never proves contradictions, i.e., can't prove both $P$ and $\neg P$
- **Complete**: Every true statement can be proven

Why must such systems be incomplete? The proof via the halting problem shows us. An axiom system can enumerate its theorems[^2]: start from axioms, apply inference rules, output each proof as you find it. If a statement is provable, you'll eventually find the proof. But if it's not provable? You'll wait forever, never knowing whether the statement is actually unprovable or whether you just haven't searched long enough. Sound familiar? It's the same asymmetry we saw with the halting problem: you can confirm "yes" but never confirm "no."

[^1]: "Capable of expressing basic arithmetic" is the minimum bar. The theorem applies to any system at least that powerful, including all of mainstream mathematics.

[^2]: Why can we enumerate theorems? A proof is a finite sequence of steps, each following mechanically from axioms or previous steps. Enumerate all finite sequences, check each for validity, and output the conclusion of each valid proof. Every theorem will eventually appear.

## Takeaway

We've traced a boundary between what's computable and what isn't. In Part 2, we saw that Turing completeness is the ceiling: you can't compute more than a Turing machine can. But now we've seen that this ceiling has holes. Some problems have no algorithm that always halts with the correct answer.

**Inside**: any yes/no problem for which we can write a terminating algorithm. Is this number prime? Trial division will tell you. What's 347 × 892? Long multiplication gives the answer. Sort this list? Mergesort terminates with the correct ordering. These are decidable: we have procedures that always halt with correct answers.

**Outside**: the halting problem is just the beginning. Rice's theorem tells us that *any* interesting question about program behavior is undecidable. Does this code have a bug? Will it ever access the network? Is it equivalent to this other program? No single general algorithm can answer these for **all programs**. And Gödel tells us the problem runs deeper: some true statements about numbers can never be proven from any finite set of axioms.

This boundary doesn't depend on technology. Faster computers, quantum computers, whatever comes next: the halting problem will still be undecidable, and arithmetic will still be incomplete. There are truths that no mechanical procedure can discover. That's a deep fact about the nature of computation itself.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
