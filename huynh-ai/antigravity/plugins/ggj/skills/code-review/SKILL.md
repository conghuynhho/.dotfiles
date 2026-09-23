---
name: code-review
description: Reviews changed code in a pull request or working tree and reports findings grouped by severity. Use whenever the user asks to review code, get PR or pull-request feedback, check code quality, find bugs or security issues, do a security review.
---

# Code Review

Review changed code, not the whole repository. Focus on the diff plus the
surrounding context needed to understand it. Report findings grouped by
severity so the author knows what blocks the merge and what is optional.

## Invocation

```bash
/ggj:code-review [PR_URL] [context]
```

| Param | Placeholder | Description |
|-------|-------------|-------------|
| 1st | `$PR_URL` / `$0` | What to review: branch name, PR URL, commit SHA, diff base (e.g. `staging`), or `working-tree` |
| 2nd | `$context` / `$1` | Extra context: ticket/issue key, requirements, focus area, or constraints |

Examples:

```bash
/ggj:code-review staging...HEAD "BL-123: validate email on signup"
/ggj:code-review "https://github.com/org/repo/pull/42" "focus on auth flow"
/ggj:code-review working-tree "FE only — check responsive layout"
```

When `$PR_URL` is provided, use it directly as the review target. When `$context`
is provided, treat it as the business requirement or review focus — validate
the diff against it. If either is empty, infer from conversation or ask once.

**Active scope:** $PR_URL
**Active context:** $context

---

## Workflow

### 1. Determine the review scope

Use `$PR_URL` when provided; otherwise figure out what to review:

- **Branch / PR** → `git diff <base>...HEAD` (e.g. `git diff staging...HEAD`)
- **PR URL** → `gh pr diff <number>`, `gh pr view` for metadata; **post inline comments** (step 7)
- **Current branch with open PR** → `gh pr view` to detect PR; post inline if found
- **Specific commit** → `git show <sha>`
- **Working tree** → `git diff` + `git diff --staged`
- **Just-implemented feature** → review the files you just changed

If the scope is ambiguous (multiple branches, unclear base), ask the user
which changes to review before proceeding. Run `git status` first if unsure
what state the working tree is in.

### 2. Read enough context

The diff alone is often not enough. Open the changed files to see the surrounding
code, and check callers or callees when a change affects an interface. Do not
review lines that were not changed unless they are needed to judge the change.

If `$context` mentions a ticket, read the requirement and confirm the diff
addresses it.

### 3. Classify changed files (BE / FE)

Scan every changed file in the diff and classify it as **BE**, **FE**, or
**shared** (touches both layers, e.g. DTO used by API + UI).

**Backend signals** — path or extension suggests server-side code:
`api/`, `server/`, `backend/`, `services/`, `repositories/`, `models/`,
`migrations/`, `controllers/`, `routes/`, `middleware/`, `cron/`, `queue/`,
`handlers/`, `domain/`, `infra/`, `*.sql`, NestJS modules, gRPC protos,
OpenAPI specs consumed by the server.

**Frontend signals** — path or extension suggests client-side code:
`components/`, `pages/`, `views/`, `hooks/`, `stores/`, `composables/`,
`layouts/`, `styles/`, `assets/`, `frontend/`, `client/`, `*.vue`, `*.tsx`,
`*.jsx`, `*.css`, `*.scss`, Storybook stories, client-side routing.

**Heuristics when ambiguous:**
- `.ts` in `src/api/` or next to controllers → BE; in `src/components/` → FE
- Shared types/DTOs used by both → tag **shared**; load both checklists
- `$context` hint like `"FE only"` or `"BE only"` overrides path heuristics
- Config-only changes (CI, Docker) → Common checklist only, skip BE/FE files

Summarize BE/FE classification in the Summary paragraph and `### What changed` bullets.

### 4. Load and apply checklists

Backend/Frontend checklists live **outside** the plugin. Follow the whitelist
and path rules in `ggj-plugin/CLAUDE.md` → **External file access**.

**Always** apply the **Common** checklist (below).

**Then load external checklists based on classification:**

| Classification | Action |
|----------------|--------|
| Any file tagged BE or shared | `Read` → `Backend.md` |
| Any file tagged FE or shared | `Read` → `Frontend.md` |
| Both BE and FE files changed | Load **both** files |
| Neither (config/docs only) | Common checklist only |

Resolve path: `$WORKDIR/GGJungle/configs/packages/common/docs/<file>`, or
`Glob` `**/GGJungle/configs/packages/common/docs/<file>` if `$WORKDIR` is unknown.

If `Read` is denied → stop and tell the user to complete **Developer setup** in
`ggj-plugin/CLAUDE.md` ( `additionalDirectories` or `Read(**/GGJungle/configs/packages/common/docs/**)` ).
Do not review BE/FE items from memory.

Walk every item in the loaded checklist(s). For each issue found, record:
`file`, `start_line`, `end_line`, `side`, labels (domain/severity/effort),
`proposed_fix_title`, `diff` or `suggestion`, optional `ai_agent_prompt`, and
body text — these feed Block 2 and inline PR posting (step 7).

### 5. Derive test cases from the diff

After reviewing, write **Test Cases** in CodeRabbit format (see Block 1 in
Output Format): four categories with `Verify …` sub-bullets, each grounded in
real functions, endpoints, or UI flows from the diff.

### 6. Report findings

Use the **Output Format** below:
1. **Block 1** — CodeRabbit-style Summary + Test Cases (chat + PR top-level review body)
2. **Block 2** — Review comments (chat mirror of inline findings)
3. **Block 3** — Post **inline comments on PR lines** when scope is a GitHub PR

### 7. Post inline comments on the PR (when applicable)

Skip this step when reviewing a branch diff, commit, or working tree **without**
an open GitHub PR. For PR scope, **every finding in Block 2 must also be posted
as an inline comment** on the exact changed line(s).

#### Resolve PR metadata

```bash
# From PR URL or current branch
gh pr view <number-or-url> --json number,headRefOid,baseRefOid,url
# Or current branch's PR
gh pr view --json number,headRefOid,baseRefOid,url
```

Save `headRefOid` as `COMMIT_SHA` — inline comments must anchor to the PR HEAD
commit. Re-fetch if the author pushes new commits during review.

#### Line range scope (required)

Every inline comment **must** highlight the exact code span the finding refers to —
from **line `start_line` through line `end_line`** (inclusive). GitHub shows this
range highlighted on the PR diff, like CodeRabbit.

**How to pick `start_line` and `end_line`:**

1. `Read` the file at PR HEAD and locate the problematic code — do not guess line
   numbers from the diff hunk header alone.
2. Set the range to the **smallest contiguous block** that contains all code
   mentioned in the comment:
   - Single statement → that line only (`start_line` = `end_line`)
   - `if` / `for` / `try` block → from opening line through closing `}`
   - Ordering bug between A and B → `start_line` = first line of A,
     `end_line` = last line of B (e.g. lines 254–269 for `send` through `updateData`)
   - Function-level issue → entire function body in the diff, not the whole file
3. Every line in `[start_line, end_line]` must appear in the PR diff for that
   file (`gh pr diff` / `git diff base...HEAD`). Shrink the range if it extends
   into unchanged context GitHub will reject.
4. Use `side: RIGHT` (new code) by default; `side: LEFT` only for deleted-only hunks.
5. Max **15 lines** per comment — split into multiple findings if wider.

**Verify before posting:**

```bash
# Confirm line numbers match real content (1-based)
sed -n '254,269p' path/to/file.ts
# Or Read tool with offset/limit — quoted lines must match comment body
```

If `start_line` ≠ `end_line`, the API requires both `start_line` and `line`
(where `line` = `end_line`). If equal, send only `line`.

| Case | API fields |
|------|------------|
| Single line | `-F line=254` |
| Multi-line | `-F start_line=254 -F line=269` |

**Wrong:** comment talks about `send` + `updateData` but anchors only line 254.
**Right:** `start_line=254`, `end_line=269` covers the full `if (send) { … }` +
`updateData` sequence under review.

#### Post each finding

One API call per finding. Use the verified `start_line` / `end_line` from above:

```bash
# Multi-line (start_line ≠ end_line)
gh api --method POST repos/{owner}/{repo}/pulls/{pull_number}/comments \
  -f commit_id="$COMMIT_SHA" \
  -f path="apps/api/translation/src/modules/baseV3/autoTranslate.abstract.ts" \
  -F start_line=254 \
  -F line=269 \
  -f side="RIGHT" \
  -f body="$(cat <<'EOF'
_🛡️ Stability & Availability_ | _🟠 Major_ | _⚡ Quick win_

**Slack notification failure blocks the DB update.**

Lines 254–269: `await send(...)` runs before `await this.updateData(...)`. If
the Slack notification fails, the DB update never runs and translation results
won't be saved.

- Any transient Slack/API error aborts the whole handler before persistence.
- The primary write path should not depend on a best-effort notification.

Wrap the Slack notification in `try/catch` (best-effort), or move it after
`updateData` so notification failure doesn't block the primary write.

<details>
<summary>🐛 Proposed fix to make Slack notify best-effort before DB write</summary>

```diff
     if (this.useGPTOpenai && errorList.length) {
+      try {
         await send(
           {
             preContent: 'Translate openAI error, please check the error message',
             message: JSON.stringify([...new Set(errorList)]),
           },
           process.env.ERROR_SLACK_CHANNEL,
         )
+      } catch (err) {
+        console.error('Slack notify failed', err)
+      }
     }
     await this.updateData({
```

</details>

<details>
<summary>🤖 Prompt for AI Agents</summary>

```
Verify each finding against current code. Fix only still-valid issues, skip the
rest with a brief reason, keep changes minimal, and validate.

In `apps/api/translation/src/modules/baseV3/autoTranslate.abstract.ts` around
lines 254 - 269, Slack `send` is awaited before `updateData`, so notification
failure prevents persistence. Make Slack best-effort (`try/catch` or move after
`updateData`) without changing the `updateData` payload or success path.
```

</details>
EOF
)"
```

Single-line finding (`start_line` = `end_line`):

```bash
gh api --method POST repos/{owner}/{repo}/pulls/{pull_number}/comments \
  -f commit_id="$COMMIT_SHA" \
  -f path="path/to/file.ts" \
  -F line=42 \
  -f side="RIGHT" \
  -f body="..."
```

#### Post Block 1 as the PR review summary

After all inline comments, submit one top-level review (does not duplicate inline
bodies — only Summary + Test Cases):

```bash
gh pr review <number> --comment --body-file /tmp/ggj-review-summary.md
```

Write `/tmp/ggj-review-summary.md` with Block 1 content only.

#### Posting rules

- **Do not skip** inline posting for Critical/Major findings on a PR
- Critical/Major comments **must** include `<details>` **Proposed fix** with `diff` or `suggestion`
- Critical/Major with non-trivial fixes **must** include `<details>` **Prompt for AI Agents**
- Every posted comment body must open with label row + bold headline; use
  **`Lines {start_line}–{end_line}:`** in the body when the range spans >1 line
- `diff` / `suggestion` must apply to the anchored range (or the minimal superset of changed lines)
- **🟢 Minor** / nitpicks: post inline only when the fix is non-obvious; otherwise
  group in the top-level review body under `### Minor notes`
- If `gh api` fails (permissions, line not in diff, stale commit, range outside
  diff): shrink `start_line`/`end_line` to the nearest valid diff hunk, retry once;
  if still failing, report error in chat with intended range + body
- Never post secrets, tokens, or full PII in comment bodies
- Confirm with the user before posting if they said "review only" / "no post" in
  `$context`; default for PR scope is **post**


## Common Checklist

Apply to every change. Backend and Frontend checklists are loaded from
`packages/common/docs/` — see step 4 in Workflow.

#### Correctness
- Does it match the spec or `$context` requirements?
- Are edge cases handled (null, empty, boundary values)?
- Are error paths handled, not just the happy path?
- Are there off-by-one errors, race conditions, or state inconsistencies?

#### Readability & Simplicity
- Are names descriptive and consistent with project conventions?
- Is the control flow straightforward?
- Is related code grouped, with clear module boundaries?
- Do abstractions earn their complexity?
- Is there dead code, no-op variables, or leftover `// removed` comments?

#### Architecture
- Does it follow existing patterns? If it introduces a new one, is that justified?
- Does it maintain clean module boundaries?
- Is there duplication that should be shared?
- Do dependencies flow in the right direction (no circular dependencies)?

#### Change Sizing
```
~100 lines   → Good. Reviewable in one sitting.
~300 lines   → Acceptable if single logical change.
~1000 lines  → Too large. Recommend splitting.
```

#### Change Documentation
- Complex changes explained in PR description or comments?
- New functions have typed inputs/outputs?
- Callers updated when behavior changes?

---

## Finding Categories

Every finding opens with a **label row** (CodeRabbit style, italic + emoji):

```
_🎯 <Domain>_ | _<Severity emoji> <Severity>_ | _<Effort emoji> <Effort>_
```

**Domain** (pick one):

| Emoji | Label |
|-------|-------|
| 🎯 | Functional Correctness — logic bugs, wrong behavior, spec mismatch |
| 🛡️ | Stability & Availability — failures, blocking awaits, error handling |
| 🔒 | Security — auth, injection, data exposure |
| ⚡ | Performance — N+1, leaks, hot-path cost |
| 🧹 | Maintainability — structure, naming, duplication |

**Severity:**

| Emoji | Label |
|-------|-------|
| 🔴 | Critical — must fix before merge |
| 🟠 | Major — should fix |
| 🟢 | Minor — optional |

**Effort:**

| Emoji | Label |
|-------|-------|
| ⚡ | Quick win — small, localized fix |
| 💬 | Consider — worth discussing |
| 🏗️ | Heavy lift — non-trivial refactor or cross-file change |
| 🚫 | Pre-merge — blocking (pair with Critical) |

**Headline** (line 2): bold one-liner stating the core defect, e.g.
`**\`length === 2\` does not guarantee one image from each product.**`

**Body structure** (required for Critical/Major):
1. Explain *why* the current code is wrong (reference symbols from the anchored range)
2. Bullet **concrete failure scenarios** (duplicate ids, empty input, race, …)
3. One-line **direction**: what to validate / change (not full code yet)
4. `<details>` **Proposed fix** — see **Proposed fix format** below
5. Optional `<details>` **Prompt for AI Agents** — copy-paste prompt to fix this finding

### Proposed fix format (required for Critical/Major)

Wrap the fix in a collapsible block. Title = action, not generic "suggestion":

````markdown
<details>
<summary>🐛 Proposed fix to require one image per distinct id</summary>

```diff
   const files = await imagesModel.find({
     where: { ... },
+    fields: ['masterId', 'userId'],
   }) || []
-  return {
-    validate: files.length === 2 && files[0].userId === files[1].userId,
-  }
+  const masterFile = files.find(file => String(file.masterId) === String(masterId))
+  const copyFile = files.find(file => String(file.masterId) === String(copyId))
+  return {
+    validate: Boolean(masterFile) && Boolean(copyFile) && masterFile.userId === copyFile.userId,
+  }
```

</details>
````

**Proposed fix rules:**
- `<summary>` starts with `🐛 Proposed fix to <short action>` — describe the outcome, not "fix bug"
- Use `diff` fence when logic changes span multiple lines; use `suggestion` only for
  single-hunk GitHub-applyable edits inside the anchored range
- `diff` must be **minimal**: only lines that change, with 3-space context prefix as in unified diff
- Include related improvements in the same diff when they belong to the same fix (e.g. `fields` projection)
- After `</details>`, optional one-line note tying extra context to the fix

**AI Agents prompt** (include for Critical/Major when fix is non-trivial):

```markdown
<details>
<summary>🤖 Prompt for AI Agents</summary>

```
Verify each finding against current code. Fix only still-valid issues, skip the
rest with a brief reason, keep changes minimal, and validate.

In `@path/to/file.js` around lines {start_line} - {end_line}, <specific defect>.
Update <function/symbol> to <required behavior>. Keep the existing return shape
and limit `fields`/projections to identifiers needed for the check.
```
</details>
```

---

## Output Format

Produce up to **three blocks** depending on scope.

---

### Block 1 — Summary & Test Cases (CodeRabbit style)

Pasteable release-notes block. Match this structure exactly — same headings,
checkbox style, and `Verify …` phrasing.

```markdown
## Summary

<One paragraph: what was done and why, naming the main files/modules affected.
Example: "Refactored `server/services/common/product.js` and the localized
variants (`en`, `hk`, `ja`, …) to centralize password resolution through
`commonServiceProduct.getPassword`.">

### What changed

- <Concrete change tied to a file or function>
- <Another specific change from the diff>
- <Include behavioral changes, not just file renames>

## Test Cases

- [ ] Happy path scenarios
  - Verify <specific flow> succeeds when <input/condition>.
  - Verify <another happy path> returns <expected result>.
- [ ] Edge cases and boundary conditions
  - Verify behavior when <boundary condition from the actual code>.
  - Verify <locale/variant/module> still returns <expected tuple/shape>.
- [ ] Error/negative cases
  - Verify <wrong input> still returns <expected failure response>.
  - Verify malformed or missing <input> does not break <function>.
- [ ] Regression test cases if applicable
  - Verify <pre-existing behavior> still works after this change.
  - Verify repeated calls do not leave <listeners/timers/leaks>.
```

**Summary rules:**
- Opening paragraph names real paths/functions from the diff — no generic filler
- `### What changed` bullets map 1:1 to meaningful diff hunks (removed X, added Y, updated Z to call …)
- Omit a test category only when truly N/A; never leave placeholder text

**Test case rules:**
- Every sub-bullet starts with **Verify** (CodeRabbit convention)
- Ground each case in the actual code: function names, endpoints, locales, cookies, timeouts, etc.
- Happy path = expected success flows introduced or preserved by this PR
- Edge = boundaries the new code explicitly handles (timeouts, empty input, last-ms events)
- Error/negative = invalid input, auth failure, missing data
- Regression = behavior that existed before and must not break; resource cleanup if listeners/timers added
- If the PR is FE-only, cases describe UI actions; if BE-only, describe API/service calls

---

### Block 2 — Review comments (chat + inline body template)

One finding per issue. This block mirrors what gets posted inline on the PR.
Each finding **must** include machine-usable anchor fields for step 7.

````markdown
## Review comments

### Finding 1
- **file:** `ja/server/services/mypage/developer/product.js`
- **side:** RIGHT
- **start_line:** 1094
- **end_line:** 1106
- **scope:** lines 1094–1106 — image validation `files.length === 2` check
- **labels:** 🎯 Functional Correctness · 🟠 Major · 🏗️ Heavy lift
- **proposed_fix_title:** Proposed fix to require one image per distinct id

_🎯 Functional Correctness_ | _🟠 Major_ | _🏗️ Heavy lift_

**`length === 2` does not guarantee one image from each product.**

Lines 1094–1106: The query matches all valid manual images whose `urlHash` equals
`hash` and whose `masterId` is in `[masterId, copyId]`. The success check
`files.length === 2 && files[0].userId === files[1].userId` assumes exactly one
matching row per product, but that is not enforced:

- If a single product has **two** valid images sharing the same `urlHash`,
  `files.length === 2` and both share the same `userId`, so it incorrectly
  returns `validate: true` even though the other product has no matching image.
- If `masterId === copyId`, `inq: [id, id]` collapses to one id, and two images
  on that single product again produce a false positive.

Validate by id rather than by count so both products are actually represented
and owned by the same user.

<details>
<summary>🐛 Proposed fix to require one image per distinct id</summary>

```diff
   const files = await imagesModel.find({
     where: {
       masterId: {
         inq: [masterId, copyId],
       },
       imageCategoryId: MANUAL_PRODUCT_IMAGE_CATEGORY_ID,
       urlHash: hash,
       isValid: 1,
     },
+    fields: ['masterId', 'userId'],
   }) || []
-  return {
-    validate: files.length === 2 && files[0].userId === files[1].userId,
-  }
+  const masterFile = files.find(file => String(file.masterId) === String(masterId))
+  const copyFile = files.find(file => String(file.masterId) === String(copyId))
+  return {
+    validate: Boolean(masterFile) && Boolean(copyFile) && masterFile.userId === copyFile.userId,
+  }
```

</details>

The `fields` projection above also addresses selecting only `userId`/`masterId`
when those are the only columns needed for the check.

<details>
<summary>🤖 Prompt for AI Agents</summary>

```
Verify each finding against current code. Fix only still-valid issues, skip the
rest with a brief reason, keep changes minimal, and validate.

In `ja/server/services/mypage/developer/product.js` around lines 1094 - 1106,
the validation relies on `files.length === 2` and matching `userId`, which can
pass when both rows belong to the same product instead of one row per
`masterId`/`copyId`. Update the image lookup path to validate by distinct
`masterId` presence, ensuring both `masterId` and `copyId` each have a matching
result. Keep the existing `validate` return structure and limit `fields` to
identifiers needed for the check.
```

</details>

### Finding 2
...

**Tally:** 1 critical, 2 major, 3 nitpicks.
**Posted:** 3 inline comments on PR #123 · 1 summary review
````

**Review comment rules:**
- `file`, `side`, `start_line`, `end_line`, `scope`, and `proposed_fix_title` are
  **required** for every Critical/Major finding
- Label row + bold headline + failure bullets + direction + Proposed fix + AI prompt
  = complete Critical/Major comment (do not post without Proposed fix)
- `scope` = one-line summary of the anchored code span (audit before post)
- Verify range with `Read` / `sed -n '{start},{end}p'` before posting
- Body after metadata = exact markdown posted via `gh api ... pulls/comments`
- Omit empty severity groups; still post tally + posted count

---

### Block 3 — PR posting checklist (PR scope only)

After Block 1 and Block 2 are ready, verify **each inline comment** before posting:

**Per-finding content checklist**

- [ ] Label row: `_<Domain emoji> …_ | _<Severity emoji> …_ | _<Effort emoji> …_`
- [ ] Bold headline states the defect in one line
- [ ] Body cites `Lines {start}–{end}:` and explains *why* current code fails
- [ ] ≥2 concrete failure scenarios as bullets (when applicable)
- [ ] One-line fix direction before the collapsible blocks
- [ ] `<details>` `🐛 Proposed fix to <action>` with minimal `diff` (or `suggestion` for 1-hunk edits)
- [ ] `<details>` `🤖 Prompt for AI Agents` for Critical/Major non-trivial fixes
- [ ] `start_line`–`end_line` verified against file content and PR diff

**Posting sequence**

1. [ ] Fetched `headRefOid` for the PR
2. [ ] Block 2 complete — every Critical/Major has Proposed fix (+ AI prompt if needed)
3. [ ] Posted inline comment per finding via `gh api` with verified line range
4. [ ] Posted Block 1 via `gh pr review --comment --body-file`
5. [ ] Reported in chat: PR URL, comment count, line ranges, whether each had Proposed fix

**Request changes** when any Critical finding exists:

```bash
gh pr review <number> --request-changes --body-file /tmp/ggj-review-summary.md
```

Otherwise use `--comment` (non-blocking review with summary).
