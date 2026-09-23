---
name: ggj-review-gui-ggj
description: |
  Review GoGoJungle GGJ front-end GUI — Next.js App Router, @gogo/gui-ggj monorepo,
  MUI, Emotion, createFastContext, i18n sheets. Loads share-review-gui README first.
  Use for PRs and GUI tasks in ggj-ja / ggj-en / ggj-th and packages/gui/ggj.
argument-hint: [PR/ticket] [context]
---

# GGJ GUI Review (review-gui-ggj)

**Load order:** [share-review-gui/README.md](../share-review-gui/README.md) first (process, phases, severity, ownership, output) → then references below.

## Invocation

| Tool | Command |
|------|---------|
| Claude Code | `/ggj:review-gui-ggj [PR/ticket] [context]` |
| Cursor | `/ggj-review-gui-ggj [PR/ticket] [context]` |

Examples:

```bash
/ggj-review-gui-ggj staging...HEAD "context here"
/ggj:review-gui-ggj https://github.com/org/repo/pull/42 "context here"
```


## Common guide (always load first)

[share-review-gui/README.md](../share-review-gui/README.md)

## Scope

| In scope | Path |
|----------|------|
| Locale apps | `apps/gui/ggj-ja`, `ggj-en`, `ggj-th` |
| Shared package | `packages/gui/ggj` (`@gogo/gui-ggj`) |

## When to Use

- Reviewing front-end PRs in GGJ (surface Next.js apps)
- Next.js 13 App Router / React 18 / MUI 5 / Emotion
- `page-components/`, `Ggj*` components, `createFastContext`, CDN, i18n sheets

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
| Next.js | [nextjs.md](../share-review-gui/reference/nextjs.md) | App Router, metadata, SSR |
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
| Security (deep) | [security-review-guide.md](../share-review-gui/reference/security-review-guide.md) | `dangerouslySetInnerHTML`, auth, redirect |
| Performance (deep) | [performance-review-guide.md](../share-review-gui/reference/performance-review-guide.md) | New deps, LCP route, large lists |

Examples: [examples.md](../share-review-gui/examples.md)

## GGJ reference index

| Area | Reference | Load when |
|------|-----------|-----------|
| App Router / SSR / metadata | [nextjs-app-router.md](../reference/review-gui-ggj/nextjs-app-router.md) | `src/app/`, Server Components, `generateMetadata` |
| Monorepo layering | [architecture-review-guide.md](../reference/review-gui-ggj/architecture-review-guide.md) | New routes, `page-components/`, country overrides |
| GGJ reuse & context | [code-quality-ggj.md](../reference/review-gui-ggj/code-quality-ggj.md) | New helpers, `createFastContext`, `Ggj*` components |
| Emotion / MUI theme | [css-emotion-ggj.md](../reference/review-gui-ggj/css-emotion-ggj.md) | Emotion `css`, MUI `sx`, theme tokens |
| Perf (video, CDN, charts) | [performance-ggj.md](../reference/review-gui-ggj/performance-ggj.md) | IVS/HLS, Highcharts, lazy hydration, bundle |

GGJ examples: [examples.md](../reference/review-gui-ggj/examples.md).

## Output (GGJ)

Follow **Output Format** and **Quick Checklist** in the common README. Checklist section may be labeled **GGJ Checklist** (agent items only).
