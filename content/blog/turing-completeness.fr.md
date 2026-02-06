+++
title = "Ce que signifie être Turing-complet (Partie 2/3)"
date = 2026-01-10
description = "Pourquoi les cerveaux et l'IA sont des « machines de Turing approximatives »"

[taxonomies]
tags = ["math", "computer-science"]

[extra]
katex = true
+++

Dans la [Partie 1](@/blog/turing-machines.md), nous avons construit les machines de Turing (MT) depuis zéro : un ruban, une tête de lecture/écriture, quelques états et transitions. Notre détecteur de palindromes avait peut-être une douzaine d'états.

La citation qui a lancé cette série était celle de Demis Hassabis [affirmant](https://x.com/demishassabis/status/2003097405026193809) que « le cerveau humain (et les modèles fondamentaux d'IA) sont des machines de Turing approximatives ». Mais Hassabis ne voulait sûrement pas dire que nos esprits sont comme de petits détecteurs de palindromes. Il faisait plutôt une affirmation sur la *puissance de calcul* : les cerveaux peuvent calculer tout ce qui est calculable, si on leur donne assez de temps (de calcul) et de mémoire. Le terme technique pour cette propriété est **Turing-complet**.

## La machine de Turing universelle

Dans la [Partie 1](@/blog/turing-machines.md), nous avons construit des machines individuelles pour chaque problème : une pour les palindromes, une pour compter les nombres pairs. Chacune était un dispositif fixe, câblé pour une seule tâche. Vous voulez vérifier si un nombre est premier ? Construisez une nouvelle machine. Vous voulez trier des nombres ? Construisez-en une autre.

Turing a posé la question : pourrait-on construire *une seule* machine qui fait le travail de toutes les autres ?

La réponse est oui. Une **machine de Turing universelle** (MTU) est une machine de Turing spécifique $U$ qui prend un encodage $\langle M, w \rangle$ d'une autre machine $M$ et d'une entrée $w$, puis simule $M$ s'exécutant sur $w$ :

$$U(\langle M, w \rangle) = M(w)$$

L'encodage n'est que des données sur le ruban : les états comme des nombres, la table de transitions comme une liste de règles, puis l'entrée $w$. La MTU lit cette description et l'exécute pas à pas, en suivant l'état de $M$, la position de la tête et le contenu du ruban sur son propre ruban.

C'est de là que vient le terme « programme ». La MTU n'a pas besoin d'être reconstruite pour chaque tâche ; il suffit de lui fournir un programme différent (c'est-à-dire un encodage). Votre ordinateur portable fonctionne de la même manière : le script Python que vous exécutez est la machine encodée $M$, le fichier que vous lui donnez est l'entrée $w$, et le processeur simule $M$ sur $w$, pas à pas.

## La Turing-complétude

Turing n'a pas physiquement construit la MTU ; il l'a spécifiée avec assez de précision pour qu'elle *puisse* être construite. La spécification elle-même est la preuve qui dit : voici une machine concrète qui simule n'importe quelle autre. On appelle tout système ayant cette puissance **Turing-complet** : donnez-lui un encodage $\langle M, w \rangle$, et il peut faire tout ce que $M$ ferait sur $w$.

Que faut-il pour être Turing-complet ? Trois choses :

1. **Une mémoire en lecture/écriture non bornée** : Un stockage qui peut croître sans limite, avec la capacité de lire et d'écrire à des emplacements arbitraires (comme le ruban infini de la MT et sa tête de lecture/écriture)
2. **Le branchement conditionnel** : Un comportement différent selon les valeurs des données (comme la fonction de transition : « si dans l'état $q$ en lisant $s$, alors... »)
3. **L'itération non bornée** : La capacité de répéter des opérations indéfiniment, via des boucles, la récursion, ou équivalent (une MT peut parcourir ses états autant de fois que nécessaire)

C'est suffisant. Python les possède. JavaScript, C, Excel (oui, vraiment) et même PowerPoint aussi. L'encodage peut être absurde, mais il fonctionnera.

## Le plafond

Mais la Turing-complétude est-elle le *maximum* de puissance qu'un système puisse atteindre ? Pourrait-on construire quelque chose de plus fort : un système qui résout des problèmes qu'aucune machine de Turing ne peut résoudre ?

Une machine de Turing calcule une fonction : donnez-lui une entrée $w$, et elle produit une sortie $M(w)$ (ou tourne indéfiniment). Différents formalismes définissent « fonction calculable » différemment. Turing a inventé son modèle avec ruban et tête. Alonzo Church, travaillant indépendamment, a défini le calcul à l'aide de fonctions pures. D'autres ont proposé leurs propres définitions. Remarquablement, chaque formalisation raisonnable s'est avérée définir exactement la même classe de fonctions. Des points de départ différents, une même destination.

Cette convergence est le fondement empirique de la **thèse de Church-Turing** :

> Une fonction est effectivement calculable si et seulement si elle est calculable par une machine de Turing.

Personne n'a jamais trouvé de contre-exemple.

La thèse répond à notre question. Il n'existe pas de « super-ordinateur » au-delà de la Turing-complétude. On peut construire des systèmes plus rapides, des systèmes avec une syntaxe plus agréable. Mais on ne peut pas construire un système qui calcule *plus* que ce qu'une machine de Turing peut calculer.

**La Turing-complétude est le plafond.**

## Retour à Demis

Les cerveaux et les réseaux de neurones sont Turing-complets : ils branchent, bouclent, et peuvent étendre leur mémoire selon les besoins. En théorie, ils peuvent résoudre n'importe quel problème calculable.

L'« intelligence générale » signifie simplement en résoudre suffisamment. Combien exactement dépend de la définition utilisée. L'écart entre l'IA actuelle et cet objectif n'est pas une question de capacité sous-jacente, mais de résoudre suffisamment de problèmes calculables **efficacement**. Les humains et l'IA sont des machines de Turing « approximatives » parce qu'ils sont finis. Une machine de Turing a un ruban infini et un temps illimité ; nous avons des paramètres fixes et des délais. Mais pour les problèmes qui nous importent vraiment, le fini devrait suffire, pourvu qu'on maîtrise l'efficacité.

Ce que nous ne savons pas encore, c'est le chemin le plus rapide pour y arriver : de meilleures données, plus de puissance de calcul, des architectures plus intelligentes ? Probablement tout cela à la fois. Des milliers de chercheurs et des milliards de dollars travaillent sur exactement cette question, jour après jour.

## La suite

La Turing-complétude nous dit ce qui est *possible*. Mais elle ne nous dit pas ce qui est *impossible*.

Dans la [Partie 3](@/blog/limits-of-computation.md), nous ouvrirons le plafond et regarderons au-dessus. Certains problèmes sont *démontrablement* insolubles : pas simplement difficiles, mais impossibles pour toute machine de Turing, tout ordinateur, tout cerveau, toute IA.

---
