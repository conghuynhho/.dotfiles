# Architecture Review Guide — GGJ

> Load when: new routes, `page-components/`, country overrides, refactors.
> App Router → [nextjs-app-router.md](nextjs-app-router.md) · Quality → [code-quality-ggj.md](code-quality-ggj.md).

## Layering

```
apps/gui/ggj-{ja,en,th}/src/app/     ← thin routes (metadata + re-export)
packages/gui/ggj/
  page-components/                   ← feature UI per route
  components/                        ← Ggj* shared primitives
  fast-context/                      ← createFastContext providers
  common/                            ← http, i18n, CDN helpers
  country-components/                ← locale/country overrides (when used)
```

## Dependency rule

Presentational `Ggj*` components must not own route-level data fetching or direct HTTP unless explicitly a data container.

| Layer | May depend on | Must not depend on |
|-------|---------------|-------------------|
| `page-components/` | `Ggj*`, fast-context, common utils | Locale app `nuxt.config`-style hacks |
| `components/Ggj*` | other components, theme | App-specific route params hardcoded |
| `src/app/` routes | page-components, metadata helpers | Inline business logic duplicating package |

## Country / locale overrides

- Prefer shared package + country constants over inline `if (locale === …)`
- Locale apps stay thin — logic belongs in `@gogo/gui-ggj`

## Anti-patterns

| Anti-pattern | Severity |
|--------------|----------|
| Server fetch logic in client-only component without boundary | 🟠 important |
| Duplicate page UI across `ggj-ja` / `ggj-en` / `ggj-th` | 🟠 important |
| New helper instead of existing `Ggj*` / common util | 🟡 nit |
| Secrets in `NEXT_PUBLIC_*` | 🔴 blocking |
