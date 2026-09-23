# Performance — Surface (Nuxt 2 / GGJ)

> Load when: LCP routes, CDN, Highcharts, bundle changes in surface monorepo.
> Universal perf → [performance.md](../../share-review-gui/reference/performance.md).

## LCP (Nuxt 2 / surface)

```vue
<!-- ❌ LCP candidate lazy-loaded -->
<img :src="genCDNUrl(hero)" loading="lazy" />

<!-- ✅ Above-fold hero: eager + CDN resize -->
<ImgWrapper :src="hero" disable-lazy />
```

- [ ] `asyncData` on LCP route stays lean — blocks TTFB
- [ ] Trim `__NUXT__` payload — don't embed full API responses
- [ ] CDN resize URLs (`img/*`) for hero dimensions

## JavaScript & bundle (surface)

```javascript
// ❌ Page-top heavy import
import Highcharts from 'highcharts'

// ✅ componentFactory + lazy-load-component.js
components: { Chart: () => componentFactory(() => import('...')) }
```

| Tag | Check |
|-----|-------|
| agent | Dynamic `import()` for charts, calendars, editors |
| agent | Highcharts in separate chunk — don't duplicate in `nuxt.config` |
| ci | `nuxt build --analyze` when adding dependencies |

## API / data fetching perf

```javascript
// ❌ Sequential independent calls
const a = await GoGoHTTP.get('/a')
const b = await GoGoHTTP.get('/b')

// ✅ Parallel in asyncData
const [a, b] = await Promise.all([
  GoGoHTTP.get('/a'),
  GoGoHTTP.get('/b'),
])
```

- [ ] Debounce search/input API
- [ ] No fetch-all-then-filter client-side
- [ ] Poll only when needed; compare before Vuex commit

## CDN & caching

| Tag | Check |
|-----|-------|
| agent | `genCDNUrl` / env CDN base — no raw S3 paths in HTML |
| ci | `curl -I <asset-url>` — `Cache-Control` on production |
| ci | Lighthouse on changed public routes |

Nuxt build config → [nuxt.md](nuxt.md).
