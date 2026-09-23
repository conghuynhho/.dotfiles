# Architecture Review Guide — Front-End

> Load when: new routes, state modules, large refactors, or unclear file placement.
> Quality anti-patterns → [code-quality-universal.md](code-quality-universal.md).
> Repo-specific layering (e.g. Nuxt monorepo) may exist in a project overlay skill.

## Layering (general)

Separate **route/data logic** from **presentational UI**:

```
route / page container    ← data fetch, validation, SEO, routing
presentational components ← props in, events out
shared state              ← store for cross-page data
```

**Dependency rule (inward):** presentational layers must not own SSR-critical fetch or call HTTP directly unless the component is explicitly a data container.

| Layer | May depend on | Must not depend on |
|-------|---------------|-------------------|
| Presentational `.vue` | child components, i18n | route-only hooks for SSR-critical data |
| Page / route container | presentational views, store, HTTP client | build-specific paths hardcoded in shared UI |
| Shared components | other components, utils | framework config internals |
| Store modules | utils | page/view components |

### Review questions

- "Does this file belong with route logic or reusable UI?"
- "Is fetch/validation leaking into a dumb component?"
- "Will multiple entry points need this — is it in a shared layer?"

## SOLID (front-end adaptation)

### Single responsibility

| Signal | Action |
|--------|--------|
| Page container > 200 lines mixing SEO + fetch + many UI states | Split container vs presentational |
| Component handles fetch + format + render + analytics | Extract store action or child container |
| Mixin name like `EverythingMixin` | Split by domain |

### Open/closed

| Signal | Action |
|--------|--------|
| Growing `if (type === …)` in one template | Map/lookup or small sub-components |
| New variant needs copy-paste of entire page | Factory / composition pattern |

### Dependency inversion

Presentational components get stable props from route/container — not raw HTTP + API shape. See [code-quality-universal.md](code-quality-universal.md#leaky-abstractions).

## Anti-patterns

| Anti-pattern | Signal | Severity |
|--------------|--------|----------|
| **God page** | One loader fetches many APIs, sets many fields | 🟠 important |
| **Big ball of mud** | New feature adds logic to layout + plugin + random mixin | 🟠 important |
| **Copy-paste variant** | Same block duplicated per locale/route instead of shared module | 🟡 nit → 🟠 if logic diverges |
| **Lava flow** | Legacy module "don't touch" with no tests | 📚 learning |
| **Boat anchor** | Unused import left "for later" | 🟡 nit |

## Coupling & cohesion

**Good coupling:** props/events between parent/child; store actions for shared state.

**Bad coupling:**
- Global event bus for new features (prefer `$emit` / store)
- Cross-layer imports that create circular deps
- Prop drilling 4+ levels instead of store or provide/inject

**Cohesion check:** methods in one component should operate on the same props/data. If half the methods ignore a key prop, split the component.

## Size guidelines

| Unit | Soft limit |
|------|------------|
| SFC template + script | ~300 lines |
| Route data loader | ~50 lines — extract helpers |
| Store module | One domain per file |
| Function params | ≤ 4 — use options object |

## Framework checks (Nuxt / SSR)

| Tag | Check |
|-----|-------|
| agent | SSR-critical data in route hooks, not client-only lifecycle |
| agent | Container vs presentational split respected |
| agent | Shared code not duplicated per build entry |
| agent | Heavy UI lazy-loaded — not top-level import |
| agent | Analytics / browser-only plugins client-only |

## Quick 5-minute architecture scan

```markdown
□ New files in correct layer (shared vs route-specific)?
□ Route logic separated from presentational .vue?
□ No duplicate fetch after SSR hydration?
□ Store used for cross-page state instead of prop drilling?
□ No circular imports between containers and store?
```

## Red flags

```markdown
🔴 Page API in root layout / app shell / global plugin
🔴 Domain logic in shared components that fetch and mutate global state ad hoc
🔴 Hardcoded secrets or internal URLs in client bundle
🟡 Wrong import path breaking shared code across builds
```

## Tools

| Tool | Use |
|------|-----|
| ESLint | complexity, import rules |
| Bundle analyzer | coupling to heavy deps |
| Madge | circular JS dependencies |
