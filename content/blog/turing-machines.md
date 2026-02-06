+++
title = "What is a Turing Machine? (Part 1/3)"
date = 2026-01-09
description = "The elegant abstraction that defines what it means to compute"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

Last month, DeepMind CEO Demis Hassabis [fired back](https://twitter.com/demishassabis/status/2003097405026193809) at Yann LeCun on X with a claim that caught my attention:

> "The human brain (and AI foundation models) are approximate Turing Machines."[^1]

I've heard the expressions "Turing machine" and "Turing complete" a hundred times over the years, but I have to admit I never truly understood what they meant. This is my attempt at a short, dense, yet accessible explanation. Part 1 covers what a Turing machine actually *is*. [Part 2](@/blog/turing-completeness.md) will explain what "Turing complete" means and return to Demis's claim.

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

Let's build a machine $M$ that accepts binary strings with an even number of 1s.

Take the input $w = \texttt{1011}$. This has three 1s (odd), so $M$ should reject it. The input $w = \texttt{1100}$ has two 1s (even), so $M$ should accept it.

The tape starts with the input written on it, followed by blanks (written $b$) extending infinitely to the right:

$$\texttt{1} \quad \texttt{0} \quad \texttt{1} \quad \texttt{1} \quad b \quad b \quad b \quad \cdots$$

The machine's head starts at the leftmost cell, in some initial state $q_0$. Our strategy: scan right, toggling between "seen even" and "seen odd" on each 1, ignoring 0s, and accept or reject when we hit a blank.

**States**: $Q = \lbrace q_{\text{even}}, q_{\text{odd}}, q_{\text{accept}}, q_{\text{reject}} \rbrace$, with $q_0 = q_{\text{even}}$ (zero 1s seen is even).

**Transitions**:

| State | Read | Write | Move | Next State |
|-------|------|-------|------|------------|
| $q_{\text{even}}$ | 0 | 0 | R | $q_{\text{even}}$ |
| $q_{\text{even}}$ | 1 | 1 | R | $q_{\text{odd}}$ |
| $q_{\text{even}}$ | $b$ | $b$ | — | $q_{\text{accept}}$ |
| $q_{\text{odd}}$ | 0 | 0 | R | $q_{\text{odd}}$ |
| $q_{\text{odd}}$ | 1 | 1 | R | $q_{\text{even}}$ |
| $q_{\text{odd}}$ | $b$ | $b$ | — | $q_{\text{reject}}$ |

Read each row as: "If in *State*, *Read* this symbol, then *Write* this symbol, then *Move* position in this direction (Left or Right); you're now in this *Next State*."

Let's trace through $w = \texttt{1011}$:

1. State $q_{\text{even}}$, read `1` → move right, switch to $q_{\text{odd}}$
2. State $q_{\text{odd}}$, read `0` → move right, stay in $q_{\text{odd}}$
3. State $q_{\text{odd}}$, read `1` → move right, switch to $q_{\text{even}}$
4. State $q_{\text{even}}$, read `1` → move right, switch to $q_{\text{odd}}$
5. State $q_{\text{odd}}$, read $b$ → halt in $q_{\text{reject}}$

Rejected, as expected. Try $w = \texttt{1100}$ yourself: you should end in $q_{\text{accept}}$.

Notice something? This machine never writes anything new, never moves left. It's just scanning right and toggling state. We're not using the full power of a Turing machine yet.

## Example 2: Palindrome Detection

Now let's try something that *requires* writing and bidirectional movement: detecting palindromes.

A string is a palindrome if it reads the same forwards and backwards. Take $w = \texttt{101}$: it's a palindrome, so $M$ should accept. The input $w = \texttt{100}$ is not, so $M$ should reject.

**Algorithm**:

1. Read the leftmost character, remember it (via state), mark it with $X$
2. Scan right to find the rightmost unmarked character
3. Check if it matches what we remembered; reject if not
4. Mark it with $X$, scan left back to the first unmarked character
5. Repeat until all characters are marked (accept) or we find a mismatch (reject)

Let's trace through $w = \texttt{101}$. The tape starts as:

$$\texttt{1} \quad \texttt{0} \quad \texttt{1} \quad b \quad \cdots$$

**Iteration 1**: In state $q_0$, read `1` at the left. Transition to $q_{\text{seek1}}$ ("looking for 1"), write $X$:

$$X \quad \texttt{0} \quad \texttt{1} \quad b \quad \cdots$$

In $q_{\text{seek1}}$, scan right to the rightmost unmarked character (`1`). It matches! Write $X$, transition to $q_{\text{return}}$:

$$X \quad \texttt{0} \quad X \quad b \quad \cdots$$

In $q_{\text{return}}$, scan left back to the first unmarked character (`0`), transition to $q_0$.

**Iteration 2**: In $q_0$, read `0`. Transition to $q_{\text{seek0}}$, write $X$:

$$X \quad X \quad X \quad b \quad \cdots$$

In $q_{\text{seek0}}$, scan right for the rightmost unmarked character... there isn't one. Everything is marked, so transition to $q_{\text{accept}}$.

This example shows what Example 1 didn't need:

- **Writing**: We mark characters with $X$ to track progress
- **Bidirectional movement**: We scan left and right repeatedly
- **State as memory**: We remember "looking for 0" vs "looking for 1"

Notice that $X$ isn't part of the input. The **input alphabet** is $\Sigma = \lbrace \texttt{0}, \texttt{1} \rbrace$, but the **tape alphabet** is $\Gamma = \lbrace \texttt{0}, \texttt{1}, X, b \rbrace$. The machine can read and write symbols beyond what appears in valid inputs.

## Formal Definition

Now that we've seen examples, here's the formal definition. A Turing machine is a 7-tuple:

$$M = (Q, \Gamma, b, \Sigma, \delta, q_0, F)$$

| Symbol | Meaning |
|--------|---------|
| $Q$ | Finite set of states |
| $\Gamma$ | Tape alphabet (finite set of symbols the machine can read/write) |
| $b \in \Gamma$ | Blank symbol (fills the infinite tape beyond input) |
| $\Sigma \subseteq \Gamma \setminus \lbrace b \rbrace$ | Input alphabet (valid input symbols) |
| $q_0 \in Q$ | Initial state |
| $F \subseteq Q$ | Accepting states |
| $\delta: Q \times \Gamma \rightarrow Q \times \Gamma \times \lbrace L, R \rbrace$ | Transition function |

The transition function $\delta$ is the brain of the machine: "If I'm in state $q$ and see symbol $s$, then write $s'$, move left or right, and switch to state $q'$."

A machine **accepts** input $w$ if it eventually reaches a state in $F$. The **language** it recognizes is the set of all strings it accepts: $L(M) = \lbrace w \in \Sigma^\* \mid M \text{ accepts } w \rbrace$, where $\Sigma^\*$ means all finite strings over the input alphabet, such as $\lbrace 0, 1 \rbrace^\* = \lbrace \epsilon, 0, 1, 00, 01, \ldots \rbrace$.

Look at $L(M)$ again. The machine $M$ is finite: finitely many states, finite tape alphabet, therefore finitely many transition rules. Yet the language $L(M)$ can contain infinitely many strings. **A Turing machine is a finite description of a potentially infinite set.**

This parallels something I explored in [my post on Russell's Paradox](@/blog/russells-paradox.md). In set-builder notation, $\lbrace x : x > 5 \rbrace$ describes infinitely many numbers with a few symbols. A Turing machine does something similar:

$$\lbrace x : x > 5 \rbrace \quad \text{vs} \quad \lbrace w : M \text{ accepts } w \rbrace$$

Both define sets via a membership criterion. The difference: set-builder notation allows *any* property, including ones with no mechanical test ("$n$ will appear in next week's winning lottery numbers" defines a set, but good luck testing membership). A Turing machine, by construction, *is* a test.[^2] The definition and the procedure are the same thing: hand me a candidate $w$, and I run $M$ on it.

Our even-1s machine has six transition rules, yet it accepts infinitely many strings: $\epsilon$, `0`, `00`, `11`, `0000`, `1111`, `0110`... You could never list them all, but hand me any string and I can run the machine to tell you if it's in the set.

## What's Next

We've seen what a Turing machine is: a minimal abstraction for mechanical computation. Read, write, move, change state.

But why should such a simple machine matter? [Part 2](@/blog/turing-completeness.md) tackles what "Turing complete" means, why this primitive machine turns out to be maximally powerful, and what Demis meant by "approximate Turing machines."

---

<a id="tweet"></a>
<blockquote class="twitter-tweet" data-theme="dark" data-align="center"><p lang="en" dir="ltr">Yann is just plain incorrect here, he's confusing general intelligence with universal intelligence.<br><br>Brains are the most exquisite and complex phenomena we know of in the universe (so far), and they are in fact extremely general.<br><br>Obviously one can't circumvent the no free lunch… <a href="https://t.co/RjeqlaP7GO">https://t.co/RjeqlaP7GO</a></p>&mdash; Demis Hassabis (@demishassabis) <a href="https://twitter.com/demishassabis/status/2003097405026193809?ref_src=twsrc%5Etfw">December 22, 2025</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

[^1]: [Full tweet at the end of the post](#tweet)

[^2]: With one caveat: the machine might run forever without halting. More on that in Part 2.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
