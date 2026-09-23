# Vue 2 — Best Practices

> Load when: `.vue` SFC changes (components, pages).
> Vue 2 (EOL) · mostly Options API. Tags: [README.md](../README.md#review-ownership). SSR / repo patterns → project overlay skill if present.

## Essential rules

| Rule | Detail |
|------|--------|
| `v-for` + `:key` | Stable id — not index on reorderable lists |
| No `v-if` + `v-for` | Same element — filter via `computed` first |
| `data()` function | Fresh object per instance |
| Props | `type`, `required`/`default`, `validator` |
| Styles | `scoped`, CSS modules, or BEM |
| SFC | One `PascalCase.vue` per file; multi-word name; prefix (`Base`, `App`) |
| Props/events | `camelCase` in JS, `kebab-case` in template + `$emit` |
| Data flow | No prop mutation; no `$parent`/`$children` — use Vuex for shared state |
| Logic | `computed` = derived; `watch` = side effects; `methods` = handlers |

## Performance pitfalls

| Area | Mistake |
|------|---------|
| Render | Heavy logic in template/methods — use `computed` |
| Render | Inline `:config="{}"` / `:style="{}"` every render |
| Lists | Missing `:key`; `v-if`+`v-for`; huge lists without virtual scroll |
| Reactivity | Large static data in `data` — `Object.freeze` or keep outside |
| Toggle | Wrong `v-if` vs `v-show` (frequent toggle → `v-show`) |
| Memory | Listeners/timers/bus not removed in `beforeDestroy` |
| Bundle | Global register all components; whole-library imports |
| Input | No debounce on search/scroll/resize |

Lifecycle cleanup → [performance.md](performance.md#lists-memory--algorithms).

## Review checklist

| Tag | Check |
|-----|-------|
| agent | PascalCase multi-word; scoped CSS; consistent option order |
| agent | Stable `:key`; no `v-if`+`v-for`; no inline heavy expressions |
| agent | `data()` function; `computed` for derived; `watch` debounced for side effects |
| agent | Props declared; child doesn't mutate props; `kebab-case` events |
| agent | `beforeDestroy` cleanup; loading/error on API calls |
| agent | Lazy routes/components; tree-shaken imports |
| agent | Empty/error/loading UI; no `console.log` |
| human | Virtual scroll if list has hundreds+ rows |
