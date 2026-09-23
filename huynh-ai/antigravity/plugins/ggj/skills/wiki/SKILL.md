---
name: wiki
description: >-
  Maintain an LLM-managed team knowledge base ("LLM wiki", Karpathy's pattern):
  the human curates sources and asks questions, this skill does all bookkeeping.
  Use this skill WHENEVER the user says "ingest", "query wiki", "lint wiki",
  "audit wiki", "add to wiki", "search wiki", "fetch notion", "fetch github",
  "sync", "refresh", "health check the wiki", or invokes "/llm" — even if they
  don't say the word "wiki". ALL data lives on a remote server and is accessed
  ONLY through the `wiki-mcp` MCP server (tools named `mcp__wiki-mcp__*`). There
  is NO local-file fallback: never read, write, list, or grep local files, the
  working directory, or any on-disk folder for wiki data.
---

# LLM Wiki Skill

A persistent, compounding knowledge base maintained by the LLM (Karpathy's "LLM
wiki" pattern). The human curates sources and asks questions; the LLM does all
the bookkeeping — fetching sources, summarizing, cross-linking, and keeping the
index consistent.

## The one hard rule: everything goes through `wiki-mcp`

Every read, write, list, retrieval, and source fetch happens through
`mcp__wiki-mcp__*` tools. **There is NO local-file fallback.** Never read, write,
list, grep, or inspect local files, the current working directory, or any folder
on disk for wiki content. If a needed `wiki-mcp` tool is unavailable, **STOP and
tell the user** — do not improvise with local file tools. There is no offline
mode.

Remote layout (all paths are remote, served by `wiki-mcp`):

```
raw/        # immutable source snapshots with YAML frontmatter — NEVER modified after save
wiki/
  _index.md # content catalog — refreshed on every ingest
  log.md    # append-only ops log
  *.md      # entity/concept pages (TitleCase-Hyphenated filenames)
```

## Tools (`wiki-mcp`)

Call tools by their exact names. Parameter names below are the expected ones; if
a call returns an unexpected error, re-check against the tool's actual schema
rather than guessing new parameters.

### Wiki tools

| Tool | Use |
|------|-----|
| `mcp__wiki-mcp__wiki_index_status` | Health check before any operation |
| `mcp__wiki-mcp__wiki_retrieve` | Hybrid search + `[[WikiLink]]` expansion (params: `query`, `limit`, `min_score`, `expand_links`, `include_index`, `collection`) |
| `mcp__wiki-mcp__wiki_setup_index` | Re-index after writes (`embed: true` for hybrid query; `embed: false` for the fast path) |
| `mcp__wiki-mcp__wiki_read_file` | Read one file under `wiki/…` or `raw/…` |
| `mcp__wiki-mcp__wiki_write_file` | Create/overwrite a page under `wiki/` only (`overwrite` to replace) |
| `mcp__wiki-mcp__wiki_save_raw` | Save a NEW immutable file under `raw/` (FAILS if the path already exists) |
| `mcp__wiki-mcp__wiki_list_files` | List files (`collection: "wiki" \| "raw"`, optional `pattern`) |
| `mcp__wiki-mcp__wiki_append_log` | Append an entry to `wiki/log.md` (`heading`, `body`) |

### Source-fetch tools (proxied, read-only)

| Tool | Use |
|------|-----|
| `mcp__wiki-mcp__notion_API-retrieve-a-page` | Fetch a Notion page + its `last_edited_time` |
| `mcp__wiki-mcp__notion_API-get-block-children` | Walk the Notion block tree for content |
| `mcp__wiki-mcp__notion_API-retrieve-a-block` | Read a single Notion block |
| `mcp__wiki-mcp__notion_API-post-search` | Search Notion pages |
| `mcp__wiki-mcp__notion_API-query-data-source` | Query a Notion data source |
| `mcp__wiki-mcp__notion_API-retrieve-a-database` | Read a Notion database |
| `mcp__wiki-mcp__github_get_file_contents` | Fetch a file (content + blob `sha`) from a repo |
| `mcp__wiki-mcp__github_list_commits` | List commits (filter by `path`) for the real last-update date |
| `mcp__wiki-mcp__github_search_code` | Search code across repos |
| `mcp__wiki-mcp__github_search_repositories` | Find repositories |

## Health check (do this first, silently)

Before any operation, call `mcp__wiki-mcp__wiki_index_status`.

- `ok: true` → proceed, using `mcp__wiki-mcp__*` tools for **all** I/O.
- unavailable / error → tell the user **"the `wiki-mcp` server is unavailable"**
  and **STOP**. Do not touch local files.

## Routing: pick the operation from what the user said

| User says… | Operation |
|------------|-----------|
| `fetch notion <url>`, `fetch github <url>`, `sync`, `refresh`, ingest from a URL/ID | **FETCH** (then auto-hands off to INGEST) |
| a `raw/` path, pasted content to store, `ingest <…>` | **INGEST** |
| `query wiki <question>`, or any question about wiki content | **QUERY** |
| `lint wiki`, `audit wiki`, `health check`, `sync`, `refresh` | **LINT / SYNC** |

`/llm` is a shorthand the user may type before any of the above (e.g.
`/llm fetch notion <url>`); strip it and route by the remaining words.

## Dates

Wiki bookkeeping records real dates. For `fetched_at` in `raw/` frontmatter and
for `YYYY-MM-DD` shown inside pages, log entries, and index entries, **use the
actual current date** from the environment — never invent or estimate it. For
upstream timestamps (`source_last_edited`, `source_sha`), use the real values
returned by the source-fetch tools, not the current date. Note: `raw/` filenames
do NOT contain a date — dates live only in frontmatter (see Conventions).

---

## Operation: FETCH

Trigger: `fetch notion …`, `fetch github …`, `sync`, `refresh`, or ingest from a
URL/ID.

FETCH captures **two things** for every source: the original content (saved into
`raw/`, immutable) and the **real upstream metadata** — above all the true
last-update timestamp — stored as YAML frontmatter on the `raw/` file.

### `raw/` frontmatter template

```yaml
---
source: notion                 # notion | github
source_id: <notion-page-id>    # Notion only
source_url: <https://…>        # original URL (both)
source_last_edited: <ISO-8601> # REAL upstream timestamp (see sub-flows)
source_sha: <blob-sha>         # GitHub only (from github_get_file_contents)
fetched_at: <YYYY-MM-DD>       # current date this snapshot was taken
title: <Human Title>
---
```

### Change-detection (run FIRST on every FETCH — avoids needless re-ingest)

1. **Fetch live metadata only** — get the upstream last-update marker without
   re-ingesting the body:
   - Notion → `notion_API-retrieve-a-page`, read `last_edited_time`.
   - GitHub → `github_list_commits` filtered by `path`, read the newest
     `commit.committer.date` (fallback `commit.author.date`); also note the file
     `sha` from `github_get_file_contents`.
2. **Find the latest existing snapshot** for this source — `wiki_list_files`
   (`collection: "raw"`, `pattern` matching the source/title); for the newest
   candidate(s), `wiki_read_file` and parse the frontmatter (`source_id` /
   `source_url`, `source_last_edited`, `source_sha`).
3. **Compare**:
   - **Unchanged** (Notion `last_edited_time` equals stored `source_last_edited`;
     GitHub commit date AND `sha` unchanged) → skip re-ingest, report **"up to
     date"**, optionally `wiki_append_log` a one-line note. Done.
   - **Changed**, or no prior snapshot exists → continue: save a NEW `raw/` file
     (version-suffixed if the name already exists — see Conventions), then run
     **INGEST**.

`wiki_save_raw` is immutable and fails if the path exists, so **never overwrite
`raw/`** — write a new version-suffixed file instead (see Conventions).

### Notion sub-flow

1. Extract the page ID from the URL (or use a bare ID).
2. `notion_API-retrieve-a-page` → capture `last_edited_time`, title, URL/ID.
3. Pull content with `notion_API-get-block-children` (walk nested blocks as
   needed) and render to markdown.
4. **Discover links** (for the recursive crawl) — while walking blocks, collect
   linked targets: `child_page` blocks, `link_to_page` blocks, page `mention`
   references, and any URLs in `bookmark` / `link_preview` / rich-text `href`
   fields. Resolve each child/linked page ID; these become the depth+1 queue.
5. Save with `wiki_save_raw` (frontmatter: `source: notion`, `source_id`,
   `source_url`, `source_last_edited: <last_edited_time>`, `fetched_at`, `title`).
6. Run **INGEST** on the new raw file, then process discovered links
   (see **Link-following**).

### GitHub sub-flow

1. Parse `owner` / `repo` / `path` (and optional `ref`) from the URL.
2. `github_get_file_contents` `{ owner, repo, path }` → capture content and `sha`.
3. `github_list_commits` `{ owner, repo, path }` → newest commit's
   `commit.committer.date` (fallback `commit.author.date`) is the real
   last-update timestamp.
4. **Discover links** (for the recursive crawl) — parse the fetched
   markdown/source for: relative repo paths (`./docs/x.md`, `../lib/y.md`),
   absolute `github.com/<owner>/<repo>/blob/<ref>/<path>` URLs, and other in-repo
   references. Resolve relative paths against the source file's directory into
   `{ owner, repo, path }` (carry `ref`/branch if present) and queue each for
   `github_get_file_contents`. **External non-GitHub URLs**: record them as
   references in the page, but do NOT crawl them (out of proxy scope).
5. Save with `wiki_save_raw` (frontmatter: `source: github`, `source_url`,
   `source_last_edited: <commit date>`, `source_sha: <sha>`, `fetched_at`,
   `title`).
6. Run **INGEST** on the new raw file, then process discovered links
   (see **Link-following**).

### Link-following (recursive crawl — "fetch linked docs")

After the root document is fetched and ingested, follow its discovered links so
the wiki graph compounds.

1. **For EACH linked document, run the full per-source pipeline above**: fetch
   live metadata → **Change-detection** (skip if unchanged; else new `raw/`
   + INGEST) → `wiki_save_raw` with real metadata frontmatter → INGEST into a
   `wiki/` page → **cross-link bidirectionally**: add `[[ChildPage]]` to the
   parent's `## Related` and `[[ParentPage]]` to the child's `## Related`.
2. **Crawl controls** (track and respect these):
   - **Depth limit** — default **max depth = 3** (root = depth 0). Override per
     request: `fetch notion <url> depth=5`. `fetch … no-follow` disables link
     following entirely.
   - **Deduplication** — before fetching a target, check whether it's already
     captured: `wiki_list_files` (`collection: "raw"`) + `wiki_read_file` to
     compare the target's `source_id` / `source_url` against existing
     frontmatter. If already present and unchanged, **skip re-fetch** and just
     ensure the `[[WikiLink]]` cross-reference exists. Track visited IDs/paths
     within the run to avoid cycles.
   - **Scope guard** — stay within the **same Notion workspace** / **same GitHub
     repo** by default; do not crawl unrelated external repos or arbitrary web
     URLs.
   - **Breadth guard** — a deep tree can produce many files. If the crawl will
     touch more than ~10 documents, surface a short plan/count to the user and
     confirm before mass-ingesting (`--fast` / `no-follow` skips this).

Log with `wiki_append_log` — `heading`:
`fetch+ingest | <Root Title> (+N linked)`; `body`: the crawled sources
(`notion:<id>` or `github:<owner>/<repo>/<path>`) with depth and detected change
(`new | updated | up-to-date | skipped-duplicate`).

Report the crawl as a tree (parent → children), listing created/updated `raw/`
and `wiki/` paths and which targets were skipped — format per **Output
formatting → FETCH crawl report**.

---

## Operation: INGEST

Trigger: a `raw/` path, pasted content to save as raw, or `ingest <source>`.
FETCH hands off here after saving raw.

1. **Read source** — `wiki_read_file` on the `raw/` file. If content came only
   from chat, first `wiki_save_raw` to a `raw/` filename (see Conventions) before
   continuing.
2. **Discuss** (skip if `--fast` / `ingest fast`) — surface 3–5 key takeaways and
   wait for the user.
3. **Find related pages** — `wiki_retrieve` with 2–3 topic queries to see what
   already exists.
4. **Write the summary page** — `wiki_write_file` → `wiki/<SourceTitle>.md`:

   ```markdown
   # <Title>

   **Source:** <source_url / notion id / github path> | **Date ingested:** <YYYY-MM-DD>

   ## Summary
   <2–4 paragraph synthesis>

   ## Key Claims
   - <specific, falsifiable bullet>

   ## Contradictions / Open Questions
   > <conflicts or uncertain claims>

   ## Related
   - [[PageName]] — <why related>
   ```

5. **Propagate cross-references to genuinely affected pages** — for each existing
   page that the new material relates to or updates, `wiki_read_file` it, then
   `wiki_write_file` (`overwrite`) to add the `[[<SourceTitle>]]` back-link and
   reconcile any changed claims. Update **all pages the source actually touches**
   — usually a handful, occasionally more — but **do not invent links to
   unrelated pages** or pad the count. Relevance, not volume, is the goal.
6. **Update `wiki/_index.md`** — `wiki_read_file` → edit → `wiki_write_file`. Add
   or refresh a one-line catalog entry per new/changed page (see Conventions for
   the entry format).
7. **Re-index** — `wiki_setup_index` with `embed: true` (`embed: false` on the
   fast path).
8. **Log** — `wiki_append_log`, `heading`: `ingest | <Source Title>`, `body`:
   `Pages touched: …` / `Key additions: …` / `[re-index: done | pending]`.
9. **Report** — list created/updated paths and index status, formatted per
   **Output formatting → INGEST report**.

---

## Operation: QUERY

Trigger: `query wiki <question>` or any question about wiki content.

1. **Retrieve first** — run `wiki_retrieve` to surface candidate pages before
   reading anything. Keep `include_index: true` so the `_index.md` catalog guides
   you (for broad/unfamiliar questions, optionally `wiki_read_file` on
   `wiki/_index.md` up front to scan the full catalog). For multi-part or
   comparison questions, run 2–3 targeted passes (one per sub-topic/entity)
   instead of one broad query. Tune the knobs to result quality: sparse /
   low-relevance → raise `limit`, lower `min_score`; too noisy → tighten `limit`,
   raise `min_score`, or set `collection: "wiki"` to focus on synthesized pages.
2. **Walk the wiki graph (llm-wiki / Karpathy pattern)** — for the candidate
   pages, `wiki_read_file` the most relevant `wiki/` pages **in full** (retrieval
   only returns excerpts), and follow their `[[WikiLink]]` references one level
   out to neighbor pages that bear on the question (`expand_links: true` brings
   these in automatically). The synthesized `wiki/` pages are your primary
   grounding.
3. **Verify against `raw/` when accuracy demands it** — `wiki/` pages are
   LLM-written summaries, so they can compress, drift, or omit specifics. Before
   answering, decide whether the question needs ground-truth precision: exact
   figures / quotes / config values, a claim under the page's
   `## Contradictions / Open Questions`, anything contested or low-confidence, or
   any case where being wrong is costly. If so, open the underlying immutable
   snapshot(s) — the `raw/…` path from the page's **Source** line / frontmatter —
   with `wiki_read_file` and reconcile the wiki claim against the source. For
   casual or overview questions where the synthesized page is clearly sufficient,
   skip this and don't over-fetch.
4. **Synthesize with grounded citations** — answer **only** from what you
   retrieved and read, cite `([[PageName]])` for every claim (note when a fact was
   confirmed against `raw/`), and explicitly flag any gap or low-confidence area.
   Never fabricate to fill a gap. Format per **Output formatting → QUERY**.
5. **File back** (optional but how the wiki compounds) — `wiki_write_file` →
   `wiki/<QueryTitle>.md`, then update `_index.md`.
6. **Log** — `wiki_append_log`, `heading`: `query | <summary>`, `body`:
   `Answer filed: …` / `Retrieval: wiki_retrieve (<N> passes)` / `Verified vs raw: <yes/no>`.

---

## Operation: LINT / SYNC

Trigger: `lint wiki`, `sync`, `refresh`, `health check`, `audit wiki`.

Run these checks, then print a report and log it.

1. **Contradictions** — `wiki_retrieve` with conflicting-claim queries.
2. **Orphan pages** — `wiki_list_files` (`collection: "wiki"`) + `wiki_read_file`
   to build the link graph; flag pages nothing links *to*.
3. **Broken links** — `[[WikiLink]]` targets with no matching file in
   `wiki_list_files`.
4. **Missing cross-references** — a concept that already has its own `wiki/` page
   but is mentioned in other pages **without** a `[[PageName]]` link. (Distinct
   from orphans, which find pages nothing links *to*, and broken links, which
   find links pointing *to* nothing.)
5. **Gaps** — concepts appearing in 3+ pages with no dedicated page.
6. **Index completeness** — every `wiki/*.md` (except `log.md`) is listed in
   `_index.md`.
7. **Stale sources (upstream changed)** — for each `raw/` file
   (`wiki_list_files` `collection: "raw"` + `wiki_read_file` frontmatter),
   re-fetch live metadata (Notion `last_edited_time`, or GitHub newest commit
   date + `sha`) and compare with stored `source_last_edited` / `source_sha`.
   Flag any source whose upstream is newer than the snapshot as **stale** and
   suggest a re-FETCH.
8. **Outdated claims (newer ingest supersedes)** — a different failure mode from
   #7: here the upstream has NOT changed, but a claim in a `wiki/` page is
   contradicted or superseded by a **more recently ingested** `raw/` source.
   Compare wiki claims against the newest relevant `raw/` snapshots (by
   `fetched_at`) and flag the affected page for revision. (#7 = the external
   source moved; #8 = an internal wiki claim is outdated relative to newer
   ingested material.)

**Output** — print the lint report in chat (format per **Output formatting →
LINT report**), then `wiki_append_log`, `heading`:
`lint`, `body`: `Issues found: …` / `Stale sources: …` / `Fixed: …`.

---

## Output formatting

How you present results to the human matters. Claude Code renders markdown in a
terminal, so favor **terminal-friendly markdown**: result first, bookkeeping
after; compact and scannable; no walls of text. Never paste raw tool output —
always synthesize. Avoid wide tables (they wrap badly); prefer trees and tight
bullets. Keep lines ~80 chars.

Shared conventions across all reports:
- `[[WikiLink]]` for pages, `raw/…` / `wiki/…` for paths.
- Status tags as plain text: `[new]`, `[updated]`, `[up-to-date]`, `[skip]`
  (plain text reads cleanly regardless of terminal font; swap for emoji only if
  the team prefers it).
- In change lists, `+` = created, `~` = updated.

### QUERY output

Lead with the answer in prose, each claim cited inline. Pack sources on one line.
Show `Gaps:` only when retrieval actually missed something. For a one-line
answer, skip the template entirely — just answer plus a `Sources:` line.

```
<answer, 1–3 short paragraphs, every claim cited ([[PageA]])>

Sources: [[PageA]], [[PageB]], [[PageC]]
Gaps: retrieval missed "<topic>" — no dedicated page yet
```

### INGEST report

```
Ingested: <Title>

Summary: <one sentence — what it is>
Pages
  + wiki/<NewPage>.md        (created)
  ~ wiki/<Existing>.md       (back-link + <what changed>)
  ~ wiki/_index.md           (catalog entry)
Index: re-index done (embed)
```

### FETCH crawl report (tree)

```
Fetched: <Root Title>  (depth 0)
└─ [new]        <Root>        raw/notion-<Root>.md → wiki/<Root>.md
   ├─ [updated]     <Child A>  raw/notion-<ChildA>.md → wiki/<ChildA>.md
   ├─ [up-to-date]  <Child B>  (re-ingest skipped)
   └─ [skip]        <Child C>  (already captured, meta unchanged)

Total: 2 raw / 2 wiki created-or-updated · 2 skipped · re-index done
```

### LINT report

Group findings by check, show a count per group, list items tersely, and close
with a `Clean:` line naming the checks that passed.

```
Lint report

Contradictions (1)
  • [[PageA]] vs [[PageB]] — <conflict in one phrase>
Broken links (2)
  • [[GhostPage]] referenced in [[PageA]], [[PageC]]
Stale sources (1)
  • raw/github-<Spec>.md — upstream commit newer than snapshot → re-fetch
Gaps (1)
  • "<concept>" appears in 4 pages, no dedicated page

Clean: orphans · missing-xref · index completeness
```

---

## Conventions

- **`raw/` filenames** — `raw/<source>-<Title-Slug>.md`, where `<source>` is
  `notion` or `github` and `<Title-Slug>` is the title in TitleCase-Hyphenated
  form (e.g. `raw/notion-GGJ-Infrastructure.md`). No date in the filename — the
  real dates live in the frontmatter (`fetched_at`, `source_last_edited`).
  **`raw/` is immutable** and `wiki_save_raw` fails if the path exists, so never
  overwrite: when a changed source needs a new snapshot, append a version suffix
  `-2`, `-3`, etc. (e.g. `raw/notion-GGJ-Infrastructure-2.md`). The **latest**
  snapshot for a source is the matching file with the newest `fetched_at` in its
  frontmatter, not the highest suffix.
- **`wiki/` page filenames** — TitleCase, hyphenated:
  `wiki/GGJ-Infrastructure.md`.
- **WikiLinks** — `[[PageName]]` → `wiki/PageName.md`.
- **Claims** — write them specific and falsifiable.
- **`_index.md` entries** — one line per page:
  `- [[PageName]] — <one-line summary> (ingested YYYY-MM-DD, source: <notion|github|…>)`.
- **`log.md` entries** — `wiki_append_log` emits `## [YYYY-MM-DD] <heading>`, so
  pass `heading` as `<op> | <Title>` where `op ∈ ingest | query | lint | fetch`.
  Keep `body` lines short and grep-friendly.
- **Prefer updating existing wiki pages** over creating near-duplicates.
- **MCP-only** — all I/O through `mcp__wiki-mcp__*`. No local file reads/writes,
  no local grep, no inspecting the working directory or any on-disk folder.