---
name: blog-post
description: Write blog posts for Vincent's Zola blog. Use when asked to write, draft, or create a new blog post, or when helping with blog content.
---

# Blog Post Skill

Write blog posts matching Vincent's established style, tone, and complexity.

## Before Writing

Find the most recent English posts (exclude translations like `.fr.md`, `.ja.md`):
```bash
/bin/ls -t content/blog/*.md | grep -v '\.\(fr\|ja\)\.md$' | grep -v '_index' | head -3
```
Read them to absorb the current style—they are your ground truth.

## After Writing

If Vincent made style corrections or expressed preferences during the session, append them to the "Learnings" section at the bottom of this file. Keep entries concise (1-2 lines each).

## Style

### Voice
- **Conversational but precise**—explaining to a curious friend, not lecturing
- **First person**—"I want to explore", "Let's see what this means"
- **Humble curiosity**—share the learning journey, not just conclusions
- **Dense, no fluff**—respect the reader's time

### Structure
- **Hook**: Open with what sparked the exploration (a tweet, podcast, conversation, problem)
- **Short sections**: 2-4 paragraphs per `##` section; use questions as section transitions ("But can X do Y?")
- **Examples before definitions**: Build intuition first, then formalize
- **Footnotes for asides**: Keep tangents out of the main flow
- **Closing section**: "Takeaway", "Bottom Line", or "What's Next" (for series)
- **Footer**: `*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*`

### Technical Content
- Explain domain-specific notation piece by piece
- Use concrete examples and anthropomorphizations
- Proofs: rigorous but followable; use "Suppose, toward contradiction" phrasing
- Link to related posts with explicit names: `[my post on Russell's Paradox](@/blog/russells-paradox.md)`

### Formatting
- **Bold** key terms on first use
- KaTeX: `$...$` inline, `$$...$$` block; use `\lbrace`/`\rbrace` for set braces, `\*` for Kleene star
- `<details><summary>...</summary>...</details>` for optional deep-dives
- Tables: include a line explaining how to read them
- No emojis

### Series Posts
- Title format: "Title (Part N/M)"
- Link to previous/next parts at top and bottom
- Each part should stand alone while building on prior context

## Frontmatter

```toml
+++
title = "Post Title"
date = YYYY-MM-DD
description = "One sentence hook"

[taxonomies]
tags = ["lowercase-tag"]  # typically 1-2 tags

[extra]
katex = true  # only if using math
+++
```

## Output

Create the post at `content/blog/slug-matching-title.md`.

---

## Learnings

- Don't run `zola serve`; Vincent prefers to run it himself
- Don't run `zola check` after every small edit; batch validation at the end
- For long/complex topics, propose splitting into multiple posts before writing
- Minimize em dashes; prefer colons, semicolons, periods, or parentheses
- Don't make unsubstantiated claims; if something hasn't been proven in the post, don't assert it
- Don't claim something is "expected" or "obvious" when it's actually surprising
- When contrasting concepts, explain WHY the distinction matters
- Every section needs motivation; answer "why am I reading this?" before diving in
- Twitter/X embeds: use `data-theme="dark"` and `data-align="center"`; needs CSP config for `platform.twitter.com`
- Anchor links: use standalone `<a id="..."></a>` elements; `id` on other elements doesn't work reliably in Zola
- Math-heavy posts: use display math liberally; equations should be easy to spot, not buried in prose
- Use bullet points for lists of examples, axioms, verification steps; less prose for technical content
- Announce structure upfront when introducing multi-part concepts
- Define terms that seem obvious but aren't; geometric or informal language may need algebraic clarification
- List edge cases explicitly; don't leave them implicit or assume the reader will infer them
- Explain concepts before naming them; show the technique first, then give it a name
- Use consistent notation throughout; don't introduce new variable names mid-post without explanation
- Qualify claims about real-world applications; distinguish the mathematical foundation from implementation details
- Intro should promise a concrete reward: "by the end you'll understand X"
