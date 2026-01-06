# Blog Project Plan

## Completed

- [x] Install Zola via Homebrew (v0.21.0)
- [x] Initialize Zola project in `/Users/vincent/Projects/blog`
- [x] Add tabi theme as git submodule
- [x] Configure `config.toml` (base_url, theme, taxonomies, syntax highlighting)
- [x] Create content structure (homepage + /blog/ section)
- [x] Create test post (`hello-world.md`)
- [x] Verify site works locally with `zola serve`

## Completed (continued)

- [x] Create GitHub repo (`vinidlidoo/blog`)
- [x] Add GitHub Actions workflow (`shalzz/zola-deploy-action`)
- [x] Configure GitHub Pages (source: `gh-pages` branch)
- [x] Verify deployment at <https://vinidlidoo.github.io/blog/>

## Optional / Future

- [ ] Customize blog title/description in `config.toml`
- [ ] Customize homepage content in `content/_index.md`
- [ ] Customize tabi theme settings

---

## Quick Reference

### Commands

```bash
zola serve          # Dev server at http://127.0.0.1:1111
zola build          # Build to public/
zola check          # Validate site
```

### New Post Template

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

### Git Submodules (tabi theme)

```bash
# After cloning repo on new machine:
git submodule update --init

# Update theme to latest:
git submodule update --remote themes/tabi
```

---

## Key Files

- `config.toml` — Site configuration
- `content/_index.md` — Homepage
- `content/blog/_index.md` — Blog section settings
- `content/blog/*.md` — Blog posts
- `themes/tabi/` — Theme (submodule)
