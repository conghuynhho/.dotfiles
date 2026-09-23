# Common Front-End Bugs Checklist

> Load when: forms, async flows, lists, lifecycle, route changes, or any logic/data diff.
> Vue rules → [vue.md](vue.md). Quality → [code-quality-universal.md](code-quality-universal.md). Tags: [README.md](../README.md#review-ownership).

## Async & routing

| Tag | Bug pattern | Check |
|-----|-------------|-------|
| agent | **Stale response** — route/id changes mid-fetch; old data shown | Guard after `await` with current `params` / route |
| agent | **TOCTOU** — check before fetch, not after | Compare route/id after every `await` |
| agent | **Unhandled rejection** — missing `.catch` / try-catch on API | Loading + error UI; no silent fail |
| agent | **Double fetch** — SSR data refetched in `mounted` | Reuse `asyncData`/`fetch` result on client |
| agent | **Race on rapid click** — duplicate submit | Debounce button; disable while loading |

## Null, empty & boundaries

| Tag | Bug pattern | Check |
|-----|-------------|-------|
| agent | **Empty list** — no empty state; layout breaks | `v-if` empty UI when `items.length === 0` |
| agent | **Null dereference** — `item.title` when `item` null | Optional chaining or guard before render |
| agent | **First/last edge** — pagination off-by-one | Page 0/1, last page, `total === 0` |
| agent | **Max length** — editor/input exceeds API limit | Enforce client + server |

## Vue reactivity & templates

| Tag | Bug pattern | Check |
|-----|-------------|-------|
| agent | **`v-if` + `v-for`** on same element | Filter via `computed` first |
| agent | **Unstable `:key`** — index on reorderable list | Stable id from data |
| agent | **Prop mutation** — child writes to prop | `$emit` or local copy |
| agent | **Heavy method in template** — runs every render | Move to `computed` |
| agent | **Missing cleanup** — listener/timer/bus in `mounted` | Remove in `beforeDestroy` |

## Forms & user input

| Tag | Bug pattern | Check |
|-----|-------------|-------|
| agent | **Double submit** — no loading lock on button | `disabled` while pending |
| agent | **Client-only validation** — server rejects silently | Mirror required rules; show API errors |
| agent | **Dirty state lost** — navigate away without confirm | Warn if unsaved (when spec requires) |

## SSR / hydration (Nuxt)

| Tag | Bug pattern | Check |
|-----|-------------|-------|
| agent | **`window`/`document` in SSR** | `process.client` / `mounted` only |
| agent | **Hydration mismatch** — server HTML ≠ client first paint | Same data/markup both sides |
| agent | **Date/time locale drift** — server UTC vs client local | Consistent formatting in SSR |

## Data & API

| Tag | Bug pattern | Check |
|-----|-------------|-------|
| agent | **Unvalidated query → API** — `sort`, `page`, `id` | Whitelist / `filterInt` before request |
| agent | **Fetch-all-then-filter** — `limit=9999` client filter | Server filter + pagination |
| agent | **Leaky API shape in child** — raw response in props | Map in container to stable props |

## Quick scan (2 min)

```markdown
□ Empty/null/loading/error states for changed flows?
□ Async guarded after await (route still matches)?
□ No v-if+v-for; stable :key on lists?
□ Submit debounced/disabled while loading?
□ SSR-safe (no window in asyncData)?
```
