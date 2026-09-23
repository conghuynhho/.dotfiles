---
name: ggj-review-gui-acc
description: |
  Review GoGoJungle Accounts front-end GUI — Next.js Pages Router, login/register/SNS auth,
  MUI, Redux, next-i18next. Loads share-review-gui README first.
  Use for PRs and GUI tasks in apps/gui/accounts.
argument-hint: [PR/ticket] [context]
---

# Accounts GUI Review (review-gui-acc)

**Load order:** [share-review-gui/README.md](../share-review-gui/README.md) first (process, phases, severity, ownership, output) → then references below.

## Invocation

| Tool | Command |
|------|---------|
| Claude Code | `/ggj:review-gui-acc [PR/ticket] [context]` |
| Cursor | `/ggj-review-gui-acc [PR/ticket] [context]` |

Examples:

```bash
/ggj-review-gui-acc staging...HEAD "context here"
/ggj:review-gui-acc https://github.com/org/repo/pull/42 "context here"
```


## Common guide (always load first)

[share-review-gui/README.md](../share-review-gui/README.md)

## Scope

| In scope | Path |
|----------|------|
| Accounts app | `apps/gui/accounts` |

## When to Use

- Reviewing front-end PRs in accounts.gogojungle.co.jp GUI
- Login, register, SNS auth, password reset, email confirm, account select
- Next.js 13 Pages Router / React 18 / MUI 5 / Redux Toolkit

## Out of scope

Do **not** expand review beyond the PR/ticket unless the diff triggers it.

| Out of scope | Instead |
|--------------|---------|
| Academic design patterns / DSA | Flag only practical complexity |
| Backend API design, DB schema, infra | 🔵 `[suggestion]` if contract affects FE; do not review server code |
| Proxy, Docker, deploy pipelines, guard middleware internals | Out of scope — FE review only |
| Formatting, import order, naming preference | ESLint / Prettier / `[nit]` |
| Large refactors outside the ticket | 🔵 `[suggestion]` or follow-up PR |
| Unit/E2E test implementation | Unless the PR adds or changes tests |
| Full accessibility audit (WCAG) | Only forms/modals/interactive UI in the diff |

**Depth:** CSS/copy-only PR → skim. Logic/data PR → load [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md).

## Common reference index

Load **only** files relevant to the diff.

| Area | Reference | Load when |
|------|-----------|-----------|
| React | [react.md](../share-review-gui/reference/react.md) | `.tsx` component changes |
| Next.js | [nextjs.md](../share-review-gui/reference/nextjs.md) | GSSP, `_app`, redirects |
| API, URL, redirects, errors | [api-data-fetching.md](../share-review-gui/reference/api-data-fetching.md) | Fetch, redirect `?u=`, errors |
| Security | [security.md](../share-review-gui/reference/security.md) | XSS, cookies, auth, SSO |
| Performance | [performance.md](../share-review-gui/reference/performance.md) | Bundle, images |
| SEO, i18n | [readability-seo.md](../share-review-gui/reference/readability-seo.md) | Meta, copy, locales |
| Components | [component-design.md](../share-review-gui/reference/component-design.md) | Forms, buttons, inputs |
| CSS / styling | [css-less-sass.md](../share-review-gui/reference/css-less-sass.md) | Emotion, responsive |
| QA phases (detail) | [testing-qa.md](../share-review-gui/reference/testing-qa.md) | Phase 1–4 detail |
| Architecture | [architecture-review-guide.md](../share-review-gui/reference/architecture-review-guide.md) | Layering, refactors |
| Code quality | [code-quality-universal.md](../share-review-gui/reference/code-quality-universal.md) | Helpers, duplication |
| Common FE bugs | [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md) | Async, forms, hydration |
| Security (deep) | [security-review-guide.md](../share-review-gui/reference/security-review-guide.md) | Redirect validation, auth flows |

Examples: [examples.md](../share-review-gui/examples.md)

## Accounts reference index

| Area | Reference | Load when |
|------|-----------|-----------|
| Pages / auth flows | [nextjs-accounts.md](../reference/review-gui-acc/nextjs-accounts.md) | Login, register, SNS, password, confirm |
| Architecture & Redux | [architecture-review-guide.md](../reference/review-gui-acc/architecture-review-guide.md) | Slices, GSSP, contexts |
| Code quality | [code-quality-accounts.md](../reference/review-gui-acc/code-quality-accounts.md) | API in slices, toast/loading, i18n |
| Emotion / MUI theme | [css-emotion-accounts.md](../reference/review-gui-acc/css-emotion-accounts.md) | `theme.config.ts`, min-width media queries |

Accounts examples: [examples.md](../reference/review-gui-acc/examples.md).

## Output (Accounts)

Follow **Output Format** and **Quick Checklist** in the common README. Checklist section may be labeled **Accounts Checklist** (agent items only).
