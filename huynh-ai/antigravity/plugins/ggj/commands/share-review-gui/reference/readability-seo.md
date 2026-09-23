# Readability & SEO

> Load when: `head()`, meta tags, copy, i18n, text overflow.
> Tags: [README.md](../README.md#review-ownership). Framework `head()` → project overlay skill if present.

## On-page SEO

| Tag | Check |
|-----|-------|
| agent | Title 10–70 chars, unique, in `<head>` |
| agent | Description 160–300 chars, unique |
| agent | One `<h1>` per page; logical `h2+` hierarchy |
| agent | Canonical URL (locale, trailing slash) |
| agent | Single `<body>`; valid nesting |
| agent | OG: `title`, `description`, `url`, `image` |
| agent | X: `card`, `site`, `creator` |

## Text & i18n

| Tag | Check |
|-----|-------|
| agent | Ellipsis / `line-clamp` for overflow |
| agent | i18n complete for locales in scope; no hardcoded copy when `$t()` exists |
| human | Empty, normal, long, overflowing text display |
| human | JP keyboard: full/half-width, kana/kanji |
