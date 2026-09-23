# CSS / Less Review Guide

> Load when: `.vue` `<style>`, `.less` files, layout, responsive, animations.
> Runtime perf: [performance.md](performance.md).
> Repo-specific tokens (e.g. Bootstrap variables) may exist in a project overlay skill.

## Variables vs hardcoded values

```less
/* ❌ Repeated hex in component */
.card { border: 1px solid #e5e5e5; padding: 16px; }

/* ✅ Design tokens or shared variables */
.card {
  border: 1px solid var(--border-color, @gray-lighter);
  padding: var(--spacing-md, 16px);
}
```

| Tag | Check |
|-----|-------|
| agent | Colors/spacing from tokens/variables, not repeated literals |
| agent | Same value not copy-pasted 3+ times |
| human | Visual match to design spec |

## `!important`

Use only for utilities (`.sr-only`), print, or documented third-party overrides.

```less
/* ❌ Fix specificity wars */
.title { font-size: 24px !important; }

/* ✅ Flatter selector or BEM modifier */
.article__title--large { font-size: 24px; }
```

## Performance

| Tag | Check |
|-----|-------|
| agent | No `transition: all`; animate `transform`/`opacity` not `width`/`height`/`top`/`left` |
| agent | Selector depth ≤ 3; avoid expensive `filter`/`backdrop-filter` on large areas |
| agent | `will-change` only during animation |

Runtime/bundle perf → [performance.md](performance.md).

## Responsive design

**Mobile-first preferred** for new CSS:

```less
.container {
  padding: 16px;
  @media (min-width: 768px) {
    padding: 24px;
  }
}
```

| Tag | Check |
|-----|-------|
| agent | `max-width: 100%` + fluid layouts — no fixed desktop-only width |
| agent | Touch targets ≥ 44px ([performance.md](performance.md)) |
| human | Phone / tablet — no overlap, cut-off text |
| human | iOS Safari: fixed footer + keyboard |

| agent | Nesting ≤ 3 levels; BEM `&__element`; prefer mixins over long `@extend` |

## Browser compatibility

| Feature | Note |
|---------|------|
| Flexbox `gap` | Check Safari target |
| CSS variables | Provide fallback for older browsers |
| `aspect-ratio` | Pair with padding hack fallback if required |
| `100dvh` | Use with `100vh` fallback on mobile full-screen |

## Tools

Stylelint · Chrome DevTools (layout shift) · Can I Use
