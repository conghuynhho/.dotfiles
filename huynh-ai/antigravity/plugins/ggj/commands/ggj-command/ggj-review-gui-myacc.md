---
name: ggj-review-gui-myacc
description: |
  Review GoGoJungle MyAccount front-end GUI — Next.js Pages Router, member/bank/settings,
  MUI, Redux, Jotai, next-i18next. Loads share-review-gui README first.
  Use for PRs and GUI tasks in apps/gui/myaccount.
argument-hint: [PR/ticket] [context]
---

# MyAccount GUI Review (review-gui-myacc)

**Load order:** [share-review-gui/README.md](../share-review-gui/README.md) first (process, phases, severity, ownership, output) → then references below.

## Invocation

| Tool | Command |
|------|---------|
| Claude Code | `/ggj:review-gui-myacc [PR/ticket] [context]` |
| Cursor | `/ggj-review-gui-myacc [PR/ticket] [context]` |

Examples:

```bash
/ggj-review-gui-myacc staging...HEAD "context here"
/ggj:review-gui-myacc https://github.com/org/repo/pull/42 "context here"
```


## Common guide (always load first)

[share-review-gui/README.md](../share-review-gui/README.md)

## Scope

| In scope | Path |
|----------|------|
| MyAccount app | `apps/gui/myaccount` |

## When to Use

- Reviewing front-end PRs in myaccount GUI
- Member profile, bank, email/phone verify, terms, withdrawal
- Next.js 13 Pages Router / React 18 / MUI 5 / Redux + Jotai

## Out of scope

Do **not** expand review beyond the PR/ticket unless the diff triggers it.

| Out of scope | Instead |
|--------------|---------|
| Academic design patterns / DSA | Flag only practical complexity |
| Backend API design, DB schema, infra | 🔵 `[suggestion]` if contract affects FE; do not review server code |
| Proxy, Docker, deploy pipelines | Out of scope — FE review only |
| Formatting, import order, naming preference | ESLint / Prettier / `[nit]` |
| Large refactors outside the ticket | 🔵 `[suggestion]` or follow-up PR |
| Unit/E2E test implementation | Unless the PR adds or changes tests |
| Full accessibility audit (WCAG) | Only forms/modals/interactive UI in the diff |

**Depth:** CSS/copy-only PR → skim. Logic/data PR → load [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md) and [code-quality-myaccount.md](../reference/review-gui-myacc/code-quality-myaccount.md).

## Common reference index

Load **only** files relevant to the diff.

| Area | Reference | Load when |
|------|-----------|-----------|
| React | [react.md](../share-review-gui/reference/react.md) | `.tsx` component changes |
| Next.js | [nextjs.md](../share-review-gui/reference/nextjs.md) | GSSP, layouts, `_app` |
| API, URL, redirects, errors | [api-data-fetching.md](../share-review-gui/reference/api-data-fetching.md) | Fetch, 401/456 redirect |
| Security | [security.md](../share-review-gui/reference/security.md) | XSS, cookies, auth |
| Performance | [performance.md](../share-review-gui/reference/performance.md) | Bundle, images, re-render |
| SEO, i18n | [readability-seo.md](../share-review-gui/reference/readability-seo.md) | Meta, copy, locales |
| Components | [component-design.md](../share-review-gui/reference/component-design.md) | Forms, buttons, uploads |
| CSS / styling | [css-less-sass.md](../share-review-gui/reference/css-less-sass.md) | Emotion, responsive |
| QA phases (detail) | [testing-qa.md](../share-review-gui/reference/testing-qa.md) | Phase 1–4 detail |
| Architecture | [architecture-review-guide.md](../share-review-gui/reference/architecture-review-guide.md) | Layering, refactors |
| Code quality | [code-quality-universal.md](../share-review-gui/reference/code-quality-universal.md) | Helpers, duplication |
| Common FE bugs | [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md) | Async, forms, hydration |
| Security (deep) | [security-review-guide.md](../share-review-gui/reference/security-review-guide.md) | Upload, auth, redirect |

Examples: [examples.md](../share-review-gui/examples.md)

## MyAccount reference index

| Area | Reference | Load when |
|------|-----------|-----------|
| Pages / layouts / GSSP | [nextjs-myaccount.md](../reference/review-gui-myacc/nextjs-myaccount.md) | Member, bank, verify flows |
| Architecture & Redux | [architecture-review-guide.md](../reference/review-gui-myacc/architecture-review-guide.md) | Slices, Jotai forms, layouts |
| Code quality (official checklist) | [code-quality-myaccount.md](../reference/review-gui-myacc/code-quality-myaccount.md) | API in slices, debounce, upload |
| Emotion / MUI theme | [css-emotion-myaccount.md](../reference/review-gui-myacc/css-emotion-myaccount.md) | Theme tokens, locale-specific UI |

MyAccount examples: [examples.md](../reference/review-gui-myacc/examples.md).

## Output (MyAccount)

Follow **Output Format** and **Quick Checklist** in the common README. Checklist section may be labeled **MyAccount Checklist** (agent items only).
