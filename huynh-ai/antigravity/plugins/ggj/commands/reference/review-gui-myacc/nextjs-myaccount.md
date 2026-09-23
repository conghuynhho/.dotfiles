# Next.js Pages Router — MyAccount

> Load when: member, bank, verify, terms, withdrawal pages.
> Common Next.js → [nextjs.md](../../share-review-gui/reference/nextjs.md).

## Scope

`apps/gui/myaccount` — authenticated settings app (`au-payload` required).

## Key routes

| Area | Paths |
|------|-------|
| Profile | `/`, `/member` |
| Financial | `/bank`, bank-v2 flows |
| Security | `/password`, `/email`, `/verify-phone`, `/verify-email` |
| Legal | `/terms/*`, `/others/*`, withdrawal |

## Layouts

| Layout | Use |
|--------|-----|
| `CommonLayout` | Default with side menu |
| `WithoutSideMenu` | Focused flows |
| `BlankLayout` | Minimal chrome |
| `Component.PageLayout` | Per-page override |
| `disabledCommonLayout` | Special routes |

## Data fetching

| Context | Pattern |
|---------|---------|
| SSR | GSSP calls slice exports directly (e.g. `getMemberInfo`) |
| Client | loading + toast + try/catch — **required** |
| SSR | No try/catch toast — return props or redirect |
| Auth | 401 / 456 → redirect to `ACCOUNT_HOST_URL?u=...` |
| Headers | `appendGgjHeader({ req })` with cookie when needed |

## State

- Redux: `app` (auth from `au-payload`), feature slices per page
- **Member page exception:** Jotai + react-hook-form — not Redux for form state
- `updateAccountLastAccessAt()` debounced in `_app`

## i18n

- `ggjServerSideTranslations(req, ns)`
- Auto-injected: `common@common-layout`, `common@common-error`
- Locale-specific form fields under `ja/`, `vi/`, `default/` folders

## Review checklist

| Tag | Check |
|-----|-------|
| agent | Auth from `_app` `au-payload` — not client assumption |
| agent | Client API: loading + toast + error handling |
| agent | Meta title/description per page |
| human | Scroll to input on validation error (iOS) |
| human | NProgress + layout persistence on navigation |
