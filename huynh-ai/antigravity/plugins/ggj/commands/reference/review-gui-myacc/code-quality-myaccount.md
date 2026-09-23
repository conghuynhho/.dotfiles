# Code Quality — MyAccount

> Load when: any logic/data PR in myaccount.
> Source: `apps/gui/myaccount/README.md` Frontend checklist.
> Universal → [code-quality-universal.md](../../share-review-gui/reference/code-quality-universal.md).

## Official checklist (from README)

| Tag | Check |
|-----|-------|
| agent | Re-render issues on large forms |
| agent | Scroll to input on validation error |
| agent | Colors/fonts from `theme.config.ts` — not hardcoded |
| agent | `ggjDebounce` on API calls from clicks |
| agent | Client API: try/catch + `toastHandler` app error |
| agent | SSR API: no client toast pattern |
| agent | No array index as `key` |
| agent | Upload: extension, size, count — toast on validation fail |
| agent | Response typed `TGgjRes<T>` (`app.d.ts`) |
| agent | API code in `store/xxxSlice.ts` |

## Upload validation (design guideline)

```tsx
if (validateError) {
  toastHandler({ message: t('format-not-supported'), type: 'error' })
}
```

Form submit: show Backdrop via `loadingOnHandler` / `loadingOffHandler`.

## Redux patterns

| Tag | Check |
|-----|-------|
| agent | `reducerManager.add` in GSSP + `remove` on unmount |
| agent | `HYDRATE` correct for feature slices |
| agent | Static reducers: `app`, `alert`, `loading` |

## Persistent layout

`Component.PageLayout` pattern — layout not re-mounted on link click (see README Adam Wathan pattern).
