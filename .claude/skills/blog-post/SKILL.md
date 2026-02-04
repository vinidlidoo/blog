---
name: blog-post
description: Write or edit blog posts for Vincent's Zola blog. Use when asked to edit an existing or create a new blog post, or when helping with blog content.
---

# Blog Post Skill

Write or edit blog posts matching Vincent's established style, tone, and complexity.

## Before Writing

Find the most recent English posts (exclude translations like `.fr.md`, `.ja.md`):

```bash
/bin/ls -t content/blog/*.md | rg -v '\.(fr|ja)\.md$' | rg -v '_index' | head -3
```

Read them to absorb the current style—they are your ground truth.

For long/complex topics, propose splitting into multiple posts before writing.

## Workflows

### Workflow 1: Creating an Outline

Use when: User provides a transcript (from Claude conversation) or a brief describing what they want to write about.

**Steps:**

1. **Absorb style** — Read 2-3 recent posts (see "Before Writing")

2. **Draft outline** — Create outline in `drafts/` folder with:
   - Working title and target audience
   - Hook summary
   - Numbered sections with **Main message** for each
   - Key points/examples per section
   - Planned diagrams, tables, or code blocks

3. **First sub-agent review** — Spin up a Plan agent to critically review for:
   - Technical accuracy (are claims correct? examples valid?)
   - Pedagogical flow (concepts introduced before used? logical progression?)
   - Gaps and missing connections
   - Balance (benefits vs tradeoffs, not overselling)

   The agent should NOT read the source transcript—review the outline on its own merits.

4. **Prioritize feedback** — Present reviewer feedback to user as a prioritized task list (use your judgment on priority). User decides what to implement.

5. **Iterate with user** — Address selected feedback through back-and-forth. User may leave `<!-- FEEDBACK: ... -->` comments directly in the outline file.

6. **Second sub-agent review** — Spin up another Plan agent, providing context:
   - Summary of what first reviewer said
   - What was implemented
   - What was intentionally deferred (and why)

   Focus: Do the changes work? Any new issues introduced? Ready for drafting?

7. **Final outline** — Outline is approved when user is satisfied after second review.

### Workflow 2: Writing from Outline

Use when: User has an approved outline in `drafts/` and wants the full post written.

**Steps:**

1. **Absorb style** — Read 2-3 recent posts (if not already done during outline phase)

2. **Write post** — Follow the outline section by section:
   - Expand main messages into full prose
   - Add transitions between sections
   - Include planned diagrams/tables
   - Match voice and formatting from Style section below

3. **User review** — User reads draft and provides feedback or direct edits

4. **Iterate** — Address feedback until user approves

5. **Finalize** — Create final post at `content/blog/slug-matching-title.md`

### Workflow 3: Editing an Existing Post

Use when: User wants targeted changes to a published or draft post.

**Steps:**

1. **Read the post** — Understand current content, structure, and tone

2. **Clarify scope** — If unclear, ask user what specifically needs changing

3. **Make targeted edits** — Change only what's requested; don't restructure or rewrite unless asked

4. **User review** — User approves changes

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

- **Outlines** go to `drafts/topic-name.md`
- **Final posts** go to `content/blog/slug-matching-title.md`

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
- **Don't start sentences with "Because"**: Use sparingly for effect only. Prefer "X, so Y" constructions.
- **Introduce terminology before using it**: If a concept hasn't been explained yet, use plain language first.
- **Show, don't tell**: When introducing a framework or tool, demonstrate its value through a concrete scenario rather than explaining what it's good for.
- **Avoid sarcastic rhetorical openers**: Questions like "So what's the framework good for?" read as dry and dismissive. Lead with the payoff directly.
- **Don't double-hedge**: One hedge per claim is enough. "As far as I can tell, it's comprehensive" works; "As far as I can tell, it's comprehensive enough" undermines itself.
- **KaTeX underscore escaping**: Markdown processes underscores before KaTeX. Inside `\text{}`, use double backslash: `\text{node\\_hash}`. For subscripts after `\text{}`, escape and use braces: `\text{child}\_{0}` not `\text{child}_0`.
- **KaTeX array line breaks**: Use three backslashes `\\\` for line breaks inside `\begin{array}` environments. Two backslashes `\\` won't work. Also prefer `\begin{array}{ll}...\end{array}` with `\left\lbrace...\right.` over `\begin{cases}` which is flaky in KaTeX.
- **Escape tildes for approximation**: Use `\~` instead of `~` for "approximately" (e.g., `\~100 GB`). Unescaped tildes can be misinterpreted as strikethrough markers by some editors/renderers.
