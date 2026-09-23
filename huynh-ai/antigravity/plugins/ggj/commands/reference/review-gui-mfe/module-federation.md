# Module Federation — Mypage MFE

> Load when: `rsbuild.config.ts`, `src/exposes/`, remote entry, shared deps.
> Host contract → [architecture-review-guide.md](architecture-review-guide.md).

## Remote app structure

```
mypage-{app}/
├── modules/i18n/i18n.config.js
├── lang/                  # built JSON
├── src/
│   ├── exposes/           # mount fns ONLY (HMR caveat)
│   ├── components/        # real UI
│   └── fast-context/      # per-feature store
├── rsbuild.config.ts
└── package.json           # gg.mypage-mfe.{app}
```

## Expose contract

```tsx
// src/exposes/pages@video-library.tsx
export default function mountVideoLibrary(
  rootElement: HTMLElement,
  options: { store: StoreObject }
) {
  const root = createRoot(rootElement)
  root.render(<Providers store={options.store}><VideoLibrary /></Providers>)
  return () => root.unmount()
}
```

| Rule | Detail |
|------|--------|
| Naming | `pages@video-library`, `components@MsgList` |
| Mount | Default export; return cleanup `() => root.unmount()` |
| Logic | In `components/` — not in `exposes/` (HMR) |
| Providers | `*StoreProvider` → `I18nProvider` → `ThemeRegistry isMypage` → optional `GgjToast` |
| Type | Export `StoreObject` for host typing |

## rsbuild.config.ts

| Setting | Rule |
|---------|------|
| `name` | Package name with `-` → `_` (e.g. `mypage_video`) |
| `exposes` | Map `./pages@X` → expose file path |
| `shared` | `react`, `react-dom`, `@emotion/*`, `react-i18next` as singletons |
| `dedupe` | Shared deps deduped — no duplicate React bundles |
| `assetPrefix` | localhost dev or `{CDN}/mfe/{name}/` |
| Port | Register in `@gogo/share-mfe/list-mfe-port/mypage-mfe-ports.js` |

## Review checklist

| Tag | Check |
|-----|-------|
| agent | New expose registered in `rsbuild.config.ts` |
| agent | Mount fn returns cleanup |
| agent | `shared` + `dedupe` updated for new peer deps |
| agent | Port added for new app |
| ci | `yarn build:lang` run when i18n changed |
