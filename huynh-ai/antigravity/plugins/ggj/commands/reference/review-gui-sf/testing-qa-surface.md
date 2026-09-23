# Testing & QA — Surface (Rich Editors)

> Load when: Summernote, Editor.js, or similar rich text in surface monorepo.
> Phase 1–4 workflow → [testing-qa.md](../../share-review-gui/reference/testing-qa.md).

## Rich editors (Summernote / Editor.js)

| Tag | Check |
|-----|-------|
| human | Undo/redo after paste/upload |
| human | Paste: plain text, rich HTML, external images |
| agent | No base64 in save/auto-save payload |
| agent | Image URLs valid CDN paths |
| agent | Upload size + MIME validated (client + server) |
| agent | Payload: safe HTML, correct fields, no duplicate blobs |
| agent | Lazy image/iframe; external URLs per spec |
| human | Text ↔ HTML mode: media URLs resolve; no duplicate fetches |
| agent | Max length enforced in editor and submit |

XSS on editor output → [security.md](../../share-review-gui/reference/security.md).
