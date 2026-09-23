# Performance — GGJ

> Load when: IVS/HLS video, Highcharts, lazy hydration, bundle changes.
> Universal → [performance.md](../../share-review-gui/reference/performance.md).

| Tag | Check |
|-----|-------|
| agent | Heavy widgets behind dynamic import / client boundary |
| agent | Video (IVS/HLS): cleanup on unmount; no duplicate players |
| agent | Highcharts: load on demand — not in root layout |
| agent | `next/image` + CDN URL helpers for LCP images |
| agent | List virtualization or pagination for large datasets |
| agent | `isBot` / SSR skips non-essential client widgets when applicable |
| ci | Bundle analyze when adding dashjs/hls/highcharts deps |
| human | Video playback and chart interaction across browsers |

Editor / user HTML XSS → [security.md](../../share-review-gui/reference/security.md).
