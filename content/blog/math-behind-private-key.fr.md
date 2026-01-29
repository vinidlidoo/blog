+++
title = "Les mathématiques derrière votre clé privée (Partie 1/2)"
date = 2026-01-16
updated = 2026-01-18
description = "De la théorie des groupes aux courbes elliptiques : comment la cryptographie à clé publique fonctionne vraiment"

[taxonomies]
tags = ["crypto", "math"]

[extra]
katex = true
+++

![Addition de points](/img/elliptic-curve-point-addition.png)

Les courbes elliptiques reviennent sans cesse en cryptographie. Je les évitais depuis des années, mais en creusant l'architecture des rollups Ethereum, j'ai finalement décidé de m'arrêter et de vraiment comprendre ce qu'il se passe. La surprise ? Tout repose sur la théorie des groupes — cette même algèbre abstraite que j'ai apprise à l'université et aussitôt oubliée parce qu'elle semblait si déconnectée de quoi que ce soit de réel. Il s'avère que j'avais tort.

À la fin de cet article, vous comprendrez les mathématiques fondamentales derrière les clés publiques et privées : comment elles sont construites à partir des courbes elliptiques, et pourquoi cette construction est sécurisée. La [2e partie](@/blog/secrets-and-signatures.fr.md) couvrira comment ces mathématiques sont appliquées en pratique.

## Les corps : des nombres avec de l'arithmétique

Dans [mon article sur le paradoxe de Russell](@/blog/russells-paradox.fr.md), j'ai couvert ce qu'est un ensemble. Un **corps** est un ensemble $F$ muni de deux **opérations binaires** — l'addition et la multiplication — satisfaisant **neuf axiomes** : quatre pour chaque opération, plus la distributivité qui les relie. « Binaire » signifie que chaque opération prend deux éléments et en retourne un du même ensemble :

$$+: F \times F \to F$$
$$\cdot: F \times F \to F$$

Deux exemples d'axiomes (voir l'[Annexe](#axiomes-des-corps) pour la liste complète) :
  - associativité : $(a + b) + c = a + (b + c)$
  - inverses multiplicatifs : $\forall a \neq 0,\ \exists\ a^{-1}$ tel que $a \cdot a^{-1} = 1$

Il s'avère que les corps sont la structure minimale requise pour supporter l'algèbre linéaire, le calcul différentiel et d'autres mathématiques de premier cycle. Les nombres réels $\mathbb{R}$ forment un corps. Les rationnels $\mathbb{Q}$ aussi. Mais les entiers $\mathbb{Z}$ non : il n'existe pas d'entier $n$ tel que $2 \cdot n = 1$. L'inverse multiplicatif de 2 serait $\frac{1}{2}$, qui n'est pas dans $\mathbb{Z}$.

La cryptographie utilise souvent des corps finis. La courbe secp256k1 d'Ethereum opère sur $\mathbb{F}_p$ :

$$\mathbb{F}_p = \lbrace 0, 1, 2, \ldots, p-1 \rbrace$$

où $p$ est un grand nombre premier ($p \approx 2^{256}$). L'arithmétique s'effectue modulo $p$. En prenant $p = 7$ comme petit exemple :
- $5 + 4 = 9 \equiv 2 \pmod{7}$
- $3 \cdot 5 = 15 \equiv 1 \pmod{7}$ — donc $3$ et $5$ sont inverses multiplicatifs dans $\mathbb{F}_7$

Pourquoi $p$ doit-il être premier ? Avec $p = 6$, on a $2 \cdot 3 \equiv 0$. Si $2$ avait un inverse $2^{-1}$, on pourrait multiplier les deux côtés : $2^{-1} \cdot 2 \cdot 3 = 2^{-1} \cdot 0$, ce qui donne $3 = 0$, une contradiction. Donc $2$ n'a pas d'inverse multiplicatif, et l'axiome du corps n'est pas satisfait. Les nombres premiers évitent ce problème.

## Les groupes : plus simples que les corps

Un **groupe** est une structure plus simple qu'un corps : une seule opération binaire au lieu de deux, quatre axiomes au lieu de neuf. On écrit un groupe $(G, \circ)$ où $G$ est un ensemble et $\circ$ est l'opération (qui peut être l'addition, la multiplication, la composition, etc.).

Les quatre axiomes :
1. **Fermeture** : $\forall a, b \in G:\ a \circ b \in G$
2. **Associativité** : $(a \circ b) \circ c = a \circ (b \circ c)$
3. **Identité** : $\exists\ e \in G$ tel que $e \circ a = a \circ e = a$
4. **Inverses** : $\forall a \in G,\ \exists\ a^{-1} \in G$ tel que $a \circ a^{-1} = a^{-1} \circ a = e$

Les axiomes ne spécifient pas ce que $G$ contient ni ce que $\circ$ fait. Démontrez quelque chose sur les groupes en général, et cela s'applique à tous les groupes : entiers, symétries, points sur une courbe.

**Exemple** : $(\mathbb{Z}, +)$, les entiers sous l'addition :
- Fermeture : $3 + 5 = 8 \in \mathbb{Z}$
- Associativité : $(2 + 3) + 4 = 2 + (3 + 4) = 9$
- Identité : $e = 0\ $ (pas 1 !)
- Inverses : $a^{-1} = -a$ puisque $a + (-a) = 0$

## Les courbes elliptiques sont des groupes

Une **courbe elliptique** sur un corps $\mathbb{F}_p$ est l'ensemble des points $(x, y)$ satisfaisant :

$$y^2 = x^3 + ax + b$$

plus un **point à l'infini** spécial $\mathcal{O}$. Les constantes $a, b \in \mathbb{F}_p$ définissent la forme de la courbe.

Cet ensemble forme un groupe sous une opération binaire appelée **addition de points**. La construction peut sembler arbitraire, mais c'est précisément ce qui fait que les axiomes de groupe sont satisfaits. Voici comment ça fonctionne :

1. Trouver la droite passant par $P$ et $Q$ (c'est-à-dire résoudre pour la pente $m$ et l'ordonnée à l'origine $c$ dans $y = mx + c$). Si $P = Q$, utiliser la tangente à $P$.
2. Cette droite intersecte la courbe en exactement 3 points (en comptant la multiplicité — une tangente compte double). Trouver la troisième intersection $R$.
3. Calculer le résultat :
   - **Si $R$ est un point fini** : le réfléchir par rapport à l'axe des x pour obtenir $P + Q = -R$, où $-R = (x, -y)$.
   - **Si la droite est verticale** : il n'y a pas de troisième intersection finie. Le résultat est $\mathcal{O}$, le point à l'infini.

Une dernière règle : $P + \mathcal{O} = P$ pour tout point $P$. Le point à l'infini agit comme l'élément identité.

Vérification des axiomes de groupe :
- **Fermeture** : l'addition de points donne toujours un autre point sur la courbe (ou $\mathcal{O}$)
- **Associativité** : elle est satisfaite, bien que la preuve soit non triviale
- **Identité** : $\mathcal{O}$, par définition ci-dessus
- **Inverses** : l'inverse de $(x, y)$ est $(x, -y)$, puisque leur somme donne $\mathcal{O}$

## Pourquoi les cryptographes s'y intéressent

Nous avons donc un groupe : des points sur une courbe elliptique, une opération d'addition, quatre axiomes satisfaits. Mais les groupes sont partout en mathématiques. Qu'est-ce qui rend *ce* groupe utile pour la cryptographie ?

La réponse réside dans une asymétrie : certaines opérations sur ce groupe sont faciles à calculer, d'autres sont pratiquement impossibles à inverser. Pour le voir, nous avons besoin d'un concept supplémentaire.

**La multiplication scalaire** est une addition répétée. Puisque nous avons une opération de groupe, nous pouvons l'appliquer de manière répétée. $nP$ signifie ajouter $P$ à lui-même $n$ fois :

$$nP = \underbrace{P + P + \cdots + P}_{n \text{ fois}}$$

La sécurité cryptographique nécessite de grands nombres. Ethereum utilise $n \approx 2^{256}$, un nombre à 78 chiffres. Calculer naïvement $nP$ nécessiterait $n - 1$ additions, ce qui est impossible.

Mais tout entier a une représentation binaire. Prenons $n = 13$ :

$$13 = 1101_2 = 8 + 4 + 1$$

Donc $13P = 8P + 4P + P$. L'idée clé : $8P = 2(4P) = 2(2(2P))$. On calcule $2P$, $4P$, $8P$ par doublements successifs (3 opérations), puis on additionne les termes pertinents (2 de plus). Total : 5 opérations au lieu de 12.

C'est le **double-and-add**. Pour tout $n$, il nécessite $O(\log n)$ opérations, environ le nombre de bits dans $n$. Même pour $n \approx 2^{256}$, cela ne fait qu'environ 256 doublements et additions. Rapide.

**Le sens inverse est difficile.** Étant donné $P$ et $Q = nP$, trouver $n$ est le **problème du logarithme discret** (DLP). « Logarithme » par analogie avec $b^n = x \Rightarrow n = \log_b(x)$. « Discret » parce que nous sommes dans un groupe fini.

Aucun algorithme connu ne fait vraiment mieux que la force brute. Avec $n \approx 2^{256}$, c'est infaisable.

**Cette asymétrie est exactement ce dont la cryptographie à clé publique a besoin.** Chaque spécification de courbe inclut un point de base standard $P$ (aussi appelé générateur) que tout le monde utilise.
- Choisissez un entier secret $n$. C'est votre **clé privée**.
- Calculez $Q = nP$. C'est votre **clé publique**.
- Publiez $Q$. Les protocoles de signature et de chiffrement s'appuient sur cette paire de clés.
- Pour usurper votre identité, un attaquant doit retrouver $n$ à partir de $Q$ et $P$. Mais c'est le DLP, qui est infaisable.

C'est le cœur de la cryptographie sur courbes elliptiques. Les implémentations réelles ajoutent des couches : Ethereum hache votre clé publique pour dériver votre adresse, et les schémas de signature comme ECDSA impliquent des étapes supplémentaires. Mais la sécurité de tout cela repose sur la difficulté du DLP.

## À retenir

Nous avons couvert beaucoup de terrain. Les corps nous donnent l'arithmétique dans des espaces finis. Les groupes sont des structures plus simples — une opération, quatre axiomes — qui apparaissent partout. Les courbes elliptiques forment un groupe sous l'addition de points, et le problème du logarithme discret sur ces courbes est suffisamment difficile pour sécuriser vos clés privées.

La construction est élégante : choisissez un nombre secret $n$, multipliez un point connu $P$ par $n$, publiez le résultat $Q = nP$. N'importe qui peut vérifier des choses avec $Q$, mais retrouver $n$ est hors de portée en termes de calcul. Dans la [2e partie](@/blog/secrets-and-signatures.fr.md), nous verrons comment ce fondement permet deux protocoles pratiques : ECDH pour l'échange de clés, et ECDSA pour les signatures numériques.

---

<a id="axiomes-des-corps"></a>

## Annexe : Axiomes des corps

<details>
<summary>Les neuf axiomes</summary>

**Axiomes de l'addition** (pour tout $a, b, c \in F$) :
<ol>
<li><strong>Associativité</strong> : $(a + b) + c = a + (b + c)$</li>
<li><strong>Commutativité</strong> : $a + b = b + a$</li>
<li><strong>Identité</strong> : $\exists\ 0 \in F$ tel que $a + 0 = a$</li>
<li><strong>Inverses</strong> : $\exists\ (-a) \in F$ tel que $a + (-a) = 0$</li>
</ol>

**Axiomes de la multiplication** (pour tout $a, b, c \in F$) :
<ol start="5">
<li><strong>Associativité</strong> : $(a \cdot b) \cdot c = a \cdot (b \cdot c)$</li>
<li><strong>Commutativité</strong> : $a \cdot b = b \cdot a$</li>
<li><strong>Identité</strong> : $\exists\ 1 \in F$ tel que $a \cdot 1 = a$</li>
<li><strong>Inverses</strong> : $\forall a \neq 0,\ \exists\ a^{-1} \in F$ tel que $a \cdot a^{-1} = 1$</li>
</ol>

**Liaison entre addition et multiplication** :
<ol start="9">
<li><strong>Distributivité</strong> : $a \cdot (b + c) = a \cdot b + a \cdot c$</li>
</ol>

</details>

---

*Cet article a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
