# GUI Review Examples — Accounts

## Example 1 — Login redirect

```markdown
# GUI Review — Login return URL

## Summary
`?u=` param used in `href` without validation. High risk.

**Verdict:** 🔄 Request Changes

## Accounts Checklist
- ❌ Open redirect possible
- ✅ `appendGgjHeader` in GSSP
- ✅ i18n `gui@login`

## Findings
| 🔴 blocking | `login.tsx` | unvalidated `?u=` | use `validateUrlCoupon` pattern |
```

## Example 2 — SNS register

```markdown
# GUI Review — SNS buttons

## Summary
Loading state missing on SNS click. Low risk.

**Verdict:** 💬 Comment

## Findings
| 🟠 important | `SnsButtons.tsx` | double submit possible | `ggjDebounce` + disable while pending |
```

**Invoke:** `Review GUI for [PR/ticket] using review-gui-acc skill`
