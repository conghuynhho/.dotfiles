# Code Quality — Accounts

> Load when: auth forms, API calls, toast/loading, i18n.
> Universal → [code-quality-universal.md](../../share-review-gui/reference/code-quality-universal.md).

## API & Redux

| Tag | Check |
|-----|-------|
| agent | API functions in `store/*Slice.ts` |
| agent | Dynamic slice: `add` in GSSP, `remove` on unmount |
| agent | `HYDRATE` handles SSR → client merge |
| agent | Response typed with `TGgjRes<T>` |

## UX patterns

```tsx
// Client submit pattern
try {
  loadingOnHandler()
  const { data, error } = await authApi(...)
  if (error) { /* business error */ return }
  // success
} catch {
  toastHandler({ type: 'error' })
} finally {
  loadingOffHandler()
}
```

| Tag | Check |
|-----|-------|
| agent | `loadingOnHandler` / `loadingOffHandler` paired |
| agent | `toastHandler` for user-visible errors |
| agent | `ggjDebounce` on multi-click actions |
| agent | All strings via `useTranslation(ns)` |
| agent | GSSP loads required namespaces |

## Styling

- Media queries: **min-width**, mobile-first
- Emotion for SSR styling; scss/built-in CSS also used
- Application error vs business error display per spec
