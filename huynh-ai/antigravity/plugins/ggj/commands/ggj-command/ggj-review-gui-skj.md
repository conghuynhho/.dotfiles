---
name: ggj-review-gui-skj
description: |
  Review Skijan front-end GUI — Next.js Pages Router, @gogo/gui-skijan monorepo,
  MUI, Redux, fast-context, country overrides. Loads share-review-gui README first.
  Use for PRs and GUI tasks in apps/gui/skijan* and packages/gui/skijan.
argument-hint: [PR/ticket] [context]
---

# Skijan GUI Review (review-gui-skj)

**Load order:** [share-review-gui/README.md](../share-review-gui/README.md) first (process, phases, severity, ownership, output) → then references below.

## Invocation

| Tool | Command |
|------|---------|
| Claude Code | `/ggj:review-gui-skj [PR/ticket] [context]` |
| Cursor | `/ggj-review-gui-skj [PR/ticket] [context]` |

Examples:

```bash
/ggj-review-gui-skj staging...HEAD "context here"
/ggj:review-gui-skj https://github.com/org/repo/pull/42 "context here"
```


## Common guide (always load first)

[share-review-gui/README.md](../share-review-gui/README.md)

## Scope

| In scope | Path |
|----------|------|
| Locale apps | `apps/gui/skijan`, `skijan-en`, `skijan-es`, `skijan-hk`, `skijan-id`, `skijan-ko`, `skijan-th`, `skijan-tw`, `skijan-vi`, `skijan-zh` |
| Shared package | `packages/gui/skijan` (`@gogo/gui-skijan`) |

## When to Use

- Reviewing front-end PRs in Skijan
- Next.js 13 Pages Router / React 18 / MUI 5 / Redux Toolkit
- `page-components/`, `Ggj*` / `Skj*` components, layouts, country overrides

## Out of scope

Do **not** expand review beyond the PR/ticket unless the diff triggers it.

| Out of scope | Instead |
|--------------|---------|
| Academic design patterns / DSA | Flag only practical complexity — see [performance-review-guide.md](../share-review-gui/reference/performance-review-guide.md) § Lists |
| Backend API design, DB schema, infra | 🔵 `[suggestion]` if contract affects FE; do not review server code |
| Proxy, Docker, deploy pipelines | Out of scope — FE review only |
| Formatting, import order, naming preference | ESLint / Prettier / `[nit]` |
| Large refactors outside the ticket | 🔵 `[suggestion]` or follow-up PR — not 🔴 blocking |
| Unit/E2E test implementation | Unless the PR adds or changes tests — do not demand new coverage |
| Full accessibility audit (WCAG) | Only forms/modals/interactive UI in the diff |

**Depth:** CSS/copy-only PR → skim ([README time budget](../share-review-gui/README.md#time-budget)). Logic/data PR → load [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md).

## Common reference index

Load **only** files relevant to the diff.

| Area | Reference | Load when |
|------|-----------|-----------|
| React | [react.md](../share-review-gui/reference/react.md) | `.tsx` component changes |
| Next.js | [nextjs.md](../share-review-gui/reference/nextjs.md) | GSSP, layouts, `_app` |
| API, URL, redirects, errors | [api-data-fetching.md](../share-review-gui/reference/api-data-fetching.md) | Fetch, query params, redirects |
| Security | [security.md](../share-review-gui/reference/security.md) | XSS, cookies, auth |
| Performance | [performance.md](../share-review-gui/reference/performance.md) | Images, bundle, CWV |
| SEO, i18n | [readability-seo.md](../share-review-gui/reference/readability-seo.md) | Meta, copy, locales |
| Components | [component-design.md](../share-review-gui/reference/component-design.md) | Forms, buttons, inputs |
| CSS / styling | [css-less-sass.md](../share-review-gui/reference/css-less-sass.md) | Layout, responsive |
| QA phases (detail) | [testing-qa.md](../share-review-gui/reference/testing-qa.md) | Phase 1–4 detail |
| Architecture | [architecture-review-guide.md](../share-review-gui/reference/architecture-review-guide.md) | Layering, refactors |
| Code quality | [code-quality-universal.md](../share-review-gui/reference/code-quality-universal.md) | Helpers, duplication |
| Common FE bugs | [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md) | Async, forms, lists, hydration |
| Security (deep) | [security-review-guide.md](../share-review-gui/reference/security-review-guide.md) | Editor.js output, auth, redirect |
| Performance (deep) | [performance-review-guide.md](../share-review-gui/reference/performance-review-guide.md) | New deps, large lists, bundle |

Examples: [examples.md](../share-review-gui/examples.md)

## Skijan reference index

| Area | Reference | Load when |
|------|-----------|-----------|
| Pages Router / layouts / GSSP | [nextjs-skijan.md](../reference/review-gui-skj/nextjs-skijan.md) | `pages/`, Layout assignment, SSR |
| Monorepo & country overrides | [architecture-review-guide.md](../reference/review-gui-skj/architecture-review-guide.md) | `@country-components`, file placement |
| Redux / fast-context / API | [code-quality-skijan.md](../reference/review-gui-skj/code-quality-skijan.md) | `store/*Slice.ts`, `ggjDebounce`, auth |
| MUI theme / Emotion | [css-emotion-skijan.md](../reference/review-gui-skj/css-emotion-skijan.md) | `theme.config.ts`, palette tokens |
| Perf / media | [performance-skijan.md](../reference/review-gui-skj/performance-skijan.md) | Video, Editor.js, infinite scroll |

Skijan examples: [examples.md](../reference/review-gui-skj/examples.md).

## Output (Skijan)

Follow **Output Format** and **Quick Checklist** in the common README. Checklist section may be labeled **Skijan Checklist** (agent items only).
