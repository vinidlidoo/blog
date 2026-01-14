---
name: sync-translations
description: Sync edits from English posts to existing translations. Use when you've updated an English post and want to propagate changes to FR/JA versions.
---

# Sync Translations Skill

Update existing translations after English sources have been edited.

## Invocation

```
/sync-translations [post-name]
```

**Without argument:** Auto-detects all changed English posts in `content/blog/` and syncs those with existing translations.

**With argument:** Syncs only the specified post.
- `/sync-translations kv-cache`
- `/sync-translations content/blog/turing-machines.md`

## Prerequisites

English source changes MUST be committed to git. This provides a clean diff baseline.

## Helper Script

Run `check-sync.sh` to see which translations need syncing:

```bash
.claude/skills/sync-translations/check-sync.sh
```

## Workflow

### 1. Detect Posts Needing Sync

**Key insight:** Find when each translation's CONTENT was last updated (not just touched—renames don't count), then check if English changed since.

**For each English post in `content/blog/` (or the specified post):**

1. Find translations (`.fr.md`, `.ja.md`, etc.)
2. For each translation, find its last content-change commit (skip renames):
   ```bash
   # Find commit where translation had actual content changes (>4 diff lines)
   git log --format="%H" --follow -- <trans-file> | while read commit; do
       changes=$(git show "$commit" -- "$trans-file" | grep -c "^[-+]")
       [[ "$changes" -gt 4 ]] && echo "$commit" && break
   done
   ```
3. Check if English source changed since that commit:
   ```bash
   git diff <baseline-commit>..HEAD -- <english-file>
   ```
4. If diff is non-empty, this translation needs syncing

**If no argument provided:** Check all English posts, collect those needing sync.

**If argument provided:** Check only the specified post.

**Abort if:** No posts need syncing, or uncommitted changes exist.

### 2. For Each Post: Analyze and Update

For each post to sync:

1. Get git diff from translation's baseline:
   ```bash
   git diff <translation-last-commit>..HEAD -- <english-file>
   ```
2. Summarize what changed (sections, paragraphs)
3. For each translation needing update:
   - Read the current translation
   - Read the learnings file (`.claude/translation-learnings/<lang>.md`)
   - Apply targeted edits—preserve unchanged sections, translate only changed/added content

### 3. Editor Review (Required, Parallel)

After ALL posts are updated, invoke `translation-editor` subagents **in parallel**—one per translation file. When invoking each editor:

1. Provide the English source and translated file paths
2. Tell the editor this is **update mode** and describe what sections changed
3. Instruct the editor to **only edit the specific file passed to it**

Example invocation context:
> "This is an update sync for `three-proofs-by-diagonalization.fr.md`. The English source changed: [summary]. Focus review on those sections. Only edit this file."

### 4. Report Summary

After editors complete:
- Which posts were synced
- Which translations were updated per post
- Summary of changes
- Any posts skipped (no translations)

## Abort Conditions

| Condition | Message |
|-----------|---------|
| Uncommitted changes | "Uncommitted changes in content/blog/. Please commit first." |
| No sync needed | "All translations are up to date with their English sources." |
| No translations exist | "No translations found for `<post-name>`. Use `/translate-post` to create them." |
| Post not found (with arg) | "Could not find post: `<post-name>`" |

## Validation

Run `zola check` after all translations are updated.
