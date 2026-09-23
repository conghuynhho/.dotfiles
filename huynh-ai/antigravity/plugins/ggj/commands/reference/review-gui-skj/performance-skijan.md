# Performance — Skijan

> Load when: video, Editor.js, infinite scroll, images.
> Universal → [performance.md](../../share-review-gui/reference/performance.md).

| Tag | Check |
|-----|-------|
| agent | Heavy widgets behind `NoSsr` / dynamic import |
| agent | Infinite scroll / virtualization for long lists |
| agent | Next `Image` with project `deviceSizes` |
| agent | Editor.js: no base64 in save payload; max length enforced |
| agent | `isBot` skips GTM, push notification, online status widgets |
| ci | Bundle analyze when adding dashjs/hls/editor deps |
| human | Video playback across browsers |

Editor XSS → [security.md](../../share-review-gui/reference/security.md).
