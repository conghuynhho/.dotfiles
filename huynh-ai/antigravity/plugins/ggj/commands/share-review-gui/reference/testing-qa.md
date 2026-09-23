# Testing & QA

> Load when: Phase 1–4 workflow, CRUD flows, edge cases, rich editors.
> Tags: [README.md](../README.md#review-ownership). Infra: [api-data-fetching.md](api-data-fetching.md) · [security.md](security.md) · [performance.md](performance.md).

## Phase 1 {#phase-1}

| Tag | Check |
|-----|-------|
| agent | Implementation matches ticket/spec intent |
| agent | In-scope only; no unrelated changes |
| agent | New workflows documented and testable E2E |
| agent | Wiki / Figma / JP specs linked and current |

## Phase 2 {#phase-2}

| Tag | Check |
|-----|-------|
| human | Layout, spacing, copy, states match Figma/design |
| agent | JP NG patterns documented and covered |
| human | CRUD: confirm, cancel, success/error toasts |
| agent | Duplicate-product: detection, merge, idempotency |
| human | F12: no unhandled rejections, Vue warnings, PII in logs |

## Edge cases {#edge-cases}

| Tag | Check |
|-----|-------|
| agent | All acceptance criteria and branches covered |
| agent | Boundaries: min/max length, empty list, max page size |
| agent | Type limits: overflow, truncation, enum out of range |
| agent | `null` / `undefined` / missing API fields handled |
| agent | Guards before DOM access, index, nested reads |
| agent | Side effects: wrong link URLs; component in multiple layouts; layout slots (desktop vs mobile) |

API error mapping → [api-data-fetching.md](api-data-fetching.md).

## Ad hoc {#ad-hoc}

Run infra checks from linked files when Phase 4 applies. Rich-editor checks may exist in a project overlay skill.
