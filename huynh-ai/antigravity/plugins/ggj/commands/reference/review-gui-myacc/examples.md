# GUI Review Examples — MyAccount

## Example 1 — Member form re-render

```markdown
# GUI Review — Member address form

## Summary
Jotai atom recreated each render causes full form reset. High risk.

**Verdict:** 🔄 Request Changes

## MyAccount Checklist
- ❌ Re-render issue on locale switch
- ✅ API in `store/memberSlice.ts`
- ✅ `ggjDebounce` on save

## Findings
| 🔴 blocking | `MemberForm.tsx` | atom in render body | move atom outside component |
```

## Example 2 — Bank upload

```markdown
# GUI Review — Bank document upload

## Summary
Missing file size check; wrong toast pattern. Medium risk.

**Verdict:** 🔄 Request Changes

## Findings
| 🟠 important | `BankUpload.tsx` | no size validation | match README upload checklist + toast |
```

**Invoke:** `Review GUI for [PR/ticket] using review-gui-myacc skill`
