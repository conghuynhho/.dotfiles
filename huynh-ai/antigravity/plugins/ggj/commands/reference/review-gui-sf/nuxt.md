# Nuxt 2 — GoGoJungle

> Load when: routes, `asyncData`, layouts, middleware, `nuxt.config.js`, store, SSR.
> Nuxt 2 + Vue 2 · `desktop/` / `mobile/` per locale. Tags: [share-review-gui ownership](../../share-review-gui/README.md#review-ownership).

**Also:** [api-data-fetching.md](../../share-review-gui/reference/api-data-fetching.md) · [vue.md](../../share-review-gui/reference/vue.md) · [readability-seo.md](../../share-review-gui/reference/readability-seo.md) · [security.md](../../share-review-gui/reference/security.md) · [performance.md](../../share-review-gui/reference/performance.md)

> Scope: active surface code only — exclude `packages/` and `archived/`.

## Project & directories

| Topic | Rule |
|-------|------|
| Locales | `ja/`, `en/`, `th/`, `vi/`, `zh/`, `hk/` — each has own `nuxt.config.js` + `desktop/` / `mobile/` |
| Shared code | `common/` (pages, plugins, store, middleware, layouts), root `components/`, `utils/` |
| Builds | Route/config in correct `{locale}/desktop/` or `{locale}/mobile/` `nuxt.config.js` |
| Config layering | Base `{locale}/nuxt.config.js` factory → `Object.assign` in `desktop/` / `mobile/` config |
| `srcDir` / `buildDir` | `srcDir: ${envType}`; `buildDir: .nuxt/${envType}`; `publicPath: /surface/${envType}/` |
| Aliases | `@@/` = repo root; `@/` = current build `srcDir` (desktop or mobile) |
| i18n | `common/plugins/vue-i18n.js`; JSON in `lang/`; component `i18n: { messages }`; `$t()` not hardcoded |
| Locale routing | `/en`, `/th`, `/vi` URL prefix; cookie `lang`; default `ja` |
| Desktop/mobile | Verify both when shared layout/navigation changes; mobile may import desktop pages |
| Side effects | Link URLs; component in multiple layouts; layout slot edits |
| `pages/` | File-based routes; thin `.vue` wrappers OK |
| `common/pages/` | Shared page factories (`.js` / `.vue`); compose with `Object.assign` |
| `common/containers/` | Route logic (asyncData, validate, SEO) — presentational in `common/pages/` |
| `layouts/` | `<Nuxt />` (+ `<nuxt-child>` if nested); `error.vue` for 404/500 |
| `store/` | Root `store/index.js` + `nuxtServerInit`; shared modules in `common/store/`; locale modules one per file |
| `plugins/` | Shared in `common/plugins/`; `ssr: false` / `mode: 'client'` for browser-only |
| `middleware/` | `route-change` (breadcrumb), `auxiliary-tag`; register in desktop/mobile config |
| `ext-router.json` | Extended routes per build — keep in sync with new pages |
| Config | Grouped `head`, `css`, `plugins`, `modules`, `build`, `router`, `env`; no client secrets |

## Data fetching & routing

| Hook | When |
|------|------|
| `asyncData` | Render-critical data in `pages/` only |
| `fetch` | Store/component state |
| `nuxtServerInit` | One-time server store seed — minimal |
| `mounted` | Client-only / browser APIs |

| Tag | Check |
|-----|-------|
| agent | `await`/`return`; `error({ statusCode: 404\|500 })`; loading + error states |
| agent | Use `app.GoGoHTTP` (not raw `$axios`); SSR requests pass `appendGgjHeader({ req })` |
| agent | Context `params`, `store`, `redirect`, `error`, `req` |
| agent | `Promise.all` parallel (e.g. page data + `appendBlockInfoAsyncData`); trim SSR payload |
| agent | Blocked-user pages call `appendBlockInfoAsyncData` with correct `PRODUCT_TYPE_MAP_ID` |
| agent | No page API in layout / `app.vue` / plugin |
| agent | No duplicate fetch after SSR hydration |
| agent | `<NuxtLink>` not `<a href>`; `_param.vue` + `validate()` (e.g. `filterInt`) |
| agent | Route registered in correct desktop/mobile config + `ext-router.json` if needed |
| agent | Shared detail pages: logic in `common/containers/`, UI in `common/pages/` |

## Component patterns (codebase)

| Pattern | Rule |
|---------|------|
| Naming | Shared renew components: `Ggj` prefix (`GgjProductBox`, `GgjFavoriteButton`); domain prefixes (`Navi`, `System`) |
| Container / page | Route page `.js` in `common/containers/` composes `Object.assign(title, { asyncData, validate, … })` + imports presentational `.vue` from `common/pages/` |
| Mixins | Domain mixins (`NaviMixin`, `ArticleMixin`, `blockUser`, `consentCookies`, `ChartWrapper`) — prefer over duplicating logic |
| Blocked user | `appendBlockInfoAsyncData` in asyncData + `blockUser` mixin + `SeriesFloatingPanel` / blocked UI |
| Lazy load | Heavy charts/calendars via `componentFactory` + `common/js/lazy-load-component.js` (client-only) |
| Dynamic import | `() => import('@@/../components/…')` in `components` option for code-split |
| Event bus | `common/plugins/event-bus` — prefer `$emit` / Vuex over bus for new code |
| Images | `ImgWrapper` with `disable-lazy` when above fold; `handleCoverError` fallback on navi items |
| Store commit | Page containers commit to `common/store/` modules (`cart/setInfo`, `navi/pushBC`) — keep mutations sync |
| i18n | Component-level `i18n: { messages }` with JSON from `lang/`; keys via `$t()` |
| Global helpers | `formatNumber`, `formatTime`, `formatCurrency`, `genCDNUrl` from `common/plugins/common.js` — don't reimplement |

## SSR · state · i18n

| Tag | Check |
|-----|-------|
| agent | No `window`/`document`/`localStorage` except `process.client` / `process.browser` / `mounted` |
| agent | DOM widgets: `<client-only>`, `ssr: false`, `mode: 'client'`, or `.client.js` plugin |
| agent | Tracking plugins (GTM, fb-pixel, tiktok, adform, yjtag) must stay `ssr: false` |
| agent | Same server/client markup (no hydration mismatch) |
| agent | `nuxtServerInit` minimal — user, cart count, banners, bot flag, site notices only |
| agent | Vuex: no prop drilling 3+ levels; `mapState`/`mapActions`; sync mutations |
| agent | Breadcrumbs via `setBC`/`pushBC`; middleware `route-change` updates on navigation |
| agent | SSR → store or page `data` → children (single source) |
| agent | State reset on logout/route leave; shared `common/store/` safe across locales + builds |
| agent | Persisted state versioned if shape changes |
| agent | `head()` via `common/pages/index.js` mixin or page override; `hid` on meta; JSON-LD where needed |
| agent | `processMetaSEO` / `ROBOTS_HEADER` for bot/crawl pages |
| agent | `isBot` / `DATA_ATTR_GGJ_BOT` respected for bot-specific rendering |
| agent | Sanitized `v-html` — [security.md](../../share-review-gui/reference/security.md) |
| human | No hydration warnings; desktop + mobile builds when layout shared |
| human | JA copy vs JP spec; locale-specific title keys (`title2` vs `title` for `ja`) |

## Build & plugins (codebase)

| Topic | Rule |
|-------|------|
| Style | `@nuxtjs/style-resources` — bootstrap `variables.less` globally |
| Transpile | `highcharts`, `highcharts-custom-events`, `@ggj/push-notification` |
| Chunks | `splitChunks.cacheGroups.highcharts` — don't duplicate vendor config |
| Polyfills | Babel `corejs: 3` + IE polyfills in base config — test before removing |
| Sentry | `getSentryPlugins` in client build; `hidden-source-map` in production |
| Global mixin | `common/plugins/common.js` — `formatNumber`, `formatTime`, `formatCurrency`, `genCDNUrl` |
| HTTP | `common/plugins/http-proxy` — `GoGoHTTP` injected on `app` and `Vue.prototype` |
| Loading bar | `loading: false` — use component-level loading states instead |

## Nuxt-specific pitfalls

| Area | Mistake |
|------|---------|
| Data | Slow `asyncData` blocks TTFB; oversized `__NUXT__` payload |
| SSR | Heavy `nuxtServerInit`; `window` on server |
| Hydration | Different server/client markup |
| Mode | Wrong rendering mode (`universal` / `static` / `spa`) |
| Bundle | Page-specific logic in global plugins |
| Aliases | Wrong `@@/` vs `@/` import — breaks cross-build shared code |
| Locale | Hardcoded `/ja` paths; missing `basePath` from route for non-default langs |
| Mobile | Forgetting mobile `nuxt.config.js` also scans desktop pages for shared routes |
| Block | Missing `appendBlockInfoAsyncData` on user-facing product/article/series/event pages |
| Charts | Highcharts in separate chunk — lazy-load via `componentFactory`, don't import at page top |

Vue general rules (`:key`, `computed`, props, lifecycle) → [vue.md](../../share-review-gui/reference/vue.md). CDN/images/cross-browser → [performance-surface.md](performance-surface.md) · [performance.md](../../share-review-gui/reference/performance.md).

## Review checklist

| Tag | Check |
|-----|-------|
| agent | Correct locale + desktop/mobile dirs; `@@/` / `@/` imports |
| agent | `GoGoHTTP` + `appendGgjHeader`; `common/containers/` vs `common/pages/` split |
| agent | Component patterns above (`Ggj` naming, mixins, `componentFactory`, blocked-user) |
| agent | `asyncData`/`fetch` rules above |
| agent | `nuxtServerInit` lean; breadcrumb middleware; `ext-router.json` updated |
| agent | SSR/state/i18n/SEO/security rules above |
| agent | Tracking plugins `ssr: false`; lazy heavy components |
| agent | Vue general rules — [vue.md](../../share-review-gui/reference/vue.md) |
| ci | `nuxt build --analyze` when deps change; Lighthouse on public routes |
