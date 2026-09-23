---
name: ggj-code-review
description: Reviews changed code in a pull request or working tree and reports findings grouped by severity. Use whenever the user asks to review code, get PR or pull-request feedback, check code quality, find bugs or security issues, do a security review.
---

# Code Review (Cursor entry point)

This is a thin Cursor-only wrapper so the `/` picker shows `/ggj-code-review`
(distinguishing it from other tools' plugins) without duplicating the real
instructions.

Only `name` differs from the canonical skill (the `argument-hint` /
`arguments` / `allowed-tools` fields on the Claude version aren't part of
Cursor's skill frontmatter, so they're dropped here). Keep `description` above
in sync by hand whenever that file changes.

**Read `../../skills/code-review/SKILL.md` in full now and follow it
exactly** — that file is the single source of truth for this skill's
behavior.
