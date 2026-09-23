# Code Quality — GGJ

> Load when: new helpers, `createFastContext`, `Ggj*` components, forms.
> Universal → [code-quality-universal.md](../../share-review-gui/reference/code-quality-universal.md).

## Mandatory conventions

| Rule | Detail |
|------|--------|
| Reuse `Ggj*` | Search `packages/gui/ggj/components` before new primitives |
| Context | `createFastContext` for shared UI state — not prop drilling across trees |
| Debounce | `ggjDebounce` on submit / multi-click actions |
| Keys | No array index as React `key` |
| Types | `TGgjRes<T>`, project error enums |
| HTTP | Package `common/http` + SSR header helpers |

## Fast context

```tsx
// Provider at layout or page boundary
// Consumers via generated hooks — avoid duplicate local auth/UI state
```

| Tag | Check |
|-----|-------|
| agent | Existing `Ggj*` / context hook used before new abstraction |
| agent | Client submit: loading + error feedback |
| agent | All strings via i18n — no hardcoded copy when namespace exists |
| agent | Theme tokens — no magic colors/fonts |
| human | Re-render on large `page-components/` trees |
| human | Lazy / dynamic import for heavy widgets (charts, video) |

## Component naming

- `Ggj*` — shared GGJ primitives (`GgjButton`, charts, media, layout pieces)
- Feature folders under `page-components/` — route-scoped, not generic `utils/`
