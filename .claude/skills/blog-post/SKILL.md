---
name: blog-post
description: Write or edit blog posts for Vincent's Zola blog. Use when asked to edit an existing or create a new blog post, or when helping with blog content.
---

# Blog Post Skill

Write or edit blog posts matching Vincent's established style, tone, and complexity.

## Before Writing

Find the most recent English posts (exclude translations like `.fr.md`, `.ja.md`):
```bash
/bin/ls -t content/blog/*.md | grep -v '\.\(fr\|ja\)\.md$' | grep -v '_index' | head -3
```
Read them to absorb the current style—they are your ground truth.

For long/complex topics, propose splitting into multiple posts before writing.

## After Writing

If Vincent made style corrections or expressed preferences during the session, append them to the "Learnings" section at the bottom of this file. Keep entries concise (1-2 lines each).

## Style

### Voice
- **Conversational but precise**—explaining to a curious friend, not lecturing
- **First person**—"I want to explore", "Let's see what this means"
- **Humble curiosity**—share the learning journey, not just conclusions
- **Dense, no fluff**—respect the reader's time
- **Honest about difficulty**—don't claim something is "expected" or "obvious" when it's actually surprising

### Structure
- **Hook**: Open with what sparked the exploration (a tweet, podcast, conversation, problem); promise a concrete reward ("by the end you'll understand X")
- **Motivate each section**: Answer "why am I reading this?" before diving in
- **Short sections**: 2-4 paragraphs per `##` section; use questions as section transitions ("But can X do Y?")
- **Announce structure upfront**: When introducing multi-part concepts, state the count and breakdown
- **Examples before definitions**: Build intuition first, then formalize
- **Footnotes for asides**: Keep tangents out of the main flow
- **Closing section**: "Takeaway", "Bottom Line", or "What's Next" (for series)
- **Footer**: `*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*`

### Technical Content
- Explain domain-specific notation piece by piece; use consistent notation throughout
- Use concrete examples and anthropomorphizations
- Explain concepts before naming them; show the technique first, then give it a name
- Define terms that seem obvious but aren't; geometric or informal language may need algebraic clarification
- List edge cases explicitly; don't leave them implicit
- When contrasting concepts, explain WHY the distinction matters
- Don't make unsubstantiated claims; if something hasn't been proven in the post, don't assert it
- Qualify claims about real-world applications; distinguish the mathematical foundation from implementation details
- Proofs: rigorous but followable; use "Suppose, toward contradiction" phrasing
- Link to related posts with explicit names: `[my post on Russell's Paradox](@/blog/russells-paradox.md)`

### Math-Heavy Posts
- Use display math liberally; equations should be easy to spot, not buried in prose
- Use bullet points for lists of examples, axioms, verification steps; less prose for technical content

### Formatting
- **Bold** key terms on first use
- Minimize em dashes; prefer colons, semicolons, periods, or parentheses
- KaTeX: `$...$` inline, `$$...$$` block; use `\lbrace`/`\rbrace` for set braces, `\*` for Kleene star
- `<details><summary>...</summary>...</details>` for optional deep-dives
- Tables: include a line explaining how to read them
- Twitter/X embeds: use `data-theme="dark"` and `data-align="center"`; needs CSP config for `platform.twitter.com`
- Anchor links: use standalone `<a id="..."></a>` elements; `id` on other elements doesn't work reliably in Zola
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

Don't run `zola serve` or `zola check` during editing; Vincent prefers to run these himself. Batch validation at the end if needed.

---

## Learnings

- **Numbered lists reset** when interrupted by non-list content. Use HTML `<ol start="N">` to continue numbering across sections.
- **Critiquing external work**: One jab is enough, then be constructive. Frame as "opens a door" not "failed to deliver." Avoid sounding bitter or sarcastic.
- **Section titles**: Be specific and descriptive. Generic titles like "On This Blog" or "The Full Loop" are weaker than titles that capture the actual content.
- **Parallel structure for multi-topic sections**: When covering related topics in one section, use parallel framing ("On X:... On Y:...") to tie them together.
- **Avoid redundant sentences**: Don't say the same thing twice in different words. If two consecutive sentences make the same point, pick one.
- **Sentence fragments**: Starting a sentence with "And" can work for effect, but don't do it without strong intention. When in doubt, integrate into the previous sentence.
- **Genuine acknowledgment**: When pivoting from criticism to opportunity, be honest about the limitation first. Jumping straight to "it's an opening" can feel forced if you haven't earned it.
- **Caveats for vision sections**: Acknowledge hard problems honestly. Shows intellectual honesty without undermining the argument.
- **Tech Twitter naming**: For memeable concept names, use established patterns like "-first", "-native", or classical references.
- **Conversational rhythm**: Prefer flowing constructions ("Not exactly breaking, more like resurfacing") over terse ones ("Not breaking, just resurfacing").
- **Rhetorical momentum**: Answer your own questions to drive forward ("I was left wondering if X. No, there's probably Y.") rather than leaving them hanging.
- **Concrete framing**: "The flow looks like this" beats "The vision I keep returning to." Ground descriptions in what's happening, not how you feel about it.
- **Soften alignment claims**: "It looks like we're circling similar ideas" is more honest than asserting you and others are aligned.
- **Media continuity**: When embedding audio/video, keep the follow-up commentary attached to the preceding context. Don't orphan explanatory sentences after media blocks.
