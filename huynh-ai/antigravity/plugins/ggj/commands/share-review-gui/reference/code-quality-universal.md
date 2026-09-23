# Universal Code Quality Anti-Patterns

> Load when: new helpers, refactors, duplicated logic, growing function signatures.
> Repo-specific reuse paths may exist in a project overlay skill.

## Reuse audit (mandatory before new code)

Search before accepting inline logic:

```javascript
// ❌ Reimplement URL helper when project has one
imgSrc: `https://cdn.example.com/img/${path}`

// ✅ Use existing project helper
imgSrc: this.buildAssetUrl(path)
```

```javascript
// ❌ Hand-rolled debounce
methods: { onInput() { clearTimeout(this.t); this.t = setTimeout(...) } }

// ✅ Check utils/ or lodash already in bundle
import debounce from 'lodash/debounce'
```

**Check:** shared `components/`, `utils/`, mixins, and composables before adding new code.

## Parameter sprawl

```javascript
// ❌ Growing positional args
function createPage(ctx, a, b, c, d, e) { ... }

// ✅ Single context / config object
function createPage({ productType, blockType }) { ... }
```

## Leaky abstractions

```vue
<!-- ❌ Child expects raw API response shape -->
<ProductCard :product="apiResponse.data.results[0]" />

<!-- ✅ Map in container; child gets stable props -->
<ProductCard :product="adaptProduct(apiRow)" />
```

## Stringly-typed code

```javascript
// ❌ Magic status strings across files
if (order.status === 'pending') ...

// ✅ Shared constants
import { ORDER_STATUS } from '@/utils/constants'
if (order.status === ORDER_STATUS.PENDING) ...
```

## Nested conditionals

```javascript
// ❌ Nested ternary in template
{{ isSale ? (isMember ? priceMember : priceSale) : priceNormal }}

// ✅ computed
computed: {
  displayPrice() {
    if (!this.isSale) return this.priceNormal
    return this.isMember ? this.priceMember : this.priceSale
  }
}
```

Use early return in data loaders / methods — max ~2 nesting levels.

## Copy-paste variants

```javascript
// ❌ Two modules differ only by one constant — 95% same

// ✅ Factory with parameter
export function createDetailPage(entityType) { ... }
```

## No-op updates

```javascript
// ❌ Poll always commits store even when unchanged
setInterval(async () => {
  const data = await fetchStatus()
  this.$store.commit('setStatus', data)
}, 5000)

// ✅ Compare before commit
if (!isEqual(this.$store.state.status, data)) {
  this.$store.commit('setStatus', data)
}
```

## TOCTOU (async front-end)

```javascript
// ❌ Check then fetch — route may change mid-flight
if (this.$route.params.id === id) {
  const data = await fetch(id)
  this.item = data
}

// ✅ Guard after await with current route/id
const data = await fetch(id)
if (this.$route.params.id !== id) return
this.item = data
```

Cancel in `beforeDestroy` / route watcher cleanup.

## Over-broad operations

```javascript
// ❌ Load full list client-side then filter
const all = await http.get('/api/items?limit=9999')
const filtered = all.data.filter(x => x.type === 'fx')

// ✅ Server filter + pagination
const page = await http.get('/api/items', { params: { type: 'fx', page: 1 } })
```

Trim SSR payload — don't pass entire API response to the client.

## Redundant state

```javascript
// ❌ data + computed duplicate
data() {
  return { items: [], itemCount: 0 }
},
methods: {
  setItems(items) {
    this.items = items
    this.itemCount = items.length
  }
}

// ✅ computed itemCount from items
```

## Review checklist

| Tag | Check |
|-----|-------|
| agent | Searched shared utils/helpers before new util |
| agent | No magic strings for types, routes, API codes |
| agent | No copy-paste modules differing only by constant |
| agent | `computed` for derived UI state; no redundant stored fields |
| agent | Async handlers guard route/id after `await` |
| agent | API calls use filters/pagination, not fetch-all-then-filter |
