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
