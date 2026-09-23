# Architecture Review Guide — MyAccount

> Load when: new settings pages, slices, Jotai forms.

## Structure

```
apps/gui/myaccount/
├── pages/
├── components/
│   ├── layouts/       # CommonLayout, WithoutSideMenu, BlankLayout
│   ├── common/        # GgjImageCropper, GgjUploadImageOrFiles
│   └── pages/         # member/, bank/, bank-v2/, index/, ...
├── store/             # feature slices + app, alert, loading
├── contexts/          # I18n, Loading, Toast
└── common/            # http, upload, i18nUtils, utils
```

## Layering

| Layer | Rule |
|-------|------|
| `components/pages/<feature>/` | Feature UI |
| `store/*Slice.ts` | API + Redux state (mandatory per README) |
| `pages/member.tsx` | GSSP calls slice exports; props to Jotai forms |

## Member / bank complexity

- Large forms use **Jotai** + react-hook-form — verify re-render scope
- Locale branches (`ja/`, `vi/`) for bank fields, address dialogs
- Upload flows: `common/upload.ts` + `GgjUploadImageOrFiles`

## Anti-patterns

| Anti-pattern | Severity |
|--------------|----------|
| API in component (not slice) | 🟠 important — except GSSP calling slice exports |
| Array index as `key` | 🟠 important |
| Hardcoded theme colors | 🟡 nit → 🟠 on design-critical pages |
| Missing slice `remove` on unmount | 🟡 nit |
