+++
title = "The Math Behind Your Private Key (Part 1/2)"
date = 2026-01-16
description = "From group theory to elliptic curves: how public-key cryptography actually works"

[taxonomies]
tags = ["crypto", "math"]

[extra]
katex = true
+++

![Point Addition](/img/elliptic-curve-point-addition.png)

Elliptic curves keep showing up in crypto. I'd been dodging them for years, but while digging into Ethereum's rollup architecture I finally decided to stop and actually learn what's going on. The surprise? It's all built on group theory—the same abstract algebra I learned in college and promptly forgot because it seemed so disconnected from anything real. Turns out I was wrong.

By the end of this post, you'll understand the core math behind public and private keys: how they're constructed from elliptic curves, and why the construction is secure. Part 2 will cover how this math gets applied in practice.

## Fields: Numbers with Arithmetic

In [my post on Russell's Paradox](@/blog/russells-paradox.md), I covered what a set is. A **field** is a set $F$ equipped with two **binary operations**—addition and multiplication—satisfying **nine axioms**: four for each operation, plus distributivity linking them. "Binary" means each operation takes two elements and returns one element from the same set:

$$+: F \times F \to F$$
$$\cdot: F \times F \to F$$

Two axiom examples (see [Appendix](#field-axioms) for full list):
  - associativity: $(a + b) + c = a + (b + c)$
  - multiplicative inverses: $\forall a \neq 0,\ \exists\ a^{-1}$ such that $a \cdot a^{-1} = 1$

As it turns out, fields are the minimal structure required to support linear algebra, calculus and other undergraduate math. The real numbers $\mathbb{R}$ form a field. So do the rationals $\mathbb{Q}$. But the integers $\mathbb{Z}$ do not: there's no integer $n$ such that $2 \cdot n = 1$. The multiplicative inverse of 2 would be $\frac{1}{2}$, which isn't in $\mathbb{Z}$.

Cryptography often uses finite fields. Ethereum's secp256k1 curve operates over $\mathbb{F}_p$:

$$\mathbb{F}_p = \lbrace 0, 1, 2, \ldots, p-1 \rbrace$$

where $p$ is a large prime ($p \approx 2^{256}$). Arithmetic wraps modulo $p$. Using $p = 7$ as a small example:
- $5 + 4 = 9 \equiv 2 \pmod{7}$
- $3 \cdot 5 = 15 \equiv 1 \pmod{7}$ — so $3$ and $5$ are multiplicative inverses in $\mathbb{F}_7$

Why must $p$ be prime? With $p = 6$, we have $2 \cdot 3 \equiv 0$. If $2$ had an inverse $2^{-1}$, we could multiply both sides: $2^{-1} \cdot 2 \cdot 3 = 2^{-1} \cdot 0$, giving $3 = 0$, a contradiction. So $2$ has no multiplicative inverse, and the field axiom fails. Primes avoid this.

## Groups: Simpler Than Fields

A **group** is a simpler structure than a field: one binary operation instead of two, four axioms instead of nine. We write a group as $(G, \circ)$ where $G$ is a set and $\circ$ is the operation (could be addition, multiplication, composition, etc.).

The four axioms:
1. **Closure**: $\forall a, b \in G:\ a \circ b \in G$
2. **Associativity**: $(a \circ b) \circ c = a \circ (b \circ c)$
3. **Identity**: $\exists\ e \in G$ such that $e \circ a = a \circ e = a$
4. **Inverses**: $\forall a \in G,\ \exists\ a^{-1} \in G$ such that $a \circ a^{-1} = a^{-1} \circ a = e$

The axioms don't specify what $G$ contains or what $\circ$ does. Prove something about groups in general, and it applies to every group: integers, symmetries, points on a curve.

**Example**: $(\mathbb{Z}, +)$, the integers under addition:
- Closure: $3 + 5 = 8 \in \mathbb{Z}$
- Associativity: $(2 + 3) + 4 = 2 + (3 + 4) = 9$
- Identity: $e = 0\ $ ( not 1! )
- Inverses: $a^{-1} = -a$ since $a + (-a) = 0$

## Elliptic Curves are Groups

An **elliptic curve** over a field $\mathbb{F}_p$ is the set of points $(x, y)$ satisfying:

$$y^2 = x^3 + ax + b$$

plus a special **point at infinity** $\mathcal{O}$. The constants $a, b \in \mathbb{F}_p$ define the curve's shape.

This set forms a group under a binary operation called **point addition**. The construction may seem arbitrary, but it's precisely what makes the group axioms hold. Here's how it works:

1. Find the line through $P$ and $Q$ (i.e., solve for slope $m$ and intercept $c$ in $y = mx + c$). If $P = Q$, use the tangent line at $P$.
2. This line intersects the curve at exactly 3 points (counting multiplicity—a tangent counts twice). Find the third intersection $R$.
3. Compute the result:
   - **If $R$ is a finite point**: reflect it over the x-axis to get $P + Q = -R$, where $-R = (x, -y)$.
   - **If the line is vertical**: there is no finite third intersection. The result is $\mathcal{O}$, the point at infinity.

One more rule: $P + \mathcal{O} = P$ for any point $P$. The point at infinity acts as the identity element.

Verifying the group axioms:
- **Closure**: point addition always yields another point on the curve (or $\mathcal{O}$)
- **Associativity**: holds, though the proof is non-trivial
- **Identity**: $\mathcal{O}$, by definition above
- **Inverses**: the inverse of $(x, y)$ is $(x, -y)$, since their sum gives $\mathcal{O}$

## Why Cryptographers Care

So we have a group: points on an elliptic curve, an addition operation, four axioms satisfied. But groups are everywhere in mathematics. What makes *this* group useful for cryptography?

The answer lies in an asymmetry: some operations on this group are easy to compute, others are practically impossible to reverse. To see this, we need one more concept.

**Scalar multiplication** is repeated addition. Since we have a group operation, we can apply it repeatedly. $nP$ means adding $P$ to itself $n$ times:

$$nP = \underbrace{P + P + \cdots + P}_{n \text{ times}}$$

Cryptographic security requires large numbers. Ethereum uses $n \approx 2^{256}$, a number with 78 digits. Naively computing $nP$ would require $n - 1$ additions, which is impossible.

But any integer has a binary representation. Take $n = 13$:

$$13 = 1101_2 = 8 + 4 + 1$$

So $13P = 8P + 4P + P$. The key insight: $8P = 2(4P) = 2(2(2P))$. We compute $2P$, $4P$, $8P$ by repeated doubling (3 operations), then add the relevant terms (2 more). Total: 5 operations instead of 12.

This is **double-and-add**. For any $n$, it requires $O(\log n)$ operations, roughly the number of bits in $n$. Even for $n \approx 2^{256}$, that's only ~256 doublings and additions. Fast.

**The reverse direction is hard.** Given $P$ and $Q = nP$, finding $n$ is the **discrete logarithm problem** (DLP). "Logarithm" by analogy to $b^n = x \Rightarrow n = \log_b(x)$. "Discrete" because we're in a finite group.

No known algorithm beats brute force by much. With $n \approx 2^{256}$, that's infeasible.

**This asymmetry is exactly what public-key cryptography needs.** Each curve specification includes a standard base point $P$ (also called the generator) that everyone uses.
- Pick a secret integer $n$. This is your **private key**.
- Compute $Q = nP$. This is your **public key**.
- Publish $Q$. Signature and encryption protocols build on top of this key pair.
- To impersonate you, an attacker must recover $n$ from $Q$ and $P$. But that's the DLP, which is infeasible.

This is the core of elliptic curve cryptography. Real implementations add layers: Ethereum hashes your public key to derive your address, and signature schemes like ECDSA involve additional steps. But the security of all of it rests on the DLP being hard.

## Takeaway

We covered a lot of ground. Fields give us arithmetic in finite spaces. Groups are simpler structures—one operation, four axioms—that show up everywhere. Elliptic curves form a group under point addition, and the discrete logarithm problem on these curves is hard enough to secure your private keys.

The construction is elegant: pick a secret number $n$, multiply a known point $P$ by it, publish the result $Q = nP$. Anyone can verify things with $Q$, but recovering $n$ is computationally out of reach. In Part 2, we'll see how this foundation enables two practical protocols: ECDH for encrypting messages, and ECDSA for digital signatures.

---

<a id="field-axioms"></a>

## Appendix: Field Axioms

<details>
<summary>The nine axioms</summary>

**Addition axioms** (for all $a, b, c \in F$):
<ol>
<li><strong>Associativity</strong>: $(a + b) + c = a + (b + c)$</li>
<li><strong>Commutativity</strong>: $a + b = b + a$</li>
<li><strong>Identity</strong>: $\exists\ 0 \in F$ such that $a + 0 = a$</li>
<li><strong>Inverses</strong>: $\exists\ (-a) \in F$ such that $a + (-a) = 0$</li>
</ol>

**Multiplication axioms** (for all $a, b, c \in F$):
<ol start="5">
<li><strong>Associativity</strong>: $(a \cdot b) \cdot c = a \cdot (b \cdot c)$</li>
<li><strong>Commutativity</strong>: $a \cdot b = b \cdot a$</li>
<li><strong>Identity</strong>: $\exists\ 1 \in F$ such that $a \cdot 1 = a$</li>
<li><strong>Inverses</strong>: $\forall a \neq 0,\ \exists\ a^{-1} \in F$ such that $a \cdot a^{-1} = 1$</li>
</ol>

**Linking addition and multiplication**:
<ol start="9">
<li><strong>Distributivity</strong>: $a \cdot (b + c) = a \cdot b + a \cdot c$</li>
</ol>

</details>

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
