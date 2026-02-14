+++
title = "Verkle Trees : Engagements Polynomiaux (Partie 2/2)"
date = 2026-02-13
description = "Comment un seul point de courbe peut engager 256 enfants, et pourquoi les preuves passent de kilo-octets à octets"

[taxonomies]
tags = ["crypto", "computer-science"]

[extra]
katex = true
social_media_card = "/img/verkle-tree-banner.webp"
+++

![Verkle tree : des courbes polynomiales lisses convergent depuis de nombreux noeuds feuilles vers un seul point d'engagement lumineux](/img/verkle-tree-banner.webp)

La [Partie 1](@/blog/ethereum-merkle-patricia-trie.fr.md) s'est terminée sur un problème : les preuves de Merkle dans le state trie d'Ethereum sont trop volumineuses pour la validation sans état. À plusieurs Mo par bloc, le coût en bande passante de l'inclusion des preuves dans les blocs pousserait les validateurs individuels vers les data centers.

Une solution consiste à remplacer les engagements par hachage par des **engagements polynomiaux** : chaque noeud stocke un point de courbe au lieu d'un hash. La différence se manifeste dans les preuves : au lieu de fournir tous les hashs des noeuds frères (~3 Ko), le prouveur envoie une seule petite preuve (~150 octets), environ 20× plus compacte. À la fin de cet article, vous comprendrez comment.

## Pourquoi les engagements polynomiaux ?

Dans un arbre de Merkle, chaque noeud engage ses enfants en les hachant ensemble :

$$H = \text{hash}(\text{child}\_{0}, \text{child}\_{1}, \ldots, \text{child}\_{15})$$

Pour vérifier qu'un enfant appartient bien au noeud, on recalcule $H$ depuis zéro, ce qui signifie qu'il faut disposer de tous les frères. En cryptographie, c'est ce qu'on appelle **ouvrir** un engagement : révéler une valeur et prouver qu'elle correspond. Avec les hashs, ouvrir un enfant exige de fournir tous les autres : 15 hashs de noeuds frères par niveau, sur ~8-10 niveaux de la valeur jusqu'à la racine.

Et si on disposait d'un schéma d'engagement dans lequel :

1. L'engagement lui-même reste compact (comparable à un hash)
2. La preuve pour un seul enfant en position $i$ est beaucoup plus petite que l'ensemble des frères
3. La taille de la preuve ne croît pas avec le nombre d'enfants

On pourrait alors élargir les noeuds bien au-delà de 16, disons à 256, obtenant un arbre moins profond avec moins de niveaux à prouver :

$$C \leftarrow \text{commit}(v\_0, v\_1, \ldots, v\_{255})$$

Le vérificateur contrôle une petite preuve $\pi_i$ par rapport à $C$ sans voir aucun autre enfant. C'est un **engagement vectoriel**, et c'est de là que vient le « V » de Verkle : **V**ector commitment + M**erkle**.[^1] Même structure d'arbre, mais un engagement différent à chaque noeud.

Quand j'ai découvert cette idée pour la première fois, cela m'a semblé magique : comment un seul point peut-il engager 256 valeurs *et* permettre de prouver n'importe laquelle sans avoir besoin des autres ? La réponse tient aux polynômes. Voyons comment.

## Des valeurs à un polynôme

L'idée est de représenter les 256 enfants comme les évaluations d'un seul polynôme. Un polynôme se présente ainsi :

$$P(x) = a_0 + a_1 x + a_2 x^2 + \cdots + a_{255} x^{255}$$

On choisit les positions $0, 1, \ldots, 255$ et on détermine les coefficients $a_0, \ldots, a_{255}$ de sorte que :

$$P(i) = v_i \quad \text{pour } i = 0, 1, \ldots, 255$$

On obtient un polynôme de degré 255 qui passe par chaque valeur enfant. Un tel polynôme existe toujours et est unique : $n$ paires point-valeur déterminent exactement un polynôme de degré $n - 1$.[^2] L'algorithme qui trouve ce polynôme s'appelle l'**interpolation de Lagrange**.

<details>
<summary>Comment fonctionne l'interpolation de Lagrange</summary>

L'idée : construire des polynômes « sélecteurs » qui valent 1 en un point et 0 en tous les autres, puis les pondérer par les valeurs souhaitées. Pour $n$ points, le polynôme de base pour la position $j$ est :

$$L_j(x) = \prod_{\substack{m=0 \\\ m \neq j}}^{n-1} \frac{x - m}{j - m}$$

$L_j(j) = 1$ et $L_j(m) = 0$ pour tout $m \neq j$. Le polynôme complet est leur somme pondérée :

$$P(x) = \sum_{i=0}^{n-1} v_i L_i(x)$$

Par exemple, avec 4 points, le sélecteur pour la position 0 est :

$$L_0(x) = \frac{(x-1)(x-2)(x-3)}{(0-1)(0-2)(0-3)}$$

Il vaut 1 quand $x = 0$ et 0 pour $x = 1, 2, 3$. Le polynôme complet $P(x) = v_0 L_0(x) + v_1 L_1(x) + v_2 L_2(x) + v_3 L_3(x)$ passe par les quatre valeurs.

</details>

Jusqu'ici, c'est de l'algèbre pure. On a un polynôme qui encode les enfants (les données du compte d'Alice se trouvent à une certaine position, disons $P(3) = v_{\text{Alice}}$), mais partager $P$ directement signifierait transmettre les 256 coefficients, pas mieux qu'envoyer les enfants eux-mêmes. Il faut un moyen de comprimer $P$ en un engagement court. C'est là qu'interviennent les courbes elliptiques.

## Un point de courbe pour un polynôme entier

Toute l'arithmétique à partir d'ici (les coefficients du polynôme, ses évaluations, les scalaires de la courbe elliptique) se fait dans le même [**corps fini**](@/blog/math-behind-private-key.fr.md) $\mathbb{F}_p$.

Supposons qu'il existe un scalaire secret $s$ que personne ne connaît, mais que tout le monde ait accès aux points de courbe publics suivants :

$$G, \ sG, \ s^2G, \ \ldots, \ s^dG$$

La façon dont $s$ est généré et détruit est traitée dans l'[Annexe](#trusted-setup). Pour l'instant, considérons ces points comme donnés. Pour engager $P(x)$, le prouveur calcule :

$$C = a_0 \cdot G + a_1 \cdot sG + \cdots + a_d \cdot s^dG = P(s) \cdot G$$

Le prouveur ne connaît pas $s$ ; il combine simplement les coefficients de son polynôme avec les points publics.[^3] Le résultat est un seul point de courbe (48 octets compressés sur BLS12-381) qui engage le polynôme entier. Il est **liant** (l'analogue de la résistance aux collisions pour les schémas d'engagement) : deux polynômes distincts $P \neq Q$ vérifient $P(s) \neq Q(s)$ avec une probabilité écrasante.[^4]

Le noeud Verkle stocke désormais $C = P(s) \cdot G$ au lieu d'un hash keccak256 de ses enfants. Mais comment prouver un seul enfant sans révéler les autres ?

## Preuves d'ouverture : prouver une seule valeur

Les données d'Alice se trouvent en position $z$ dans le noeud. Puisque les enfants sont encodés comme des évaluations du polynôme, prouver que l'enfant en position $z$ a la valeur $y$ revient à prouver $P(z) = y$. Le vérificateur possède l'engagement $C$ mais ne connaît ni $P$ ni aucun autre enfant. Comment le prouveur le convainc-t-il ?

Le point essentiel vient de l'algèbre des polynômes : si $P(z) = y$, alors $P(x) - y$ a une racine en $x = z$, donc $(x - z)$ le divise exactement. On définit le **polynôme quotient** :

$$Q(x) = \frac{P(x) - y}{x - z}$$

$Q$ est un polynôme valide si et seulement si $P(z) = y$. Une affirmation fausse laisse un reste, et le prouveur ne peut pas produire un $Q$ valide.

**La preuve est simplement un engagement sur $Q$ au lieu de $P$ :**

$$\pi = Q(s) \cdot G$$

Ce seul point de courbe $\pi$ est la **preuve d'ouverture**. Pas besoin de noeuds frères.

Le vérificateur doit maintenant s'assurer que $Q$ est légitime. Si la division est exacte, alors $P(x) - y = Q(x) \cdot (x - z)$ est une identité polynomiale, donc elle est vraie en tout point, y compris $x = s$ :

$$P(s) - y = Q(s) \cdot (s - z)$$

Le vérificateur dispose de deux points de courbe : $C = P(s) \cdot G$ et $\pi = Q(s) \cdot G$. Ceux-ci masquent respectivement $P(s)$ et $Q(s)$ : déduire les scalaires à partir des points est le [problème du logarithme discret](@/blog/math-behind-private-key.fr.md). Et $(s - z)$ nécessite de connaître $s$, que personne ne possède.

## Vérification de la preuve par couplage

Un **couplage** $e$ est une fonction qui prend un point d'un groupe de courbe ($\mathbb{G}_1$) et un point d'un autre ($\mathbb{G}_2$) et produit un élément dans un groupe cible, avec la propriété de **bilinéarité** :

$$e(aG_1, bG_2) = e(G_1, G_2)^{ab}$$

On donne en entrée un point masquant $a$ et un point masquant $b$, et la sortie capture leur produit. On ne peut pas extraire $a$ ou $b$, mais on peut vérifier si deux produits sont égaux en comparant les sorties des couplages.[^5] Les couplages nécessitent deux groupes de courbe distincts ; le $G$ que nous avons utilisé vit dans $\mathbb{G}_1$ (devenant $G_1$), et $G_2$ est un générateur de $\mathbb{G}_2$. Les paramètres publics incluent également $sG_2$.

La stratégie : placer le côté gauche de notre équation, $P(s) - y$, dans un couplage, et les deux facteurs du côté droit, $Q(s)$ et $(s - z)$, dans l'autre.

Pour le côté gauche : $(P(s) - y)G_1 = C - yG_1$, donc

$$e(C - yG_1, G_2) = e(G_1, G_2)^{P(s) - y}$$

Pour le côté droit : $Q(s) \cdot G_1 = \pi$ et $(s - z)G_2 = sG_2 - zG_2$, donc

$$e(\pi, sG_2 - zG_2) = e(G_1, G_2)^{Q(s)(s-z)} $$

Les deux sont égaux si et seulement si $P(s) - y = Q(s)(s - z)$, ce qui est exactement ce qu'on voulait prouver. L'**équation de vérification** :

$$e(C - yG_1, G_2) = e(\pi, sG_2 - zG_2)$$

Le vérificateur connaît chaque variable de cette équation : $C$ et $\pi$ proviennent du prouveur, $y$ et $z$ sont la valeur annoncée et la position, et $G_1$, $G_2$, $sG_2$ sont des paramètres publics. Un seul couplage, pas de noeuds frères.

## Preuve Verkle pas à pas

Suivons une preuve complète à travers l'arbre. Alice veut vérifier son solde en ETH. Un arbre Verkle a une largeur de 256 et une profondeur d'environ 3 pour l'état d'Ethereum.[^6] Son adresse hashée correspond à un chemin : racine → $C_1$ → $C_2$ → feuille $v$. Le prouveur envoie à Alice la valeur de la feuille $v$, les engagements intermédiaires $C_1$ et $C_2$, et une preuve d'ouverture $\pi_i$ à chaque niveau. Alice vérifie de bas en haut :

1. $C_2$ ouvre-t-il en position $k_2$ sur la valeur $v$ ? Vérifier $\pi_2$.
2. $C_1$ ouvre-t-il en position $k_1$ sur $C_2$ ?[^7] Vérifier $\pi_1$.
3. $C_0$ ouvre-t-il en position $k_0$ sur $C_1$ ? Vérifier $\pi_0$.
4. $C_0$ correspond-il au state root dans le block header ? Terminé.

Trois vérifications de couplage, trois points de courbe (~48 octets chacun), environ 150 octets au total. À comparer avec 15 hashs de noeuds frères à 32 octets chacun (480 octets) par niveau dans un arbre de Merkle. Ce schéma engagement-ouverture-vérification s'appelle **[KZG](https://en.wikipedia.org/wiki/Commitment_scheme#KZG_commitment)** (Kate-Zaverucha-Goldberg). Ethereum utilise une variante appelée IPA (détaillée ci-dessous), mais l'architecture est la même : un engagement par noeud, une preuve par niveau. En chiffres :

<img src="/img/merkle-vs-verkle-comparison.webp" alt="Comparaison côte à côte de la structure de preuve Merkle vs Verkle : Merkle nécessite 15 hashs de noeuds frères par niveau tandis que Verkle ne nécessite qu'une preuve par niveau, résultant en des preuves ~20× plus petites">

Les engagements polynomiaux **suppriment aussi un compromis auquel les arbres de Merkle étaient confrontés.** Dans un arbre de Merkle, un arbre plus étroit signifie des preuves plus petites (moins de frères par niveau), mais un arbre plus profond implique davantage de lectures disque aléatoires par recherche (le goulot d'étranglement de l'[annexe de la Partie 1](@/blog/ethereum-merkle-patricia-trie.fr.md#annexe)). La taille des preuves Verkle ne croît pas avec la largeur, donc il n'y a pas de raison de garder les arbres étroits. Avec 256 enfants par noeud, l'arbre est suffisamment peu profond pour que les recherches ne touchent que 3-4 niveaux : des preuves compactes *et* un accès disque rapide.

## La proposition Verkle d'Ethereum : IPA

Les chiffres ci-dessus reflètent les tailles de preuves KZG. La [proposition de Verkle tree d'Ethereum](https://notes.ethereum.org/@vbuterin/verkle_tree_eip) utilise un schéma différent : des **engagements de Pedersen** ouverts avec **IPA** (Inner Product Arguments) sur la courbe **Bandersnatch**. Les preuves individuelles sont plus volumineuses (~544 octets), et la vérification est plus lente (logarithmique par rapport au nombre d'enfants, contre constante). Le compromis : pas de cérémonie de confiance. Si le secret $s$ d'une cérémonie KZG était un jour reconstitué, l'ensemble du schéma s'effondre. Pour le state tree, qui sécurise toute la valeur d'Ethereum de manière permanente, la communauté a préféré éliminer entièrement cette hypothèse. Au niveau des blocs, le [schéma multiproof](https://dankradfeist.de/ethereum/2021/06/18/pcs-multiproofs.html) de Dankrad Feist fusionne toutes les preuves d'ouverture en une seule preuve de taille constante, ramenant la surcharge par bloc dans la fourchette de ~100-200 Ko.

## Et ensuite

Au moment où j'écris, la question de savoir si les Verkle trees seront intégrés à Ethereum reste [ouverte](https://eips.ethereum.org/EIPS/eip-6800). Quoi qu'il en soit, les idées que nous avons construites ici (engager des données avec des polynômes, prouver des propriétés sans tout révéler) sont fondamentales pour quelque chose de plus grand : les **preuves à connaissance nulle**. Elles permettent de prouver non seulement l'accès à l'état, mais que l'exécution d'un bloc entier est correcte en une seule preuve compacte. Des preuves plus petites ne résolvent pas tout (par exemple, quelqu'un doit toujours stocker l'état en croissance permanente pour construire les blocs), mais la direction est claire : prouver plus, stocker moins.

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
