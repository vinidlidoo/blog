---
name: blog-post
description: Create blog post outlines and drafts for Vincent's Zola blog. Orchestrates agent teams for research, outline creation, and style review. Use when asked to create a new outline, write or edit a blog post, or help with blog content.
---

# Blog Post Skill

Orchestrate blog post creation using agent teams. The primary workflow spins up parallel research agents, synthesizes their output into an outline, and runs a critique-revise loop before presenting to the user.

For long/complex topics, propose splitting into multiple posts before outlining.

## Workflows

### Workflow 1: Creating an Outline

Use when: User provides a transcript (from Claude conversation) or a brief describing what they want to write about.

**Steps:** Use agent teams (`TeamCreate`) to orchestrate the workflow. All teammates persist across phases (no respawning).

1. **Create team and spin up research phase** — Create a team with `TeamCreate`, then spawn teammates in parallel:
   - **Transcript researcher** — Use the `transcript-researcher` agent (`.claude/agents/transcript-researcher.md`). Reads source material, extracts key ideas, technical claims, and structural suggestions. Writes a structured brief to `drafts/briefs/<topic>-transcript-brief.md`. Skip if source material is short enough to fit in the outline writer's context.
   - **Web researcher** — Spawn as an ad-hoc `general-purpose` Task agent with per-session instructions. Proactively researches the topic: finds relevant papers, blog posts, specs, and prior art. Also fetches any specific references provided by the user or found in source material. Writes findings to `drafts/briefs/<topic>-web-research.md`.
   - **Style critic** — Use the `style-critic` agent (`.claude/agents/style-critic.md`). Reads recent posts (by recency and by tag) and the Style/Learnings sections of this skill. Internalizes patterns for the critique phase.

2. **Outline writing** — Spawn an ad-hoc `general-purpose` Task agent as the outline writer. Instruct it to read this skill file for style guidance, check memory files for series context (notation, scope boundaries from prior sessions), and synthesize all research briefs from `drafts/briefs/` into a draft outline in `drafts/outlines/`, following the outline template at `.claude/skills/blog-post/outline-template.md`.

3. **Critique-revise loop** — The style critic (same agent from step 1) reviews the outline, the outline writer revises. Coordinate via `SendMessage`. Repeat once (two critique rounds max).

4. **Present to user** — Final outline with a summary of what the critics flagged and what was addressed. Shut down teammates.

Note: For simple posts with short source material, the transcript researcher can be skipped, but the web researcher and style critic should always run.

### Workflow 2: Writing from Outline

Use when: User has an approved outline in `drafts/outlines/` and wants the full post written.

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

If Vincent made style corrections or expressed preferences during the session, append them to the "Learnings" section at the bottom of this file. Keep entries concise (1-2 lines each). All learnings are valid immediately.

**Consolidation** happens separately, when the style-critic agent runs at the start of a new outline session. It reads both sections and:

- Moves Learnings entries into the appropriate Style subsections (Voice, Structure, Formatting, etc.)
- Combines related entries and removes duplicates with existing Style rules
- Only removes a Learning if Vincent has explicitly contradicted it with a newer preference

## Style

### Voice

- **Conversational but precise**—explaining to a curious friend, not lecturing
- **First person**—"I want to explore", "Let's see what this means"
- **Humble curiosity**—share the learning journey, not just conclusions
- **Dense, no fluff**—respect the reader's time; don't say the same thing twice in different words
- **Honest about difficulty**—don't claim something is "expected" or "obvious" when it's actually surprising
- **Flowing rhythm**—prefer flowing constructions ("Not exactly breaking, more like resurfacing") over terse ones; answer your own rhetorical questions to drive forward rather than leaving them hanging
- **Concrete framing**—ground descriptions in what's happening ("The flow looks like this"), not how you feel about it ("The vision I keep returning to")
- **One critique, then constructive**—when critiquing external work, one jab is enough. Frame as "opens a door" not "failed to deliver"
- **Genuine acknowledgment**—when pivoting from criticism to opportunity, be honest about the limitation first
- **Soften alignment claims**—"It looks like we're circling similar ideas" beats asserting alignment
- **Don't double-hedge**—one hedge per claim is enough
- **Sentence fragments sparingly**—starting with "And" can work for effect, but when in doubt, integrate into the previous sentence
- **Avoid "Because" openers**—prefer "X, so Y" constructions; use "Because" sparingly for effect only
- **No sarcastic rhetorical openers**—questions like "So what's the framework good for?" read as dismissive; lead with the payoff directly

### Structure

- **Hook**: Open with what sparked the exploration (a tweet, podcast, conversation, problem); promise a concrete reward ("by the end you'll understand X")
- **Motivate each section**: Answer "why am I reading this?" before diving in
- **Short sections**: 2-4 paragraphs per `##` section; use questions as section transitions ("But can X do Y?")
- **Announce structure upfront**: When introducing multi-part concepts, state the count and breakdown
- **Examples before definitions**: Build intuition first, then formalize; demonstrate value through a concrete scenario rather than explaining what something is good for
- **Specific section titles**: Capture the actual content; generic titles like "On This Blog" or "The Full Loop" are weaker than descriptive ones
- **Parallel structure**: When covering related topics in one section, use parallel framing ("On X:... On Y:...") to tie them together
- **Footnotes for asides**: Keep tangents out of the main flow
- **Media continuity**: When embedding audio/video, keep follow-up commentary attached to preceding context; don't orphan explanatory sentences after media blocks
- **Closing section**: "Takeaway", "Bottom Line", or "What's Next" (for series)
- **Footer**: Auto-generated by the site template. Do not add manually.

### Technical Content

- Explain domain-specific notation piece by piece; use consistent notation throughout
- Use concrete examples and anthropomorphizations
- Explain concepts before naming them; show the technique first, then give it a name. Use plain language before introducing terminology
- Define terms that seem obvious but aren't; geometric or informal language may need algebraic clarification
- List edge cases explicitly; don't leave them implicit
- When contrasting concepts, explain WHY the distinction matters
- Don't make unsubstantiated claims; if something hasn't been proven in the post, don't assert it
- Qualify claims about real-world applications; distinguish the mathematical foundation from implementation details
- Acknowledge hard problems honestly in vision/future sections; shows intellectual honesty without undermining the argument
- Proofs: rigorous but followable; use "Suppose, toward contradiction" phrasing
- Link to related posts with explicit names: `[my post on Russell's Paradox](@/blog/russells-paradox.md)`

### Math-Heavy Posts

- Use display math liberally; equations should be easy to spot, not buried in prose
- Use bullet points for lists of examples, axioms, verification steps; less prose for technical content

### Formatting

- **Bold** key terms on first use
- Avoid em dashes; use colons, semicolons, periods, or parentheses instead. On the rare occasion one is needed, use `—` (em dash character), never `--` (double hyphen)
- KaTeX: `$...$` inline, `$$...$$` block; use `\lbrace`/`\rbrace` for set braces, `\*` for Kleene star
- KaTeX underscore escaping: inside `\text{}`, use `\text{node\\_hash}`; for subscripts after `\text{}`, use `\text{child}\_{0}` not `\text{child}_0`
- KaTeX array line breaks: use `\\\` (three backslashes) inside `\begin{array}` environments; prefer `\begin{array}{ll}` with `\left\lbrace...\right.` over `\begin{cases}` which is flaky
- Escape tildes for approximation: use `\~` instead of `~` (e.g., `\~100 GB`) to avoid strikethrough interpretation
- Numbered lists that span non-list content: use HTML `<ol start="N">` to continue numbering
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

- **Outlines** go to `drafts/outlines/topic-name.md`
- **Final posts** go to `content/blog/slug-matching-title.md`

Don't run `zola serve` or `zola check` during editing; Vincent prefers to run these himself. Batch validation at the end if needed.

---

## Learnings

(All prior entries consolidated into Style subsections above.)

- Don't quote concrete numbers (byte sizes, percentages) before the reader has the machinery to understand where they come from. Stay conceptual in setup/hypothesis sections; let later sections deliver the specifics.
- Be precise about what's actually surprising. Before writing "how can X do Y?", ask: does something the reader already knows also do Y? If so, sharpen the claim to what's genuinely new.
- Avoid hand-wavy abstract phrases like "all-or-nothing operation." Show a concrete formula or example instead of describing a property in words.
- Don't introduce technical details (e.g., finite fields, specific algorithms) before the reader needs them. If a concept only matters in a later section, let that section introduce it. Transition paragraphs should do one job: bridge the reader forward.
- Build up to key equations: show the derivation step by step, then present the clean formula as the payoff. Don't drop an equation first and justify it after.
- Late sections should shed complexity, not add it. The reader is fatigued after hard technical content. Closing/future-looking sections should use plain language, avoid new jargon, and strip optional details (tables, details blocks) when the main text already covers the point.
- When mentioning technology that supersedes what the post teaches, frame the current content as foundational, not obsolete. Don't undercut the reader's investment.
- Link on the concept, not the container. `[finite field](@/blog/...)` beats `my post on [X](@/blog/...)` or `[post](@/blog/...)`. The link text should be the most informative word.
- Don't repeat formulas or expressions within a few lines. If $C = P(s) \cdot G$ just appeared, use "this $C$" or prose instead of restating it.
- Introduce terminology through action, not definition. "Alice wants to **open** the commitment" beats "In cryptography, revealing a value is called **opening**." Show the term in use; the reader absorbs the definition from context.
- When introducing unfamiliar terms in late/closing sections, frame them as variants or swaps, not prerequisites. "Swaps in different building blocks: a different X, Y, and Z" reassures the reader they don't need to understand each one.
- Use `\tag{N}` for important equations referenced later. Refer back with "equation $(N)$", not bare "$(N)$".
- Consistent terminology: pick one term for a concept (e.g., "public parameters" not sometimes "public points" or "public curve points") and bold it on first use.
