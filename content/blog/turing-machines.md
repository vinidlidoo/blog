+++
title = "What is a Turing Machine?"
date = 2026-01-09
description = "The elegant abstraction that defines what it means to compute"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

Last month, DeepMind CEO Demis Hassabis [fired back](https://twitter.com/demishassabis/status/2003097405026193809) at Yann LeCun on X with a claim that caught my attention:

> "The human brain (and AI foundation models) are approximate Turing Machines."[^1]


I've heard the expressions "Turing machine" and "Turing complete" a hundred times over the years, but I have to admit I never truly understood what they meant. This is my attempt at a short, dense, yet accessible explanation. Part 1 covers what a Turing machine actually *is*. Part 2 will explain what "Turing complete" means and return to Demis's claim.

[^1]: [Full tweet at the end of the post](#the-tweet)
## Historical Context

In the 1930s, mathematicians were trying to formalize what "computation" actually means. Before electronic computers existed, a "computer" was literally a human being performing calculations by hand, following rules and writing intermediate results on paper.

Alan Turing asked: what are the *minimal* operations needed to capture any mechanical calculation? His answer was an abstract machine so simple it seems almost trivial, yet powerful enough to compute anything that can be computed at all.

## The Turing Machine

### Intuition

Imagine a person sitting at a desk with:

- An infinitely long strip of paper divided into squares (the **tape**)
- A pencil and eraser
- A finite set of memorized instructions

They can only:

1. Look at one square at a time
2. Write or erase a symbol in that square
3. Move attention one square left or right
4. Be in one of finitely many "mental states"

That's it. No arithmetic unit, no memory banks, no parallel processing. Just read, write, move, change state. Repeat.

Let's see this in action.

## Example 1: Even Number of 1s

Let's build a machine that accepts binary strings with an even number of 1s.

This only requires tracking one bit of information: have I seen an even or odd number of 1s so far? Toggle on each 1, ignore 0s, accept at the end if even.

**States**: $Q = \lbrace q_{\text{even}}, q_{\text{odd}}, q_{\text{accept}}, q_{\text{reject}} \rbrace$

**Transitions**:

| State | Read | Write | Move | Next State |
|-------|------|-------|------|------------|
| $q_{\text{even}}$ | 0 | 0 | R | $q_{\text{even}}$ |
| $q_{\text{even}}$ | 1 | 1 | R | $q_{\text{odd}}$ |
| $q_{\text{even}}$ | $b$ | $b$ | — | $q_{\text{accept}}$ |
| $q_{\text{odd}}$ | 0 | 0 | R | $q_{\text{odd}}$ |
| $q_{\text{odd}}$ | 1 | 1 | R | $q_{\text{even}}$ |
| $q_{\text{odd}}$ | $b$ | $b$ | — | $q_{\text{reject}}$ |

Notice something? This machine never writes anything new, never moves left. It's just scanning right and toggling state. We're not using the full power of a Turing machine yet.

## Example 2: Palindrome Detection

Now let's try something that *requires* writing and bidirectional movement: detecting palindromes.

A string is a palindrome if it reads the same forwards and backwards: `101`, `1001`, `11011`.

**Algorithm**:

1. Read the leftmost character, remember it (via state), mark it with $X$
2. Scan right to find the rightmost unmarked character
3. Check if it matches what we remembered; reject if not
4. Mark it with $X$, scan left back to the first unmarked character
5. Repeat until all characters are marked (accept) or we find a mismatch (reject)

This requires:

- **Writing**: We mark characters with $X$ to track progress
- **Bidirectional movement**: We scan left and right repeatedly
- **State as memory**: We remember "looking for 0" vs "looking for 1"

Notice that $X$ isn't part of the input; it's scratch notation the machine uses internally. The machine can read and write symbols beyond just the input characters.

## Formal Definition

Now that we've seen examples, here's the formal definition. A Turing machine is a 7-tuple:

$$M = (Q, \Gamma, b, \Sigma, \delta, q_0, F)$$

| Symbol | Meaning |
|--------|---------|
| $Q$ | Finite set of states |
| $\Gamma$ | Tape alphabet (all symbols the machine can read/write) |
| $b \in \Gamma$ | Blank symbol (fills the infinite tape beyond input) |
| $\Sigma \subseteq \Gamma \setminus \lbrace b \rbrace$ | Input alphabet (valid input symbols) |
| $q_0 \in Q$ | Initial state |
| $F \subseteq Q$ | Accepting states |
| $\delta: Q \times \Gamma \rightarrow Q \times \Gamma \times \lbrace L, R \rbrace$ | Transition function |

The transition function $\delta$ is the brain of the machine: "If I'm in state $q$ and see symbol $s$, then write $s'$, move left or right, and switch to state $q'$."

A machine **accepts** input $w$ if it eventually reaches a state in $F$. The **language** it recognizes is the set of all strings it accepts: $L(M) = \lbrace w \in \Sigma^\* \mid M \text{ accepts } w \rbrace$, where $\Sigma^\*$ means all finite strings over the input alphabet, such as $\lbrace 0, 1 \rbrace^\* = \lbrace \epsilon, 0, 1, 00, 01, \ldots \rbrace$.

Here's the key insight: **a Turing machine is a finite description of a potentially infinite set**.

In mathematics, we often capture infinite sets with finite notation. [Set-builder notation](@/blog/russells-paradox.md) like $\lbrace x : x > 5 \rbrace$ describes infinitely many numbers in a few symbols. A Turing machine does something similar, but *computably*: it's a finite program that defines set membership via a procedure you can actually execute.

Our even-1s machine has six transition rules. Yet it accepts infinitely many strings: $\epsilon$, `0`, `00`, `11`, `0000`, `1111`, `0110`, and so on forever. You could never list them all, but you can run the machine on any candidate and get an answer.

The palindrome machine is similar: a handful of states and rules, but it recognizes an infinite set of strings.

Notice the parallel structure:

$$\lbrace x : x > 5 \rbrace \quad \text{vs} \quad \lbrace w : M \text{ accepts } w \rbrace$$

In set-builder notation, the property after the colon defines membership. For a Turing machine, "M accepts w" *is* the property. The machine encodes the predicate; running it evaluates whether the predicate holds for a given input.

## What's Next

We've seen what a Turing machine is: a minimal abstraction for mechanical computation. Read, write, move, change state.

But why should such a simple machine matter? Part 2 tackles what "Turing complete" means, why this primitive machine turns out to be maximally powerful, and what Demis meant by "approximate Turing machines."

---

## The Tweet

<blockquote class="twitter-tweet" data-theme="dark" data-align="center"><p lang="en" dir="ltr">Yann is just plain incorrect here, he's confusing general intelligence with universal intelligence.<br><br>Brains are the most exquisite and complex phenomena we know of in the universe (so far), and they are in fact extremely general.<br><br>Obviously one can't circumvent the no free lunch… <a href="https://t.co/RjeqlaP7GO">https://t.co/RjeqlaP7GO</a></p>&mdash; Demis Hassabis (@demishassabis) <a href="https://twitter.com/demishassabis/status/2003097405026193809?ref_src=twsrc%5Etfw">December 22, 2025</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
