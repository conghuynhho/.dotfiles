# Performance

> Load when: images, bundle, CDN, CWV, lists, animations.
> Deep workflow → [performance-review-guide.md](performance-review-guide.md). CSS rules → [css-less-sass.md](css-less-sass.md). Vue lifecycle → [vue.md](vue.md). Tags: [README.md](../README.md#review-ownership).

## Quick checklist

| Tag | Check |
|-----|-------|
| agent | Lazy-load below-fold images/iframes; LCP hero **not** lazy |
| agent | `aspect-ratio` / dimensions on images — avoid CLS |
| agent | `beforeDestroy` cleanup; debounce input API; clear timers |
| agent | Dynamic `import()` for heavy charts/editors; tree-shake utilities |
| agent | `100dvh` + `100vh` fallback; touch targets ≥ 44px |
| agent | Env CDN base — no raw internal bucket paths in HTML |
| agent | Parallel independent fetches (`Promise.all`); no fetch-all-then-filter |
| ci | Bundle analyze when adding deps; Lighthouse on changed pages |
| ci | `curl -I <asset-url>` for `Cache-Control` on production |
| human | Cross-browser layout; iOS fixed footer + keyboard |

## Core Web Vitals

| Metric | Good | Needs work |
|--------|------|------------|
| **LCP** | ≤ 2.5s | Hero lazy-loaded, slow server data fetch |
| **INP** | ≤ 200ms | Long sync tasks on click/input |
| **CLS** | ≤ 0.1 | Images without size, dynamic insert above fold |
| **FCP** | ≤ 1.8s | Blocking CSS/fonts |

```vue
<!-- ❌ LCP candidate lazy-loaded -->
<img :src="heroUrl" loading="lazy" />

<!-- ✅ Above-fold: eager + sized -->
<img :src="heroUrl" fetchpriority="high" width="800" height="450" />
```

```css
.banner img { width: 100%; aspect-ratio: 16 / 9; }
```

- [ ] Server data on LCP route lean — blocks TTFB
- [ ] Trim SSR payload — don't embed full API responses
- [ ] `min-height` on ad/skeleton slots; `font-display: swap` for webfonts

## Lists, memory & algorithms

- [ ] 100+ items → pagination or virtual scroll (`[human]` verify)
- [ ] Stable `:key` on `v-for`; `computed` not heavy methods in template
- [ ] Remove listeners/timers in `beforeDestroy` ([vue.md](vue.md))

| Pattern | Flag |
|---------|------|
| Nested loops on same array | 🟠 if n can be large — use `Set`/`Map` |
| `arr.includes()` or `find` inside loop | O(n²) |

## Severity

| Finding | Label |
|---------|-------|
| LCP image lazy-loaded | 🔴 blocking |
| Missing cleanup → leak on navigation | 🟠 important |
| Whole library for one function | 🟡 nit |
| No bundle analyze on new heavy dep | `[ci]` |

## Tools

Lighthouse (LCP, CLS) · bundle analyzer · Chrome Performance / Memory
