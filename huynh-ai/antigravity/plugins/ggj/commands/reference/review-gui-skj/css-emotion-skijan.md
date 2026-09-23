# CSS / Emotion / MUI — Skijan

> Load when: `theme.config.ts`, Emotion `css`, responsive layout.
> Universal → [css-less-sass.md](../../share-review-gui/reference/css-less-sass.md).

## Theme

| Topic | Rule |
|-------|------|
| Config | `packages/gui/skijan/theme/theme.config.ts` |
| Country merge | `@country-constants/customTheme.config` |
| Palette | Custom tokens: `ruby`, `jade`, `smoke`, `canvas`, `online`, `offline` |
| Breakpoints | `xs`, `md`, `lg` only (`sm`/`xl` removed) |
| Global CSS | `packages/gui/skijan/common/css/` |

## Styling rules

- Emotion `css` prop / `styled` — match surrounding file
- Media queries: **min-width**, mobile-first (see accounts README pattern)
- MUI `sx` with theme palette — not hardcoded hex

| Tag | Check |
|-----|-------|
| agent | Colors from `theme.config.ts` / MUI palette |
| agent | Locale validation constants from `@country-constants` |
| human | Correct layout type visual (Surface vs Mypage vs Inquiry) |
