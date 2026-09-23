# Next.js Pages Router — Accounts

> Load when: login, register, SNS auth, password reset, email confirm, account select.
> Common Next.js → [nextjs.md](../../share-review-gui/reference/nextjs.md).

## Scope

`apps/gui/accounts` — public auth app (login, register, recovery, SNS).

## Key routes

| Area | Paths |
|------|-------|
| Login / register | `/login`, `/register`, `/register/sns` |
| Password | `/password/forgot`, `/password/reset` |
| Email | `/confirm`, `/confirm/email` |
| Account | `/select`, `/guide/enable-cookie` |
| SNS | Provider callbacks via register/login flows |

## Layout

- Inline Header/Footer in `_app.tsx` (440px centered card)
- `/guide/enable-cookie` → empty layout
- Language switcher in footer

## Data fetching

| Context | Pattern |
|---------|---------|
| SSR | GSSP + `appendGgjHeader({ req })`; no client toast |
| Client | `loadingOnHandler` / `toastHandler`; try/catch |
| API | Exported from `store/*Slice.ts` — not inline in pages |
| Response | `TGgjRes<T>`; business vs application errors per spec |
| HTTP | `common/http.ts` |

## Auth & redirects

- Post-login return URL via `?u=` — **must validate** (open-redirect risk)
- SNS OAuth: state/callback handling in slice + page
- Session cookies set by API — FE must not assume client-only auth
- `GgjCheckEnableCookie` on flows that require cookies

## i18n

- `ggjServerSideTranslations(req, ns)` in GSSP
- Namespaces per page (`gui@login`, `gui@register`, …)
- All user-visible copy via `useTranslation(ns)`

## Review checklist

| Tag | Check |
|-----|-------|
| agent | `?u=` / return URL validated before redirect |
| agent | SNS buttons debounced; loading while pending |
| agent | GSSP loads required namespaces |
| agent | Dynamic Redux slice `add` in GSSP, `remove` on unmount |
| agent | `HYDRATE` merges SSR auth state |
| human | Mobile keyboard / tap targets on auth forms |
| human | SNS popup blocked handling |
