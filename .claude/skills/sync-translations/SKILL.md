---
name: sync-translations
description: Manage blog post translations. Creates new translations for posts that don't have them, and syncs existing translations when English sources change.
---

# Sync Translations Skill

Create new translations and update existing ones. This skill handles both:

- **Creating** translations for posts that don't have them
- **Syncing** existing translations when the English source has changed

## Invocation

```
/sync-translations [post-name]
```

**Without argument:** Auto-detects all posts needing work (missing translations OR outdated ones).

**With argument:** Works on the specified post only.

- `/sync-translations kv-cache`
- `/sync-translations content/blog/turing-machines.md`

## Prerequisites

For **sync mode**: English source changes MUST be committed to git (provides clean diff baseline).

For **create mode**: No prerequisites.

## Helper Script

Run `check-sync.sh` to see translation status:

```bash
.claude/skills/sync-translations/check-sync.sh
```

Reports three statuses:

- `[NEEDS TRANSLATION]` - No translation exists for this language
- `[NEEDS SYNC]` - Translation exists but English has changed
- `[UP TO DATE]` - Translation is current

Languages are auto-detected from `config.toml`.

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

**Anchor fragments** (`#section-name`): When the English link has an anchor (e.g., `post.md#some-section`), translate the anchor to match the target post's heading slug. Zola generates slugs by lowercasing, replacing spaces with hyphens, and stripping accents. For Latin-script languages (FR), look up the translated heading and derive the slug. For CJK languages (JA), Zola's auto-romanization of headings produces fragile slugs; omit the anchor rather than guessing.

## Pre-Translation Checklist

Before translating or updating, do these steps:

1. **Collect established terminology**: For every internal link (`@/blog/...`), read the target translation (if it exists) and note vocabulary choices already used for shared concepts.
2. **Localize absolute URLs**: Replace `/contact/`, `/about/`, etc. with their localized versions (`/fr/contact/`, `/ja/contact/`).

## Translation Style

- **Default to native vocabulary** over loanwords. Only use katakana/anglicisms (Japanese) or anglicisms (French) for established technical terms or when no natural equivalent exists.
- **Match the source register**: if the English is conversational, the translation must be conversational. Avoid formal/academic/technical vocabulary when the English uses plain language.
- **Technical terms**: use accepted translations where they exist; keep English terms if no good translation exists.
- **Mathematical terms**: use standard target-language mathematical vocabulary.
- See the learnings file for vocabulary and style conventions.

## Workflow

### 1. Detect Work Needed

Run `check-sync.sh` (or inline logic) to categorize posts:

- `NEEDS_TRANSLATION` → create mode
- `NEEDS_SYNC` → sync mode

**Abort if:** No work needed, or uncommitted changes exist in content/blog/.

### 2. Process Posts

**For posts needing NEW translation (create mode):**

1. Read `.claude/translation-learnings/schema.md` and the learnings file (`.claude/translation-learnings/<lang>.jsonl`)
2. Read the source post completely
3. Translate following preservation rules and style guidelines
4. Write to `<source-basename>.<lang>.md` in the same directory

**For posts needing SYNC (update mode):**

1. Get git diff from translation's baseline commit
2. Read `.claude/translation-learnings/schema.md`, the learnings file, and the current translation
3. Apply targeted edits—preserve unchanged sections, translate only changed/added content

### 3. Editor Review (Required)

After translations are written/updated, invoke `translation-editor` subagents:

- **Fresh mode** (new translations): Full review of entire translation
- **Update mode** (syncs): Focus on changed sections, light touch elsewhere

For syncs, run editors **in parallel** (one per translation file).

Example invocation context for update mode:
> "This is an update sync for `three-proofs.fr.md`. The English source changed: [summary]. Focus review on those sections. Only edit this file."

### 4. Report Summary

- Which posts were processed
- Mode used (create vs sync)
- Summary of changes
- Any posts skipped

## Abort Conditions

| Condition | Message |
|-----------|---------|
| Uncommitted changes | "Uncommitted changes in content/blog/. Please commit first." |
| No work needed | "All translations are up to date." |
| Post not found (with arg) | "Could not find post: `<post-name>`" |

## Validation

Run `zola check` after all translations are created/updated.

---

## Learnings

- Keep tag values in English across all translations for consistent taxonomy
- The collaboration footer should be translated (see learnings files for language-specific wording)
- When adding a new language for the first time, create `content/blog/_index.<lang>.md` (the section index) or the build will fail
- Preserve acronym introduction patterns: if source introduces "full term (ACRONYM)" then uses "ACRONYM" later, the target text should follow the same pattern
- Maintain terminology consistency: if the source uses one term consistently (e.g., never mixing synonyms), the target text should use a single consistent term
- When prose explains notation choices (e.g., "I called it $n$ there; I'll use $d$ here"), convert the prose but keep the math symbols as-is
