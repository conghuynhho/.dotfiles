# CSS / Emotion / MUI — Accounts

> Load when: Emotion styles, responsive auth forms.
> Universal → [css-less-sass.md](../../share-review-gui/reference/css-less-sass.md).

| Topic | Rule |
|-------|------|
| Theme | `theme.config.ts` + MUI breakpoints in `_app.tsx` |
| Emotion | Preferred for SSR (`@emotion/react`, `@emotion/styled`) |
| Responsive | min-width media queries, smallest screen first |
| Layout | 440px centered auth card pattern |

| Tag | Check |
|-----|-------|
| agent | min-width breakpoints — not max-width cascade |
| agent | Theme values over hardcoded colors |
| human | Mobile auth form usability (keyboard, tap targets) |
