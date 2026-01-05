---
title: Blog Setup Handoff - Zola Static Site Generator
tags:
  - blog
  - zola
  - static-site-generator
  - project-setup
date: 2026-01-05
---

# Blog Setup Handoff: Zola Static Site Generator

## Decision Summary

After evaluating multiple static site generators (Zola, Hugo, Jekyll, Quartz, Astro, Eleventy), **Zola** was chosen for the following reasons:

### Why Zola

- **Single binary, zero dependencies** — No Node.js, no Ruby, no node_modules. Just download and run.
- **Fast builds** — ~36ms builds (roughly 4x faster than Hugo in benchmarks)
- **Sane templating** — Uses Tera (Jinja2/Django-like syntax), much cleaner than Hugo's Go templates
- **Lightweight output** — Produces minimal HTML/CSS, no JavaScript bloat
- **Terminal-friendly workflow** — Write markdown in neovim, `git push`, done

### Rejected Alternatives

| SSG | Reason for rejection |
|-----|---------------------|
| **Hugo** | Go template syntax is confusing; Zola is faster anyway |
| **Quartz** | Designed for Obsidian digital gardens, outputs ~4MB pages with heavy JS |
| **Astro** | Overkill for simple blog; requires Node.js; more complex than needed |
| **Eleventy** | Good option but requires Node.js; Zola is simpler for this use case |
| **Jekyll** | Ruby dependency; slow builds; dated |

### Design Goals

- Minimalist aesthetic (inspired by Karpathy's Bear Blog, Vitalik's blog)
- Each blog post is a simple markdown file
- Write in neovim, deploy via terminal (`git push`)
- Lightweight, fast-loading pages

---

## Zola Quick Reference

<!-- FEEDBACK: I use MacOS -->
### Installation

```bash
# macOS
brew install zola

# Arch Linux
pacman -S zola

# Ubuntu/Debian (snap)
snap install zola --edge

# Or download binary directly from:
# https://github.com/getzola/zola/releases
```

### Project Structure

```
my-blog/
├── config.toml          # Site configuration
├── content/             # Markdown content lives here
│   ├── _index.md        # Homepage content
│   └── blog/            # Blog posts section
│       ├── _index.md    # Blog section index
│       └── my-post.md   # Individual post
├── templates/           # Tera templates
│   ├── base.html        # Base layout
│   ├── index.html       # Homepage template
│   └── blog/
│       ├── list.html    # Blog listing
│       └── page.html    # Individual post
├── static/              # Static assets (images, css, etc.)
├── sass/                # Sass files (optional, compiled automatically)
└── themes/              # Themes (optional)
```

### Essential Commands

```bash
# Initialize new site
zola init my-blog

# Development server with live reload
zola serve

# Build for production
zola build

# Check for errors without building
zola check
```

### Post Frontmatter Format

```markdown
+++
title = "My First Post"
date = 2026-01-05
description = "A brief description for SEO and previews"
[taxonomies]
tags = ["rust", "blog"]
+++

Your markdown content here...
```

<!-- FEEDBACK: double-check the docs at getzola.org -->
### Minimal config.toml

```toml
base_url = "https://yourdomain.com"
title = "Your Blog Title"
description = "Your blog description"
default_language = "en"
compile_sass = true
minify_html = true
generate_feeds = true
feed_filenames = ["rss.xml"]

[markdown]
highlight_code = true
highlight_theme = "base16-ocean-dark"

[extra]
# Custom variables accessible in templates
author = "Your Name"
```

---

## Deployment Options

<!-- FEEDBACK: I'll follow the recommendation -->
### GitHub Pages (Recommended)

1. Create repo: `username.github.io` or any repo with GitHub Pages enabled
2. Add GitHub Action workflow:

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Build and deploy
        uses: shalzz/zola-deploy-action@v0.21.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

3. In repo Settings > Pages, set source to `gh-pages` branch

### Cloudflare Pages

```bash
# Build command
zola build

# Output directory
public
```

### Manual Deploy

```bash
zola build
# Upload contents of `public/` directory to any static host
```

---

## Recommended Minimal Themes

<!-- FEEDBACK: went over it and will use tabi -->
If starting from scratch feels daunting, these themes match the minimalist aesthetic:

- **zola-bearblog** — Replicates Bear Blog's minimal style
- **tabi** — Clean, accessible, no JS
- **terminimal** — Terminal-inspired minimal theme
- **no-style-please** — Extremely minimal, almost no CSS

To use a theme:

<!-- FEEDBACK: need to understand how git submodule command works. add to plan.md -->
```bash
cd my-blog
git submodule add https://github.com/user/theme-name themes/theme-name
```

Then in `config.toml`:

```toml
theme = "theme-name"
```

---

<!-- FEEDBACK: before we use Github Action, let's test the blog locally first -->
## Workflow Summary

```
1. Write post in neovim:     nvim content/blog/new-post.md
2. Preview locally:          zola serve
3. Commit and push:          git add . && git commit -m "New post" && git push
4. GitHub Action deploys automatically
```

---

## Resources

- **Zola Docs**: <https://www.getzola.org/documentation/>
- **Tera Templates**: <https://keats.github.io/tera/docs/>
- **Zola Themes**: <https://www.getzola.org/themes/>
- **GitHub Deploy Action**: <https://github.com/shalzz/zola-deploy-action>

---

## Next Steps for Claude Code

1. Initialize a new Zola project
2. Set up a minimal theme or create templates from scratch
3. Configure `config.toml` with site details
4. Create initial content structure
5. Set up GitHub repo with deployment workflow
6. Test locally with `zola serve`
