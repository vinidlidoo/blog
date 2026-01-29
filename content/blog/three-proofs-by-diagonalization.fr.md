+++
title = "Trois preuves par diagonalisation"
date = 2026-01-08
description = "Une famille de preuves qui construisent des objets qui diffèrent nécessairement de chaque élément d'une liste"

[taxonomies]
tags = ["math"]

[extra]
katex = true
+++

En poursuivant l'exploration entamée avec le [podcast #488 de Lex Fridman](https://youtu.be/14OPT6CcsH4?t=2967&si=_qnWStDudzUB_o_D), je veux m'intéresser à la **diagonalisation** — une technique de preuve qui revient sans cesse dans les fondements des mathématiques.

L'idée centrale : construire un objet qui diffère nécessairement de chaque élément d'une liste donnée en modifiant les entrées « diagonales ». Nous verrons trois variations de cette technique, toutes partageant la même structure logique (chacune est également abordée dans le podcast).

## 1. La preuve de Cantor : les réels sont indénombrables

Georg Cantor a introduit la diagonalisation en 1891 pour prouver que les nombres réels forment un infini strictement plus grand que les nombres naturels.

Supposons, par l'absurde, qu'on puisse énumérer tous les réels entre 0 et 1. Chaque réel peut s'écrire comme un développement décimal infini :

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

Construisons maintenant un nouveau nombre $d$ en regardant la **diagonale** — le $n$-ième chiffre du $n$-ième nombre — et en changeant chaque chiffre. Si le chiffre diagonal est 5, on le remplace par 6 ; sinon on met 5 :

$$d = 0.\mathbf{6}\mathbf{5}\mathbf{5}\mathbf{5}\mathbf{5}\ldots$$

Ce nombre $d$ diffère de $r_1$ par le premier chiffre, de $r_2$ par le deuxième, de $r_3$ par le troisième, et ainsi de suite. Il diffère de chaque nombre de la liste.

Mais nous avions supposé que la liste contenait tous les réels entre 0 et 1. Contradiction. Donc une telle liste ne peut pas exister — les réels sont **indénombrables**.

## 2. L'ensemble des parties est toujours plus grand

Cantor a prouvé quelque chose de plus général encore : pour tout ensemble $X$, son **ensemble des parties** $\mathcal{P}(X)$ — l'ensemble de tous les sous-ensembles — est strictement plus grand que $X$ lui-même. Même pour les ensembles infinis.

Cela signifie qu'il n'existe pas de « plus grand » infini. Étant donné un ensemble infini quelconque, on peut toujours en construire un plus grand en prenant son ensemble des parties.

### La preuve formelle

Soit $X$ un ensemble quelconque. Il y a évidemment au moins autant de sous-ensembles que d'éléments (chaque élément $x$ correspond au singleton $\lbrace x \rbrace$). La question est de savoir s'il y en a strictement plus.

Supposons, par l'absurde, que $X$ et $\mathcal{P}(X)$ aient la même cardinalité. Alors il existe une bijection $f: X \to \mathcal{P}(X)$, associant chaque élément à un sous-ensemble unique.

Définissons un nouveau sous-ensemble :

$$D = \lbrace x \in X : x \notin f(x) \rbrace$$

En clair : $D$ contient tous les éléments qui ne sont **pas** dans leur sous-ensemble associé.

Puisque $D$ est un sous-ensemble de $X$, on a $D \in \mathcal{P}(X)$. Et puisque $f$ est une bijection, un élément a pour image $D$. Appelons cet élément Diana, de sorte que $f(\text{Diana}) = D$.

Maintenant, demandons-nous : Diana est-elle dans $D$ ?

**Si Diana $\in D$ :** Par définition de $D$, Diana serait un élément qui n'est pas dans son sous-ensemble associé. Mais son sous-ensemble associé est $D$, donc Diana $\notin D$. Contradiction.

**Si Diana $\notin D$ :** Alors Diana n'est pas dans son sous-ensemble associé, ce qui est exactement le critère d'appartenance à $D$. Donc Diana $\in D$. Contradiction.

Les deux cas échouent. Par conséquent, aucune bijection n'existe, et $|\mathcal{P}(X)| > |X|$.

### Personnes et comités

Voici une illustration due à Joel David Hamkins : pour toute collection de personnes, on peut former plus de comités qu'il n'y a de personnes — même avec une infinité de personnes.

Un comité n'est rien d'autre qu'un sous-ensemble de personnes. On affirme que $|\mathcal{P}(\text{Personnes})| > |\text{Personnes}|$.

Supposons que non. Alors on pourrait nommer chaque comité d'après une personne, de manière bijective. (La personne n'a pas besoin d'être membre du comité qui porte son nom — c'est juste une convention de nommage.)

Formons le **Comité D** : toutes les personnes qui ne sont *pas* dans le comité qui porte leur nom.

C'est un comité valide. Il doit porter le nom de quelqu'un — appelons-la Daniella.

Daniella est-elle dans le comité qui porte son nom ?

- Si oui, elle est dans le Comité D. Mais le Comité D est composé des personnes qui *ne sont pas* dans leur comité éponyme. Contradiction.
- Si non, elle n'est pas dans son comité éponyme. Donc elle remplit les conditions pour être dans le Comité D. Contradiction.

Plus de comités que de personnes.

### Fruits et salades de fruits

Une autre illustration, due à un étudiant de Hamkins à Oxford : pour toute collection de fruits, il y a plus de salades de fruits possibles que de fruits.

Une salade de fruits n'est rien d'autre qu'un sous-ensemble de fruits. S'il n'y avait qu'autant de salades que de fruits, on pourrait nommer chaque salade d'après un fruit.

Formons la **salade diagonale** : tous les fruits qui ne sont *pas* dans la salade qui porte leur nom.

Cette salade doit porter le nom d'un fruit — disons, le durian.

Le durian est-il dans la salade qui porte son nom ?

- Si oui, il ne devrait pas y être (la salade ne contient que les fruits qui *ne sont pas* dans leur salade éponyme).
- Si non, il devrait y être (il remplit le critère d'appartenance).

Contradiction. Plus de salades que de fruits.

## 3. Le paradoxe de Russell : pas d'ensemble universel

Dans un [article précédent](@/blog/russells-paradox.fr.md), j'ai exploré le paradoxe de Russell et comment il a brisé la théorie naïve des ensembles. Ce que je n'avais pas souligné alors, c'est que l'argument de Russell est **la même technique diagonale**.

Voici la structure parallèle :

**L'hypothèse de correspondance :** Supposons que la classe de tous les ensembles $V$ soit elle-même un ensemble. Alors chaque ensemble est « dans la liste » — $V$ indexe tous les ensembles, y compris lui-même. On peut demander pour chaque ensemble $x$ : est-ce que $x$ se contient lui-même ?

**La construction diagonale :** Formons $R$, la collection de tous les ensembles où la réponse est « non » :

$$R = \lbrace x \in V : x \notin x \rbrace$$

C'est exactement la même construction que celle de Cantor. Là où Cantor demandait « $x$ est-il dans son sous-ensemble associé $f(x)$ ? », Russell demande « $x$ est-il élément de lui-même ? » L'ensemble $R$ rassemble toutes les réponses « non » — les ensembles qui ne sont pas membres d'eux-mêmes.

**La contradiction :** Puisque $R$ est une collection d'ensembles et que $V$ contient tous les ensembles, on a $R \in V$. Maintenant, demandons-nous : $R \in R$ ?

- Si $R \in R$ : Alors $R$ est membre de lui-même. Mais $R$ ne contient que les ensembles qui *ne sont pas* membres d'eux-mêmes. Donc $R \notin R$. Contradiction.
- Si $R \notin R$ : Alors $R$ n'est pas membre de lui-même — exactement le critère d'appartenance à $R$. Donc $R \in R$. Contradiction.

La structure est identique à Diana, Daniella et le durian. La correspondance supposée (tous les ensembles indexés par $V$) permet de former l'ensemble diagonal, qui ne peut alors pas exister.

Ce que Russell a prouvé, pour reprendre la formulation de Hamkins : « Il n'existe pas d'ensemble universel. » L'hypothèse que $V$ est un ensemble mène à une contradiction, donc l'univers des ensembles ne peut pas lui-même être un ensemble.

## Le fil conducteur

Les trois preuves partagent le même squelette :

1. Supposer qu'une collection peut être mise en correspondance avec ses « parties » (chiffres, sous-ensembles, comités, salades ou ensembles)
2. Construire l'objet diagonal : celui qui diffère de chaque élément à sa propre position
3. Demander si cet objet se contient lui-même / appartient à sa propre catégorie
4. Aboutir à une contradiction dans les deux cas (oui et non)

La diagonalisation révèle que certaines collections sont trop grandes pour être capturées par une liste ou un ensemble quelconque. C'est une limite fondamentale inscrite dans la structure même des mathématiques.

---

*Cet article a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
