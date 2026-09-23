# Security

> Load when: user HTML, cookies, auth, redirects, uploads, third-party scripts.
> Deep workflow → [security-review-guide.md](security-review-guide.md). Redirects detail → [api-data-fetching.md](api-data-fetching.md). Tags: [README.md](../README.md#review-ownership).

## Quick checklist

### XSS

| Tag | Check |
|-----|-------|
| agent | User/API HTML sanitized before render (`sanitize-html`, DOMPurify, etc.) |
| agent | Rich text sanitized on save and display; server validates MIME/size |
| agent | No `v-html` / `innerHTML` on unsanitized content |
| agent | Block `javascript:` / `data:` in `href` / `src` |
| agent | Query/hash not injected into `title` / meta unescaped |
| agent | `target="_blank"` → `rel="noopener noreferrer"` |
| agent | CSP + trusted CDN; no inline script from pasted content |

### Cookies & session

| Tag | Check |
|-----|-------|
| agent | Value &lt; ~4 KB; reasonable `max-age`; correct domain/path |
| agent | Auth: `HttpOnly`, `Secure`, `SameSite=Lax` or `Strict` |
| agent | No secrets/PII in client cookies or `localStorage` if cookie auth is standard |
| agent | Logout clears client state; no PII left in persisted store |
| agent | No credentials in client build `env` committed to repo |

### URLs & redirects

| Tag | Check |
|-----|-------|
| agent | No open redirect (`?redirect=` → external) — whitelist internal paths |
| agent | `encodeURIComponent` on query strings |
| agent | No infinite redirect in auth/locale middleware |

### Uploads & logging

| Tag | Check |
|-----|-------|
| agent | Client validates size + MIME; display URLs use CDN paths not raw buckets |
| agent | No stack traces in UI; API errors → i18n, not raw server messages |
| agent | F12 / Sentry: no passwords, tokens, PII in logs |
| ci | `npm audit` on dep changes; no known vulnerable package without exception |

## Examples

```vue
<!-- ❌ -->
<div v-html="product.description" />

<!-- ✅ -->
<div v-html="sanitizeHtml(product.description)" />
```

```javascript
// ❌ Open redirect
redirect(decodeURIComponent(ctx.query.redirect))

// ✅ Whitelist internal paths only
const path = validateInternalPath(ctx.query.redirect)
if (path) redirect(path)
```

```javascript
// ❌
catch (e) { this.errorMessage = e.response.data.stack }

// ✅
catch (e) {
  this.errorMessage = this.$t('errors.generic')
}
```

## Third-party & CSP

| Tag | Check |
|-----|-------|
| agent | Analytics/tags: client-only plugin where SSR applies |
| agent | Scripts from trusted CDN domains only |
| agent | `img-src` / `script-src` limited to required domains |
| agent | Don't widen CSP for convenience when adding vendors |

## Severity

| Issue | Severity |
|-------|----------|
| Unsanitized `v-html` on user/API HTML | 🔴 blocking |
| Open redirect param | 🔴 blocking |
| Auth cookie missing `Secure` in prod | 🟠 important |
| PII in `console.log` | 🟠 important |
| Missing `noopener` on external link | 🟡 nit |
