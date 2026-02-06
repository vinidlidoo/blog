+++
title = "La chaîne de valeur de l'éducation : où l'IA s'inscrit"
date = 2026-01-29
updated = 2026-01-31
description = "L'éducation n'est pas un bloc monolithique. La décomposer en étapes révèle où la technologie peut réellement aider."

[taxonomies]
tags = ["ai", "education"]

[extra]
social_media_card = "/img/education-value-chain.webp"
stylesheets = ["css/details.css"]
+++

<img src="/img/education-value-chain.webp" alt="La chaîne de valeur de l'éducation : Découverte, Apprentissage, Évaluation et Certification.">

Le 21 janvier 2026, Google a annoncé des [tests de préparation au SAT intégrés à Gemini](https://blog.google/products-and-platforms/products/education/practice-sat-gemini/) (gratuits, complets, corrigés par IA). Le même jour, OpenAI a lancé [Education for Countries](https://openai.com/index/edu-for-countries/) à Davos, un programme aidant les gouvernements à intégrer l'IA dans leurs systèmes éducatifs nationaux. L'initiative de Google est ciblée ; celle d'OpenAI est plus large. Dans les deux cas, l'IA dans l'éducation accélère.

La question est *où* dans l'éducation. « L'IA va transformer l'éducation » est à peu près aussi opérationnel que « le logiciel va résoudre les problèmes des entreprises ». Un lycéen hésitant entre sciences infirmières et informatique n'a pas le même problème qu'un élève de bootcamp dev bloqué sur la récursivité, qui n'a pas le même problème qu'un responsable du recrutement cherchant à vérifier les compétences d'un candidat. De quelle partie de l'éducation parle-t-on ? Cet article tente de répondre en décomposant l'éducation en étapes, en montrant ce qui coince à chacune et où la technologie pourrait intervenir.

## La chaîne de valeur

Vue du point de vue de l'élève, l'éducation est une chaîne de valeur en quatre étapes. Chaque étape répond à une question différente :

{% table(wide=true) %}

| Étape | Fonction | Question centrale |
|-------|----------|-------------------|
| Découverte | Identifier quoi poursuivre | Qu'est-ce que je devrais apprendre ? |
| Apprentissage | Acquérir connaissances et compétences | Comment l'apprendre ? |
| Évaluation | Mesurer ce qui a été appris | Est-ce que je l'ai appris ? |
| Certification | Signaler sa compétence aux autres | Comment le prouver ? |
{% end %}

Des modèles similaires par étapes existent dans la certification professionnelle et les sciences de l'éducation,[^1] mais aucun n'était assez simple pour être utilisé tel quel, alors j'ai construit celui-ci. Je l'ai confronté à des enseignants et des professeurs d'université, et il tient la route.

Prenons une professionnelle en reconversion du marketing vers la data science. Elle commence à la **Découverte** : rechercher quelles compétences comptent, comparer les programmes, lire des offres d'emploi pour comprendre ce que les employeurs attendent vraiment. Elle passe à l'**Apprentissage** : suivre un cursus, réaliser des projets, combler ses lacunes en statistiques et en Python. Puis l'**Évaluation** : passer des tests d'entraînement, soumettre des projets de portfolio pour obtenir des retours, se mesurer aux exigences du poste. Enfin, la **Certification** : obtenir une certification, construire un portfolio public, obtenir une recommandation d'un mentor. Chaque étape a ses propres failles et ses propres opportunités pour la technologie.

Ces étapes sont séquentielles mais pas strictement linéaires. On peut boucler entre Apprentissage et Évaluation de nombreuses fois avant d'atteindre la Certification. Ou on peut revenir de l'Apprentissage à la Découverte : à mi-parcours d'un cursus en data science, on découvre la vision par ordinateur et on réalise que c'est le sous-domaine qu'on veut vraiment poursuivre. La chaîne de valeur décrit la progression logique, pas un pipeline rigide.

## Où ça casse : étape par étape

Chaque étape a ses propres points de rupture. Voici ce que les élèves, les enseignants et les employeurs peuvent rencontrer.

<img src="/img/four-stages-education.webp" alt="Les quatre étapes de la chaîne de valeur de l'éducation (Découverte, Apprentissage, Évaluation et Certification) avec leurs points de friction.">

Ci-dessous, quinze points de friction répartis sur les quatre étapes, chacun résumé en une ligne. Ce n'est pas exhaustif, mais ça suit la règle des 80/20 :

### Découverte

<ol>
<li><strong>Orientation</strong> : difficile de cerner l'intersection entre ce qui nous intéresse, ce dans quoi on excelle, ce dont le monde a besoin (et ce qui paie)</li>
<li><strong>Accès</strong> : les programmes adaptés sont difficiles à trouver, à intégrer, et souvent, à financer</li>
</ol>

### Apprentissage

<ol start="3">
<li><strong>Motivation</strong> : on perd son élan et on décroche avant d'atteindre un plafond intellectuel</li>
<li><strong>Programmes</strong> : le format unique n'est pas adapté aux connaissances préalables ni au rythme de chacun</li>
<li><strong>Contenu</strong> : des manuels et des supports génériques qui ignorent les objectifs et le parcours de chacun</li>
<li><strong>Boucles de rétroaction</strong> : on ne sait pas qu'on est hors piste avant les partiels ou les examens finaux</li>
</ol>

### Évaluation

<ol start="7">
<li><strong>Identité</strong> : vérifier l'identité d'un candidat en ligne est intrusif et imparfait</li>
<li><strong>Triche</strong> : les modèles de langage peuvent rédiger des dissertations passables et résoudre des exercices</li>
<li><strong>Validité</strong> : réussir un examen sur la négociation, ce n'est pas la même chose que savoir négocier</li>
<li><strong>Anxiété</strong> : certains étudiants maîtrisent la matière mais s'effondrent en conditions d'examen</li>
</ol>

### Certification

<ol start="11">
<li><strong>Granularité</strong> : un diplôme en quatre ans est trop sommaire ; un micro-certificat est trop fin</li>
<li><strong>Fraude</strong> : les <a href="https://en.wikipedia.org/wiki/Diploma_mill">usines à diplômes</a> délivrent des certificats qui semblent légitimes</li>
<li><strong>Portabilité</strong> : les crédits de l'université X ne sont pas transférables à l'université Y</li>
<li><strong>Obsolescence</strong> : les certificats ne reflètent pas si les compétences ont été maintenues depuis leur délivrance</li>
<li><strong>Opacité</strong> : les certificats sont des déclarations adossées à une réputation, pas des preuves vérifiables</li>
</ol>

Sans carte, on pourrait se contenter de construire un meilleur manuel. C'est une amélioration, mais si la certification est le vrai goulot d'étranglement, ce n'est pas le levier le plus important. Les étapes forcent à voir l'ensemble et à se demander : où l'amélioration compte-t-elle le plus ?

## Les étapes en action

Maintenant qu'on a les étapes et leurs points de friction, on peut se demander : que se passerait-il si on orientait les capacités actuelles de l'IA et d'autres technologies émergentes vers chacune
d'entre elles ? Ce qui suit, ce sont des pistes de réflexion (une par étape), pas des solutions validées.

### Découverte : agent de navigation de carrière

<img src="/img/career-pathfinding-agent.webp" alt="Un agent IA analysant des documents et cartographiant des trajectoires de carrière en data science, UX design et éthique de l'IA.">

Les agents IA actuels peuvent déjà interroger des bases de données, analyser des documents et écrire du code d'analyse. Un agent de navigation combinerait ces capacités pour la planification de carrière : on importe son CV et ses relevés de notes, et l'IA croise ces données avec des offres d'emploi et des référentiels de compétences pour cartographier les perspectives. Investir six mois dans les statistiques et l'infrastructure de données, et l'agent esquisse comment les options évoluent ; pivoter vers l'UX à la place, et le tableau change. Le problème tridimensionnel de la découverte (intérêt, aptitude, demande) devient un espace de décision navigable.

### Apprentissage : la question comme point de départ

<img src="/img/you-choose-your-own-adventure.webp" alt="Un système d'apprentissage où la conversation s'adapte en temps réel aux lacunes et aux questions de chacun.">

Les grands modèles de langage peuvent déjà tenir des conversations longues et contextuelles, en adaptant leurs explications à la volée. Un système d'apprentissage par la question ferait de cette conversation *le* chemin, bien plus qu'un complément pour les moments de blocage. On pose des questions sur les points qui nous échappent, on insiste quand quelque chose ne passe pas, et le contenu s'ajuste en temps réel. Ce qui reste, ce sont des notes d'étude co-écrites, façonnées par ses propres lacunes, questions et parcours. J'en ai parlé plus en détail dans [La question comme point de départ](@/blog/prompt-first-learning.fr.md).

### Évaluation : performance évaluée par l'IA

<img src="/img/ai-assessed-performance.webp" alt="Une évaluation de performance par IA où le système observe quelqu'un qui conçoit un circuit imprimé en réalité augmentée.">

Les modèles actuels sont multimodaux : ils traitent texte, images et vidéo, et peuvent interpréter ce qu'on fait à travers un écran ou une caméra. Un système d'évaluation de performance par IA utiliserait ces capacités pour remplacer les examens par des simulations de tâches. Au lieu de répondre à des questions sur la conception de circuits, on conçoit et route un circuit imprimé pendant que l'IA évalue les choix de composants et le tracé des pistes. Au lieu d'écrire sur les principes de gestion de projet, on travaille sur un scénario pendant que l'IA évalue les décisions. Le parcours de chaque candidat se déroule différemment selon ses choix, rendant certaines formes de triche nettement plus difficiles. Ce sur quoi on est évalué est plus proche de ce qu'on ferait en poste.

### Certification : des certificats ancrés dans les preuves

<img src="/img/evidence-based-credentials.webp" alt="Un système de certification ancré dans les preuves, stockant des preuves vérifiables de compétences sur une blockchain.">

La blockchain peut rendre n'importe quel enregistrement instantanément vérifiable et infalsifiable. Un système de certification ancré dans les preuves irait plus loin : la chaîne stockerait non seulement la déclaration (« cette personne a réussi ») mais aussi les empreintes de ce qui a été effectivement démontré (réponses d'évaluation, livrables de projets, notes des évaluateurs). Le certificat devient un support transparent plutôt qu'un badge opaque. Quiconque le consulte peut vérifier les preuves, la confiance ne repose plus sur la réputation de l'émetteur, mais sur des preuves vérifiables. Cela adresse trois des points de friction : la fraude (les certificats ne peuvent pas être falsifiés), la portabilité (n'importe qui peut vérifier sans contacter l'émetteur) et l'opacité (les preuves sont auditables).

## La suite

De nombreux acteurs participent à ces étapes, chacun avec des incitatifs et des contraintes différentes :

- **Élèves** : lycéens, étudiants, adultes en activité
- **Fournisseurs** : institutions, plateformes, bootcamps
- **Employeurs** : responsables du recrutement, recruteurs
- **Gardiens** : entités gouvernementales, organismes d'accréditation, organismes de certification

Dans les prochains articles, je choisirai une étape à la fois, replacerai ces acteurs en contexte, et creuserai les points de friction les plus urgents et les pistes technologiques les plus prometteuses.

C'est un cadre de départ. Il manque peut-être une ou deux pièces, et les contours pourraient évoluer à mesure que j'approfondis. Si vous repérez un angle mort, [n'hésitez pas à me le signaler](https://vinidlidoo.github.io/fr/contact/).

[^1]: Les parallèles les plus proches sont la progression apprendre-pratiquer-certifier courante en certification professionnelle et le cycle d'apprentissage transformatif en sept étapes de [De Witt et al. (2023)](https://journals.sagepub.com/doi/10.1177/15413446231220317).

---

*Cet article a été écrit en collaboration avec [Claude](https://claude.ai) (Opus 4.5).*
