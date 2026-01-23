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
    ├── _index.md       # Blog section config (English)
    ├── _index.fr.md    # Blog section config (French)
    ├── *.md            # Blog posts (English)
    └── *.fr.md         # Blog posts (French)
config.toml             # Site config (base_url, theme, taxonomies, languages)
i18n/                   # UI string overrides (language_name, tags, etc.)
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

## Multilingual Support

English (default) and French. Translations use Zola's file naming: `post-name.fr.md` alongside `post-name.md`.

URLs: English at `/blog/...`, French at `/fr/blog/...`

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

- Homepage uses `[extra] section_path = "blog/_index.md"` to show recent posts
- Taxonomies must be declared in `config.toml` before use in posts
- `social_media_card` in frontmatter must be a local file path (not external URLs)

## Syntax Highlighting (Zola 0.22+)

```toml
[markdown.highlighting]
style = "class"
theme = "catppuccin-frappe"
```

- `style = "class"` generates `giallo.css` in `static/` with CSS classes
- Tabi's CSS provides the actual colors; the theme just defines token types
- Old format (`[markdown]` with `highlight_code`/`highlight_theme`) no longer works

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
- For large images, compress with: `magick input.png -resize 1200x png:- | cwebp -q 90 -o output.webp -- -`

## Video and Audio

For large media files, use Cloudflare R2 bucket (`vinidlidoo-blog`):

```bash
aws s3 cp file.mp4 s3://vinidlidoo-blog/video/file.mp4 \
  --endpoint-url https://93e9358874da65cc09f1d1f51d83848a.r2.cloudflarestorage.com \
  --profile r2
```

Public URL: `https://pub-94e31bf482a74272bb61e9559b598705.r2.dev/path/file`

Embed with HTML5 tags:
```html
<video autoplay loop muted playsinline>
  <source src="https://pub-....r2.dev/video/file.mp4" type="video/mp4">
</video>

<audio controls>
  <source src="https://pub-....r2.dev/audio/file.mp3" type="audio/mpeg">
</audio>
```

## Content Security Policy

CSP is configured in `config.toml` under `allowed_domains`. When adding external media:
- Add domains to `media-src` for video/audio
- Add domains to `img-src` for images
- **Inline styles are blocked**—use CSS classes in `static/css/` instead (e.g., `.centered`)

## Custom Stylesheets

Add per-post CSS via frontmatter:
```toml
[extra]
stylesheets = ["css/details.css"]
```

Files go in `static/css/`.

## Mermaid Diagrams

Generate diagrams as static SVGs (avoid mermaid shortcode - has rendering issues).

```bash
mmdc -i static/mmdc/diagram-name.mmd -o static/img/diagram-name.svg -b white
```

- Source files in `static/mmdc/` with YAML frontmatter for theme config
- See `static/mmdc/translation-workflow.mmd` for example with classDef styling
- Use simple `<img>` tag in markdown (no special classes needed with white background)
