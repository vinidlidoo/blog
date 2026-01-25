# French Translation Learnings

Terminology and conventions discovered through editing. The translation-editor agent reads this file and appends new learnings.

## Mathematical Terms

| English | French | Notes |
|---------|--------|-------|
| proof by contradiction | par l'absurde | Not "en vue d'une contradiction" |
| size (of a set) | cardinalité | Not "taille" when discussing cardinality |
| power set | ensemble des parties | |
| uncountable | indénombrable | |
| decimal expansion | développement décimal | Not "décimale infinie" |
| set-builder notation | notation en compréhension | Not "notation ensembliste" |
| unrestricted comprehension | compréhension naïve | Standard term in French math literature |

## Machine Learning / AI Terms

| English | French | Notes |
|---------|--------|-------|
| attends to (attention mechanism) | prête attention à | Not "assiste à" (which means "attends an event") |
| cache hit | succès de cache | "hit de cache" acceptable but less native |
| cache miss | échec de cache | "miss de cache" acceptable but less native |
| forward pass | passe forward | Keep "forward" as technical term |
| hidden state | état caché | |
| sleep-time agents | sleep-time agents | Keep English; do not translate literally |

## Computer Science Terms

| English | French | Notes |
|---------|--------|-------|
| tape (Turing machine) | ruban | Not "bande" |
| head (Turing machine) | tête de lecture | |
| transition function | fonction de transition | |
| tape alphabet | alphabet du ruban | |
| input alphabet | alphabet d'entrée | |
| accepting states | états acceptants | |
| mismatch | discordance | Not "non-correspondance" |
| soundness (logic) | correction | Not "cohérence" (which means consistency) |
| consistency (logic) | consistance | "cohérent/incohérent" acceptable but "consistant" is more precise |
| actual numbers (vs real numbers) | les nombres tels qu'ils sont | "nombres réels" means real numbers (mathematical term) |
| Turing complete | Turing-complet | Hyphenated in French |
| Universal Turing Machine | machine de Turing universelle (MTU) | |
| provably (unsolvable) | *démontrablement* (with emphasis) | "prouvablement" is not standard French |
| the evidence behind | le fondement empirique de | Not "la preuve qui sous-tend" |

## Style Conventions

- Use "on" for impersonal/general statements, "nous" sparingly for rhetorical emphasis
- Avoid "qui...qui" chains — use present participles to break repetition
- "illustration" works better than "anthropomorphisation" for pedagogical examples
- "autrement dit" for "in other words" / "the name for"
- Keep well-known English technical terms (e.g., "forward pass", "sleep-time agents") rather than creating awkward literal translations
- "avec un bémol" for "with one caveat" (conversational tone)
- "finit par atteindre" rather than "atteint finalement" (more natural word order)
- "passez-moi" over "donnez-moi" when mimicking casual speech ("hand me")
- "pourvu que" vs "si" — use "si" for simple conditions; "pourvu que" for provisions/provisos
- "a posé la question" flows better than "s'est demandé" for "X asked"
- Use verb forms when possible: "ils branchent, bouclent" not "ils font du branchement, des boucles"
- "slip through" (mistakes) = "passent inaperçues" not "passent à travers" (literal)
- "fluent in X" = "parle couramment X" not "fluent en X" (anglicism)
- "cringe" (noun, describing awkward content) = "la gêne" rather than "le malaise"
- "does it sound translated or native?" = "a-t-on l'impression d'une traduction ou d'un texte original ?" not "ça sonne traduit" (anglicism)
- "for reach" (audience) = "pour toucher un public plus large" not "pour la portée" (too abstract)
- "business/technical writing" (skill) = "rédiger en contexte professionnel/technique" not "vocabulaire" (writing is broader than vocabulary)
- "adding X to itself" (repeated operation) = "ajouter X à lui-même" not "additionner X à lui-même" (ajouter is more natural)
- "forward direction" (crypto) = "calcul direct" not "direction avant" (literal)
- "the hard direction" = "le sens difficile" not "la direction difficile"
- "the reverse direction" = "le sens inverse" not "la direction inverse"
- "Here's the algebra" = "Voici le raisonnement" not "Voici l'algèbre" (more natural)
- "secrecy" (as goal/property) = "confidentialité" not "le secret" (more precise in crypto context)
- "solves X" (protocol purpose) = "assure X" not "résout X" when X is a property like secrecy/authenticity
- **Series/part numbering:** Use "Partie N/M" format (e.g., "Partie 1/2") not "1re partie/2" or "Nème partie"
- "messaging apps" = "applications de messagerie" not "messageries" (which sounds like the service/platform rather than the app)
- "make sense" / "click" (understanding) = "cliquer" or "déclencher un déclic" not "faire sens" (anglicism)
- "rabbit hole" (topic to explore) = "sujet à creuser" not "terrier" (too literal)
- "the key insight" = "le point essentiel" not "l'insight clé" (anglicism)
- "iterate" (process) = "recommencer" not "itérer" (too technical/formal in conversational context)
- "six-pack" (abs) = "des abdos bien dessinés" or "des tablettes de chocolat" not "un ventre plat" (which lacks the muscular connotation)
- "despite starting at age X" = "alors que je n'ai commencé qu'à X ans" not "malgré un début à X ans" (more natural construction)
- "I go back and forth" (dialogue) = "On échange" not "J'avance par allers-retours" (awkward)
- "no vendor lock-in" = "rien de propriétaire" not "pas de dépendance à un fournisseur" (too long)
- "learner" (formal education context) = "élève" not "apprenant" (too jargony); in general/autodidact contexts, restructure to avoid the noun (e.g., "aide à apprendre", "le parcours de chacun")
- "per-reader adaptation" = "personnalisation individuelle" not "adaptation par lecteur" (unclear)
- "back-and-forth" (interactivity) = "dialogue" or "échange" not "aller-retour"
- Avoid starting sentences with "Mais" repeatedly → use "Cela dit," or embed "quand même" in sentence
- When translating quotes from external sources, preserve key adverbs like "dynamiquement"
- "fails you" (textbook) = "fait défaut" not "vous laisse en plan" (too informal/colloquial)
- Maintain "on" voice for consistency: "le document co-écrit" not "le document que vous co-écrivez" when rest of article uses "on"
- "artifact" (produced output you keep) = "ce que vous gardez" or "ce qui reste", not "artefact" (which means archaeological object or measurement distortion in French)
- "I got excited" (emotional reaction) = "Tout excité, je..." not "Je m'emballe" (which sounds more like getting carried away/overreacting)
- "anyone who's been through school" = "Quiconque a fait des études" not "Quiconque a traversé le système scolaire" (too literal/bureaucratic)
- "my textbook" (personal notes as learning material, autodidact context) = "mes notes de référence" not "mon support de cours" (implies formal coursework) or "mon manuel" (implies published textbook)
- "production system" = "système de production" not "vrai système" (technical term)
- "dinner parties" = "dîners" not "dîners d'amis" (simpler, more natural)
- "workaround" (informal) = "la solution" not "solution de contournement" (IT jargon)
- "natural language back-and-forth" = "le dialogue" not "l'échange en langage naturel" (too technical/NLP jargon)
- "have the material respond" (content adapting) = "que le contenu s'ajuste" not "que le contenu réponde" (captures dynamic adaptation)
- "resurfacing" (old news) = "qui refait surface" not "qui resurgit" (more idiomatic for news/content reappearing)
- "the flow looks like this" = "Voici comment ça se passe" not "Le flux ressemble à ceci" (too literal/technical)
- "circling similar ideas" = "converger vers les mêmes idées" not "tourner autour d'idées similaires" (more positive connotation)
- "patterns" (data/computing) = "motifs" not "patterns" (anglicism)
- "single-row lookups" = "lectures ponctuelles" not "recherches d'une seule ligne" (clearer, more idiomatic)
- "closed-form" (math) = "forme close" or "forme fermée" not "forme clausée"
- Avoid verb anglicisms like "seeker" - use native French verbs ("se positionner")
- "analytics workloads" = "traitements analytiques" not "charges analytiques" (workload = charge de travail, but in context "traitements" flows better)
- "Let's put concrete numbers to this" = "Passons aux chiffres" not "Mettons des chiffres concrets" (more natural imperative)
- "this is where X actually happens" = "C'est là qu'opère réellement X" not "C'est là que X se produit réellement" (more dynamic verb)
- Avoid redundant etymological pairs: "paie le coût de reconstruction pour réassembler" not "pour reconstituer" (reconstruction/reconstituer too close)
