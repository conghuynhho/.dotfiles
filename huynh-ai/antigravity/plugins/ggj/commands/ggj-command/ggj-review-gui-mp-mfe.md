---
name: ggj-review-gui-mp-mfe
description: |
  Review GoGoJungle Mypage MFE front-end — React, Rsbuild, Module Federation,
  @gogo/share-mfe, host bridge via RxJS. Loads share-review-gui README first.
  Use for PRs in apps/gui/mypage-mfe and packages/gui/share-mfe.
argument-hint: [PR/ticket] [context]
---

# Mypage MFE GUI Review (review-gui-mp-mfe)

**Load order:** [share-review-gui/README.md](../share-review-gui/README.md) first (process, phases, severity, ownership, output) → then references below.

## Invocation

| Tool | Command |
|------|---------|
| Claude Code | `/ggj:review-gui-mp-mfe [PR/ticket] [context]` |
| Cursor | `/ggj-review-gui-mp-mfe [PR/ticket] [context]` |

Examples:

```bash
/ggj-review-gui-mp-mfe staging...HEAD "context here"
/ggj:review-gui-mp-mfe https://github.com/org/repo/pull/42 "context here"
```


## Common guide (always load first)

[share-review-gui/README.md](../share-review-gui/README.md)

## Scope

| In scope | Path |
|----------|------|
| MFE remotes | `apps/gui/mypage-mfe/mypage-*` |
| Shared MFE lib | `packages/gui/share-mfe` (`@gogo/share-mfe`) |

Host app (`gui-mypage`, Vue) is **out of scope** unless the diff explicitly changes MFE contract (store shape, expose names).

## When to Use

- Reviewing front-end PRs in mypage microfrontends
- React 19 / Rsbuild / Module Federation / MUI 6 / Emotion
- `exposes/`, `fast-context/`, host `BehaviorSubject` bridge

## Out of scope

Do **not** expand review beyond the PR/ticket unless the diff triggers it.

| Out of scope | Instead |
|--------------|---------|
| Academic design patterns / DSA | Flag only practical complexity |
| Backend API design, DB schema, infra | 🔵 `[suggestion]` if contract affects FE |
| Proxy, Docker, deploy pipelines (`acb`, CDN deploy) | Out of scope — FE review only |
| Host `MountReactComponent` / `initMFE` implementation | Note contract breaks only |
| Formatting, import order | ESLint / Prettier / `[nit]` |
| Full accessibility audit (WCAG) | Only interactive UI in the diff |

**Depth:** CSS/copy-only PR → skim. Logic/data PR → load [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md).

## Common reference index

Load **only** files relevant to the diff.

| Area | Reference | Load when |
|------|-----------|-----------|
| React | [react.md](../share-review-gui/reference/react.md) | `.tsx` component changes |
| API, errors | [api-data-fetching.md](../share-review-gui/reference/api-data-fetching.md) | Host-injected `http` usage |
| Security | [security.md](../share-review-gui/reference/security.md) | XSS, user content |
| Performance | [performance.md](../share-review-gui/reference/performance.md) | Bundle, shared deps |
| Components | [component-design.md](../share-review-gui/reference/component-design.md) | Forms, modals |
| CSS / styling | [css-less-sass.md](../share-review-gui/reference/css-less-sass.md) | Emotion, MUI |
| Code quality | [code-quality-universal.md](../share-review-gui/reference/code-quality-universal.md) | Duplication in share-mfe |
| Common FE bugs | [common-bugs-checklist.md](../share-review-gui/reference/common-bugs-checklist.md) | Async, lists, cleanup |

Examples: [examples.md](../share-review-gui/examples.md)

## MFE reference index

| Area | Reference | Load when |
|------|-----------|-----------|
| Module Federation / exposes | [module-federation.md](../reference/review-gui-mfe/module-federation.md) | `rsbuild.config.ts`, mount fns |
| Architecture & host bridge | [architecture-review-guide.md](../reference/review-gui-mfe/architecture-review-guide.md) | RxJS store, `fast-context/` |
| Code quality & share-mfe | [code-quality-mfe.md](../reference/review-gui-mfe/code-quality-mfe.md) | `@gogo/share-mfe` reuse, i18n |
| i18n in MFE | [i18n-mfe.md](../reference/review-gui-mfe/i18n-mfe.md) | Namespaces, `I18nProvider` |

MFE examples: [examples.md](../reference/review-gui-mfe/examples.md).

## Output (Mypage MFE)

Follow **Output Format** and **Quick Checklist** in the common README. Checklist section may be labeled **Mypage MFE Checklist** (agent items only).
