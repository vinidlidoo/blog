---
name: blog-post
description: Write blog posts for Vincent's Zola blog. Use when asked to write, draft, or create a new blog post, or when helping with blog content.
---

# Blog Post Skill

Write blog posts matching Vincent's established style, tone, and complexity.

## Before Writing

Run `/bin/ls -t content/blog/*.md | head -3` to find the most recent posts (use `/bin/ls` since `ls` may be aliased to `eza`), then read them to absorb the current style—they are your ground truth.

## After Writing

If Vincent made style corrections or expressed preferences during the session, append them to the "Learnings" section at the bottom of this file. Keep entries concise (1-2 lines each).

## Style Principles

### Tone
- **Conversational but precise**—write like explaining to a curious friend, not lecturing
- **First person**—"I want to explore", "Let's see what this means"
- **No fluff**—get to the point, respect the reader's time
- **Humble curiosity**—share the learning journey, not just conclusions

### Structure
- Open with a hook: what sparked this exploration (podcast, problem, question)
- Use `##` headers to break into clear sections
- Build concepts progressively—don't assume, but don't over-explain
- End with a "Takeaway" section that crystallizes the insight
- Footer: `*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*`

### Complexity
- Assume basic literacy but explain domain-specific notation
- Introduce notation piece by piece (e.g., "Reading it piece by piece: $\lbrace \rbrace$ means...")
- Use concrete examples and anthropomorphizations to ground abstract concepts
- Rigorous but not overly formal—proofs should be followable, not intimidating

### Formatting
- **Bold** for key terms on first use
- KaTeX for math: `$...$` inline, `$$...$$` block
- Use `\lbrace` and `\rbrace` for set braces in KaTeX
- `<details><summary>...</summary>...</details>` for optional deep-dives
- No emojis unless explicitly requested

## Frontmatter Template

```toml
+++
title = "Post Title"
date = YYYY-MM-DD
description = "One-sentence hook for the post"

[taxonomies]
tags = ["tag1", "tag2"]

[extra]
katex = true  # if using math
+++
```

## Output

Create the post at `content/blog/slug-matching-title.md`.

---

## Learnings

- Don't run `zola serve`; Vincent prefers to run it himself
- For long/complex topics, propose splitting into multiple posts before writing
- Minimize em dashes; prefer colons, semicolons, periods, or parentheses instead
- Put examples before formal definitions for accessibility; let readers build intuition first
- Remove tangential comparisons that don't serve the main point (keep focus tight)
- Connect abstract insights back to concrete examples from the post
- Link to related posts when introducing concepts (e.g., set-builder notation → Russell's Paradox post)
- Don't make unsubstantiated claims; if something hasn't been proven in the post, don't assert it
- Use `\*` to escape Kleene star (`^*`) in KaTeX to avoid markdown parsing issues
- Twitter/X embeds: need CSP config in `config.toml` for `platform.twitter.com` (both `script-src` and `frame-src`); use `data-theme="dark"` and `data-align="center"`
- Anchor links: use standalone `<a id="..."></a>` elements for jump targets; `id` on embedded HTML elements doesn't work reliably in Zola
