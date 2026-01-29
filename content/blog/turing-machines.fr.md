+++
title = "Qu'est-ce qu'une machine de Turing ? (Partie 1/3)"
date = 2026-01-09
description = "L'abstraction élégante qui définit ce que signifie calculer"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

Le mois dernier, le PDG de DeepMind Demis Hassabis a [répliqué](https://twitter.com/demishassabis/status/2003097405026193809) à Yann LeCun sur X avec une affirmation qui a attiré mon attention :

> « Le cerveau humain (et les modèles de fondation en IA) sont des machines de Turing approximatives. »[^1]

J'ai entendu les expressions « machine de Turing » et « Turing-complet » des centaines de fois au fil des années, mais je dois admettre que je n'ai jamais vraiment compris ce qu'elles signifiaient. Voici mon essai d'explication : courte, dense, mais accessible. La partie 1 couvre ce qu'est réellement une machine de Turing. [La partie 2](@/blog/turing-completeness.md) expliquera ce que « Turing-complet » signifie et reviendra sur l'affirmation de Demis.

[^1]: [Tweet complet à la fin de l'article](#tweet)

## Contexte historique

Dans les années 1930, les mathématiciens cherchaient à formaliser ce que « calcul » veut vraiment dire. Avant l'existence des ordinateurs électroniques, un « calculateur » était littéralement un être humain effectuant des calculs à la main, suivant des règles et écrivant des résultats intermédiaires sur papier.

Alan Turing s'est demandé : quelles sont les opérations *minimales* nécessaires pour capturer tout calcul mécanique ? Sa réponse fut une machine abstraite si simple qu'elle semble presque triviale, mais suffisamment puissante pour calculer tout ce qui peut être calculé.

## La machine de Turing

### Intuition

Imaginez une personne assise à un bureau avec :

- Une bande de papier infiniment longue divisée en cases (le **ruban**)
- Un crayon et une gomme
- Un ensemble fini d'instructions mémorisées

Elle ne peut que :

1. Regarder une case à la fois
2. Écrire ou effacer un symbole dans cette case
3. Déplacer son attention d'une case vers la gauche ou la droite
4. Se trouver dans un nombre fini d'« états mentaux »

C'est tout. Pas d'unité arithmétique, pas de banques de mémoire, pas de traitement parallèle. Juste lire, écrire, se déplacer, changer d'état. Répéter.

Voyons cela en action.

## Exemple 1 : Nombre pair de 1

Construisons une machine $M$ qui accepte les chaînes binaires contenant un nombre pair de 1.

Prenons l'entrée $w = \texttt{1011}$. Elle contient trois 1 (impair), donc $M$ devrait la rejeter. L'entrée $w = \texttt{1100}$ contient deux 1 (pair), donc $M$ devrait l'accepter.

Le ruban commence avec l'entrée écrite dessus, suivie de blancs (notés $b$) s'étendant infiniment vers la droite :

$$\texttt{1} \quad \texttt{0} \quad \texttt{1} \quad \texttt{1} \quad b \quad b \quad b \quad \cdots$$

La tête de lecture commence sur la case la plus à gauche, dans un état initial $q_0$. Notre stratégie : parcourir vers la droite en alternant entre « vu pair » et « vu impair » à chaque 1, ignorer les 0, et accepter ou rejeter quand on atteint un blanc.

**États** : $Q = \lbrace q_{\text{pair}}, q_{\text{impair}}, q_{\text{accepter}}, q_{\text{rejeter}} \rbrace$, avec $q_0 = q_{\text{pair}}$ (zéro 1 vus, c'est pair).

**Transitions** :

| État | Lu | Écrit | Mouvement | État suivant |
|------|-----|-------|-----------|--------------|
| $q_{\text{pair}}$ | 0 | 0 | D | $q_{\text{pair}}$ |
| $q_{\text{pair}}$ | 1 | 1 | D | $q_{\text{impair}}$ |
| $q_{\text{pair}}$ | $b$ | $b$ | — | $q_{\text{accepter}}$ |
| $q_{\text{impair}}$ | 0 | 0 | D | $q_{\text{impair}}$ |
| $q_{\text{impair}}$ | 1 | 1 | D | $q_{\text{pair}}$ |
| $q_{\text{impair}}$ | $b$ | $b$ | — | $q_{\text{rejeter}}$ |

Chaque ligne se lit ainsi : « Si on est dans *État* et qu'on *Lit* ce symbole, alors *Écrire* ce symbole, faire ce *Mouvement* (Gauche ou Droite), et passer à *État suivant*. »

Déroulons $w = \texttt{1011}$ :

1. État $q_{\text{pair}}$, lire `1` → se déplacer à droite, passer à $q_{\text{impair}}$
2. État $q_{\text{impair}}$, lire `0` → se déplacer à droite, rester en $q_{\text{impair}}$
3. État $q_{\text{impair}}$, lire `1` → se déplacer à droite, passer à $q_{\text{pair}}$
4. État $q_{\text{pair}}$, lire `1` → se déplacer à droite, passer à $q_{\text{impair}}$
5. État $q_{\text{impair}}$, lire $b$ → s'arrêter en $q_{\text{rejeter}}$

Rejeté, comme prévu. Essayez $w = \texttt{1100}$ vous-même : vous devriez terminer en $q_{\text{accepter}}$.

Vous remarquez quelque chose ? Cette machine n'écrit jamais rien de nouveau, ne va jamais vers la gauche. Elle ne fait que parcourir vers la droite et changer d'état. On n'utilise pas encore toute la puissance d'une machine de Turing.

## Exemple 2 : Détection de palindromes

Essayons maintenant quelque chose qui *requiert* l'écriture et le mouvement bidirectionnel : détecter les palindromes.

Une chaîne est un palindrome si elle se lit de la même manière dans les deux sens. Prenons $w = \texttt{101}$ : c'est un palindrome, donc $M$ devrait accepter. L'entrée $w = \texttt{100}$ n'en est pas un, donc $M$ devrait rejeter.

**Algorithme** :

1. Lire le caractère le plus à gauche, le mémoriser (via l'état), le marquer avec $X$
2. Parcourir vers la droite pour trouver le caractère non marqué le plus à droite
3. Vérifier s'il correspond à ce qu'on a mémorisé ; rejeter sinon
4. Le marquer avec $X$, parcourir vers la gauche jusqu'au premier caractère non marqué
5. Répéter jusqu'à ce que tous les caractères soient marqués (accepter) ou qu'on trouve une discordance (rejeter)

Déroulons $w = \texttt{101}$. Le ruban commence ainsi :

$$\texttt{1} \quad \texttt{0} \quad \texttt{1} \quad b \quad \cdots$$

**Itération 1** : Dans l'état $q_0$, lire `1` à gauche. Passer à $q_{\text{cherche1}}$ (« cherche un 1 »), écrire $X$ :

$$X \quad \texttt{0} \quad \texttt{1} \quad b \quad \cdots$$

Dans $q_{\text{cherche1}}$, parcourir vers la droite jusqu'au caractère non marqué le plus à droite (`1`). Il correspond ! Écrire $X$, passer à $q_{\text{retour}}$ :

$$X \quad \texttt{0} \quad X \quad b \quad \cdots$$

Dans $q_{\text{retour}}$, parcourir vers la gauche jusqu'au premier caractère non marqué (`0`), passer à $q_0$.

**Itération 2** : Dans $q_0$, lire `0`. Passer à $q_{\text{cherche0}}$, écrire $X$ :

$$X \quad X \quad X \quad b \quad \cdots$$

Dans $q_{\text{cherche0}}$, parcourir vers la droite pour trouver le caractère non marqué le plus à droite... il n'y en a pas. Tout est marqué, donc passer à $q_{\text{accepter}}$.

Cet exemple illustre ce que l'exemple 1 n'exigeait pas :

- **Écriture** : On marque les caractères avec $X$ pour suivre la progression
- **Mouvement bidirectionnel** : On parcourt à gauche et à droite, encore et encore
- **L'état comme mémoire** : On mémorise « cherche un 0 » vs « cherche un 1 »

Notez que $X$ ne fait pas partie de l'entrée. L'**alphabet d'entrée** est $\Sigma = \lbrace \texttt{0}, \texttt{1} \rbrace$, mais l'**alphabet du ruban** est $\Gamma = \lbrace \texttt{0}, \texttt{1}, X, b \rbrace$. La machine peut lire et écrire des symboles au-delà de ce qui apparaît dans les entrées valides.

## Définition formelle

Maintenant que nous avons vu des exemples, voici la définition formelle. Une machine de Turing est un 7-uplet :

$$M = (Q, \Gamma, b, \Sigma, \delta, q_0, F)$$

| Symbole | Signification |
|---------|---------------|
| $Q$ | Ensemble fini d'états |
| $\Gamma$ | Alphabet du ruban (ensemble fini de symboles que la machine peut lire/écrire) |
| $b \in \Gamma$ | Symbole blanc (remplit le ruban infini au-delà de l'entrée) |
| $\Sigma \subseteq \Gamma \setminus \lbrace b \rbrace$ | Alphabet d'entrée (symboles d'entrée valides) |
| $q_0 \in Q$ | État initial |
| $F \subseteq Q$ | États acceptants |
| $\delta: Q \times \Gamma \rightarrow Q \times \Gamma \times \lbrace G, D \rbrace$ | Fonction de transition |

La fonction de transition $\delta$ est le cerveau de la machine : « Si je suis dans l'état $q$ et vois le symbole $s$, alors écrire $s'$, se déplacer à gauche ou à droite, et passer à l'état $q'$. »

Une machine **accepte** l'entrée $w$ si elle finit par atteindre un état dans $F$. Le **langage** qu'elle reconnaît est l'ensemble de toutes les chaînes qu'elle accepte : $L(M) = \lbrace w \in \Sigma^* \mid M \text{ accepte } w \rbrace$, où $\Sigma^*$ désigne toutes les chaînes finies sur l'alphabet d'entrée, comme $\lbrace 0, 1 \rbrace^* = \lbrace \epsilon, 0, 1, 00, 01, \ldots \rbrace$.

Regardez bien $L(M)$. La machine $M$ est finie : un nombre fini d'états, un alphabet de ruban fini, donc un nombre fini de règles de transition. Et pourtant, le langage $L(M)$ peut contenir une infinité de chaînes. **Une machine de Turing est une description finie d'un ensemble potentiellement infini.**

Cela fait écho à quelque chose que j'ai exploré dans [mon article sur le paradoxe de Russell](@/blog/russells-paradox.md). En notation en compréhension, $\lbrace x : x > 5 \rbrace$ décrit une infinité de nombres avec quelques symboles. Une machine de Turing fait quelque chose de similaire :

$$\lbrace x : x > 5 \rbrace \quad \text{vs} \quad \lbrace w : M \text{ accepte } w \rbrace$$

Les deux définissent des ensembles via un critère d'appartenance. La différence : la notation en compréhension permet *n'importe quelle* propriété, y compris celles sans test mécanique (« $n$ apparaîtra dans les numéros gagnants du loto de la semaine prochaine » définit un ensemble, mais bonne chance pour tester l'appartenance). Une machine de Turing, par construction, *est* un test.[^2] La définition et la procédure sont une seule et même chose : passez-moi un candidat $w$, et j'exécute $M$ dessus.

Notre machine « nombre pair de 1 » a six règles de transition, pourtant elle accepte une infinité de chaînes : $\epsilon$, `0`, `00`, `11`, `0000`, `1111`, `0110`... On ne pourrait jamais toutes les lister, mais donnez-moi n'importe quelle chaîne et je peux exécuter la machine pour vous dire si elle appartient à l'ensemble.

[^2]: Avec un bémol : la machine pourrait tourner indéfiniment sans jamais s'arrêter. On en reparlera dans la partie 2.

## La suite

Nous avons vu ce qu'est une machine de Turing : une abstraction minimale pour le calcul mécanique. Lire, écrire, se déplacer, changer d'état.

Mais pourquoi une machine si simple devrait-elle nous intéresser ? [La partie 2](@/blog/turing-completeness.md) aborde ce que « Turing-complet » signifie, pourquoi cette machine primitive s'avère être maximalement puissante, et ce que Demis voulait dire par « machines de Turing approximatives ».

---

<a id="tweet"></a>
<blockquote class="twitter-tweet" data-theme="dark" data-align="center"><p lang="en" dir="ltr">Yann is just plain incorrect here, he's confusing general intelligence with universal intelligence.<br><br>Brains are the most exquisite and complex phenomena we know of in the universe (so far), and they are in fact extremely general.<br><br>Obviously one can't circumvent the no free lunch… <a href="https://t.co/RjeqlaP7GO">https://t.co/RjeqlaP7GO</a></p>&mdash; Demis Hassabis (@demishassabis) <a href="https://twitter.com/demishassabis/status/2003097405026193809?ref_src=twsrc%5Etfw">December 22, 2025</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

---

*Cet article a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
