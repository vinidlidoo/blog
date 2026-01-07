+++
title = "Russell's Paradox"
date = 2026-01-06
description = "A fundamental contradiction that shook the foundations of mathematics"

[taxonomies]
tags = ["math"]

[extra]
katex = true
stylesheets = ["css/details.css"]
+++

Listening to [Lex Fridman's podcast #488](https://youtu.be/14OPT6CcsH4?t=2967&si=_qnWStDudzUB_o_D) on infinity and Gödel's incompleteness sent me down a rabbit hole on Russell's Paradox—a deceptively simple contradiction that broke naive set theory in 1901.

## The Paradox

Define a set $R$ containing all sets that don't contain themselves:

$$R = \lbrace x : x \notin x\rbrace$$

This is **set-builder notation**. Reading it piece by piece:

- $\lbrace \ \rbrace$ — "the set of"
- $x$ — a variable representing any set
- $:$ — "such that" (sometimes written as $|$)
- $x \notin x$ — "$x$ is not an element of itself"

So the whole expression reads: "The set of all $x$ such that $x$ is not a member of itself."

Does $R$ contain itself? There are only two possibilities:

**Case 1: Suppose $R \in R$ (R contains itself)**

If $R$ is a member of itself, then $R$ must satisfy the membership criterion. But the criterion is "does not contain itself." So if $R \in R$, then $R \notin R$. Contradiction.

**Case 2: Suppose $R \notin R$ (R does not contain itself)**

If $R$ is not a member of itself, then $R$ satisfies exactly the property we used to define $R$—it's a set that doesn't contain itself. So $R$ qualifies for membership in $R$, meaning $R \in R$. Contradiction.

Both cases lead to contradiction.

## What Went Wrong

The problem is **unrestricted comprehension**—the assumption that any property defines a valid set. "The set of all $x$ such that..." feels like it should always work, but Russell showed it doesn't.

Modern set theory (ZFC) fixes this by **building sets in stages**. You can't conjure a set from thin air—you must construct it from sets that already exist. This is called the **cumulative hierarchy**:

- $V_0 = \emptyset$
- $V_{\alpha+1} = \mathcal{P}(V_\alpha)$
- $V_\lambda = \bigcup_{\alpha < \lambda} V_\alpha$ for limit ordinals $\lambda$

Let's see what each rule means, then why this construction dissolves Russell's paradox.

### Rule 1: Start with nothing

$V_0 = \emptyset$, the empty set.

### Rule 2: Take the power set

$V_{\alpha+1} = \mathcal{P}(V_\alpha)$

The **power set** $\mathcal{P}(A)$ is the set of all subsets of $A$. To build it, consider each element of $A$ and decide: include it or not. With $n$ elements, you get $2^n$ subsets.

<details>
<summary>How to construct the power set of {a, b}</summary>

If $A = \lbrace a, b \rbrace$, the subsets are:

- Include nothing: $\emptyset$
- Include just $a$: $\lbrace a \rbrace$
- Include just $b$: $\lbrace b \rbrace$
- Include both: $\lbrace a, b \rbrace$

So $\mathcal{P}(\lbrace a, b \rbrace) = \lbrace \emptyset, \lbrace a \rbrace, \lbrace b \rbrace, \lbrace a, b \rbrace \rbrace$ — four subsets, since $2^2 = 4$.

</details>

Now let's build the first few stages:

**$V_1 = \mathcal{P}(V_0) = \mathcal{P}(\emptyset)$**

What are the subsets of the empty set? There's only one: the empty set itself (you "include nothing"). So $V_1 = \lbrace \emptyset \rbrace$. This is a set with one element.

**$V_2 = \mathcal{P}(V_1) = \mathcal{P}(\lbrace \emptyset \rbrace)$**

$V_1$ has one element: $\emptyset$. For each element, include or exclude:

- Exclude $\emptyset$: gives us $\emptyset$
- Include $\emptyset$: gives us $\lbrace \emptyset \rbrace$

So $V_2 = \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$ — two elements, since $2^1 = 2$.

Note that $\emptyset$ and $\lbrace \emptyset \rbrace$ are different: one is an empty box, the other is a box containing an empty box.

**$V_3 = \mathcal{P}(V_2) = \mathcal{P}(\lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace)$**

$V_2$ has two elements. Include or exclude each:

- Include nothing: $\emptyset$
- Include just $\emptyset$: $\lbrace \emptyset \rbrace$
- Include just $\lbrace \emptyset \rbrace$: $\lbrace \lbrace \emptyset \rbrace \rbrace$
- Include both: $\lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$

So $V_3 = \lbrace \emptyset, \lbrace \emptyset \rbrace, \lbrace \lbrace \emptyset \rbrace \rbrace, \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace \rbrace$ — four elements, since $2^2 = 4$.

Now we're getting somewhere. We have sets containing other sets, sets with multiple elements, and nested structures. $V_4$ has $2^4 = 16$ elements, $V_5$ has $2^{16} = 65536$, and the growth explodes from there.

**Why does this matter?** These "empty boxes" aren't abstract curiosities—they *encode* actual mathematics. The standard definition of natural numbers in set theory:

- $0 = \emptyset$
- $1 = \lbrace \emptyset \rbrace$
- $2 = \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$
- $3 = \lbrace \emptyset, \lbrace \emptyset \rbrace, \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace \rbrace$

Each number $n$ is the set containing all smaller numbers. From natural numbers, you construct integers (as pairs), rationals (as pairs of integers), reals (as sets of rationals), functions (as sets of pairs), and everything else. All of mathematics reduces to sets built from $\emptyset$.

### Rule 3: Continue past infinity

$V_\lambda = \bigcup_{\alpha < \lambda} V_\alpha$

After $V_0, V_1, V_2, \ldots$ we've built infinitely many stages. But we're not done—Rule 2 says "take the power set of the previous stage," and infinity has no immediate predecessor. There's no $V_{n}$ where $n+1 = \infty$.

So at infinity, we gather everything built so far:

$$V_\omega = V_0 \cup V_1 \cup V_2 \cup \ldots$$

Here $\omega$ is the first infinite ordinal—the name for "after all finite stages." Now Rule 2 works again: $V_{\omega+1} = \mathcal{P}(V_\omega)$, $V_{\omega+2} = \mathcal{P}(V_{\omega+1})$, and so on.

The hierarchy extends forever, with more gathering steps at higher infinities. The technical details don't matter here—what matters is that **the hierarchy never ends**.

## Why This Dissolves the Paradox

The crucial property: **a set can only contain elements from earlier stages**.

A set at stage $\alpha$ is built from sets at stages $< \alpha$. This makes self-membership impossible—for $x \in x$ to hold, $x$ would need to exist at a stage earlier than itself.

Now consider Russell's $R = \lbrace x : x \notin x \rbrace$. In the cumulative hierarchy, *every* set satisfies $x \notin x$—no set contains itself. So $R$ would have to contain *all* sets.

But "the set of all sets" doesn't exist. There's no stage where all sets are available—the hierarchy extends forever. You can only form sets from what's already been built, and "everything" is never finished being built.

The paradox dissolves because $R$ can't be constructed in the first place.

## Takeaway

Russell's paradox shows that naive set theory—where any property defines a set—is inconsistent. The fix isn't a patch; it's a complete rebuild. Modern mathematics constructs sets in stages, from the ground up, and this staged construction makes the paradoxical set impossible to form.

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
