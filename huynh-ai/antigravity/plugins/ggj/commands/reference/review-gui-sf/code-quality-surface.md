# Code Quality — Surface Monorepo

> Load when: new helpers, refactors, duplicated logic in surface.gogojungle.co.jp.
> Universal patterns → [code-quality-universal.md](../../share-review-gui/reference/code-quality-universal.md).

## Reuse audit (mandatory before new code)

Search before accepting inline logic:

```javascript
// ❌ Reimplement CDN URL — project has genCDNUrl
imgSrc: `https://cdn.example.com/img/${path}`

// ✅ common/plugins/common.js
imgSrc: this.genCDNUrl(path)
```

```javascript
// ❌ Hand-rolled debounce
methods: { onInput() { clearTimeout(this.t); this.t = setTimeout(...) } }

// ✅ Check utils/ or lodash already in bundle
import debounce from 'lodash/debounce'
```

**Check:** `common/`, `components/`, `@@/utils/`, mixins (`NaviMixin`, `blockUser`, `ArticleMixin`, etc.).

## Surface-specific patterns

### Parameter sprawl in containers

```javascript
// ❌ Growing options in container factory
Object.assign(title, { asyncData(ctx, a, b, c, d, e) { ... } })

// ✅ Single context object / config
function createPage({ productType, blockType }) {
  return Object.assign(title, {
    asyncData(ctx) { ... }
  })
}
```

### Leaky abstractions

```vue
<!-- ❌ Child expects raw GoGoHTTP response shape -->
<GgjProductBox :product="apiResponse.data.results[0]" />

<!-- ✅ Map in container; child gets stable props -->
<GgjProductBox :product="adaptProduct(apiRow)" />
```

### Copy-paste containers

```javascript
// ❌ Two containers differ only by PRODUCT_TYPE_MAP_ID
// common/containers/navi/article/a.js
// common/containers/navi/article/b.js  (95% same)

// ✅ Factory with parameter
export function createArticleContainer(productTypeMapId) { ... }
```

### Over-broad API fetch

```javascript
// ❌ Load full list client-side then filter
const all = await GoGoHTTP.get('/api/items?limit=9999')
const filtered = all.data.filter(x => x.type === 'fx')

// ✅ Server filter + pagination
const page = await GoGoHTTP.get('/api/items', { params: { type: 'fx', page: 1 } })
```

Trim SSR payload — don't pass entire API response into `__NUXT__`.

## Review checklist

| Tag | Check |
|-----|-------|
| agent | Searched `common/`, mixins, `genCDNUrl` / format helpers before new util |
| agent | No magic strings for product types, routes, API codes — use shared constants |
| agent | No copy-paste containers differing only by constant |
| agent | `computed` for derived UI state; no redundant stored fields |
| agent | Async handlers guard route/id after `await` |
| agent | API calls use filters/pagination, not fetch-all-then-filter |
| agent | Container maps API → stable props before presentational components |
