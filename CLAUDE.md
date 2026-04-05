# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this repository.

## Project overview

Mastodon Bird UI is a CSS-only theme that transforms Mastodon's default UI to resemble Twitter/X's interface. It's maintained by @rolle@mementomori.social.

## Architecture

- `src/` - Modular SCSS source files
- `dist/` - Compiled CSS output
- `scripts/` - Installation and utility scripts
- Parcel bundler compiles SCSS to CSS

## Common commands

```bash
npm install              # Install dependencies
npm run dev              # Development mode with hot-reload (Browsersync)
npm run build            # Production build (alias for build:custom-css)
npm run build:custom-css # Build CSS for Custom CSS field usage
npm run build:mastodon-core  # Build SCSS for Mastodon core installation
npm run clean            # Remove dist/ and .parcel-cache/
```

## Installation methods

### Custom CSS (for users)

Copy contents of `dist/mastodon-bird-ui.css` to Mastodon Admin > Server settings > Appearance > Custom CSS

### Mastodon core (for admins)

```bash
npm run build:mastodon-core
./scripts/install-to-mastodon.sh --path /path/to/mastodon
```

This installs Bird UI as selectable themes in user preferences.

## Development workflow

1. Run `npm run dev` to start Parcel + Browsersync
2. Browsersync proxies a local Mastodon instance (configure in `bs-config.js`)
3. Edit SCSS files in `src/`, changes appear instantly
4. Production builds go to `dist/` with version banner from package.json

## Key guidelines

- Keep CSS-only output (no JavaScript runtime)
- Maintain backward compatibility for users copying CSS to Custom CSS field
- Follow existing variable naming conventions in `_variables.scss`
- Test both single-column and multiple-columns layouts
- Version is managed in `package.json` and auto-injected into built CSS

## Mastodon compatibility

This theme targets Mastodon v4.6.0+ which uses a new semantic token system with CSS custom properties like `--color-text-primary`, `--color-bg-primary`, etc. Bird UI overrides these tokens.

## Commits and code style

- One logical change per commit
- Keep commit messages concise (one line), use sentence case
- Update CHANGELOG.md for user-facing changes
- Use present tense in commits and CHANGELOG.md
- Use sentence case for headings (not Title Case)
- Never use bold text as headings, use proper heading levels instead
- Always add an empty line after headings
- No formatting in CHANGELOG.md except `inline code` and when absolute necessary
- Use * as bullets in CHANGELOG.md
- Critical: No Co-Authored by Claude watermark in commits
- No emojis in commits or code
- Keep CHANGELOG.md date up to date when adding entries
- Update README badge version when releasing
- No empty lines after // comments in SCSS
- Always commit `dist/` build files together with source changes, because users rely on the compiled CSS via the Custom CSS panel