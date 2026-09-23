# CSS / Emotion / MUI — MyAccount

> Load when: theme tokens, locale-specific UI, forms.
> Universal → [css-less-sass.md](../../share-review-gui/reference/css-less-sass.md).

| Topic | Rule |
|-------|------|
| Theme | `theme.config.ts` — all color/font values |
| MUI | `@mui/lab`, `@mui/x-date-pickers` for date flows |
| Emotion | `css` prop in components |
| Responsive | min-width, mobile-first |
| Locale UI | VI footer, address dialogs — verify correct branch |

| Tag | Check |
|-----|-------|
| agent | `theme.config.ts` tokens — no magic hex |
| agent | File validation failure → toast (not silent) |
| human | Form backdrop during submit |
| human | Image cropper UX on mobile |
