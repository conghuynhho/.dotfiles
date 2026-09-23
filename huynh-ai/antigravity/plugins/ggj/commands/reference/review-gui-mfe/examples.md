# GUI Review Examples — Mypage MFE

## Example 1 — Expose file too large

```markdown
# GUI Review — mypage-video library

## Summary
Business logic in `exposes/pages@video-library.tsx` breaks HMR pattern. Medium risk.

**Verdict:** 💬 Comment

## Mypage MFE Checklist
- ⚠️ Logic in exposes file
- ✅ Uses host `http` from store
- ✅ `ThemeRegistry isMypage`

## Findings
| 🟠 important | `exposes/pages@video-library.tsx` | 200 lines UI | move to `components/VideoLibrary.tsx` |
```

## Example 2 — Stale host state

```markdown
# GUI Review — community MsgList

## Summary
Lang read once at mount; host locale change not reflected. Medium risk.

**Verdict:** 🔄 Request Changes

## Findings
| 🔴 blocking | `MsgList.tsx` | `store.lang.getValue()` only | use `SubscribeRxjsStore` + `useStore` |
```

**Invoke:** `Review GUI for [PR/ticket] using review-gui-mp-mfe skill`
