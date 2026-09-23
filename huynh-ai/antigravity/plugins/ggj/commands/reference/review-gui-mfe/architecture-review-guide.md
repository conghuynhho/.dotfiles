# Architecture Review Guide — Mypage MFE

> Load when: host bridge, `fast-context/`, RxJS store, navigation.

## Host ↔ Remote contract

```
Host (Vue gui-mypage)              Remote (React MFE)
─────────────────────              ──────────────────
initMFE([module])                  remoteEntry.js
MountReactComponent                mount(rootEl, { store })
  :module-name="name/expose"
  :mfe-options="{ store }"
```

**Out of scope:** Host `MountReactComponent` implementation — review only MFE side + contract breaks.

## Store passed via `mfeOptions.store`

| Key | Type | MFE usage |
|-----|------|-----------|
| `lang` | `string` or `BehaviorSubject<string>` | `I18nProvider` |
| `http` | `IHttp` (Axios) | All API — **never** create own client |
| `vueRouter` | `VueRouter` | Navigation, `VueLink` |
| `appConfig` | env map | CDN URLs, flags |
| `user` | object | User context (banner) |
| Host callbacks | functions | `onReply`, delete confirm, etc. |

## RxJS bridge

1. Host owns `BehaviorSubject`s
2. MFE `extractStateFromRxjsStore` seeds fast-context
3. `SubscribeRxjsStore` subscribes → `setSelector` on change

```tsx
// ❌ One-time read of reactive host state
const lang = store.lang.getValue() // stale after host update

// ✅ SubscribeRxjsStore + useStore selector
const [lang] = useStore(state => state.lang)
```

## Navigation

- `vueRouter.push(...)` from store
- `@gogo/share-mfe/components/VueLink` with `router={vueRouter}`
- Avoid `window.location` unless intentional full reload

## MFE-in-MFE

Documented via `remotes` in consumer `rsbuild.config.ts` — verify shared dep versions if used.

## Anti-patterns

| Anti-pattern | Severity |
|--------------|----------|
| Raw `fetch` / new Axios in MFE | 🔴 blocking |
| Business logic in `exposes/` file | 🟠 important |
| Missing `root.unmount()` cleanup | 🟠 important |
| Prop drilling past 2 levels when context exists | 🟡 nit |
