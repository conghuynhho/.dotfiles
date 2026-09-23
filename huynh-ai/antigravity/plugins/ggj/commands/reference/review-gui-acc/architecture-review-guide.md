# Architecture Review Guide — Accounts

> Load when: new auth pages, slices, contexts.

## Structure

```
apps/gui/accounts/
├── pages/           # route entry
├── components/      # UserForm, SnsButtons, page-specific UI
├── store/           # authSlice, passwordSlice, confirmSlice, ...
├── contexts/        # I18n, Loading, Toast
├── common/          # http, i18nUtils, utils, utmTracking
└── theme.config.ts
```

## Principles (from README)

1. **Isolate code** — component contains its CSS/JSX/JS
2. **Atomic common components** — no dependency on usage site

## Layout

- Inline Header/Footer in `_app.tsx` (440px centered)
- `/guide/enable-cookie` → empty layout
- Language switcher in footer

## Anti-patterns

| Anti-pattern | Severity |
|--------------|----------|
| API logic in page component | 🟠 important |
| Secrets in `publicRuntimeConfig` | 🔴 blocking |
| Unvalidated open redirect after login | 🔴 blocking |
| Missing `reducerManager.remove` on dynamic slices | 🟡 nit |
