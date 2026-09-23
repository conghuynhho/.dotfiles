# React — Best Practices

> Load when: `.tsx` / `.jsx` component changes in React apps (GGJ, Skijan, Accounts, MyAccount, MFE).
> Tags: [README.md](../README.md#review-ownership). Framework routing → project overlay skill (`nextjs.md` or App Router guide).

## Essential rules

| Rule | Detail |
|------|--------|
| Keys | Stable id — not array index on reorderable/filtered lists |
| Props | Typed interfaces; avoid `any`; required vs optional explicit |
| State | Lift only when needed; prefer colocated state |
| Effects | `useEffect` for side effects only — not for derived data (`useMemo` / render) |
| Memo | `useMemo` / `useCallback` only when profiling shows benefit — not by default |
| Refs | DOM refs via `useRef`; avoid storing mutable state in refs when state fits |
| Events | Debounce submit / multi-click API (`ggjDebounce` in GGJ apps) |
| Cleanup | Subscriptions, timers, listeners removed in effect cleanup or `useEffect` return |
| Client boundary | `'use client'` only where needed (App Router); no server imports in client files |

## Performance pitfalls

| Area | Mistake |
|------|--------|
| Render | Inline `style={{}}` / `config={{}}` creating new objects every render |
| Lists | Missing `key`; huge lists without virtualization |
| State | Storing derived values that should be `useMemo` |
| Context | Large context value causing wide re-renders — split or use selectors |
| Bundle | Barrel imports of heavy libs; whole-library imports |
| Re-render | Parent state change re-rendering entire form tree — split or memoize children |

## Forms (react-hook-form)

| Tag | Check |
|-----|-------|
| agent | `defaultValues` match SSR props; reset on prop change when needed |
| agent | Validation errors scroll to first field (`scrollToElSmoothly` pattern) |
| agent | Submit guarded against double-click |
| human | Mobile Safari keyboard / blur quirks on long forms |

## Security (FE)

| Tag | Check |
|-----|-------|
| agent | `dangerouslySetInnerHTML` only with sanitization |
| agent | No secrets in client env (`NEXT_PUBLIC_*`) |
| agent | User input not interpolated into `href` without validation |

## Review checklist

| Tag | Check |
|-----|-------|
| agent | Stable `key` on lists |
| agent | Effect deps complete; cleanup on unmount |
| agent | No prop drilling 4+ levels without context/store |
| agent | Loading / empty / error states for async UI |
| agent | Types from shared packages (`@gogo/share`), not ad-hoc duplicates |
| human | Re-render / scroll-to-error on validation fail |
