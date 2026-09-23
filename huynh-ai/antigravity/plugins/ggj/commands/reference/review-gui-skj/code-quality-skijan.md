# Code Quality — Skijan

> Load when: Redux slices, fast-context, API, forms.
> Universal → [code-quality-universal.md](../../share-review-gui/reference/code-quality-universal.md).
> Official checklist: `apps/gui/skijan/README.md`.

## Mandatory conventions

| Rule | Detail |
|------|--------|
| API in slices | `store/*Slice.ts` — not in components |
| Debounce | `ggjDebounce` from `@gogo/gui-share/event-utils/ggjDebounce` |
| Keys | No array index as React `key` |
| Upload | Extension, size, count validated |
| Types | `TGgjRes<T>`, `AppError`, `IPaging` |

## Redux + reducerManager

```tsx
// GSSP registers slice
reducerManager.add(featureSlice)
// Component unmount removes
useEffect(() => () => reducerManager.remove(ns), [])
```

| Tag | Check |
|-----|-------|
| agent | `HYDRATE` merges SSR state correctly |
| agent | Feature slice registered in GSSP **and** page |
| agent | Auth from fast-context — not duplicated local state |

## Component naming

- `Ggj*` — shared GGJ primitives (`GgjButton`, `GgjEditor`, `GgjPaymentPanel`)
- `Skj*` — Skijan-specific (`SkjProductBox`, `SkjOnlineBadge`)

## Forms & UX

| Tag | Check |
|-----|-------|
| agent | Scroll to first error on validation fail |
| agent | Theme tokens — no magic colors/fonts |
| human | Re-render on large forms; mobile Safari input blur |
| human | `NoSsr` / lazy for heavy widgets (GTM, push modal) when `isBot` |
