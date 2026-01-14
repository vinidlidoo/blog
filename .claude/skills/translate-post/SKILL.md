---
name: translate-post
description: Translate blog posts to other languages. Use when asked to translate a post, create a French/Spanish/etc version, or add a translation.
---

# Translate Post Skill

Translate blog posts while preserving structure, formatting, and technical content.

## Invocation

```
/translate-post <source-file> <target-language>
```

Examples:
- `/translate-post russells-paradox.md fr`
- `/translate-post content/blog/turing-machines.md es`

## Before Translating

1. Read the learnings file for the target language (`.claude/translation-learnings/<lang>.md`) if it exists
2. Read the source post completely
3. Identify elements that must NOT be translated (see Preservation Rules below)
4. Optionally read 1-2 existing translations to absorb Vincent's tone in that language

## Preservation Rules

**Never translate these elements:**

| Element | Example | Reason |
|---------|---------|--------|
| KaTeX inline | `$x \notin x$` | Math notation is universal |
| KaTeX block | `$$R = \lbrace x : x \notin x\rbrace$$` | Math notation is universal |
| Code blocks | ``` `code` ``` | Code is language-agnostic |
| URLs | `https://...` | Links must remain functional |
| Frontmatter keys | `title`, `date`, `tags` | TOML structure |
| Tag values | `["math", "cs"]` | Keep tags in English for consistency |
| HTML tags | `<details>`, `<summary>` | Structure markers |
| Footnote markers | `[^1]`, `[^2]` | Syntax elements |

**Always translate:**

- `title` value in frontmatter
- `description` value in frontmatter
- All prose paragraphs
- Text inside `<summary>` tags
- Content inside `<details>` blocks (excluding math/code)
- Link display text (the `[text]` part of `[text](url)`)
- Footnote content

## Internal Links

For internal links (`@/blog/post-name.md`), check if a translation exists for the target language:

1. If `post-name.<lang>.md` exists → link to `@/blog/post-name.<lang>.md`
2. If no translation exists → keep the English link `@/blog/post-name.md`

Example for French translation:
- `[Three Proofs](@/blog/three-proofs.md)` → `[Trois preuves](@/blog/three-proofs.fr.md)` (if `.fr.md` exists)

## Translation Style

- **Match Vincent's tone**: conversational, precise, first-person ("Je veux explorer...")
- **Adapt idioms**: translate meaning, not words ("sent me down a rabbit hole" → "m'a entraîné dans une exploration")
- **Technical terms**: use accepted translations where they exist; keep English terms in italics if no good translation exists
- **Mathematical terms**: use standard French mathematical vocabulary (ensemble, élément, appartient, etc.)

## Output

Write the translated file to: `<source-basename>.<lang>.md`

Example: `russells-paradox.md` → `russells-paradox.fr.md`

The file goes in the same directory as the source.

## After Translating

### Required: Editor Review

After completing the initial translation, you MUST invoke the `translation-editor` subagent to review and refine the translation:

```
Use the translation-editor subagent to review <source-file> and <translated-file>
```

The translation is NOT complete until the editor subagent has:
1. Reviewed the translation
2. Made any necessary refinements
3. Reported its findings

### Validation

1. Run `zola check` to validate
2. If Vincent made corrections, add learnings below

---

## Learnings

- Keep tag values in English across all translations for consistent taxonomy
- The collaboration footer should be translated: "Ce billet a été écrit en collaboration avec..."
- When adding a new language for the first time, create `content/blog/_index.<lang>.md` (the section index) or the build will fail
