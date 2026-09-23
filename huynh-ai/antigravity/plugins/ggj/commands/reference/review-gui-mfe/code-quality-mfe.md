# Code Quality — Mypage MFE & share-mfe

> Load when: `@gogo/share-mfe` reuse, API handlers, state updates.
> Universal → [code-quality-universal.md](../../share-review-gui/reference/code-quality-universal.md).

## Reuse `@gogo/share-mfe` first

| Package area | Examples |
|--------------|----------|
| fast-context | `createFastContext`, `SubscribeRxjsStore`, `useFastDispatch` |
| components | `GgjToast`, `VueLink`, `GgjImageCropper`, `I18nProvider`, `ThemeRegistry` |
| utils | `formatDate`, `cdn`, `url`, `refreshAuthCookie` |

New cross-MFE UI belongs in `packages/gui/share-mfe` — not duplicated per app.

## fast-context pattern

```
src/fast-context/
  VideoStoreProvider.tsx    # createFastContext + SubscribeRxjsStore
  api.ts                    # async handlers via useDispatchFastContext
```

| Tag | Check |
|-----|-------|
| agent | Async mutations in `api.ts` — `setSelector`, `getState` |
| agent | Immer for nested updates |
| agent | Custom subscriptions cleaned up |
| agent | Loading / empty / error states on fetch |
| agent | Types from `@gogo/share` for domain models |
| agent | `appConfig` for CDN — not hardcoded hosts |
| agent | No `console.log` in production paths |

## Host http usage

```tsx
const [http] = useStore(state => state.http)
if (http) {
  http.get('/api/v3/terms/user').then(...)
}
```

Never instantiate separate HTTP client in MFE.

## ai-signal exception

Uses plain React Context (`useAiSignalStore`) — no RxJS bridge. Review accordingly.
