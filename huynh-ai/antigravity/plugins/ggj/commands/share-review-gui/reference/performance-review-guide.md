# Performance Review Guide (Deep)

> Load when: new dependencies, LCP/hero routes, large lists, charts/editors, or bundle/CSS changes.
> Quick checklist → [performance.md](performance.md). Surface CDN/charts → project overlay `performance-surface.md` if present.

## When to run deep review

Run this guide when the diff touches:

- New npm package or heavy import (`highcharts`, editor, calendar)
- Above-fold images or LCP route (`asyncData` on listing/detail hero)
- Lists/tables with 100+ rows or client-side filter/sort
- Global CSS, webfonts, or layout shell changes
- `nuxt.config.js` `build`, `plugins`, or code-split boundaries

## Step-by-step

### 1 — Identify critical path

```markdown
□ What is LCP element on changed page? (hero image, H1 block, product image)
□ What blocks TTFB? (asyncData payload size, serial fetches)
□ What blocks interactivity? (sync work on click/input)
```

### 2 — Images & CLS

| Check | Flag |
|-------|------|
| LCP image has `loading="lazy"` | 🔴 blocking |
| Missing width/height or `aspect-ratio` | 🟠 CLS risk |
| Below-fold lazy; above-fold eager + sized | ✅ |

### 3 — Bundle & imports

| Check | Action |
|-------|--------|
| New dependency | `[ci]` bundle analyze — note size delta |
| Heavy UI at page top level | Dynamic `import()` / lazy factory |
| Whole library for one function | Tree-shake or smaller alternative |
| lodash | Import single method, not full package |

### 4 — Data fetching

| Anti-pattern | Fix |
|--------------|-----|
| Serial independent API calls | `Promise.all` |
| Full list + client filter | Server params + pagination |
| Entire API in `__NUXT__` | Trim SSR payload |

### 5 — Lists & complexity (practical only)

Review **only when diff has loops, filters, or large collections**:

| Pattern | Severity |
|---------|----------|
| `find`/`includes` inside loop over same array | 🟠 if n can grow |
| Nested loops on same dataset | 🟠 — consider `Map`/`Set` lookup |
| Re-sort / deep clone every render | 🟠 — `computed` + memoize |
| 100+ DOM nodes without virtual scroll | 🟠 + `[human]` verify |

Do **not** apply formal DSA review to copy/CSS-only PRs.

### 6 — Runtime & memory

- `beforeDestroy`: remove listeners, clear intervals, abort fetches if supported
- Debounce search/resize/input API handlers
- `v-show` vs `v-if` for frequently toggled UI

## CI / human follow-up

| Situation | Tag |
|-----------|-----|
| Changed LCP route | `[ci]` Lighthouse LCP/CLS |
| New heavy dep | `[ci]` `nuxt build --analyze` |
| iOS fixed footer / keyboard | `[human]` device check |
| CDN asset caching | `[ci]` `curl -I` on production URL |

## Severity recap

See [performance.md](performance.md#severity). Default: perf nits → 🟡 unless LCP/CLS regression on key route.
