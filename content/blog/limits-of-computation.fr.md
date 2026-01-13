+++
title = "Les limites du calcul (Partie 3/3)"
date = 2026-01-11
description = "Ce que les machines de Turing ne peuvent pas faire, et pourquoi c'est important"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

Dans la [Partie 2](@/blog/turing-completeness.md), nous avons établi que la Turing-complétude est le plafond de la puissance de calcul. Tout formalisme raisonnable pour le « calcul » s'avère équivalent. On ne peut pas construire quelque chose de plus puissant qu'une machine de Turing.

Mais les machines de Turing peuvent-elles résoudre *tout* ?

Non. Et la preuve est d'une élégance surprenante. Elle nous conduira aussi, presque immédiatement, à l'un des résultats les plus célèbres des mathématiques : le théorème d'incomplétude de Gödel.

## Le problème de l'arrêt

Voici une question simple : étant donné un programme, finira-t-il un jour son exécution ?
Dans notre formalisme de la [Partie 1](@/blog/turing-machines.md), un « programme » est un encodage $\langle M, w \rangle$ : une machine de Turing $M$ accompagnée de son entrée $w$, écrite comme donnée sur un ruban. La question de l'arrêt est donc : $M$ s'arrête-t-elle sur $w$ ?

Imaginons un *Décideur d'arrêt*, $H$. On lui soumet notre code et il nous dit « ceci termine (s'arrête) » ou « ceci boucle indéfiniment ». S'il existait, on pourrait l'utiliser sur n'importe quel programme pour détecter les boucles infinies avant déploiement, vérifier qu'un logiciel critique retourne toujours une réponse, garantir qu'une fonction récursive ne récursera pas éternellement. Incroyablement utile.

Le **problème de l'arrêt** demande : peut-on construire un tel $H$ ? Non pas pour un programme spécifique, mais une procédure générale qui répond correctement pour *tous* les $\langle M, w \rangle$.

Turing a prouvé qu'une telle procédure ne peut pas exister.

## Intuition

Il est utile de remarquer que les réponses « oui » et « non » à la question de l'arrêt sont fondamentalement différentes.

Pour les réponses « oui », il suffit d'exécuter le programme assez longtemps. S'il s'arrête après une semaine, on peut dire avec confiance « oui, il s'arrête ».

Les réponses « non » sont différentes. Supposons qu'on exécute un programme depuis mille ans et qu'il ne se soit toujours pas arrêté. Peut-on dire « non, il ne s'arrêtera jamais » ? On ne peut pas. Peut-être qu'il s'arrêtera dans mille et un ans. À aucun moment l'exécution du programme ne nous autorise à dire « non ».

Cette asymétrie laisse entrevoir l'impossibilité. Prouvons-la maintenant.

## L'argument diagonal

Supposons, par l'absurde, que nous ayons une procédure $H$ qui résout le problème de l'arrêt. Étant donné n'importe quel programme $P$ et une entrée, $H$ nous dit correctement si $P$ s'arrête.

Je vais maintenant utiliser $H$ comme sous-routine pour construire un nouveau programme. Appelons-le $Q$. Le programme $Q$ prend un autre programme $P$ en entrée et fait ce qui suit :

1. Demander à $H$ : « Est-ce que $P$ s'arrêterait si on l'exécutait sur $P$ lui-même ? »
2. Si $H$ dit « oui, $P$ s'arrête sur $P$ » → $Q$ boucle indéfiniment
3. Si $H$ dit « non, $P$ ne s'arrête pas sur $P$ » → $Q$ s'arrête immédiatement

C'est tout. $Q$ demande si $P$ s'arrête sur lui-même, puis fait le *contraire*.

L'étape 1 est la partie diagonale : on donne à $P$ sa propre description en entrée. C'est la même astuce autoréférentielle derrière le paradoxe de Russell et l'argument diagonal de Cantor que nous avons explorés dans [Quatre preuves par diagonalisation](@/blog/four-proofs-by-diagonalization.md).

Vient maintenant le coup de grâce. $Q$ est un programme. Que se passe-t-il si on exécute $Q$ sur *lui-même* ?

- Si $Q$ s'arrête sur $Q$, alors $H$ doit avoir dit « $Q$ s'arrête sur $Q$ », donc par l'étape 2, $Q$ boucle indéfiniment. Contradiction.
- Si $Q$ ne s'arrête pas sur $Q$, alors $H$ doit avoir dit « $Q$ ne s'arrête pas sur $Q$ », donc par l'étape 3, $Q$ s'arrête. Contradiction.

$Q$ s'arrête sur $Q$ si et seulement si $Q$ ne s'arrête pas sur $Q$. C'est impossible. Donc $H$ ne peut pas exister.

Le problème de l'arrêt est **indécidable**. $\blacksquare$

## Pourquoi c'est important

Que signifie « indécidable » ? **Un problème est décidable s'il existe une procédure qui s'arrête toujours et donne toujours la bonne réponse oui/non.** Le problème de l'arrêt est indécidable : aucune telle procédure n'existe. Pour tout prétendu décideur d'arrêt, il existe un programme sur lequel il se trompe (ou boucle indéfiniment).

Le problème de l'arrêt peut sembler être un cas limite artificiel. Mais ce n'est que la partie visible de l'iceberg. Le [théorème de Rice](https://en.wikipedia.org/wiki/Rice%27s_theorem), prouvé en 1953 par Henry Gordon Rice, l'a généralisé : *toute* propriété non triviale de ce que calcule un programme est indécidable. Vous voulez savoir si un programme produit un jour une valeur spécifique ? Indécidable. S'il accède un jour au réseau ? Indécidable. S'il contient une vulnérabilité de sécurité ? Indécidable.

Cela explique pourquoi les outils d'analyse statique produisent parfois des faux positifs, pourquoi les compilateurs ne peuvent pas toujours éliminer le code mort, et pourquoi les logiciels antivirus ne peuvent pas détecter tous les malwares. L'analyse parfaite des programmes est mathématiquement impossible.

## Le théorème d'incomplétude de Gödel

Le problème de l'arrêt prouve immédiatement l'un des résultats les plus célèbres des mathématiques.

Au début du XXe siècle, David Hilbert a proposé un objectif ambitieux : trouver un ensemble fini d'axiomes à partir duquel toute affirmation vraie sur les nombres pourrait être dérivée mécaniquement. Partir d'axiomes de base comme « $0$ est un nombre » et « $x + 0 = x$ », ajouter des règles d'inférence, et en principe on pourrait prouver n'importe quelle affirmation arithmétique vraie.

Ici, il faut distinguer deux concepts :
- Une affirmation est **vraie** si elle décrit fidèlement les nombres tels qu'ils sont (par exemple, « il n'existe pas de plus grand nombre premier »)
- Une affirmation est **démontrable** si elle peut être dérivée des axiomes via les règles d'inférence

Ce n'est pas évidemment la même chose. La vérité concerne ce qui est effectivement le cas ; la démontrabilité concerne ce qui découle de vos hypothèses de départ. Le rêve de Hilbert, appelé le **programme de Hilbert**, était de les faire coïncider pour l'arithmétique : toute affirmation vraie devrait être démontrable, et toute affirmation démontrable devrait être vraie.[^1]

Si un tel système existait, on pourrait construire une machine à prouver des théorèmes : partir des axiomes, appliquer les règles d'inférence de toutes les manières possibles, et produire chaque théorème au fur et à mesure qu'on le dérive.[^2] $1 + 1 = 2$. Tout nombre premier en a un plus grand. Une par une, toutes les affirmations vraies sur les nombres.

Voici l'observation clé : **une telle machine résoudrait le problème de l'arrêt.** Savoir si un programme s'arrête est une question sur des séquences finies de transitions d'états — exactement le genre de chose que l'arithmétique peut exprimer. Si le système d'axiomes était complet, alors pour tout programme $M$ et entrée $w$, soit « $M$ s'arrête sur $w$ » soit « $M$ ne s'arrête pas sur $w$ » serait démontrable. La machine d'énumération finirait par trouver la preuve qui existe, et nous aurions notre réponse.

Mais nous avons déjà prouvé que le problème de l'arrêt est indécidable. Donc le système ne peut pas être complet.

> **Premier théorème d'incomplétude de Gödel** : Tout système axiomatique calculable[^3] capable d'exprimer l'arithmétique de base est incomplet. Il existe des affirmations vraies que le système ne peut pas prouver.

C'est la conclusion : **la vérité dépasse la démontrabilité.** Quels que soient les axiomes choisis, certaines affirmations seront *indépendantes* — ni prouvables ni réfutables au sein du système.

[^1]: La seconde moitié — toute affirmation démontrable est vraie — s'appelle la *correction*, et nous la voulons absolument. Un système incorrect prouve des choses fausses, ce qui est inutile. La première moitié — toute affirmation vraie est démontrable — s'appelle la *complétude*. Gödel a montré que la complétude est impossible.

[^2]: Pourquoi peut-on énumérer les théorèmes ? Une preuve est une séquence finie d'étapes, chacune découlant mécaniquement des axiomes ou des étapes précédentes. On énumère toutes les séquences finies, on vérifie la validité de chacune, on produit la conclusion des preuves valides. Toute affirmation démontrable finit par apparaître.
[^3]: Le système doit aussi être *consistant* : il ne prouve jamais à la fois $P$ et $\neg P$. Un système inconsistant peut prouver n'importe quoi (y compris des contradictions), rendant la « complétude » trivialement atteignable mais dénuée de sens.

## À retenir

Nous avons tracé une frontière entre ce qui est calculable et ce qui ne l'est pas. Dans la Partie 2, nous avons vu que la Turing-complétude est le plafond : on ne peut pas calculer plus qu'une machine de Turing. Mais maintenant nous avons vu que ce plafond a des trous. Certains problèmes n'ont pas de procédure qui s'arrête toujours avec la bonne réponse.

**À l'intérieur** : tout problème oui/non pour lequel on peut écrire une procédure qui termine. Ce nombre est-il premier ? La division par essais vous le dira. Combien font 347 × 892 ? La multiplication posée donne la réponse. Trier cette liste ? Le tri fusion termine avec le bon ordre. Ce sont des problèmes décidables : nous avons des procédures qui s'arrêtent toujours avec les bonnes réponses.

**À l'extérieur** : le problème de l'arrêt n'est que le début. Le théorème de Rice nous dit que *toute* question intéressante sur le comportement d'un programme est indécidable. Ce code contient-il un bug ? Accédera-t-il un jour au réseau ? Est-il équivalent à cet autre programme ? Aucun algorithme général ne peut répondre à ces questions pour **tous les programmes**. Et Gödel nous dit que le problème est plus profond : certaines affirmations vraies sur les nombres ne peuvent jamais être prouvées à partir d'un ensemble fini d'axiomes.

Cette frontière ne dépend pas de la technologie. Ordinateurs plus rapides, ordinateurs quantiques, quoi qu'il arrive ensuite : le problème de l'arrêt restera indécidable, et l'arithmétique restera incomplète. Il existe des vérités qu'aucune procédure mécanique ne peut découvrir. C'est un fait profond sur la nature même du calcul.

---

*Ce billet a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
