# Front-End GUI Review

Structured GUI review for front-end projects. Process, checklist, and output template below; domain checklists load from the project skill.

## When to Use

- Reviewing front-end PRs or GUI-related tickets
- QA planning before merge (agent vs manual vs CI)
- Security, performance, or SEO checks on changed pages
- Component or route changes

## Project skills

Load the skill matching the repo or app under review (each skill points back here first):

| Skill | Scope |
|-------|-------|
| `review-gui-sf` | Surface — Nuxt 2 / Vue (`surface.gogojungle.co.jp`) |
| `review-gui-ggj` | GGJ — Next.js App Router (`apps/gui/ggj-*`, `packages/gui/ggj`) |
| `review-gui-skj` | Skijan — Next.js Pages Router (`apps/gui/skijan*`, `packages/gui/skijan`) |
| `review-gui-acc` | Accounts — auth GUI (`apps/gui/accounts`) |
| `review-gui-myacc` | MyAccount — settings GUI (`apps/gui/myaccount`) |
| `review-gui-mp-mfe` | Mypage MFE — React Module Federation (`apps/gui/mypage-mfe`, `packages/gui/share-mfe`) |

## Common reference index

Load **only** files relevant to the diff.

| Area | Reference | Load when |
|------|-----------|-----------|
| Vue 2 | [vue.md](reference/vue.md) | `.vue` SFC (Surface) |
| React | [react.md](reference/react.md) | `.tsx` / `.jsx` (GGJ, Skijan, Accounts, MyAccount, MFE) |
| Next.js | [nextjs.md](reference/nextjs.md) | Pages Router or App Router routes, SSR |
| API, URL, redirects | [api-data-fetching.md](reference/api-data-fetching.md) | Fetch, query params, redirects |
| Security | [security.md](reference/security.md) | XSS, cookies, auth |
| Performance | [performance.md](reference/performance.md) | Images, bundle, CWV |
| SEO, i18n | [readability-seo.md](reference/readability-seo.md) | Meta, copy, locales |
| Components | [component-design.md](reference/component-design.md) | Forms, buttons, inputs |
| CSS | [css-less-sass.md](reference/css-less-sass.md) | Styles, layout |
| QA phases | [testing-qa.md](reference/testing-qa.md) | Phase 1–4 detail |
| Architecture | [architecture-review-guide.md](reference/architecture-review-guide.md) | Layering, refactors |
| Code quality | [code-quality-universal.md](reference/code-quality-universal.md) | Helpers, duplication |
| Common FE bugs | [common-bugs-checklist.md](reference/common-bugs-checklist.md) | Async, forms, lists, hydration |
| Security (deep) | [security-review-guide.md](reference/security-review-guide.md) | User HTML, auth, redirect |
| Performance (deep) | [performance-review-guide.md](reference/performance-review-guide.md) | New deps, LCP, large lists |

## Core Principles

### Review mindset

**Goals:** catch bugs and edge cases · ensure maintainability · verify spec/Figma alignment · enforce project patterns · share knowledge.

**Not the goals:** nitpick formatting (use ESLint/Prettier) · block on style preference · rewrite to personal taste.

### Effective feedback

- Specific and actionable — cite file and line
- Questions over commands: *"What happens if `items` is empty?"* not *"This is wrong."*
- Balanced — include `[praise]` for good patterns
- Prioritized — use severity labels consistently

### Review scope

| Review manually | Leave to linters/CI |
|-----------------|---------------------|
| Logic, edge cases, XSS, redirects | Formatting, import order |
| SSR/hydration, API error mapping | Simple typos |
| SEO meta, i18n completeness | Lint rule violations |
| Component reuse, framework patterns | |

## Four-Phase Process

```
Phase 1 — Context & Purpose
  PR/ticket intent, scope, linked specs
              |
              v
Phase 2 — High-Level / Test Design
  Architecture fit, CRUD flows, design alignment
              |
              v
Phase 3 — Deep Analysis
  Edge cases, logic, security, maintainability
              |
              v
Phase 4 — Ad Hoc & Summary
  Infra (API, CDN, perf), output, merge decision
```

| Phase | Focus | When |
|-------|-------|------|
| **1 — Context & Purpose** | Intent, in-scope only, docs/Figma/wiki | Always |
| **2 — High-Level / Test Design** | Layout/copy states, CRUD, F12 | UI/flow changes |
| **3 — Deep Analysis** | Boundaries, null, side effects, API errors | Logic/data changes |
| **4 — Ad Hoc & Summary** | Security, perf, SEO, merge decision | Always |

### Phase checks (summary)

**Phase 1:** matches ticket intent · in-scope only · new flows documented and testable

**Phase 2:** design alignment · CRUD flows · no unhandled rejections or PII in F12 logs

**Phase 3:** empty/null/max boundaries · params validated before API · no silent failures · reuse existing code

**Phase 4:** XSS/redirects · SSR/hydration safe · SEO meta · perf (lazy load, cleanup, bundle if deps changed)

## Quick Checklist

### Pre-review (~2 min)

- [ ] Read PR/ticket + linked Figma/wiki/spec
- [ ] Diff size (<400 lines ideal); note scope (locales, builds, routes)
- [ ] Load domain checklists from project skill for touched areas
- [ ] If logic/async/forms: [common-bugs-checklist.md](reference/common-bugs-checklist.md)

### Red flags

`v-html` without sanitizer · open redirect · SSR `window`/`document` · hydration mismatch · unvalidated query → API · page API in layout/plugin · `console.log` in commit · unsafe editor save payload · hardcoded copy when i18n exists

### Decision matrix

| Situation | Verdict |
|-----------|---------|
| Unsanitized user HTML | 🔴 Request Changes |
| Missing required SSR/auth headers on server fetch | 🔴 Request Changes |
| Unvalidated sort/filter query param | 🟠 Important |
| Missing Lighthouse on heavy page | `[ci]` — note in output |
| Naming preference | 🟡 nit |

## Review Ownership

Items verifiable from code/diff = `[agent]`. Browser, device, or visual-only = `[human]`. Build/tooling = `[ci]`.

| Tag | Who | Agent must | In output |
|-----|-----|------------|-----------|
| `[agent]` | Static / code | Verify in diff; cite files | **Project Checklist** — ✅ / ⚠️ / ❌ |
| `[human]` | Browser / device | No pass without evidence | **Manual QA required** — 🔲 + steps |
| `[ci]` | Build / tooling | Pass only with output | **CI / tooling required** — 🔲 or ✅ Ran |

Never mark `[human]` or `[ci]` as ✅ in Project Checklist.

## Severity Labels

| Label | Meaning | Merge impact |
|-------|---------|--------------|
| 🔴 `[blocking]` | Must fix before merge | Block |
| 🟠 `[important]` | Should fix; may block by context | Discuss |
| 🟡 `[nit]` | Minor style or preference | Non-blocking |
| 🔵 `[suggestion]` | Optional improvement | Consider |
| 📚 `[learning]` | Educational note for author | No action |
| 🌟 `[praise]` | Highlight good work | Celebrate |

## Review Techniques

1. **Checklist method** — walk domain checklists row by row for touched areas
2. **Question approach** — ask about empty lists, failed API, keyboard on mobile
3. **Suggest, don't command** — *"Would `sanitize-html` fit here?"*
4. **Reuse audit** — search shared components, utils, mixins before accepting new helpers

### Communication

```markdown
❌ "This v-html is wrong."
✅ "Could unsanitized API HTML here allow XSS? Consider `sanitize-html`."

❌ "You must use the project HTTP client."
✅ "For SSR, does this request pass the same headers as other route containers?"
```

**Disagreements:** understand intent → acknowledge valid points → cite project patterns → escalate if needed → let go on non-blocking nits.

### Reviewer / author anti-patterns

| Reviewer | Author |
|----------|--------|
| Rubber stamping without reading the diff | Mega PRs (>400 lines) without split plan |
| Bike shedding on naming | No ticket/Figma link in PR |
| Scope creep refactors | Defensive replies to every nit |
| False ✅ on `[human]` / `[ci]` items | Silent force-push without addressing comments |

### Review depth

| Level | When | Duration |
|-------|------|----------|
| Skim | CSS/copy-only | ~5 min |
| Standard | Typical component/page | 20–40 min |
| Deep | New route, SSR, auth, editor | 60+ min |

## Time Budget

| PR size | Target time |
|---------|-------------|
| < 100 lines | 15–20 min |
| 100–400 lines | 30–45 min |
| > 400 lines | Ask to split or schedule deep review |

## Output Format

Copy the structure below for each review. **Rules:** always include Manual QA + CI sections; every finding gets a severity label.

```markdown
# GUI Review — [task/PR]

## Summary

[Brief overview — 1–2 sentences]

**PR size:** [Small/Medium/Large] (~X lines)
**Scope touched:** [e.g. routes, locales, builds — if applicable]
**Risk:** [Low/Medium/High]
**Verdict:** [ ] ✅ Approve · [ ] 💬 Comment · [ ] 🔄 Request Changes

## Phase 1–4

| Phase | Status | Notes |
|-------|--------|-------|
| 1 Context & Purpose | ✅ / ⚠️ / ❌ | |
| 2 High-level / Test Design | ✅ / ⚠️ / ❌ | |
| 3 Deep Analysis | ✅ / ⚠️ / ❌ | |
| 4 Ad Hoc & Summary | ✅ / ⚠️ / ❌ | |

## Project Checklist

`[agent]` items only — ✅ / ⚠️ / ❌

- **Page / routing:**
- **SEO / i18n:**
- **Performance / assets:**
- **Components:**
- **Security:**
- **Cross-browser (code-level):**

## Manual QA required

| Status | Check | How to verify |
|--------|-------|---------------|
| 🔲 Not verified | | |

N/A if none.

## CI / tooling required

| Status | Check | Command / evidence |
|--------|-------|-------------------|
| 🔲 Not run | | |

N/A if none.

## Findings

| Severity | File | Issue | Recommendation |
|----------|------|-------|----------------|
| | | | |

## Strengths

🌟 **[praise]** [What was done well]
```

### Finding copy blocks

**Blocking**

```
🔴 **[blocking]** [Title]

[Description]

**Location:** `path/to/file.vue:123`

**Suggested fix:** [concrete change]
```

**Important**

```
🟠 **[important]** [Title]

[Why it matters]

**Consider:** [approach]
```

**Nit**

```
🟡 **[nit]** [Suggestion]

Not blocking — [optional improvement].
```

**Learning**

```
📚 **[learning]** [Note]

For context, [pattern] in this codebase usually [X]. No action needed.
```

**Praise**

```
🌟 **[praise]** Great work on [specific thing]!

[Why this helps maintainability / security / perf]
```
