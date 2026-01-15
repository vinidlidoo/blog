+++
title = "Translation with Claude Code Skills"
date = 2026-01-14
description = "How custom skills and subagents make multilingual publishing faster, cheaper, and better than manual translation"

[taxonomies]
tags = ["dev"]
+++

![translation with claude code](/img/translation-with-claude-code-main-image.webp)

I can now translate every blog post into French and Japanese in under a minute, with no manual edits. The translations read incredibly natural, even for my most technical content. And with a Claude subscription, the marginal cost is zero. Hard not to be AI-pilled these days.

This post explains how I built this using Claude Code **skills** and **subagents**.

## Skills and Subagents

Two Claude Code features make this possible.

A **[skill](https://docs.anthropic.com/en/docs/claude-code/skills)** is a reusable prompt that teaches Claude how to perform a specific task. Skills can read files, run shell scripts, and coordinate complex workflows. You can invoke them with a slash command (like `/sync-translations` as we'll see in the next section), or Claude Code can trigger them automatically based on context. 

A **[subagent](https://docs.anthropic.com/en/docs/claude-code/sub-agents)** is a separate Claude instance that the main agent can spawn. Each subagent has its own system prompt, starts with a fresh context window, and doesn't pollute the main agent's context with its work. Multiple subagents can run in parallel. All of these properties turn out to matter for quality.

## The System at a Glance

This blog runs on Zola with markdown files. The approach generalizes to any blog with human-readable source files. Here's the relevant structure:

```
.claude/
├── skills/
│   └── sync-translations/
│       ├── SKILL.md          # the skill definition
│       └── check-sync.sh     # detects what needs work
├── agents/
│   └── translation-editor.md # reviews translations
└── translation-learnings/
    ├── fr.md                 # French terminology & style
    └── ja.md                 # Japanese terminology & style

content/blog/
├── kv-cache-invalidation.md     # English original
├── kv-cache-invalidation.fr.md  # French translation
├── kv-cache-invalidation.ja.md  # Japanese translation
├── translation-with-claude-code.md       # this post (no translations yet)
└── ...
```

The main agent orchestrates everything using the [sync-translations](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/skills/sync-translations/SKILL.md) **skill**. It runs the `check-sync.sh` shell script to detect what needs work, reads `{fr.md, ja.md}` in the [translation-learnings](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude/translation-learnings) directory for terminology guidance, drafts translations, then spawns two [translation-editor](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/agents/translation-editor.md) **subagents** (one for each language) to review them with fresh eyes. The editors feed discoveries back into the learnings files, so the system improves over time:

<img src="/img/translation-workflow.svg" alt="Translation workflow diagram" />

## Detecting What Needs Work

The first step for the main agent is to run the [`check-sync.sh`](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/skills/sync-translations/check-sync.sh).[^1] For each English post and target language, it outputs one of three states: **NEW** (no translation file exists), **SYNC** (translation exists but English changed), or **ABORT** (translation is current).

NEW and ABORT are straightforward file checks. SYNC is trickier. We need git history—not just file modification times—because the agent needs to know *what* changed, not just *that* something changed. Without the exact diff, it would re-translate the entire post. Minor changes get lost in the shuffle, and polished sections get unnecessarily rewritten.

The script finds when the translation *content* was last updated, then extracts the English diff since. For a post like `kv-cache-invalidation.md` with French translation `kv-cache-invalidation.fr.md`:

```bash
# Find the commit where French content last changed (not just renamed)
baseline=$(git log --follow --format="%H" -- "kv-cache-invalidation.fr.md" \
    | while read commit; do
        # Check if this commit had real content changes (not just +++ --- headers)
        changes=$(git show "$commit" -- "kv-cache-invalidation.fr.md" | grep -c "^[-+]")
        [[ "$changes" -gt 4 ]] && echo "$commit" && break
    done)

# Check if English changed since that baseline
git diff "$baseline"..HEAD -- "kv-cache-invalidation.md"
```

Any diff output means the English source diverged and the translation needs syncing.

[^1]: The script uses different labels internally: `NEEDS TRANSLATION`, `NEEDS SYNC`, and `UP TO DATE`.

## Drafter and Editor

The main agent drafts translations, writes them to disk, then spawns a separate [editor subagent](https://github.com/vinidlidoo/vinidlidoo.github.io/blob/main/.claude/agents/translation-editor.md) to review them. The editor starts with a clean context—it sees only the English source, the draft translation, and a shared learnings file (more on that below). It checks for naturalness (does this sound translated or native?), idiom adaptation (were English expressions translated by meaning, not literally?), technical terminology (standard terms in the target language?), and voice (does it still sound like me?).

Why not have the main agent review its own work? Bias. When you've just written something, the phrasing looks fine because you just chose it. Awkward constructions slip through. A fresh reader catches what the writer misses. This is true for humans; it's true for LLMs too.

The handoff depends on context. For new translations, the editor does a full review. For syncs, it focuses on changed sections—the rest was already reviewed. And since each language gets its own editor working on an independent file, they run in parallel.

## Learnings That Accumulate

Both agents share a [learnings file](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude/translation-learnings) per language. The main agent reads it before drafting; the editor reads it during review and appends new discoveries afterward. This creates a feedback loop: each translation makes the next one better.

For French, the file now captures that "proof by contradiction" should be "par l'absurde" (not the literal "en vue d'une contradiction"), that "attends to" in attention mechanisms means "prête attention à" (not "assiste à"), and that technical terms like "forward pass" should stay in English.

For Japanese, it records to avoid em dashes entirely (they're not standard in Japanese text), that "sent me down a rabbit hole" becomes 「沼にはまってしまった」 (fell into a swamp—a natural Japanese idiom for obsessive exploration), and that series numbering should use 「第N回/全M回」 format.

These aren't rules I wrote upfront. They emerged from editing sessions and compound with each post.

## Bottom Line

I'm a native French speaker who spent a decade living and working in Japan. Writing this blog in English made sense for reach, but it meant leaving readers (friends and family) behind.

The alternatives weren't great. Manual translation would take 3-4 hours per post per language, and the quality would be hard to get right: I learned my business and technical writing in English, my math in French, and while I'm fluent in Japanese, writing polished prose is a skill I haven't practiced much. Professional translation is expensive. And anyone who's read Google Translate output for technical content knows the cringe: awkward phrasing, wrong terminology, prose that screams "I am a robot."

This changes the game. The translations aren't perfect, but darn close. They cost me nothing but a minute of waiting. I wouldn't have bothered translating this blog without that option available to me. I suspect we'll see a lot more multilingual content online in the months to come.

The system took a few hours to build. Now I just write in English, commit, and run `/sync-translations`. This post was translated using it—if you read the French or Japanese version, you're seeing the result. If you want to build something similar, follow the links throughout this post or explore the [full repo](https://github.com/vinidlidoo/vinidlidoo.github.io/tree/main/.claude).

---

*This post was written in collaboration with [Claude](https://claude.ai) (Opus 4.5).*
