+++
title = "Le Prompt-First Learning"
date = 2026-01-22
description = "Et si les manuels s'adaptaient à vos questions, plutôt que l'inverse ?"

[taxonomies]
tags = ["ai", "education"]
+++

Depuis les vacances, je réfléchis à l'IA et à l'éducation. C'est en grande partie ce qui m'a poussé à créer ce blog il y a deux semaines, juste après avoir quitté Amazon où j'ai passé dix ans. Je voulais expérimenter comment l'IA peut aider à enseigner, même si mes motivations sont aussi égoïstes : j'apprends mieux en enseignant. Feynman avait raison : si on ne peut pas expliquer quelque chose simplement, c'est qu'on ne le comprend pas assez bien. Et honnêtement, peu de choses me procurent autant de satisfaction que le moment où quelque chose finit par cliquer.

Un [tweet](https://x.com/AriaWestcott/status/2013153611715350783) est passé dans mon fil la semaine dernière, affirmant que Google avait sorti « le tueur de manuels » : un système appelé Learn Your Way qui transforme des PDF en supports d'apprentissage personnalisés. L'[article de blog original](https://research.google/blog/learn-your-way-reimagining-textbooks-with-generative-ai/) datait de septembre 2025, mais bon, ce qui compte, c'est ce qu'ils ont construit et où ça nous mène.

J'ai donc essayé la [démo](https://learnyourway.withgoogle.com/) et lu l'[article scientifique](https://arxiv.org/pdf/2509.13348), publié plus tôt ce mois-ci. Je suis content qu'une entreprise avec les ressources de Google investisse dans ce domaine. Ce qu'ils ont construit n'est pas anodin : LearnLM transforme des PDF en plusieurs formats (texte immersif, diapositives avec narration, leçons audio-graphiques, cartes mentales), s'adapte à votre niveau scolaire, personnalise les exemples selon vos centres d'intérêt et intègre des questions tout au long pour vérifier votre compréhension. Le quiz à la fin de chaque section vous donne une évaluation avec vos points forts et vos axes d'amélioration. Un vrai travail a été fourni.

Voici où j'ai été un peu déçu. J'ai défini mon profil comme « étudiant de premier cycle intéressé par la peinture » et j'ai chargé le module sur les hydrocarbures. La personnalisation que j'ai reçue se résumait à une seule phrase : « *On trouve des hydrocarbures dans de nombreux matériaux d'artiste, par exemple la térébenthine utilisée pour diluer les peintures à l'huile ou les essences minérales pour nettoyer les pinceaux.* » Le reste du texte était inchangé par rapport au matériel source. C'est maigre, mais l'infrastructure est là : les transformations de format fonctionnent, le pipeline d'évaluation fonctionne, et tout le reste aussi. En parcourant le contenu, la question qui me revenait sans cesse était : est-ce qu'augmenter du contenu existant est la bonne direction, ou y a-t-il quelque chose de plus fondamental qui attend d'être construit ?

## Le problème de l'augmentation

La plupart des manuels ne sont pas écrits pour vous. Ils sont écrits pour un large public, optimisés pour le milieu de la courbe. Ils ne peuvent pas anticiper où *vous* allez bloquer ni quel bagage *vous* apportez. Augmenter ce type de matériel source, même avec une personnalisation intelligente, ne change pas le problème de fond : le texte n'a toujours pas été écrit en pensant à vos lacunes spécifiques, à vos questions spécifiques, à votre façon d'apprendre.

L'approche actuelle de Learn Your Way est l'augmentation : prendre le contenu source, ajouter des touches personnalisées, le présenter sous différents formats. C'est précieux, mais ça reste fondamentalement unidirectionnel. Le texte vous parle. Ce qui manque, c'est l'aller-retour : la possibilité de dire « attendez, je ne comprends pas cette partie » et que le contenu réponde. Et au-delà : la possibilité de choisir où aller ensuite. Pensez à *Le Livre dont vous êtes le héros*, mais pour l'apprentissage. Vous décidez quel sujet creuser, quelle tangente suivre, quelle piste approfondir. Vous n'êtes pas qu'un lecteur ; vous êtes le protagoniste de votre propre curriculum.

## Ce qui fonctionne pour moi

Voici ce qui fonctionne pour moi depuis un an. Je commence une conversation avec Claude sur un sujet : je lui dis ce que j'essaie de comprendre, mon parcours, comment j'apprends le mieux. Pour moi, ça passe souvent par les maths ; tant que je ne vois pas les formules, j'ai l'impression de ne comprendre que superficiellement. Un ami à moi apprend mieux par les analogies. On est différents, et c'est justement le point.

On échange : je pose des questions sur ce qui m'échappe, j'insiste quand quelque chose ne passe pas, je continue jusqu'à ce que je comprenne. Quand j'ai terminé, je demande à Claude de sauvegarder des notes de révision directement dans Obsidian via un serveur MCP, en portant une attention particulière aux points qui m'ont posé problème. Du Markdown simple, rien de propriétaire. Ces notes, qui répondent à mes confusions spécifiques, deviennent mon manuel.

Cette année, j'ai ajouté une étape : je prends ces notes plus une ébauche de plan et je rédige des articles de blog avec Claude Code, en utilisant un skill personnalisé qui encode mon style d'écriture et mes préférences (j'ai écrit à propos d'une approche similaire pour les [traductions](@/blog/translation-with-claude-code.fr.md)). J'édite dans Neovim et je collabore via l'intégration IDE. Si quelque chose dans mon brouillon ne m'est pas clair, je révise jusqu'à ce que ça le soit.

Le point essentiel : **à la fin de la conversation, le contenu reflète ma compréhension mise à jour**. Pas un texte statique auquel j'ai dû m'adapter, mais un document qui s'est adapté à moi.

## Le Prompt-First Learning

La vision à laquelle je reviens sans cesse :

- **Départ** : Un contenu source (section de manuel, article, transcription vidéo) plus un profil d'apprenant (parcours, objectifs, style d'apprentissage préféré)
- **Boucle** : L'IA engage une conversation. Le texte se met à jour dynamiquement en fonction de ce qui vous pose problème. Vous répondez aussi à des questions d'évaluation au fur et à mesure.
- **État final** : Un document co-écrit avec vous, façonné par les questions que vous avez posées en chemin.

Le texte statique suppose que tous les lecteurs ont les mêmes lacunes. Le texte dynamique comble *vos* lacunes à mesure qu'elles émergent. Ce n'est pas un tuteur que l'on consulte quand le manuel fait défaut : c'est la voie principale, et le document co-écrit est ce que vous gardez.

C'est évidemment simpliste. Un vrai système devrait maintenir l'exactitude factuelle à mesure que le contenu s'adapte, et dans l'éducation formelle, assurer la couverture de fondamentaux communs pour l'ensemble des étudiants. Des problèmes difficiles, certes, mais la direction semble juste.

La [section sur les travaux futurs](https://arxiv.org/pdf/2509.13348) de Google suggère quelque chose de similaire : « *Le système pourrait devenir plus adaptatif en ajustant dynamiquement le contenu pédagogique selon les performances de l'élève aux différents modules d'évaluation.* » On tourne autour de la même idée.

## Expérimenter ici

Je prévois de travailler directement sur ce blog. Faire quelques expériences, voir ce qui fonctionne. Ça pourrait ressembler à ceci : vous lisez une section, et si quelque chose n'est pas clair, vous pouvez poser des questions dans une barre latérale ou une fenêtre modale. L'article s'adapte (pas tout l'article, mais les passages spécifiques où vous êtes bloqué). Vous obtiendriez une version de l'article écrite pour vos difficultés, pas celles d'un public générique.

Comme première étape, j'ai récemment ajouté les commentaires à ce blog. Si des lecteurs signalent où ils ont été perdus, je peux mettre à jour l'article pour combler ces lacunes. C'est manuel, et ce n'est pas vraiment personnalisé : tout le monde voit le même texte mis à jour. Cela dit, c'est la même boucle : retour d'information en entrée, texte plus clair en sortie. La personnalisation individuelle pourrait venir plus tard.

La boucle de base existe aujourd'hui si vous êtes prêt à le faire manuellement. Lisez un article, ouvrez Claude, posez des questions sur les parties que vous ne comprenez pas, recommencez. Le défi est de construire une UX qui rende cela fluide et sans friction, en un minimum d'échanges pour vous débloquer.

## Au-delà de la compréhension

Le prompt-first learning vous amène à la compréhension. Cependant, comprendre n'est que la première étape. Vous devez aussi retenir ce que vous avez appris, et parfois vous voulez apprendre dans une modalité différente.

Sur la rétention : j'ai appris le japonais alors que je n'ai commencé qu'à 23 ans, et la raison principale étant les flashcards [Anki](https://apps.ankiweb.net/) avec répétition espacée. Imaginez un système qui crée automatiquement des cartes à partir des points qui vous ont posé problème, les exporte via API, et planifie les révisions à intervalles optimaux. Comprendre par la conversation, mémoriser par la répétition.

Sur la modalité : un ami japonais a récemment essayé de lire mes articles sur les [clés privées](@/blog/math-behind-private-key.fr.md) et les [signatures numériques](@/blog/secrets-and-signatures.fr.md). Son approche : soumettre les deux à NotebookLM et demander un podcast expliquant les courbes elliptiques avec des analogies Pokémon. En japonais. Le [résultat](https://drive.google.com/file/d/1WHzCb_1I8f_OAGiKehAbtkZ91GgH1D3X/view) est hilarant mais étonnamment précis ; les métaphores tenaient la route quand je les ai comparées à mes descriptions originales. Ce n'est pas du prompt-first learning, il n'y a pas de dialogue. Ça montre quand même jusqu'où le contenu peut se transformer tout en restant fidèle à la source.

## Pourquoi maintenant

L'IA creuse l'écart entre comment on apprend et comment on pourrait apprendre. Andrej Karpathy [l'a bien formulé](https://youtu.be/lXUZvyajciY?si=pV2gwP7Fe9kN7Gl8&t=7731) sur le podcast Dwarkesh en octobre dernier : « *l'éducation pré-AGI est utile, l'éducation post-AGI est fun. Les gens iront à l'école comme ils vont à la salle de sport : parce que c'est agréable, ça maintient l'esprit vif, et l'intelligence est attirante de la même façon que des abdos bien dessinés.* »

J'adhère à cette vision, mais j'ajouterais : les gens intelligents seront attrayants non seulement pour leurs opinions nuancées sur [P vs NP](https://en.wikipedia.org/wiki/P_versus_NP_problem) lors de dîners d'amis, mais parce qu'ils mettent leurs connaissances en pratique. La société récompense les gens qui sont utiles. Une discussion pour un autre article.

Pour l'instant, je suis enthousiasmé par ce qui est possible. Learn Your Way ouvre une porte. Curieux de voir ce qu'il y a de l'autre côté.

---

*Ce billet a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
