+++
title = "Traduction avec les skills de Claude Code"
date = 2026-01-14
description = "Comment les skills personnalisés et les sous-agents rendent la publication multilingue plus rapide, moins chère et de meilleure qualité que la traduction manuelle"

[taxonomies]
tags = ["dev"]
+++

![traduction avec claude code](/img/translation-with-claude-code-main-image.webp)

Je peux maintenant traduire chaque article de mon blog en français et en japonais en moins d'une minute, sans retouche manuelle. Les traductions sont d'un naturel remarquable, même pour mon contenu le plus technique. Et avec un abonnement Claude, le coût marginal est nul. Difficile de ne pas être conquis par l'IA ces jours-ci.

Cet article explique comment j'ai construit ce système en utilisant les **skills** et les **sous-agents** de Claude Code.

## Skills et sous-agents

Deux fonctionnalités de Claude Code rendent cela possible.

Un **[skill](https://docs.anthropic.com/en/docs/claude-code/skills)** est un prompt réutilisable qui apprend à Claude comment effectuer une tâche spécifique. Les skills peuvent lire des fichiers, exécuter des scripts shell et coordonner des workflows complexes. On peut les invoquer avec une commande slash (comme `/sync-translations` qu'on verra dans la prochaine section), ou Claude Code peut les déclencher automatiquement en fonction du contexte.

Un **[sous-agent](https://docs.anthropic.com/en/docs/claude-code/sub-agents)** est une instance Claude séparée que l'agent principal peut lancer. Chaque sous-agent a son propre prompt système, démarre avec une fenêtre de contexte vierge et ne pollue pas le contexte de l'agent principal avec son travail. Plusieurs sous-agents peuvent s'exécuter en parallèle. Toutes ces propriétés s'avèrent importantes pour la qualité.

## Vue d'ensemble du système

Ce blog fonctionne avec Zola et des fichiers markdown. L'approche se généralise à tout blog avec des fichiers sources lisibles par un humain. Voici la structure du système en question :

```
.claude/
├── skills/
│   └── sync-translations/
│       ├── SKILL.md          # la définition du skill
│       └── check-sync.sh     # détecte ce qui nécessite du travail
├── agents/
│   └── translation-editor.md # révise les traductions
└── translation-learnings/
    ├── fr.md                 # terminologie et style français
    └── ja.md                 # terminologie et style japonais

content/blog/
├── kv-cache-invalidation.md     # original en anglais
├── kv-cache-invalidation.fr.md  # traduction française
├── kv-cache-invalidation.ja.md  # traduction japonaise
├── translation-with-claude-code.md       # cet article (pas encore traduit)
└── ...
```

L'agent principal orchestre tout en utilisant le **skill** [sync-translations](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/skills/sync-translations/SKILL.md). Il exécute le script shell `check-sync.sh` pour détecter ce qui nécessite du travail, lit `{fr.md, ja.md}` dans le répertoire [translation-learnings](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude/translation-learnings) pour les conseils terminologiques, rédige les traductions, puis lance deux **sous-agents** [translation-editor](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/agents/translation-editor.md) (un pour chaque langue) pour les réviser avec un regard neuf. Les éditeurs renvoient leurs découvertes dans les fichiers d'apprentissage, de sorte que le système s'améliore avec le temps :

<img src="/img/translation-workflow.svg" alt="Diagramme du workflow de traduction" />

## Détecter ce qui nécessite du travail

La première étape pour l'agent principal est d'exécuter [`check-sync.sh`](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/skills/sync-translations/check-sync.sh).[^1] Pour chaque article en anglais et langue cible, il produit l'un des trois états : **NEW** (aucun fichier de traduction n'existe), **SYNC** (la traduction existe mais l'anglais a changé) ou **ABORT** (la traduction est à jour).

NEW et ABORT sont de simples vérifications de fichiers. SYNC est plus délicat. On a besoin de l'historique git — pas seulement des dates de modification des fichiers — parce que l'agent doit savoir *ce qui* a changé, pas seulement que quelque chose a changé. Sans le diff exact, il retraduirait l'article entier. Les changements mineurs se perdent dans la masse, et des sections peaufinées sont réécrites inutilement.

Le script trouve quand le *contenu* de la traduction a été mis à jour pour la dernière fois, puis extrait le diff anglais depuis. Pour un article comme `kv-cache-invalidation.md` avec la traduction française `kv-cache-invalidation.fr.md` :

```bash
# Trouver le commit où le contenu français a été modifié pour la dernière fois (pas juste renommé)
baseline=$(git log --follow --format="%H" -- "kv-cache-invalidation.fr.md" \
    | while read commit; do
        # Vérifier si ce commit avait de vrais changements de contenu (pas juste les en-têtes +++ ---)
        changes=$(git show "$commit" -- "kv-cache-invalidation.fr.md" | grep -c "^[-+]")
        [[ "$changes" -gt 4 ]] && echo "$commit" && break
    done)

# Vérifier si l'anglais a changé depuis cette baseline
git diff "$baseline"..HEAD -- "kv-cache-invalidation.md"
```

Toute sortie de diff signifie que la source anglaise a divergé et que la traduction nécessite une synchronisation.

[^1]: Le script utilise des labels différents en interne : `NEEDS TRANSLATION`, `NEEDS SYNC` et `UP TO DATE`.

## Rédacteur et éditeur

L'agent principal rédige les traductions, les écrit sur le disque, puis lance un [sous-agent éditeur](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/agents/translation-editor.md) séparé pour les réviser. L'éditeur démarre avec un contexte vierge — il ne voit que la source anglaise, la traduction brouillon et un fichier d'apprentissage partagé (on en reparle plus loin). Il vérifie le naturel (a-t-on l'impression d'une traduction ou d'un texte original ?), l'adaptation des idiomes (les expressions anglaises ont-elles été traduites par le sens, pas littéralement ?), la terminologie technique (termes standards dans la langue cible ?) et la voix (est-ce que ça me ressemble toujours ?).

Pourquoi ne pas laisser l'agent principal réviser son propre travail ? Le biais. Quand on vient d'écrire quelque chose, la formulation semble correcte parce qu'on vient de la choisir. Les constructions maladroites passent inaperçues. Un lecteur avec un regard neuf repère ce que l'auteur manque. C'est vrai pour les humains ; c'est vrai aussi pour les LLM.

Le passage de relais dépend du contexte. Pour les nouvelles traductions, l'éditeur fait une révision complète. Pour les synchronisations, il se concentre sur les sections modifiées — le reste a déjà été révisé. Et comme chaque langue a son propre éditeur travaillant sur un fichier indépendant, ils s'exécutent en parallèle.

## Des apprentissages qui s'accumulent

Les deux agents partagent un [fichier d'apprentissage](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude/translation-learnings) par langue. L'agent principal le lit avant de rédiger ; l'éditeur le lit pendant la révision et y ajoute ses nouvelles découvertes après. Cela crée une boucle de rétroaction : chaque traduction améliore la suivante.

Pour le français, le fichier capture maintenant que « proof by contradiction » doit être « par l'absurde » (pas le littéral « en vue d'une contradiction »), que « attends to » dans les mécanismes d'attention signifie « prête attention à » (pas « assiste à »), et que les termes techniques comme « forward pass » doivent rester en anglais.

Pour le japonais, il note d'éviter complètement les tirets cadratins (ils ne sont pas standards dans le texte japonais), que « sent me down a rabbit hole » devient 「沼にはまってしまった」 (tomber dans un marécage — une expression japonaise naturelle pour l'exploration obsessionnelle), et que la numérotation des séries doit utiliser le format 「第N回/全M回」.

Ce ne sont pas des règles que j'ai écrites à l'avance. Elles ont émergé des sessions d'édition et se composent avec chaque article.

## Conclusion

Je suis francophone de naissance et j'ai passé une décennie à vivre et travailler au Japon. Écrire ce blog en anglais avait du sens pour toucher un public plus large, mais cela signifiait laisser des lecteurs (amis et famille) de côté.

Les alternatives n'étaient pas géniales. La traduction manuelle prendrait 3-4 heures par article par langue, et la qualité serait difficile à maîtriser : j'ai appris à rédiger en contexte professionnel et technique en anglais, mes mathématiques en français, et bien que je parle couramment japonais, écrire une prose soignée est une compétence que je n'ai pas beaucoup pratiquée. La traduction professionnelle coûte cher. Et quiconque a lu du Google Translate pour du contenu technique connaît la gêne : formulations maladroites, terminologie incorrecte, prose qui hurle « je suis un robot ».

Cela change la donne. Les traductions ne sont pas parfaites, mais pas loin. Elles ne me coûtent rien qu'une minute d'attente. Je n'aurais pas pris la peine de traduire ce blog sans cette option à ma disposition. Je soupçonne qu'on verra beaucoup plus de contenu multilingue en ligne dans les mois à venir.

Le système a pris quelques heures à construire. Maintenant j'écris en anglais, je commite et je lance `/sync-translations`. Cet article a été traduit avec ce système — si vous lisez la version française ou japonaise, vous en voyez le résultat. Si vous voulez construire quelque chose de similaire, suivez les liens tout au long de cet article ou explorez le [dépôt complet](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude).

---

*Ce billet a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
