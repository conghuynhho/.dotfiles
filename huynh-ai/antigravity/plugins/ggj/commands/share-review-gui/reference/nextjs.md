# Next.js — Common Patterns

> Load when: `pages/`, `src/app/`, `getServerSideProps`, `generateMetadata`, layouts, middleware.
> React component rules → [react.md](react.md). Repo-specific overlays → project skill.

## Pages Router (Skijan, Accounts, MyAccount)

| Pattern | Rule |
|---------|------|
| Data fetch | `getServerSideProps` in page or co-located `getServerSideProps.ts` |
| SSR API | Use project `http` client + `appendGgjHeader({ req })` |
| Client API | Relative `/api/...` paths; loading + toast on client |
| SSR errors | No client toast in GSSP — return props or `notFound()` / redirect |
| Layout | Persistent layout via `Component.Layout` or `PageLayout` — not re-mount on nav |
| i18n | `serverSideTranslations` / `ggjServerSideTranslations` in GSSP |
| Redux | `next-redux-wrapper` + `HYDRATE`; register slice in GSSP, remove on unmount |
| `_app.tsx` | Global providers, theme, error boundary |

## App Router (GGJ)

| Pattern | Rule |
|---------|------|
| Data fetch | `async` Server Components — no `getServerSideProps` |
| Client boundary | `'use client'` for hooks, browser APIs, event handlers |
| Metadata | `generateMetadata` / `ggjGenerateMetadata` per route |
| Dynamic | `export const dynamic = 'force-dynamic'` on data-heavy routes |
| SSR headers | `appendGgjHeader({ headers })` from `next/headers` |
| Hydration | Pass SSR data via providers — avoid duplicate client fetch |
| Cache | `React cache()` for deduped server fetches |

## Shared FE rules (both routers)

| Tag | Check |
|-----|-------|
| agent | No `window` / `document` in Server Components |
| agent | Auth headers forwarded on server fetch — not bypassed with raw `fetch` |
| agent | `notFound()` / error pages for missing resources |
| agent | SEO title/description on new routes |
| agent | Images via project CDN helpers / `next/image` config |
| agent | No page-critical API in `_app` / root layout without justification |
| human | Hydration warnings; locale/cookie language behavior |

## Pitfalls

| Area | Mistake |
|------|---------|
| SSR | Fetch in `mounted` / `useEffect` only — misses SEO and slow LCP |
| Hydration | Server/client markup mismatch |
| Env | Secrets in `publicRuntimeConfig` / `NEXT_PUBLIC_*` |
| State | Duplicate fetch after SSR hydration |
| i18n | Hardcoded copy when namespace exists |
