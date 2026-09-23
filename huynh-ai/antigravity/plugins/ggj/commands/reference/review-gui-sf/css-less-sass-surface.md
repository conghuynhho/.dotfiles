# CSS / Less — Surface Conventions

> Load when: `.vue` `<style>`, `.less` in surface monorepo.
> Universal CSS rules → [css-less-sass.md](../../share-review-gui/reference/css-less-sass.md).

## Project setup

| Topic | Rule |
|-------|------|
| Global variables | `bootstrap/less/variables.less` via `@nuxtjs/style-resources` — prefer `@brand-*`, `@spacing-*` over hex literals |
| Per-locale config | `style-resources` registered in each `{locale}/nuxt.config.js` |
| Component styles | `scoped` or BEM; avoid leaking globals |
| Desktop/mobile | Shared Less in `common/`; verify both builds if layout changes |
| Viewport | `100dvh` + `100vh` fallback — not bare `100vh` on full-screen modals |

## Variables vs hardcoded values

```less
/* ❌ Repeated hex in component */
.card { border: 1px solid #e5e5e5; padding: 16px; }

/* ✅ Bootstrap variables or shared tokens */
.card {
  border: 1px solid @gray-lighter;
  padding: @padding-base-vertical @padding-base-horizontal;
}
```

| Tag | Check |
|-----|-------|
| agent | Colors/spacing from `variables.less` or design tokens |
| agent | Same value not copy-pasted 3+ times |
| human | Visual match to Figma spacing |

## Browser compatibility

Project uses Babel `corejs: 3` + polyfills in base Nuxt config — test before removing.

| Feature | Note |
|---------|------|
| Flexbox `gap` | Check Safari target |
| CSS variables | Provide fallback if supporting very old browsers |
| `aspect-ratio` | Pair with padding hack fallback if required |

## Less-specific

| Tag | Check |
|-----|-------|
| agent | Don't import huge Less trees into every SFC — use style-resources |
| agent | Nesting ≤ 3 levels — compiled selector not `.a .b .c .d .e` |
