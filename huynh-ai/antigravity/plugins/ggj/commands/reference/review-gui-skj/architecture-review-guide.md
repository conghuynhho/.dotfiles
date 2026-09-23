# Architecture Review Guide — Skijan

> Load when: `@country-components`, file placement, layouts, refactors.
> Country system → key section below · Quality → [code-quality-skijan.md](code-quality-skijan.md).

## Layering

```
apps/gui/skijan[-locale]/pages/     ← thin wrappers (Layout + re-export)
packages/gui/skijan/
  pages/                            ← GSSP + page component
  page-components/                  ← feature UI
  components/                       ← Ggj* / Skj*
  layouts/                          ← Surface, Mypage, Inquiry, Transaction
  store/                            ← Redux slices + API
  fast-context/                     ← auth, transaction chat, video-skill
  country-components/               ← shared multi-locale overrides
```

## Country override system

Import `@country-components` / `@country-constants` in shared code.

Webpack resolves: **app override → package fallback**.

| Placement | When |
|-----------|------|
| `page-components/` | Shared across locales |
| `packages/.../country-components/` | Multi-locale variant |
| `apps/.../country-components/` | Single-locale only |

**Review:** No inline `if (locale === 'vi')` when country constants exist.

## Layout rules

- `_app.tsx` throws if page missing Layout
- `LayoutSettings` static config on page (e.g. `maxWidth`)
- `LayoutContext.updateLayoutSetting` for dynamic header/bg

## Anti-patterns

| Anti-pattern | Severity |
|--------------|----------|
| API in component instead of `store/*Slice.ts` | 🟠 important |
| Missing Layout on new page | 🔴 blocking |
| Locale logic duplicated across apps | 🟠 important |
| Auth UI without `useIsLoggedIn()` | 🟠 important |
