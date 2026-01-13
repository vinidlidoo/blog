+++
title = "ラッセルのパラドックス"
date = 2026-01-06
description = "数学の基礎を揺るがした根本的な矛盾"

[taxonomies]
tags = ["math"]

[extra]
katex = true
stylesheets = ["css/details.css"]
+++

[Lex Fridmanのポッドキャスト #488](https://youtu.be/14OPT6CcsH4?t=2967&si=_qnWStDudzUB_o_D)で無限とゲーデルの不完全性定理について聴いて、ラッセルのパラドックスの沼にはまってしまった。1901年に素朴集合論を崩壊させた、一見単純だが破壊的な矛盾だ。

## パラドックス

自分自身を含まないすべての集合を含む集合 $R$ を定義する：

$$R = \lbrace x : x \notin x\rbrace$$

これは**集合の内包的記法**だ。一つずつ読み解いていこう：

- $\lbrace \ \rbrace$ — 「〜の集合」
- $x$ — 任意の集合を表す変数
- $:$ — 「〜であるような」（$|$ と書くこともある）
- $x \notin x$ — 「$x$ は自分自身の要素ではない」

つまり全体を読むと「自分自身の要素ではないすべての $x$ の集合」となる。

$R$ は自分自身を含むだろうか？可能性は2つしかない：

**ケース1：$R \in R$（Rは自分自身を含む）と仮定する**

$R$ が自分自身の要素であるなら、$R$ は所属条件を満たさなければならない。しかしその条件は「自分自身を含まない」である。したがって $R \in R$ ならば $R \notin R$ となる。矛盾。

**ケース2：$R \notin R$（Rは自分自身を含まない）と仮定する**

$R$ が自分自身の要素でないなら、$R$ はまさに $R$ を定義するために使った性質を満たす。つまり自分自身を含まない集合である。したがって $R$ は $R$ への所属資格を持ち、$R \in R$ となる。矛盾。

どちらのケースも矛盾に至る。

## 何が問題だったのか

問題は**無制限の内包**（任意の性質が有効な集合を定義するという仮定）にある。「〜であるようなすべての $x$ の集合」という表現は常に通用しそうに見えるが、ラッセルはそうではないことを示した。

現代の集合論（ZFC）はこれを**段階的に集合を構築する**ことで解決する。何もないところから集合を召喚することはできない。すでに存在する集合から構築しなければならない。これは**累積的階層**と呼ばれる：

- $V_0 = \emptyset$
- $V_{\alpha+1} = \mathcal{P}(V_\alpha)$
- $V_\lambda = \bigcup_{\alpha < \lambda} V_\alpha$（極限順序数 $\lambda$ に対して）

各規則の意味を見てから、なぜこの構成がラッセルのパラドックスを解消するのかを説明しよう。

### 規則1：無から始める

$V_0 = \emptyset$、空集合である。

### 規則2：冪集合を取る

$V_{\alpha+1} = \mathcal{P}(V_\alpha)$

**冪集合** $\mathcal{P}(A)$ は $A$ のすべての部分集合の集合だ。これを構築するには、$A$ の各要素について含めるか含めないかを決める。$n$ 個の要素があれば、$2^n$ 個の部分集合が得られる。

<details>
<summary>{a, b}の冪集合の構築方法</summary>

$A = \lbrace a, b \rbrace$ の場合、部分集合は：

- 何も含めない：$\emptyset$
- $a$ だけ含める：$\lbrace a \rbrace$
- $b$ だけ含める：$\lbrace b \rbrace$
- 両方含める：$\lbrace a, b \rbrace$

したがって $\mathcal{P}(\lbrace a, b \rbrace) = \lbrace \emptyset, \lbrace a \rbrace, \lbrace b \rbrace, \lbrace a, b \rbrace \rbrace$。$2^2 = 4$ なので4つの部分集合がある。

</details>

では最初のいくつかの段階を構築してみよう：

**$V_1 = \mathcal{P}(V_0) = \mathcal{P}(\emptyset)$**

空集合の部分集合は何か？1つしかない：空集合自身（「何も含めない」）。したがって $V_1 = \lbrace \emptyset \rbrace$。これは1つの要素を持つ集合だ。

**$V_2 = \mathcal{P}(V_1) = \mathcal{P}(\lbrace \emptyset \rbrace)$**

$V_1$ は1つの要素を持つ：$\emptyset$。各要素について、含めるか除外するか：

- $\emptyset$ を除外：$\emptyset$ が得られる
- $\emptyset$ を含める：$\lbrace \emptyset \rbrace$ が得られる

したがって $V_2 = \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$。$2^1 = 2$ なので2つの要素がある。

$\emptyset$ と $\lbrace \emptyset \rbrace$ は異なることに注意：一方は空の箱、他方は空の箱を含む箱である。

**$V_3 = \mathcal{P}(V_2) = \mathcal{P}(\lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace)$**

$V_2$ は2つの要素を持つ。それぞれを含めるか除外するか：

- 何も含めない：$\emptyset$
- $\emptyset$ だけ含める：$\lbrace \emptyset \rbrace$
- $\lbrace \emptyset \rbrace$ だけ含める：$\lbrace \lbrace \emptyset \rbrace \rbrace$
- 両方含める：$\lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$

したがって $V_3 = \lbrace \emptyset, \lbrace \emptyset \rbrace, \lbrace \lbrace \emptyset \rbrace \rbrace, \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace \rbrace$。$2^2 = 4$ なので4つの要素がある。

これで何かが見えてきた。他の集合を含む集合、複数の要素を持つ集合、入れ子構造がある。$V_4$ は $2^4 = 16$ 個の要素を持ち、$V_5$ は $2^{16} = 65536$ 個を持ち、そこから成長は爆発的になる。

**なぜこれが重要なのか？**これらの「空の箱」は単なる抽象的な珍品ではない。実際の数学を*エンコード*しているのだ。集合論における自然数の標準的な定義は：

- $0 = \emptyset$
- $1 = \lbrace \emptyset \rbrace$
- $2 = \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$
- $3 = \lbrace \emptyset, \lbrace \emptyset \rbrace, \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace \rbrace$

各数 $n$ はそれより小さいすべての数を含む集合だ。自然数から整数（ペアとして）を、有理数（整数のペアとして）を、実数（有理数の集合として）を、関数（ペアの集合として）を、そして他のすべてを構築できる。数学のすべては $\emptyset$ から構築された集合に帰着する。

### 規則3：無限の先へ続ける

$V_\lambda = \bigcup_{\alpha < \lambda} V_\alpha$

$V_0, V_1, V_2, \ldots$ の後、無限に多くの段階を構築した。しかしまだ終わりではない。規則2は「前の段階の冪集合を取る」と言うが、無限には直前の段階がない。$n+1 = \infty$ となるような $V_{n}$ は存在しない。

そこで無限において、これまでに構築したすべてを集める：

$$V_\omega = V_0 \cup V_1 \cup V_2 \cup \ldots$$

ここで $\omega$ は最初の無限順序数（「すべての有限段階の後」を表す名前）だ。これで規則2が再び機能する：$V_{\omega+1} = \mathcal{P}(V_\omega)$、$V_{\omega+2} = \mathcal{P}(V_{\omega+1})$、以下同様。

階層は永遠に続き、より高い無限でより多くの収集ステップがある。技術的な詳細はここでは重要ではない。重要なのは**階層は決して終わらない**ということだ。

## なぜこれがパラドックスを解消するのか

重要な性質：**集合はより早い段階の要素しか含むことができない**。

段階 $\alpha$ の集合は段階 $< \alpha$ の集合から構築される。これにより自己所属は不可能になる。$x \in x$ が成り立つためには、$x$ は自分自身より早い段階に存在する必要がある。

ラッセルの $R = \lbrace x : x \notin x \rbrace$ を考えよう。累積的階層では、*すべての*集合が $x \notin x$ を満たす（どの集合も自分自身を含まない）。したがって $R$ は*すべての*集合を含まなければならない。

しかし「すべての集合の集合」は存在しない。すべての集合が利用可能になる段階はない。階層は永遠に続く。すでに構築されたものからしか集合を形成できず、「すべて」は構築が終わることがない。

パラドックスは、$R$ がそもそも構築できないため解消される。

## 結論

ラッセルのパラドックスは、任意の性質が集合を定義する素朴集合論が矛盾していることを示している。解決策はパッチではなく、完全な再構築だ。現代数学は集合を段階的に、基礎から構築し、この段階的構築がパラドックス的な集合の形成を不可能にしている。

---

*この記事は[Claude](https://claude.ai)（Opus 4.5）との協力で書かれました。*
