# CSS / Emotion / MUI — GGJ

> Load when: Emotion `css`, MUI `sx`, theme tokens, responsive layout.
> Universal → [css-less-sass.md](../../share-review-gui/reference/css-less-sass.md).

## Theme

| Topic | Rule |
|-------|------|
| Styling | Emotion `css` prop / `styled` — match surrounding file |
| MUI | `sx` with theme palette — not hardcoded hex |
| Breakpoints | min-width, mobile-first |
| Tokens | Shared theme config in package — locale apps inherit |

## Styling rules

- Prefer theme palette and spacing over inline magic numbers
- Server Components: avoid client-only Emotion where static layout suffices
- Responsive images/layout aligned with CDN helpers

| Tag | Check |
|-----|-------|
| agent | Colors from theme / MUI palette |
| agent | min-width breakpoints — not max-width cascade |
| agent | Emotion styles colocated with component (isolate rule) |
| human | LCP hero / above-fold layout across locales |
