+++
title = "Le Prompt-First Learning"
date = 2026-01-22
description = "Et si les manuels s'adaptaient à vos questions, plutôt que l'inverse ?"

[taxonomies]
tags = ["ai", "education"]

[extra]
social_media_card = "/img/you-choose-your-own-adventure.webp"
+++

![Prompt-First Learning : Vous choisissez où va l'histoire](/img/you-choose-your-own-adventure.webp)

Depuis les vacances, je réfléchis à l'IA et à l'éducation. C'est en grande partie ce qui m'a poussé à créer ce blog il y a deux semaines, juste après avoir quitté Amazon où j'ai passé dix ans. Je voulais expérimenter comment l'IA peut aider à enseigner. Cela dit, mes motivations sont aussi égoïstes : j'apprends mieux en enseignant. Feynman avait raison : si on ne peut pas expliquer quelque chose simplement, c'est qu'on ne le comprend pas assez bien. Et honnêtement, peu de choses me procurent autant de satisfaction que le moment où quelque chose finit par cliquer.

Un [tweet](https://x.com/AriaWestcott/status/2013153611715350783) est passé dans mon fil la semaine dernière : « BREAKING: Google just dropped the textbook killer ». Un système appelé Learn Your Way qui transforme des PDF en supports d'apprentissage personnalisés. Tout excité, je clique sur le lien vers l'[article de blog](https://research.google/blog/learn-your-way-reimagining-textbooks-with-generative-ai/)... et je vois septembre 2025. Pas vraiment « breaking », plutôt une vieille actu qui refait surface. Mais bon, je voulais quand même voir ce qu'ils avaient construit.

J'ai donc essayé la [démo](https://learnyourway.withgoogle.com/) et lu l'[article scientifique](https://arxiv.org/pdf/2509.13348), publié plus tôt ce mois-ci. Je suis content qu'une entreprise avec les ressources de Google investisse dans ce domaine. Ce qu'ils ont construit n'est pas anodin : LearnLM transforme des PDF en plusieurs formats (texte immersif, diapositives avec narration, leçons audio-graphiques, cartes mentales), s'adapte à votre niveau scolaire, personnalise les exemples selon vos centres d'intérêt et intègre des questions tout au long pour vérifier votre compréhension. Le quiz à la fin de chaque section vous donne une évaluation avec vos points forts et vos axes d'amélioration.

<video autoplay loop muted playsinline>
  <source src="https://pub-94e31bf482a74272bb61e9559b598705.r2.dev/video/learn-your-way.mp4" type="video/mp4">
</video>

Voici où j'ai été déçu. J'ai défini mon profil comme « étudiant de premier cycle intéressé par la peinture » et j'ai chargé le module sur les hydrocarbures. J'ai parcouru le contenu, répondu aux questions, obtenu mon évaluation. À la fin, ce qui me restait, c'était le texte original plus une seule phrase ajoutée : « *On trouve des hydrocarbures dans de nombreux matériaux d'artiste, par exemple la térébenthine utilisée pour diluer les peintures à l'huile ou les essences minérales pour nettoyer les pinceaux.* » Pas de notes de révision reflétant mon parcours. Pas de document façonné par mes difficultés. L'infrastructure fonctionne (transformations de format, pipeline d'évaluation, tout), mais après toute cette interaction, je repars avec le même contenu que tout le monde. Je me suis demandé si augmenter du contenu existant allait vraiment être la meilleure direction pour l'IA et l'apprentissage. Non, il y a sans doute quelque chose de plus fondamental qui attend d'être construit.

## Le problème de l'augmentation

La plupart des manuels ne sont pas écrits pour vous. Ils sont écrits pour un large public, optimisés pour le milieu de la courbe. Ils ne peuvent pas anticiper où *vous* allez bloquer ni quel bagage *vous* apportez. Augmenter ce type de contenu source, même avec une personnalisation intelligente, ne change pas le problème de fond : le texte n'a toujours pas été écrit en pensant à vos lacunes spécifiques, à vos questions spécifiques, à votre façon d'apprendre.

Quiconque a fait des études connaît la solution : on prend ses propres notes. Le manuel est l'entrée ; vos notes sont la sortie, façonnées par ce qui vous a embrouillé et ce qui a fini par cliquer. Ce sont ces notes, pas le manuel, qu'on relit avant les examens.

L'approche actuelle de Learn Your Way est l'augmentation : prendre le contenu source, ajouter des touches personnalisées, le présenter sous différents formats. C'est utile, mais ça ne vous aide pas à prendre ces notes. Ce qui manque, c'est **le dialogue** : la possibilité de dire « attendez, je ne comprends pas cette partie » et que **le contenu s'ajuste en quasi temps réel**.

## Ce qui fonctionne pour moi

Voici ce qui fonctionne pour moi depuis un an. Je commence une conversation avec Claude sur un sujet : je lui dis ce que j'essaie de comprendre, mon parcours, comment j'apprends le mieux. Pour moi, ça passe souvent par les maths ; tant que je ne vois pas les formules, j'ai l'impression de ne comprendre que superficiellement. Un ami à moi apprend mieux par les analogies. On est différents, et c'est justement le point.

On échange : je pose des questions sur ce qui m'échappe, j'insiste quand quelque chose ne passe pas, je continue jusqu'à ce que je comprenne. Quand j'ai terminé, je demande à Claude de sauvegarder des notes de révision directement dans Obsidian via un serveur MCP (en Markdown simple, rien de propriétaire), en portant une attention particulière aux points qui m'ont posé problème. Ces notes, qui répondent à mes confusions spécifiques, deviennent aussi mes notes de référence.

Cette année, j'ai ajouté une étape : je prends ces notes plus une ébauche de plan et je rédige des articles de blog avec Claude Code, en utilisant un skill personnalisé qui encode mon style d'écriture et mes préférences (j'ai écrit à propos d'une approche similaire pour les [traductions](@/blog/translation-with-claude-code.fr.md)). J'édite dans Neovim et je collabore via l'intégration IDE. Si quelque chose dans mon brouillon ne m'est pas clair, je continue de réviser jusqu'à ce que ça le soit, que ce soit manuellement ou par d'autres échanges avec Claude.

**À la fin de la conversation, le contenu reflète ma compréhension mise à jour**. Pas un texte statique auquel j'ai dû m'adapter, mais un document qui s'est adapté à moi.

## Le Prompt-First Learning

Voici comment ça se passe :

- **Départ** : Indiquez ce que vous voulez apprendre, ce que vous savez déjà, comment vous apprenez le mieux. Du contenu source (section de manuel, article, transcription vidéo) peut ancrer la conversation, mais n'est pas obligatoire.
- **Boucle** : L'IA engage une conversation avec vous, en cherchant en ligne au besoin pour consolider ses réponses. Le texte se met à jour dynamiquement en fonction de ce qui vous pose problème. Vous répondez aussi à des questions d'évaluation au fur et à mesure.
- **État final** : Des notes de révision co-écrites avec vous, façonnées par les questions que vous avez posées et les réponses que vous avez données en chemin.

Le texte statique suppose que les autres lecteurs ont les mêmes lacunes. Le texte dynamique comble *vos* lacunes à mesure qu'elles émergent.

Ce n'est pas un « tuteur IA », un assistant qu'on consulte quand le manuel fait défaut. Dans le prompt-first learning, la conversation est la voie principale, et les notes de révision co-écrites sont ce qu'on garde. On choisit aussi où aller : quels sujets creuser, quelles tangentes suivre. *Un Livre dont vous êtes le héros*, mais pour l'apprentissage.

C'est plus facile à dire qu'à faire. Un système de production devrait maintenir l'exactitude factuelle à mesure que le contenu s'adapte, et dans l'éducation formelle, assurer la couverture de fondamentaux communs pour l'ensemble des élèves. Des problèmes difficiles. Mais cette direction me semble juste.

La [section sur les travaux futurs](https://arxiv.org/pdf/2509.13348) de Google suggère quelque chose de similaire : « *Le système pourrait devenir plus adaptatif en ajustant dynamiquement le contenu pédagogique selon les performances de l'élève aux différents modules d'évaluation.* » On dirait qu'on converge vers les mêmes idées.

## Expérimenter ici

Je prévois de travailler directement sur ce blog. Faire quelques expériences, voir ce qui fonctionne. Ça pourrait ressembler à ceci : vous lisez une section, et si quelque chose n'est pas clair, vous pouvez poser des questions dans une barre latérale ou une fenêtre modale. L'article s'adapte (pas tout l'article, mais les passages spécifiques où vous êtes bloqué). Vous obtiendriez une version de l'article écrite pour vos points de blocage, pas ceux d'un public générique.

La boucle de base existe aujourd'hui si vous êtes prêt à faire l'effort manuellement : lisez un article, ouvrez Claude, posez des questions sur les parties que vous ne comprenez pas, recommencez. Le défi est de construire une UX qui rende cela fluide.

## Au-delà de la compréhension

Le prompt-first learning vous amène à la compréhension. Mais comprendre n'est que la première étape. Vous devez aussi retenir ce que vous avez appris, et parfois vous voulez apprendre dans une modalité différente.

Sur la rétention : j'ai appris le japonais alors que je n'ai commencé qu'à 23 ans, et la raison principale, c'est les flashcards [Anki](https://apps.ankiweb.net/) avec répétition espacée. Imaginez un système qui crée automatiquement des cartes à partir des points qui vous ont posé problème, les exporte via API, et planifie les révisions à intervalles optimaux. Comprendre par la conversation, mémoriser par la répétition.

Sur la modalité : un ami japonais a récemment essayé de lire mes articles sur les [clés privées](@/blog/math-behind-private-key.fr.md) et les [signatures numériques](@/blog/secrets-and-signatures.fr.md). Son approche : soumettre les deux à NotebookLM et demander un podcast expliquant les courbes elliptiques avec des analogies Pokémon. En japonais. Le résultat est hilarant mais étonnamment précis ; les métaphores tenaient la route quand je les ai comparées à mes descriptions originales. Ce n'est pas du prompt-first learning, il n'y a pas de dialogue. Mais ça montre jusqu'où le contenu peut se transformer tout en restant fidèle à la source.

<div class="centered">
<audio controls>
  <source src="https://pub-94e31bf482a74272bb61e9559b598705.r2.dev/audio/pokemon-elliptic-curves.mp3" type="audio/mpeg">
</audio>
</div>

## Pourquoi maintenant

L'IA creuse l'écart entre comment on apprend et comment on pourrait apprendre. Andrej Karpathy [l'a bien formulé](https://youtu.be/lXUZvyajciY?si=pV2gwP7Fe9kN7Gl8&t=7731) sur le podcast Dwarkesh en octobre dernier : « *l'éducation pré-AGI est utile, l'éducation post-AGI est fun. Les gens iront à l'école comme ils vont à la salle de sport : parce que c'est agréable, ça maintient l'esprit vif, et l'intelligence est attirante de la même façon que des abdos bien dessinés.* » J'adhère à cette vision. J'ajouterais : les gens intelligents seront attrayants non seulement pour leurs opinions nuancées sur [P vs NP](https://en.wikipedia.org/wiki/P_versus_NP_problem) lors de dîners, mais parce qu'ils mettent leurs connaissances en pratique. La société récompense ceux qui sont utiles. Mais c'est une discussion pour un autre article.

Learn Your Way aide à apprendre ; leur article scientifique inclut des résultats qui le prouvent. Mais la grande opportunité n'est pas une meilleure augmentation. C'est le prompt-first : la conversation comme voie principale, des notes de révision façonnées par le parcours de chacun.

---

*Ce billet a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
