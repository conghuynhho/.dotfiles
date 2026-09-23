# GUI Review Examples — GGJ

## Example 1 — Server Component boundary

```markdown
# GUI Review — Product detail metadata

## Summary
`useState` in Server Component file. High risk — build/runtime failure.

**Verdict:** 🔄 Request Changes

## GGJ Checklist
- ❌ Missing `'use client'` on interactive section
- ✅ `generateMetadata` present
- ✅ `appendGgjHeader` on server fetch

## Findings
| 🔴 blocking | `page-components/ProductDetail.tsx` | hooks in SC file | split client island |
```

## Example 2 — Duplicate locale page

```markdown
# GUI Review — EN hero section

## Summary
Copy-pasted `page-components` from JA app. Medium risk.

**Verdict:** 💬 Comment

## Findings
| 🟠 important | `ggj-en/.../page.tsx` | duplicated UI | move to `@gogo/gui-ggj` package |
```

**Invoke:** `Review GUI for [PR/ticket] using review-gui-ggj command`
