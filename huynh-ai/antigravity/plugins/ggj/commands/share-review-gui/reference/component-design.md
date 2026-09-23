# Component Design

> Forms, buttons, inputs, upload, tabs, links.
> Tags: [README.md](../README.md#review-ownership). Images → [performance.md](performance.md). Text/i18n → [readability-seo.md](readability-seo.md).

| Area | Tag | Check |
|------|-----|-------|
| **General** | agent | Reuse existing components; single responsibility; typed props; consistent events |
| **Forms** | agent | Debounce submit; `autocomplete="off"` if needed; Enter submits; client + server validation |
| **Buttons** | agent | default/hover/disabled/loading; debounce API; loading blocks re-click |
| **Links** | agent | `noopener noreferrer` on `target="_blank"`; stop propagation if nested clickable |
| | agent | `<NuxtLink>` prefetch appropriate for route weight; `title` when helpful |
| **Upload** | agent | Max size + MIME; error message; single/multi flows |
| | human | Progress/cancel per spec |
| **Checkbox/radio** | agent | Default value; label toggles input |
| | human | Multi-select behavior |
| **Tabs** | agent | `keep-alive` when state must persist |
| **Inputs** | agent | Correct `type`; min/max/regex/required; debounce API on input |
| | agent | Disabled/validation states; placeholder; `title`/tooltip |
| | human | Special chars, emoji, JP keyboard |
| **Select/datetime** | human | Cross-browser; keyboard nav; autocomplete |
| | agent | Date/time API uses UTC (GMT+0) per spec |
| **Rich text** | — | See [security.md](security.md) + project overlay for editor-specific checks |
