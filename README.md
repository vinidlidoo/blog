# Blog

Personal blog built with [Zola](https://www.getzola.org/) and the [tabi](https://github.com/welpo/tabi) theme.

**Live site:** https://vinidlidoo.github.io/blog/

## File Structure

```
blog/
├── config.toml              # Global site settings
├── content/
│   ├── _index.md            # Homepage
│   └── blog/
│       ├── _index.md        # Blog section config
│       └── *.md             # Posts
├── themes/tabi/             # Theme (git submodule)
└── .github/workflows/       # Auto-deployment
```

## The Three Layers

**1. `config.toml`** — Site-wide settings

```toml
title = "My Blog"              # Site title (header/tab)
description = "A personal blog"
[extra]
author = "Vincent"             # Used by theme
```

**2. `content/_index.md`** — Homepage

```markdown
+++
title = "Home"
[extra]
section_path = "blog/_index.md"   # Pulls recent posts from /blog/
max_posts = 5
+++

Welcome text goes here (optional).
```

**3. `content/blog/_index.md`** — Blog section settings

```markdown
+++
title = "Blog"
sort_by = "date"       # Newest first
paginate_by = 10       # Posts per page
+++
```

## Creating a New Post

Create a file in `content/blog/` with `.md` extension:

```markdown
+++
title = "My New Post"
date = 2026-01-06
description = "What this post is about"

[taxonomies]
tags = ["programming", "zola"]
+++

Your content here. Supports **markdown**.
```

**File naming:** The filename becomes the URL slug.

- `my-new-post.md` → `/blog/my-new-post/`
- `2026-01-06-ideas.md` → `/blog/2026-01-06-ideas/`

## Quick Customization

| What            | Where                     | Example                      |
|-----------------|---------------------------|------------------------------|
| Site title      | `config.toml`             | `title = "Vincent's Blog"`   |
| Author name     | `config.toml`             | `[extra] author = "Vincent"` |
| Homepage text   | `content/_index.md`       | Add text after `+++` block   |
| Posts per page  | `content/blog/_index.md`  | `paginate_by = 5`            |

## Commands

```bash
zola serve          # Dev server at http://127.0.0.1:1111 (live reload)
zola build          # Build to public/
zola check          # Validate site without building
```

## Workflow

```bash
# 1. Write locally
vim content/blog/my-post.md

# 2. Preview
zola serve

# 3. Publish
git add -A && git commit -m "Add new post" && git push
# Site updates automatically in ~30 seconds
```

## Theme (Git Submodule)

The tabi theme is a git submodule. After cloning on a new machine:

```bash
git submodule update --init
```

To update theme to latest version:

```bash
git submodule update --remote themes/tabi
```
