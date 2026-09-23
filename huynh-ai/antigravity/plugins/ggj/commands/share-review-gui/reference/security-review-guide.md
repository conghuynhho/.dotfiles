# Security Review Guide (Deep)

> Load when: `v-html`, auth, cookies, redirects, uploads, third-party scripts, or editor save paths.
> Quick checklist → [security.md](security.md). Redirects → [api-data-fetching.md](api-data-fetching.md).

## When to run deep review

Run this guide (not just [security.md](security.md) quick table) when the diff touches:

- User-generated or API HTML rendered in the DOM
- Login/logout, session, or cookie writes
- `redirect()` / `?redirect=` / return URL params
- File upload (image, document, rich paste)
- New third-party script, iframe, or analytics tag
- `env` / build config with URLs or keys

## Step-by-step

### 1 — Map attack surface

```markdown
□ What user-controlled strings reach HTML? (description, comment, preview)
□ What reaches URL bar? (query, hash, redirect param)
□ What reaches cookies / localStorage / Vuex persist?
□ What leaves the browser? (upload, external iframe src)
```

### 2 — XSS path

| Step | Question |
|------|----------|
| Render | Any `v-html`, `innerHTML`, `document.write`? Sanitized? |
| Save | Rich editor payload stripped (no base64 blobs, no `javascript:`)? |
| URL | `href`/`src` from user input — block `javascript:`, `data:`? |
| Meta | Query injected into `title` / OG tags unescaped? |

Severity: unsanitized user/API HTML → 🔴 `[blocking]`.

### 3 — Auth & session

| Step | Question |
|------|----------|
| Cookies | Auth flags: `HttpOnly`, `Secure`, `SameSite` in prod? |
| Client store | Tokens/PII in `localStorage` when cookies are standard? |
| Logout | Client state cleared; no PII in persisted store? |
| Env | Secrets not in client `env` committed to repo? |

### 4 — Redirects

```javascript
// Always ask: can attacker pass external URL?
redirect(decodeURIComponent(ctx.query.redirect))  // 🔴 if unvalidated
```

Whitelist internal paths only — see [api-data-fetching.md](api-data-fetching.md).

### 5 — Uploads & logging

- Client MIME/size check (server must still validate)
- Display URLs: CDN paths, not raw bucket internals
- Errors: i18n message, not stack trace
- F12 / analytics: no passwords, tokens, full PII

### 6 — Third-party

| Tag | Check |
|-----|-------|
| agent | New script: client-only plugin if SSR build |
| agent | Domain allowlist — don't widen CSP for convenience |
| agent | `target="_blank"` → `rel="noopener noreferrer"` |

## Output hints

Group findings under **Security** in Project Checklist. Tag `[human]` for paste/upload flows that need browser verification.
