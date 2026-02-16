---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git log:*)
description: Git commit changes 
---
# Tasks to wrap up a session

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Look at the diffs and decide how many commits to do. Commits should be atomic. Then stage and commit. There shouldn't be dangling unstaged files at the end unless there's a good reason to (ask if unsure). Do not git push, I will do this on my own.

**Note:** If changes are small and belong to the last commit, use `git commit --amend` instead.

Use simple git commands (e.g., `git add`, `git commit`) without the `-C` flag.

## Auto-update `updated` date in blog posts

Before committing, check if any **modified** (not newly created) blog post files in `content/blog/` are staged. For each one, update the `updated` field in its TOML frontmatter to today's date (`YYYY-MM-DD`).

- If the post already has `updated = ...`, replace the date.
- If the post has no `updated` field, add `updated = YYYY-MM-DD` on the line after `date = ...`.
- **Skip new posts** (files not yet tracked by git before this commit).
- Apply to all blog post files (`*.md` in `content/blog/`), including translations.
