# GUI Review Examples

Process and output → common README. Surface examples below.

## Example 1 — Summernote product editor

```markdown
# GUI Review — OAM-1234 Product description editor

## Summary
XSS on `v-html` preview; base64 in save payload. Medium risk — fix before merge.

**Verdict:** 🔄 Request Changes

## Phase 1–4
- ✅ Scope: `ja/desktop/pages/product/edit.vue`
- ⚠️ JP NG: external iframe paste not blocked
- ❌ F12 null description TypeError; base64 in create payload

## GGJungle Checklist
- ✅ `asyncData` + 404; `<client-only>` editor
- ⚠️ Upload MIME client-only
- ❌ `v-html` without `sanitize-html`

## Manual QA required
| 🔲 Not verified | iOS Safari toolbar/keyboard | Paste, undo; save visible with keyboard |

## CI / tooling required
N/A — client-only editor, no new route

## Findings
| 🔴 blocking | `edit.vue` | unsanitized `v-html` | `sanitize-html` |
| 🔴 blocking | `edit.vue` | base64 in payload | strip in `onChange` + API |
| 🟠 important | `edit.vue` | null crash | `content \|\| ''` on init |
```

## Example 2 — SSR category listing

```markdown
# GUI Review — /fx/tools listing

## Summary
SSR/canonical OK; `sort` unvalidated. Low risk.

**Verdict:** 💬 Comment

## Phase 1–4
- ✅ Figma match; empty state; debounced search
- ⚠️ `sort=invalid` hits API

## GGJungle Checklist
- ✅ URL, i18n, server `fetch`, SEO meta, lazy images + CDN resize
- ⚠️ Whitelist `sort` before API

## Manual QA required
| 🔲 Not verified | Cross-browser + mobile | Chrome/Safari + iPhone; hero not lazy, cards lazy |

## CI / tooling required
| 🔲 Not run | CLS/LCP | Lighthouse `/fx/tools` |
| 🔲 Not run | CDN headers | `curl -I <asset-url>` |

## Findings
| 🟠 important | `fx/tools.vue` | unvalidated `sort` | whitelist + default |
```

**Invoke:** `Review GUI for [PR/ticket] using review-gui-sf skill`
