+++
title = "Verkle Trees : Engagements Polynomiaux (Partie 2/2)"
date = 2026-02-13
updated = 2026-02-16
description = "Comment un seul point de courbe peut engager 256 enfants, et pourquoi les preuves passent de kilo-octets à octets"

[taxonomies]
tags = ["crypto", "computer-science"]

[extra]
katex = true
social_media_card = "/img/verkle-tree-banner.webp"
+++

![Verkle tree : des courbes polynomiales lisses convergent depuis de nombreux noeuds feuilles vers un seul point d'engagement lumineux](/img/verkle-tree-banner.webp)

La [Partie 1](@/blog/ethereum-merkle-patricia-trie.fr.md) s'est terminée sur un problème : les preuves de Merkle dans le state trie d'Ethereum sont trop volumineuses pour la validation sans état. À plusieurs Mo par bloc, le coût en bande passante de l'inclusion des preuves pousserait les validateurs individuels vers les data centers.

Les Verkle trees proposent une réponse : remplacer les engagements par hachage par des **engagements polynomiaux**. Chaque noeud stocke un point de courbe au lieu d'un hash, et les noeuds passent de 16 enfants à 256. Au lieu de prouver une feuille en fournissant tous les hashs des noeuds frères sur le chemin jusqu'à la racine (\~3 Ko), le prouveur envoie une petite preuve à chaque niveau (\~150 octets), environ 20× plus compacte. À la fin de cet article, vous comprendrez comment.

## Des valeurs à un polynôme

L'idée centrale est de construire un **engagement vectoriel** : un schéma qui engage plusieurs valeurs et permet de prouver n'importe laquelle sans révéler les autres. C'est de là que vient le « V » de Verkle (**V**ector commitment + M**erkle**).[^1] Même structure d'arbre, mais un engagement différent à chaque noeud.

On y parvient avec des polynômes. On représente les 256 enfants d'un noeud comme les évaluations d'un seul polynôme :

$$P(x) = a_0 + a_1 x + a_2 x^2 + \cdots + a_{255} x^{255}$$

On choisit les positions $0, 1, \ldots, 255$ et on détermine les coefficients $a_0, \ldots, a_{255}$ de sorte que :

$$P(i) = v_i \quad \text{pour } i = 0, 1, \ldots, 255$$

On obtient un polynôme de degré 255 qui passe par chaque valeur enfant. Un tel polynôme existe toujours et est unique : $n$ paires position-valeur déterminent exactement un polynôme de degré $n - 1$.[^2] L'algorithme qui trouve ce polynôme s'appelle l'**interpolation de Lagrange**.

<details>
<summary>Comment fonctionne l'interpolation de Lagrange</summary>

L'idée : construire des polynômes de base qui valent chacun 1 en un point et 0 en tous les autres, puis prendre leur somme pondérée. Pour $n$ points, le polynôme de la **base de Lagrange** pour la position $j$ est :

$$L_j(x) = \prod_{\substack{m=0 \\\ m \neq j}}^{n-1} \frac{x - m}{j - m}$$

$L_j(j) = 1$ et $L_j(m) = 0$ pour tout $m \neq j$. Le polynôme complet est leur somme pondérée :

$$P(x) = \sum_{i=0}^{n-1} v_i L_i(x)$$

Par exemple, avec 4 points, le polynôme de base pour la position 0 est :

$$L_0(x) = \frac{(x-1)(x-2)(x-3)}{(0-1)(0-2)(0-3)}$$

Il vaut 1 quand $x = 0$ et 0 pour $x = 1, 2, 3$. Le polynôme complet $P(x) = v_0 L_0(x) + v_1 L_1(x) + v_2 L_2(x) + v_3 L_3(x)$ passe par les quatre valeurs.

</details>

Jusqu'ici, c'est de l'algèbre pure. On a un polynôme qui encode les enfants, mais partager $P$ directement signifierait transmettre les 256 coefficients, pas mieux qu'envoyer les enfants eux-mêmes. Il faut un moyen de comprimer $P$ en un engagement court. C'est là qu'interviennent les courbes elliptiques.

## Un point de courbe pour un polynôme entier

Petit avertissement : toute l'arithmétique à partir d'ici (les coefficients du polynôme, ses évaluations, les scalaires de la courbe elliptique) se fait dans le même [**corps fini**](@/blog/math-behind-private-key.fr.md) $\mathbb{F}_p$.

Supposons qu'il existe un scalaire secret $s$ que personne ne connaît, mais que tout le monde ait accès aux **paramètres publics** suivants :

$$G, \ sG, \ s^2G, \ \ldots, \ s^dG$$

La façon dont $s$ est généré et détruit est traitée dans l'[Annexe](#trusted-setup). Pour l'instant, considérons ces points comme donnés. Pour engager $P(x)$, le prouveur calcule :

$$\begin{aligned}
C &= a_0 \cdot G + a_1 \cdot sG + \cdots + a_d \cdot s^dG \\\\
  &= P(s) \cdot G
\end{aligned}$$

Le prouveur n'a pas besoin de connaître $s$ pour calculer $C$ : il combine simplement les coefficients de son polynôme avec les paramètres publics.[^3]

Le résultat est un seul point de courbe (48 octets compressés) qui engage le polynôme entier. De la même manière qu'un hash résistant aux collisions ne produit pas la même sortie pour deux entrées différentes, cet engagement est **liant** : deux polynômes distincts $P \neq Q$ vérifient $P(s) \neq Q(s)$ avec une probabilité écrasante, donc leurs engagements $C = P(s) \cdot G$ sont distincts.[^4]

Chaque noeud Verkle stocke désormais ce $C$ au lieu d'un hash. On a l'engagement ; il faut maintenant un moyen de prouver ce qu'il contient.

## Preuves d'ouverture : prouver une seule valeur

Alice veut **ouvrir** l'engagement $C$ en position $z$ pour vérifier qu'il contient la valeur $y$. Le prouveur doit la convaincre que $P(z) = y$ sans révéler $P$ ni aucun autre enfant. Comment ?

Le point essentiel vient de l'algèbre des polynômes : si $P(z) = y$, alors $P(x) - y$ a une racine en $x = z$, donc $(x - z)$ le divise exactement. On définit le **polynôme quotient** :

$$Q(x) = \frac{P(x) - y}{x - z}$$

Cette division est exacte si et seulement si $P(z) = y$. Une affirmation fausse laisse un reste, et le prouveur ne peut pas produire un $Q$ valide.

La **preuve d'ouverture** $\pi$ est simplement un engagement sur $Q$ :

$$\pi = Q(s) \cdot G$$

Un seul point de courbe. Pas besoin de noeuds frères.

Le vérificateur doit maintenant s'assurer que $Q$ est légitime. Si la division est exacte, en remultipliant on obtient une identité polynomiale vraie en tout point, y compris $x = s$ :

$$P(s) - y = Q(s) \cdot (s - z) \tag{1}$$

Le vérificateur ne peut pas vérifier cette équation directement. Il dispose de $C = P(s) \cdot G$ et $\pi = Q(s) \cdot G$, mais les points de courbe **masquent** leurs scalaires : extraire $P(s)$ ou $Q(s)$ à partir de ces points est le [problème du logarithme discret](@/blog/math-behind-private-key.fr.md). Et $(s - z)$ nécessite de connaître $s$, que personne ne possède.

## Vérification de la preuve par couplage

Un **couplage** $e$ est une fonction qui prend un point d'un groupe de courbe ($\mathbb{G}_1$) et un point d'un autre ($\mathbb{G}_2$) et produit un élément dans un groupe cible, avec la propriété de **bilinéarité** :

$$e(aG_1, bG_2) = e(G_1, G_2)^{ab}$$

On donne en entrée un point masquant un scalaire $a$ et un autre masquant $b$, et la sortie capture leur produit. On ne peut pas extraire $a$ ou $b$, mais on peut vérifier si **deux produits sont égaux** en comparant les sorties des couplages.[^5] Les couplages nécessitent deux groupes de courbe distincts ; le $G$ que l'on a utilisé vit dans $\mathbb{G}_1$ (devenant $G_1$), et $G_2$ est un générateur de $\mathbb{G}_2$. Les paramètres publics incluent également $sG_2$.

La stratégie : exprimer chaque côté de l'équation $(1)$ comme un produit de deux scalaires, puis placer un facteur dans $\mathbb{G}_1$ et l'autre dans $\mathbb{G}_2$. Le côté droit se factorise naturellement en $Q(s) \cdot (s - z)$. Le côté gauche est simplement $(P(s) - y) \cdot 1$, donc on le couple avec le générateur $G_2$ :

**Côté gauche** : $(P(s) - y)G_1 = C - yG_1$, donc

$$e(C - yG_1, G_2) = e(G_1, G_2)^{P(s) - y}$$

**Côté droit** : $Q(s) \cdot G_1 = \pi$ et $(s - z)G_2 = sG_2 - zG_2$, donc

$$e(\pi, sG_2 - zG_2) = e(G_1, G_2)^{Q(s)(s-z)} $$

Ces deux membres sont égaux si et seulement si l'équation $(1)$ est vérifiée, donc la vérification se réduit à un seul test :

$$e(C - yG_1, G_2) = e(\pi, sG_2 - zG_2) \tag{2}$$

Le vérificateur connaît chaque variable de cette équation : $C$ et $\pi$ proviennent du prouveur, $y$ et $z$ sont la valeur annoncée et la position, et $G_1$, $G_2$, $sG_2$ sont des paramètres publics. Un seul couplage, pas de noeuds frères.

## Vue d'ensemble

Prenons du recul et considérons ce que l'on vient de construire. Un noeud avec 256 enfants est encodé en un polynôme et condensé en un seul point de courbe. Pour ouvrir un enfant, le prouveur divise par la racine correspondante pour obtenir un polynôme quotient, et le condense en un second point de courbe. Un couplage traverse alors les deux groupes de courbes et, par bilinéarité, vérifie que la division est exacte à partir des seuls points de courbe. Deux points, une vérification, terminé. On a presque l'impression d'avoir percé un secret de l'univers.

Ce schéma engagement-ouverture-vérification s'appelle **[KZG](https://en.wikipedia.org/wiki/Commitment_scheme#KZG_commitment)** (Kate-Zaverucha-Goldberg) : un engagement par noeud, une preuve d'ouverture par niveau. Un arbre de Merkle de largeur 16 nécessite ~8-10 niveaux et 15 hashs de noeuds frères (480 octets) à chacun. Un arbre Verkle de largeur 256 couvre le même état en seulement ~3 niveaux,[^6] avec une seule preuve d'environ 48 octets à chacun :

<img src="/img/merkle-vs-verkle-comparison.webp" alt="Comparaison côte à côte de la structure de preuve Merkle vs Verkle : Merkle nécessite 15 hashs de noeuds frères par niveau tandis que Verkle ne nécessite qu'une preuve par niveau, résultant en des preuves ~20× plus petites">

<details>
<summary>Exemple pas à pas</summary>

Alice veut vérifier son solde en ETH. Son adresse hashée donne les positions $k_0, k_1, k_2$ qui tracent un chemin : racine $\to$ $C_1$ $\to$ $C_2$ $\to$ feuille $v$. Le prouveur envoie à Alice la valeur de la feuille $v$, les engagements intermédiaires $C_1$ et $C_2$, et une preuve d'ouverture $\pi_i$ à chaque niveau. Alice vérifie de bas en haut :

1. $C_2$ ouvre-t-il en position $k_2$ sur la valeur $v$ ? Vérifier $\pi_2$.
2. $C_1$ ouvre-t-il en position $k_1$ sur $C_2$ ?[^7] Vérifier $\pi_1$.
3. $C_0$ ouvre-t-il en position $k_0$ sur $C_1$ ? Vérifier $\pi_0$.
4. $C_0$ correspond-il au state root dans le block header ? Terminé.

Trois preuves d'ouverture (~48 octets chacune), environ 150 octets au total.

</details>

Les engagements polynomiaux **suppriment aussi un compromis auquel les arbres de Merkle étaient confrontés.** Dans un arbre de Merkle, réduire la largeur donne des preuves plus petites (moins de frères par niveau), mais un arbre plus profond implique davantage de lectures disque aléatoires par recherche (le goulot d'étranglement de l'[annexe de la Partie 1](@/blog/ethereum-merkle-patricia-trie.fr.md#annexe)). Puisque la taille des preuves Verkle ne croît pas avec la largeur, on peut rendre les noeuds larges et l'arbre peu profond : des preuves compactes *et* un accès disque rapide.

## La proposition Verkle d'Ethereum : IPA

Les chiffres ci-dessus reflètent les tailles de preuves KZG. La [proposition de Verkle tree d'Ethereum](https://notes.ethereum.org/@vbuterin/verkle_tree_eip) a opté pour d'autres briques : un engagement **Pedersen**, une technique de preuve **IPA**, et une courbe **Bandersnatch**. L'architecture est la même ; les preuves individuelles sont plus volumineuses (~544 octets) et la vérification plus lente, mais le compromis en valait la peine : pas de cérémonie de confiance. Si le secret $s$ d'une cérémonie KZG était un jour reconstitué, l'ensemble du schéma s'effondrerait. Pour un state tree sécurisant toute la valeur d'Ethereum, la communauté a préféré éliminer entièrement ce risque.

Au niveau des blocs, le [schéma multiproof](https://dankradfeist.de/ethereum/2021/06/18/pcs-multiproofs.html) de Dankrad Feist fusionne toutes les preuves d'ouverture d'un bloc en une seule preuve de taille constante (~200 octets), quel que soit le nombre d'accès à l'état dans le bloc.

## Et ensuite

Les Verkle trees semblent désormais peu susceptibles d'être intégrés à Ethereum ([EIP-7864](https://eips.ethereum.org/EIPS/eip-7864)) : leur dépendance à la cryptographie sur courbes elliptiques ne résiste pas aux attaques quantiques, et la communauté s'oriente plutôt vers des alternatives basées sur les fonctions de hachage. Les idées qu'on a construites ici, cependant (engager des données avec des polynômes, prouver des propriétés sans tout révéler), sont fondamentales pour quelque chose de plus grand : les **preuves à connaissance nulle**. Elles permettent de prouver non seulement l'accès à l'état, mais que l'exécution d'un bloc entier est correcte, le tout en une seule preuve compacte. Des preuves plus petites ne résolvent pas tout (par exemple, quelqu'un doit toujours stocker l'état, qui ne cesse de croître, pour construire les blocs), mais de plus en plus, l'objectif est de prouver davantage et stocker moins.

La cryptographie derrière les preuves à connaissance nulle, des circuits arithmétiques aux différences entre systèmes de preuve, est un sujet que j'explorerai bientôt sur ce blog. À suivre.

---

## Annexe

<a id="trusted-setup"></a>

<details>
<summary>La cérémonie de confiance (Trusted Setup)</summary>

Les engagements KZG nécessitent des paramètres publics : les points de courbe $G, sG, s^2G, \ldots, s^dG$. Le secret $s$ doit être détruit après sa génération. Comment détruire un nombre que personne ne devrait jamais connaître ?

La cérémonie utilise un **calcul multipartite**. Les participants contribuent de l'aléa séquentiellement :

1. Le participant 1 choisit un $s_1$ aléatoire, calcule $s_1^i G$ pour chaque puissance $i$, publie le résultat, et détruit $s_1$.
2. Le participant 2 choisit $s_2$, « re-randomise » la sortie précédente pour produire $(s_1 s_2)^i G$, et détruit $s_2$.
3. Cela continue pour tous les participants.

La sortie finale est $(s_1 s_2 \cdots s_n)^i G$. Le secret combiné $s = s_1 s_2 \cdots s_n$ est sûr tant qu'**au moins un participant** a honnêtement détruit sa contribution. Même si tous les autres participants sont malveillants, un seul participant honnête suffit.

Ethereum a organisé exactement ce type de cérémonie pour [EIP-4844](https://eips.ethereum.org/EIPS/eip-4844) (proto-danksharding) début 2023. Plus de 140 000 participants ont contribué, ce qui en fait la plus grande cérémonie de confiance jamais réalisée. Les paramètres obtenus sont utilisés aujourd'hui pour les engagements de blobs sur Ethereum.

</details>

---

[^1]: Le nom et la construction ont été introduits par John Kuszmaul dans [Verkle Trees](https://math.mit.edu/research/highschool/primes/materials/2018/Kuszmaul.pdf) (2018).

[^2]: Existence : l'interpolation de Lagrange construit $P$ directement. Unicité : supposons que $P$ et $Q$ passent tous deux par les mêmes $n$ points. Alors $D = P - Q$ s'annule aux $n$ points, mais $D$ est de degré au plus $n-1$, donc a au plus $n-1$ racines. Contradiction, sauf si $D = 0$, c'est-à-dire $P = Q$. Voir [interpolation polynomiale](https://en.wikipedia.org/wiki/Polynomial_interpolation) (théorème d'unisolvence).

[^3]: Cela fonctionne parce que la multiplication scalaire se distribue sur l'addition des points : $a_0 \cdot G + a_1 \cdot sG = (a_0 + a_1 s)G$. L'application $f(a) = aG$ est un homomorphisme de groupes des scalaires vers les points de courbe.

[^4]: Si $P \neq Q$, alors $D = P - Q$ est un polynôme non nul de degré au plus $d$, il a donc au plus $d$ racines dans $\mathbb{F}_p$. Pour que les engagements coïncident, $s$ devrait être l'une de ces $\leq d$ valeurs parmi $p$ au total. Cette probabilité est au plus $d/p$, ce qui est négligeable puisque $p \sim 2^{255}$ et $d = 255$.

[^5]: Les courbes compatibles avec les couplages possèdent une structure spéciale qui le permet. Toutes les courbes elliptiques ne supportent pas les couplages. BLS12-381, utilisée aujourd'hui dans Ethereum, a été conçue spécifiquement pour des couplages efficaces.

[^7]: Les évaluations polynomiales doivent être des scalaires, mais $C_2$ et $C_1$ sont des points de courbe. Les noeuds de branchement gèrent cela en convertissant chaque engagement enfant en un élément du corps (par exemple, sa coordonnée x sérialisée) avant d'interpoler le polynôme. La même chose s'applique à l'étape 3.

[^6]: Avec 256 enfants par noeud, $256^3 \approx 16,7$ millions et $256^4 \approx 4,3$ milliards. Ethereum compte environ 250 millions de comptes plus les slots de stockage des contrats, donc une profondeur de 3-4 couvre l'état actuel.
