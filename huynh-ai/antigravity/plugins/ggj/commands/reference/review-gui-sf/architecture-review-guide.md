# Architecture Review Guide — GoGoJungle Front-End

> Load when: new routes, store modules, shared containers, large refactors, or unclear file placement.
> GGJ patterns → [nuxt.md](nuxt.md). Quality → [code-quality-surface.md](code-quality-surface.md) · [code-quality-universal.md](../../share-review-gui/reference/code-quality-universal.md).

## Layering in this monorepo

```
pages/ / common/containers/     ← route logic (asyncData, validate, SEO)
common/pages/                   ← presentational page UI (.vue)
components/                     ← shared presentational + domain components
common/store/                   ← shared Vuex modules
{locale}/desktop|mobile/        ← build entry + nuxt.config.js
```

**Dependency rule (inward):** presentational layers must not import route containers or call `GoGoHTTP` directly unless the component is explicitly a data container.

| Layer | May depend on | Must not depend on |
|-------|---------------|-------------------|
| `common/pages/*.vue` | components, mixins, `$t()` | `asyncData`, raw HTTP in `mounted` for SSR-critical data |
| `common/containers/*.js` | pages, store, `GoGoHTTP`, mixins | desktop/mobile-specific paths hardcoded |
| `components/*` | other components, utils | locale-specific `nuxt.config` |
| `common/store/*` | utils | page components |

### Review questions

- "Does this `.vue` file belong in `common/pages/` or `components/`?"
- "Is route logic leaking into a reusable component?"
- "Will mobile and desktop both need this — is it in `common/`?"

## SOLID (front-end adaptation)

### Single responsibility

| Signal | Action |
|--------|--------|
| Container `.js` > 200 lines mixing SEO + fetch + 5 UI states | Split container vs presentational |
| Component handles fetch + format + render + analytics | Extract mixin or Vuex action |
| Mixin name like `EverythingMixin` | Split by domain |

### Open/closed

| Signal | Action |
|--------|--------|
| Growing `if (productType === …)` in one template | Map/lookup or small sub-components |
| New locale needs copy-paste of entire page | Extend `common/pages` factory with `Object.assign` |

### Dependency inversion

```javascript
// ❌ Component reaches for global HTTP + store shape
this.$axios.get('/api/x').then(r => this.items = r.data)

// ✅ Page container owns fetch; child gets props
// common/containers/foo.js → asyncData → common/pages/Foo.vue props
```

## Anti-patterns (GGJ context)

| Anti-pattern | Signal | Severity |
|--------------|--------|----------|
| **God page** | One `asyncData` fetches 10 APIs, sets 20 data fields | 🟠 important |
| **Big ball of mud** | New feature adds logic to layout + plugin + random mixin | 🟠 important |
| **Copy-paste locale** | Same block in `ja/` and `en/` instead of `common/` | 🟡 nit → 🟠 if logic diverges |
| **Lava flow** | "Don't touch `event-bus`" with no tests | 📚 learning |
| **Boat anchor** | Unused mixin import left "for later" | 🟡 nit |

## Coupling & cohesion

**Good coupling:** props/events between parent/child; Vuex actions for shared cart/breadcrumb.

**Bad coupling:**
- Event bus for new features (prefer `$emit` / Vuex — see [nuxt.md](nuxt.md))
- Importing `@/pages/...` from another build's `srcDir`
- Prop drilling 4+ levels instead of Vuex or provide/inject

**Cohesion check:** methods in one component should operate on the same props/data. If half the methods ignore `productId`, split the component.

## File organization

**Prefer (domain in `common/`):**
```
common/containers/navi/article/article-detail.js
common/pages/navi/article/ArticleDetail.vue
common/store/navi/
```

**Avoid:**
```
ja/desktop/pages/.../huge-monolith.vue   ← duplicates en/th/vi later
```

### Size guidelines

| Unit | Soft limit |
|------|------------|
| SFC template + script | ~300 lines |
| Container `asyncData` | ~50 lines — extract helpers to `utils/` |
| Vuex module | One domain per file |
| Function params | ≤ 4 — use options object |

## Nuxt-specific architecture checks

| Tag | Check |
|-----|-------|
| agent | SSR-critical data in `asyncData`/`fetch`, not `mounted` only |
| agent | `common/containers/` vs `common/pages/` split respected |
| agent | Shared code under `common/` or root `components/`, not duplicated per locale |
| agent | `@@/` for cross-build imports; `@/` for current `srcDir` only |
| agent | `ext-router.json` updated when adding extended routes |
| agent | Heavy UI lazy-loaded via `componentFactory` — not top-level import |
| agent | Tracking/analytics plugins stay `ssr: false` |

## Quick 5-minute architecture scan

```markdown
□ New files in correct locale + desktop/mobile + common/ layer?
□ Route logic separated from presentational .vue?
□ No duplicate fetch after SSR hydration?
□ Store used for cross-page state instead of prop drilling?
□ No circular imports between containers and store?
```

## Red flags

```markdown
🔴 Page API in layout / app.vue / global plugin
🔴 Domain logic in `components/` that fetches and mutates global state ad hoc
🔴 Hardcoded secrets or internal URLs in client bundle
🟡 Wrong alias (`@/` vs `@@/`) breaking mobile/desktop shared code
🟡 Missing `appendBlockInfoAsyncData` on blocked-user product pages
```

## Tools

| Tool | Use |
|------|-----|
| ESLint | complexity, import rules |
| `nuxt build --analyze` | bundle coupling to heavy deps |
| Madge | circular JS dependencies (`npx madge --circular common/`) |
