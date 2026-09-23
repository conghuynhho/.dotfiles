# GUI Review Examples

Output structure → README (Output Format section).

## Example 1 — Rich text preview (XSS)

```markdown
# GUI Review — Product description editor

## Summary
XSS on `v-html` preview; unsafe payload in save. Medium risk — fix before merge.

**Verdict:** 🔄 Request Changes

## Phase 1–4
- ✅ Scope: editor component only
- ⚠️ External iframe paste not blocked
- ❌ F12 null description TypeError; unsafe blob in create payload

## Project Checklist
- ✅ Client-only editor wrapper
- ⚠️ Upload MIME client-only
- ❌ `v-html` without sanitizer

## Manual QA required
| 🔲 Not verified | Mobile keyboard | Paste, undo; save visible with keyboard |

## CI / tooling required
N/A

## Findings
| 🔴 blocking | `Editor.vue` | unsanitized `v-html` | sanitize before render |
| 🔴 blocking | `Editor.vue` | unsafe payload | strip in onChange + API |
| 🟠 important | `Editor.vue` | null crash | default `content \|\| ''` on init |
```

## Example 2 — SSR listing page

```markdown
# GUI Review — Category listing

## Summary
SSR/canonical OK; `sort` unvalidated. Low risk.

**Verdict:** 💬 Comment

## Phase 1–4
- ✅ Design match; empty state; debounced search
- ⚠️ `sort=invalid` hits API

## Project Checklist
- ✅ URL, i18n, server fetch, SEO meta, lazy images
- ⚠️ Whitelist `sort` before API

## Manual QA required
| 🔲 Not verified | Cross-browser + mobile | Hero not lazy; cards lazy below fold |

## CI / tooling required
| 🔲 Not run | CLS/LCP | Lighthouse on changed route |

## Findings
| 🟠 important | `listing.vue` | unvalidated `sort` | whitelist + default |
```

**Invoke:** `Review GUI for [PR/ticket] using review-gui-sf skill` (surface) or load [README.md](README.md) directly for common-only review.
