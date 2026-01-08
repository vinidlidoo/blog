# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Zola static site blog using the **tabi** theme. Deploys to GitHub Pages at `vinidlidoo.github.io`.

## Commands

```bash
zola serve          # Dev server at http://127.0.0.1:1111 (live reload)
zola build          # Build to public/
zola check          # Validate site without building
```

## Project Structure

```
content/
├── _index.md           # Homepage (pulls recent posts from blog/)
└── blog/
    ├── _index.md       # Blog section config (sort_by, paginate_by)
    └── *.md            # Blog posts
config.toml             # Site config (base_url, theme, taxonomies)
themes/tabi/            # Theme (git submodule)
```

## Creating Posts

Posts go in `content/blog/` with TOML frontmatter:

```markdown
+++
title = "Post Title"
date = 2026-01-05
description = "Brief description"

[taxonomies]
tags = ["tag1", "tag2"]
+++

Content here...
```

## Theme (Git Submodule)

The tabi theme is a git submodule. After cloning on a new machine:
```bash
git submodule update --init
```

To update theme:
```bash
git submodule update --remote themes/tabi
```

## Tabi-Specific Config

- `highlight_theme = "css"` is required (not a named theme)
- Homepage uses `[extra] section_path = "blog/_index.md"` to show recent posts
- Taxonomies must be declared in `config.toml` before use in posts

## KaTeX (Math Rendering)

Enable per-post with `katex = true` in `[extra]`. Limitations:
- `\mathrm{}` doesn't render inside `<details>` blocks—use plain text instead
- `\begin{cases}` can be flaky—use inline prose for piecewise definitions
- Standard commands (`\frac`, `\sqrt`, `\sum`, `\left`, `\right`) work fine

## Footnotes

Standard markdown syntax:
```markdown
Text with footnote[^1].

[^1]: Footnote content here.
```

Style footnotes via CSS: `.footnote-definition { font-size: 0.85rem; }`

## Dates

- `post_listing_date = "both"` in `content/blog/_index.md` shows both dates in **listing only**
- For individual posts to show "Updated", add `updated = YYYY-MM-DD` to frontmatter

## Images

- Place in `static/img/`, reference as `/img/filename.ext`
- **Case-sensitive on GitHub Pages** (Linux)—ensure filenames match exactly

## Custom Stylesheets

Add per-post CSS via frontmatter:
```toml
[extra]
stylesheets = ["css/details.css"]
```

Files go in `static/css/`.
