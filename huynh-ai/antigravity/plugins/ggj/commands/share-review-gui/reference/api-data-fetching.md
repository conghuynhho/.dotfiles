# API & Data Fetching

> Load when: fetch logic, query params, redirects, rate limiting, error mapping.
> Tags: [README.md](../README.md#review-ownership). SSR `head()` patterns may be in a project overlay skill. Security redirects → [security.md](security.md).

| Area | Tag | Check |
|------|-----|-------|
| **Route** | agent | Path, query, hash match spec |
| | agent | Params validated (enum, regex, range) before API |
| | agent | Invalid ID → error/empty state, not silent fail |
| **Redirect** | agent | CDN prefix on static files |
| | agent | Post-action redirects: named/validated internal paths |
| | agent | `encodeURIComponent` on query strings |
| | agent | No loop: auth ↔ login, locale, trailing slash |
| **Rate limit** | agent | Debounce search/autocomplete |
| | agent | HTTP 429 → user message + `Retry-After` |
| | agent | Client config matches backend contract |
| **Errors** | agent | API codes → i18n messages; network/offline surfaced |
| | agent | No silent failures; no stack traces in UI |
| | human | F12: no unhandled rejections on happy path |
