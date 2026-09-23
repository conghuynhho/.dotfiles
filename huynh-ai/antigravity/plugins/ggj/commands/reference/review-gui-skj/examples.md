# GUI Review Examples — Skijan

## Example 1 — Skill detail missing Layout

```markdown
# GUI Review — Skill detail page

## Summary
New page wrapper without Layout assignment. High risk — blocks runtime.

**Verdict:** 🔄 Request Changes

## Skijan Checklist
- ❌ `Component.Layout` not set
- ✅ GSSP uses `appendGgjHeader`
- ✅ API in `store/skillDetailSlice.ts`

## Findings
| 🔴 blocking | `pages/skill/[id].tsx` | missing Layout | assign `SurfaceSkillDetailLayout` |
```

## Example 2 — Country payment component

```markdown
# GUI Review — Bank transfer VI

## Summary
VI-specific fields inline in shared component. Medium risk.

**Verdict:** 💬 Comment

## Findings
| 🟠 important | `PaymentPanel.tsx` | `locale === 'vi'` branch | extract to `@country-components` |
```

**Invoke:** `Review GUI for [PR/ticket] using review-gui-skj skill`
