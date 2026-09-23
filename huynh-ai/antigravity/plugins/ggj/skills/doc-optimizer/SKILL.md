---
name: doc-optimizer
description: Refactor and compress internal system documentation (tool/technical docs and business/spec docs) into fixed, minimal templates. Use whenever the user asks to "optimize this doc", "refactor document", "trim down this document", "standardize this doc", "clean up this doc/README/spec", or pastes/uploads a technical or business document and wants it restructured, shortened, or made easier to scan. Also trigger when the user is clearly building or maintaining an internal documentation system and asks Claude to rewrite, standardize, or condense pages for it. Applies to markdown, Word (.docx), Confluence-style pages, or plain pasted text.
---

# Doc Optimizer

Rewrites documents into one of two fixed, minimal templates so a reader can scan and get exactly what they need — nothing more. The core philosophy: **anything not in the template gets deleted or squeezed into one sentence.** This is a compression tool, not a summarization tool — the goal is a shorter, denser document that still contains every fact the template calls for.

## Step 1 — Classify the document

Before writing anything, decide which of the two types the input is:

- **Tool doc** — explains a tool, library, script, CLI, service, or internal utility. Reader's goal: "how do I set this up and use it."
- **Business doc** — explains a business feature/flow, spec, or API. Reader's goal: "what does this do, what's the contract, what do I need to watch out for."

If it's genuinely ambiguous (mixes both), ask the user which template to apply, or propose splitting into two documents — don't guess silently on a 50/50 case.

## Step 2 — Apply the matching template

Use the **exact section headers** below, in this exact order. Do not add extra top-level sections. Do not keep original headers that don't map to one of these.

### Template A — Tool doc

```markdown
# [Tool/Doc Name]

## Overview
[1–3 sentences: what this document/tool is, in plain terms]

## Setup
[Only what's needed to get it working: prerequisites, install steps, config/env vars.
Numbered steps or a short list. No prose padding.]

## Usage
[How to actually use it: commands, code snippets, typical flow.
This is the main section — the doc is "how to use"-oriented, so this can be the longest part.]

## Notes
[Only if there is something genuinely important: gotchas, limits, breaking behavior,
things that will bite the reader. If nothing qualifies, OMIT this section entirely —
do not write "no notes" or "nothing special".]

## Related docs
- [Link 1]
- [Link 2]
```

Rule of thumb for "Notes": if you removed it, would someone get burned in production? If not, it doesn't belong here.

### Template B — Business/spec doc

```markdown
# [Feature/Flow Name]

## Overview
[1–3 sentences: what this covers, in plain terms]

## Spec
[Core business logic/rules. Link to backlog ticket(s) / source spec doc(s) — always include the link if one exists in the source.]

## Workflow / Sequence
[Mermaid diagram(s) — flowchart for workflow, sequenceDiagram for sequence/interaction between systems.
If the source document only has prose describing a flow, convert it into a diagram rather than leaving it as paragraphs.]

## API
[Terse, no explanatory prose. One block per endpoint:]

**[METHOD] [/path]**
- Input: [query params / body fields — name: type, required?]
- Response: [type/shape, key fields only]

[Repeat per endpoint. No description of "what this endpoint does" unless the name is genuinely unclear — then one clause max.]

## Notes
[Only operationally important side effects: which DB table gets written, what values a
record gets set to at which step, ordering/timing constraints, idempotency concerns, etc.
Omit entirely if there's nothing like this.]
```

Everything else in the source (background context, meeting notes, author's reasoning, historical alternatives considered, changelog trivia, restated requirements already covered by the spec/API sections) either gets deleted, or — if it's important enough that deleting it would lose real information — gets compressed into a single sentence and folded into the closest relevant section. Never keep it as its own section.

## Step 3 — Language rule

If the source document (or parts of it) is written in Vietnamese, translate it into English as you rewrite it — the final output is always in English, regardless of the input language. This applies to prose, section content, and inline comments in text; do not translate code, commands, API field names/values, file paths, or literal identifiers — keep those verbatim even if they appear inside Vietnamese sentences.

## Step 4 — Compression rules (apply to both templates)

- **One idea, one sentence.** If a paragraph makes one point, it becomes one sentence.
- **Delete meta-narrative**: "as discussed in the meeting", "this was decided after debate", "note that this section was updated on...". None of this helps a reader trying to use the tool or understand the spec.
- **Prefer lists/tables over prose** wherever the source has 3+ parallel items.
- **Keep code/commands/API signatures verbatim** — never paraphrase exact syntax, field names, or types. Compression applies to explanatory prose, not to technical literals.
- **Don't invent content.** If setup steps, links, or diagrams aren't in the source and can't be reasonably inferred from it, leave that subsection minimal (e.g. a single line noting what's missing) rather than fabricating steps. Ask the user for the missing piece if it's a hard blocker (e.g., no API details at all in a business doc that clearly has an API).
- **Diagrams**: always render workflow/sequence info as Mermaid, even if the source only had prose or a screenshot description of a flow.

## Step 5 — Output

- If editing an existing file (.md/.docx), rewrite it in place following the template, preserving the original file format. For .docx, use the `docx` skill's editing workflow rather than hand-rolling XML.
- If given pasted text with no source file, output the rewritten markdown directly in the chat.
- After rewriting, briefly tell the user what was cut (one line, e.g. "Removed the changelog and meeting-notes section; compressed background into the Overview sentence") so they can catch anything that got dropped by mistake.