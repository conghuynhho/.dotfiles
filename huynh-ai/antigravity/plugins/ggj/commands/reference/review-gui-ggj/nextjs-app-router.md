# Next.js App Router — GGJ

> Load when: `src/app/`, Server Components, `generateMetadata`, layouts.
> Common Next.js → [nextjs.md](../../share-review-gui/reference/nextjs.md).

## Project & directories

| Topic | Rule |
|-------|------|
| Locale apps | `apps/gui/ggj-ja`, `ggj-en`, `ggj-th` — thin `src/app/` routes |
| Shared package | `packages/gui/ggj` (`@gogo/gui-ggj`) |
| Page pattern | App route re-exports or wraps `page-components/` |
| Layouts | Root + nested layouts in `src/app/`; country overrides when needed |
| Metadata | `generateMetadata` / `ggjGenerateMetadata` per route |

## Data fetching

| Context | Pattern |
|---------|---------|
| Server Components | `async` components; `appendGgjHeader({ headers })` from `next/headers` |
| Client boundary | `'use client'` for hooks, events, browser APIs |
| Dynamic routes | `export const dynamic = 'force-dynamic'` when SSR must be fresh |
| Dedup | `React cache()` for repeated server fetches in one request |
| Client fetch | Project HTTP helpers — avoid duplicate fetch after SSR hydration |

## Auth (FE)

- Server headers forwarded on data fetch — not bypassed with raw `fetch`
- Auth state via `createFastContext` providers where applicable
- Redirect to accounts login with validated return URL when unauthenticated

## i18n

- i18n sheets / namespaces per locale app
- Server metadata and copy from translation helpers — no hardcoded locale strings
- Country-specific overrides via package or app-level constants

## Review checklist

| Tag | Check |
|-----|-------|
| agent | No `window` / `document` in Server Components |
| agent | `'use client'` only where hooks/events required |
| agent | `generateMetadata` on new public routes |
| agent | SSR data passed to client — no redundant client-only fetch |
| agent | Images via CDN helpers / `next/image` config |
| human | Hydration warnings on interactive islands |
| human | Locale routing and metadata in each locale app |
