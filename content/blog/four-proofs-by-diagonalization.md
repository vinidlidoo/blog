+++
title = "Four Proofs by Diagonalization"
date = 2026-01-08
description = "A family of proofs that construct objects guaranteed to differ from every item in a list"

[taxonomies]
tags = ["math"]

[extra]
katex = true
+++

Continuing down the rabbit hole from [Lex Fridman's podcast #488](https://youtu.be/14OPT6CcsH4?t=2967&si=_qnWStDudzUB_o_D), I want to explore **diagonalization**—a proof technique that keeps appearing in foundational mathematics.

The core idea: construct an object that's guaranteed to differ from every object in a given list by changing the "diagonal" entries. We'll cover four variations of this technique, all sharing the same logical structure (each are also covered in the podcast).

## 1. Cantor's Proof: The Reals Are Uncountable

Georg Cantor introduced diagonalization in 1891 to prove that the real numbers form a strictly larger infinity than the natural numbers.

Suppose, toward contradiction, that we could list all real numbers between 0 and 1. Each real can be written as an infinite decimal:

$$
\begin{array}{c|cccccc}
& d_1 & d_2 & d_3 & d_4 & d_5 & \cdots \\\\
\hline
r_1 & \mathbf{5} & 1 & 4 & 1 & 5 & \cdots \\\\
r_2 & 3 & \mathbf{3} & 3 & 3 & 3 & \cdots \\\\
r_3 & 7 & 1 & \mathbf{8} & 2 & 8 & \cdots \\\\
r_4 & 0 & 0 & 0 & \mathbf{0} & 0 & \cdots \\\\
r_5 & 9 & 9 & 9 & 9 & \mathbf{9} & \cdots \\\\
\vdots & \vdots & \vdots & \vdots & \vdots & \vdots & \ddots
\end{array}
$$

Now construct a new number $d$ by looking at the **diagonal**—the $n$-th digit of the $n$-th number—and changing each digit. If the diagonal digit is 5, make it 6; otherwise make it 5:

$$d = 0.\mathbf{6}\mathbf{5}\mathbf{5}\mathbf{5}\mathbf{5}\ldots$$

This number $d$ differs from $r_1$ in the first digit, from $r_2$ in the second digit, from $r_3$ in the third digit, and so on. It differs from every number in the list.

But we assumed the list contained all reals between 0 and 1. Contradiction. Therefore no such list can exist—the reals are **uncountable**.

## 2. The Power Set Is Always Larger

Cantor proved something even more general: for any set $X$, its **power set** $\mathcal{P}(X)$—the set of all subsets—is strictly larger than $X$ itself. Even for infinite sets.

This means there's no "largest" infinity. Given any infinite set, you can always construct a larger one by taking its power set.

### The Formal Proof

Let $X$ be any set. There's obviously at least as many subsets as elements (each element $x$ corresponds to the singleton $\lbrace x \rbrace$). The question is whether there are strictly more.

Suppose, toward contradiction, that $X$ and $\mathcal{P}(X)$ have the same size. Then there exists a bijection $f: X \to \mathcal{P}(X)$, associating each element with a unique subset.

Define a new subset:

$$D = \lbrace x \in X : x \notin f(x) \rbrace$$

In words: $D$ contains all elements that are **not** in their associated subset.

Since $D$ is a subset of $X$, we have $D \in \mathcal{P}(X)$. And since $f$ is a bijection, some element maps to $D$. Call that element Diana, so $f(\text{Diana}) = D$.

Now ask: is Diana in $D$?

**If Diana $\in D$:** By definition of $D$, Diana would be an element not in her associated subset. But her associated subset is $D$, so Diana $\notin D$. Contradiction.

**If Diana $\notin D$:** Then Diana is not in her associated subset, which is exactly the criterion for membership in $D$. So Diana $\in D$. Contradiction.

Both cases fail. Therefore no bijection exists, and $|\mathcal{P}(X)| > |X|$.

### People and Committees

Here's an anthropomorphization from Joel David Hamkins: for any collection of people, you can form more committees than there are people—even with infinitely many people.

A committee is just a subset of people. The claim is $|\mathcal{P}(\text{People})| > |\text{People}|$.

Suppose not. Then we could name every committee after a person in a one-to-one correspondence. (The person doesn't have to be on the committee named after them—it's just a naming.)

Form **Committee D**: all the people who are *not* on the committee named after them.

That's a valid committee. It must be named after someone—call her Daniella.

Is Daniella on the committee named after her?

- If yes, she's on Committee D. But Committee D consists of people who *aren't* on their named committee. Contradiction.
- If no, she's not on her named committee. So she qualifies for Committee D. Contradiction.

More committees than people.

### Fruits and Fruit Salads

Another anthropomorphization, from one of Hamkins' Oxford students: for any collection of fruits, there are more possible fruit salads than fruits.

A fruit salad is just a subset of fruits. If there were only as many salads as fruits, we could name each salad after a fruit.

Form the **diagonal salad**: all fruits that are *not* in the salad named after them.

This salad must be named after some fruit—say, durian.

Is durian in the salad named after it?

- If yes, it shouldn't be (the salad only contains fruits *not* in their named salad).
- If no, it should be (it qualifies for membership).

Contradiction. More salads than fruits.

## 3. Russell's Paradox: No Universal Set

In a [previous post](@/blog/russells-paradox.md), I explored Russell's paradox and how it broke naive set theory. What I didn't emphasize then is that Russell's argument is **the same diagonal technique**.

Here's the parallel structure:

**The correspondence assumption:** Suppose the class of all sets $V$ is itself a set. Then every set is "in the list"—$V$ indexes all sets, including itself. We can ask of each set $x$: does $x$ contain itself?

**The diagonal construction:** Form $R$, the collection of all sets where the answer is "no":

$$R = \lbrace x \in V : x \notin x \rbrace$$

This mirrors Cantor's construction exactly. Where Cantor asked "is $x$ in its associated subset $f(x)$?", Russell asks "is $x$ in itself?" The set $R$ collects all the "no" answers—sets that are not members of themselves.

**The contradiction:** Since $R$ is a collection of sets, and $V$ contains all sets, we have $R \in V$. Now ask: is $R \in R$?

- If $R \in R$: Then $R$ is a member of itself. But $R$ only contains sets that are *not* members of themselves. So $R \notin R$. Contradiction.
- If $R \notin R$: Then $R$ is not a member of itself—exactly the criterion for membership in $R$. So $R \in R$. Contradiction.

The structure is identical to Diana, Daniella, and durian. The assumed correspondence (all sets indexed by $V$) lets us form the diagonal set, which then can't exist.

What Russell proved, as Hamkins puts it: "There's no universal set." The assumption that $V$ is a set leads to contradiction, so the universe of sets can't itself be a set.

## The Common Thread

All four proofs share the same skeleton:

1. Assume some collection can be put in correspondence with its "parts" (digits, subsets, committees, salads, or sets)
2. Construct the diagonal object: the one that differs from each item at its own position
3. Ask whether this object contains itself / is in its own category
4. Derive contradiction from both yes and no

Diagonalization reveals that certain collections are too large to be captured by any list or any set. It's a fundamental limit built into the structure of mathematics itself.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
