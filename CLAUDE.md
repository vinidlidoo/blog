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
