+++
title = "Le paradoxe de Russell"
date = 2026-01-06
description = "Une contradiction fondamentale qui a ébranlé les fondements des mathématiques"

[taxonomies]
tags = ["math"]

[extra]
katex = true
stylesheets = ["css/details.css"]
+++

Le [podcast #488 de Lex Fridman](https://youtu.be/14OPT6CcsH4?t=2967&si=_qnWStDudzUB_o_D) sur l'infini et l'incomplétude de Gödel m'a fait plonger dans le paradoxe de Russell — une contradiction d'apparence simple qui a brisé la théorie naïve des ensembles en 1901.

## Le paradoxe

Définissons un ensemble $R$ contenant tous les ensembles qui ne se contiennent pas eux-mêmes :

$$R = \lbrace x : x \notin x\rbrace$$

C'est la **notation en compréhension**. Décomposons-la :

- $\lbrace \ \rbrace$ — « l'ensemble de »
- $x$ — une variable représentant n'importe quel ensemble
- $:$ — « tel que » (parfois écrit $|$)
- $x \notin x$ — « $x$ n'est pas un élément de lui-même »

L'expression complète se lit donc : « L'ensemble de tous les $x$ tels que $x$ n'est pas membre de lui-même. »

Est-ce que $R$ se contient lui-même ? Il n'y a que deux possibilités :

**Cas 1 : Supposons que $R \in R$ (R se contient lui-même)**

Si $R$ est membre de lui-même, alors $R$ doit satisfaire le critère d'appartenance. Mais ce critère est « ne se contient pas lui-même ». Donc si $R \in R$, alors $R \notin R$. Contradiction.

**Cas 2 : Supposons que $R \notin R$ (R ne se contient pas lui-même)**

Si $R$ n'est pas membre de lui-même, alors $R$ satisfait exactement la propriété que nous avons utilisée pour définir $R$ — c'est un ensemble qui ne se contient pas lui-même. Donc $R$ devrait appartenir à $R$, ce qui signifie que $R \in R$. Contradiction.

Les deux cas mènent à une contradiction.

## Ce qui a mal tourné

Le problème est la **compréhension naïve** — l'hypothèse que toute propriété définit un ensemble valide. « L'ensemble de tous les $x$ tels que... » semble devoir toujours fonctionner, mais Russell a montré que ce n'est pas le cas.

La théorie des ensembles moderne (ZFC) corrige cela en **construisant les ensembles par étapes**. On ne peut pas faire apparaître un ensemble de nulle part — il faut le construire à partir d'ensembles qui existent déjà. C'est ce qu'on appelle la **hiérarchie cumulative** :

- $V_0 = \emptyset$
- $V_{\alpha+1} = \mathcal{P}(V_\alpha)$
- $V_\lambda = \bigcup_{\alpha < \lambda} V_\alpha$ pour les ordinaux limites $\lambda$

Voyons ce que chaque règle signifie, puis pourquoi cette construction dissout le paradoxe de Russell.

### Règle 1 : Partir de rien

$V_0 = \emptyset$, l'ensemble vide.

### Règle 2 : Prendre l'ensemble des parties

$V_{\alpha+1} = \mathcal{P}(V_\alpha)$

L'**ensemble des parties** $\mathcal{P}(A)$ est l'ensemble de tous les sous-ensembles de $A$. Pour le construire, on considère chaque élément de $A$ et on décide : l'inclure ou non. Avec $n$ éléments, on obtient $2^n$ sous-ensembles.

<details>
<summary>Comment construire l'ensemble des parties de {a, b}</summary>

Si $A = \lbrace a, b \rbrace$, les sous-ensembles sont :

- N'inclure rien : $\emptyset$
- Inclure seulement $a$ : $\lbrace a \rbrace$
- Inclure seulement $b$ : $\lbrace b \rbrace$
- Inclure les deux : $\lbrace a, b \rbrace$

Donc $\mathcal{P}(\lbrace a, b \rbrace) = \lbrace \emptyset, \lbrace a \rbrace, \lbrace b \rbrace, \lbrace a, b \rbrace \rbrace$ — quatre sous-ensembles, puisque $2^2 = 4$.

</details>

Construisons maintenant les premières étapes :

**$V_1 = \mathcal{P}(V_0) = \mathcal{P}(\emptyset)$**

Quels sont les sous-ensembles de l'ensemble vide ? Il n'y en a qu'un : l'ensemble vide lui-même (on « n'inclut rien »). Donc $V_1 = \lbrace \emptyset \rbrace$. C'est un ensemble à un élément.

**$V_2 = \mathcal{P}(V_1) = \mathcal{P}(\lbrace \emptyset \rbrace)$**

$V_1$ a un élément : $\emptyset$. Pour chaque élément, inclure ou exclure :

- Exclure $\emptyset$ : donne $\emptyset$
- Inclure $\emptyset$ : donne $\lbrace \emptyset \rbrace$

Donc $V_2 = \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$ — deux éléments, puisque $2^1 = 2$.

Notez que $\emptyset$ et $\lbrace \emptyset \rbrace$ sont différents : l'un est une boîte vide, l'autre est une boîte contenant une boîte vide.

**$V_3 = \mathcal{P}(V_2) = \mathcal{P}(\lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace)$**

$V_2$ a deux éléments. Inclure ou exclure chacun :

- N'inclure rien : $\emptyset$
- Inclure seulement $\emptyset$ : $\lbrace \emptyset \rbrace$
- Inclure seulement $\lbrace \emptyset \rbrace$ : $\lbrace \lbrace \emptyset \rbrace \rbrace$
- Inclure les deux : $\lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$

Donc $V_3 = \lbrace \emptyset, \lbrace \emptyset \rbrace, \lbrace \lbrace \emptyset \rbrace \rbrace, \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace \rbrace$ — quatre éléments, puisque $2^2 = 4$.

Les choses deviennent intéressantes. On a maintenant des ensembles contenant d'autres ensembles, des ensembles à plusieurs éléments et des structures imbriquées. $V_4$ a $2^4 = 16$ éléments, $V_5$ en a $2^{16} = 65536$, et la croissance explose à partir de là.

**Pourquoi est-ce important ?** Ces « boîtes vides » ne sont pas des curiosités abstraites — elles *encodent* les mathématiques concrètes. La définition standard des nombres naturels en théorie des ensembles :

- $0 = \emptyset$
- $1 = \lbrace \emptyset \rbrace$
- $2 = \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace$
- $3 = \lbrace \emptyset, \lbrace \emptyset \rbrace, \lbrace \emptyset, \lbrace \emptyset \rbrace \rbrace \rbrace$

Chaque nombre $n$ est l'ensemble contenant tous les nombres plus petits. À partir des nombres naturels, on construit les entiers (comme des paires), les rationnels (comme des paires d'entiers), les réels (comme des ensembles de rationnels), les fonctions (comme des ensembles de paires), et tout le reste. Toutes les mathématiques se réduisent à des ensembles construits à partir de $\emptyset$.

### Règle 3 : Continuer au-delà de l'infini

$V_\lambda = \bigcup_{\alpha < \lambda} V_\alpha$

Après $V_0, V_1, V_2, \ldots$ on a construit une infinité d'étapes. Mais on n'a pas terminé — la règle 2 dit « prendre l'ensemble des parties de l'étape précédente », et l'infini n'a pas de prédécesseur immédiat. Il n'y a pas de $V_n$ où $n+1 = \infty$.

Une fois arrivé à l'infini, on rassemble tout ce qui a été construit jusqu'ici :

$$V_\omega = V_0 \cup V_1 \cup V_2 \cup \ldots$$

Ici $\omega$ est le premier ordinal infini — autrement dit « après toutes les étapes finies ». Maintenant la règle 2 fonctionne à nouveau : $V_{\omega+1} = \mathcal{P}(V_\omega)$, $V_{\omega+2} = \mathcal{P}(V_{\omega+1})$, et ainsi de suite.

La hiérarchie s'étend indéfiniment, avec d'autres étapes de rassemblement aux infinis supérieurs. Les détails techniques n'importent pas ici — ce qui compte, c'est que **la hiérarchie ne s'arrête jamais**.

## Pourquoi cela dissout le paradoxe

La propriété cruciale : **un ensemble ne peut contenir que des éléments des étapes précédentes**.

Un ensemble à l'étape $\alpha$ est construit à partir d'ensembles des étapes $< \alpha$. Cela rend l'auto-appartenance impossible — pour que $x \in x$ soit vrai, $x$ devrait exister à une étape antérieure à lui-même.

Considérons maintenant le $R$ de Russell : $R = \lbrace x : x \notin x \rbrace$. Dans la hiérarchie cumulative, *tout* ensemble satisfait $x \notin x$ — aucun ensemble ne se contient lui-même. Donc $R$ devrait contenir *tous* les ensembles.

Mais « l'ensemble de tous les ensembles » n'existe pas. Il n'y a pas d'étape où tous les ensembles sont disponibles — la hiérarchie s'étend indéfiniment. On ne peut former des ensembles qu'à partir de ce qui a déjà été construit, et « tout » n'est jamais fini d'être construit.

Le paradoxe se dissout parce que $R$ ne peut tout simplement pas être construit.

## À retenir

Le paradoxe de Russell montre que la théorie naïve des ensembles — où toute propriété définit un ensemble — est inconsistante. La solution n'est pas un correctif : c'est une reconstruction complète. Les mathématiques modernes construisent les ensembles par étapes, depuis la base, et cette construction par étapes rend l'ensemble paradoxal impossible à former.

---

*Cet article a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
