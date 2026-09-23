---
name: ggj-review-gui-sf
description: |
  Review GoGoJungle surface.gogojungle.co.jp front-end GUI — Nuxt 2 monorepo, locales,
  GoGoHTTP, GGJ patterns. Loads share-review-gui README first. Use for PRs and GUI tasks in this repo.
argument-hint: [PR/ticket] [context]
---

# Surface GUI Review (review-gui-sf)

**Load order:** [share-review-gui/README.md](../share-review-gui/README.md) first (process, phases, severity, ownership, output) → then references below.

## Invocation

| Tool | Command |
|------|---------|
| Claude Code | `/ggj:review-gui-sf [PR/ticket] [context]` |
| Cursor | `/ggj-review-gui-sf [PR/ticket] [context]` |

Examples:

```bash
/ggj-review-gui-sf staging...HEAD "context here"
/ggj:review-gui-sf https://github.com/org/repo/pull/42 "context here"
```


## Common guide (always load first)

[share-review-gui/README.md](../share-review-gui/README.md)

## When to Use

- Reviewing front-end PRs in `surface.gogojungle.co.jp`
- Nuxt 2 / Vue 2
- Desktop/mobile builds, `common/containers/`, `GoGoHTTP`, CDN, GGJ components

## Out of scope

Do **not** expand review beyond the PR/ticket unless the diff triggers it.

| Out of scope | Instead |
|--------------|---------|
| Academic design patterns / DSA (GoF catalog, formal Big-O, LeetCode-style) | Flag only practical complexity — see [performance-review-guide.md](../share-review-gui/reference/performance-review-guide.md) § Lists |
| Backend API design, DB schema, infra | 🔵 `[suggestion]` if contract affects FE; do not review server code |
| Formatting, import order, naming preference | ESLint / Prettier / `[nit]` |
| Large refactors outside the ticket | 🔵 `[suggestion]` or follow-up PR — not 🔴 blocking |
| Unit/E2E test implementation | Unless the PR adds or changes tests — do not demand new coverage |
| Full accessibility audit (WCAG) | Only forms/modals/interactive UI in the diff — no dedicated a11y guide yet |

**Depth:** CSS/copy-only PR → skim ([README time budget](../share-review-gui/README.md#time-budget)). Logic/data PR → load [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md).

## Common reference index

Load **only** files relevant to the diff.

| Area | Reference | Load when |
|------|-----------|-----------|
| Vue 2 components | [vue.md](../share-review-gui/reference/vue.md) | `.vue` SFC changes |
| API, URL, redirects, errors | [api-data-fetching.md](../share-review-gui/reference/api-data-fetching.md) | Fetch, query params, redirects |
| Security | [security.md](../share-review-gui/reference/security.md) | XSS, cookies, auth |
| Performance | [performance.md](../share-review-gui/reference/performance.md) | Images, bundle, CWV |
| SEO, i18n | [readability-seo.md](../share-review-gui/reference/readability-seo.md) | Meta, copy, locales |
| Components | [component-design.md](../share-review-gui/reference/component-design.md) | Forms, buttons, inputs |
| CSS / Less | [css-less-sass.md](../share-review-gui/reference/css-less-sass.md) | Styles, layout |
| QA phases (detail) | [testing-qa.md](../share-review-gui/reference/testing-qa.md) | Phase 1–4 detail |
| Architecture | [architecture-review-guide.md](../share-review-gui/reference/architecture-review-guide.md) | Layering, refactors |
| Code quality | [code-quality-universal.md](../share-review-gui/reference/code-quality-universal.md) | Helpers, duplication |
| Common FE bugs | [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md) | Async, forms, lists, SSR, route changes |
| Security (deep) | [security-review-guide.md](../share-review-gui/reference/security-review-guide.md) | `v-html`, auth, redirect, upload, new scripts |
| Performance (deep) | [performance-review-guide.md](../share-review-gui/reference/performance-review-guide.md) | New deps, LCP route, large lists, bundle |

Examples: [examples.md](../share-review-gui/examples.md)

## Surface reference index

| Area | Reference | Load when |
|------|-----------|-----------|
| Nuxt 2 / SSR / routing / store | [nuxt.md](../reference/review-gui-sf/nuxt.md) | Routes, `asyncData`, layouts, middleware, `nuxt.config.js` |
| Monorepo layering | [architecture-review-guide.md](../reference/review-gui-sf/architecture-review-guide.md) | New routes, store, refactors, file placement |
| GGJ reuse & containers | [code-quality-surface.md](../reference/review-gui-sf/code-quality-surface.md) | New helpers, duplication, `GoGoHTTP`, mixins |
| Less / Bootstrap tokens | [css-less-sass-surface.md](../reference/review-gui-sf/css-less-sass-surface.md) | Styles using `variables.less`, locale builds |
| Perf (Nuxt / CDN / charts) | [performance-surface.md](../reference/review-gui-sf/performance-surface.md) | LCP routes, `genCDNUrl`, Highcharts, bundle |
| Rich editors | [testing-qa-surface.md](../reference/review-gui-sf/testing-qa-surface.md) | Summernote, Editor.js |

Surface examples: [examples.md](../reference/review-gui-sf/examples.md).

## Output (surface)

Follow **Output Format** and **Quick Checklist** in the common README. Checklist section may be labeled **GGJungle Checklist** (agent items only).
