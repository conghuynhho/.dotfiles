# Next.js Pages Router — Skijan

> Load when: `pages/`, Layout assignment, `getServerSideProps`, `_app.tsx`.
> Common Next.js → [nextjs.md](../../share-review-gui/reference/nextjs.md).

## Project & directories

| Topic | Rule |
|-------|------|
| Locale apps | `apps/gui/skijan*` — thin route wrappers |
| Shared package | `packages/gui/skijan` (`@gogo/gui-skijan`) |
| Page pattern | App `pages/*.tsx` assigns Layout + re-exports GSSP + page from package |
| Layouts | `SurfaceLayout`, `MypageLayout`, `InquiryLayout`, etc. — **mandatory** on every page |
| GSSP location | Often co-located `getServerSideProps.ts` in package `pages/` |

## Data fetching

| Context | Pattern |
|---------|---------|
| SSR | API in GSSP; `appendGgjHeader({ req })`; no client toast |
| Client | `loadingOnHandler` / `toastHandler`; try/catch |
| API functions | In `store/*Slice.ts` — not inline in components |
| Response | `TGgjRes<T>`, `AppError.ECB404`, `IPaging` from `app.d.ts` |
| HTTP | `packages/gui/skijan/common/http.ts` |

## Auth (FE)

- `au-payload` header → `AppContextProvider` (fast-context)
- `useIsLoggedIn()`, `useStore((s) => s.auth)`
- `GGJ_REDIRECT_CODE` → redirect to accounts login
- `GgjModalConfirmLogin`, `GgjCheckEnableCookie`

## i18n

- `ggjServerSideTranslations(req, ns, layoutNS?)` in GSSP
- Namespace: `common@sheetName`
- `useTranslation(ns)`; `useI18nContext()` for locale
- Layout exports required `nsTran*` constants

## Review checklist

| Tag | Check |
|-----|-------|
| agent | Every page sets `Component.Layout` |
| agent | GSSP re-exported from correct package path |
| agent | SSR vs client error handling pattern correct |
| agent | `ggjDebounce` on submit-sensitive actions |
| agent | `notFound()` / `ECB404` for missing resources |
| human | Layout persists on navigation; no flash |
