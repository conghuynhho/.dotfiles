---
name: ggj-wiki
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

# Wiki (Cursor entry point)

This is a thin Cursor-only wrapper so the `/` picker shows `/ggj-wiki`
(distinguishing it from other tools' plugins) without duplicating the real
instructions.

Only `name` differs from the canonical skill; keep `description` above in
sync with it by hand whenever that file changes.

**Read `../../skills/wiki/SKILL.md` in full now and follow it exactly** — that
file is the single source of truth for this skill's behavior (all operations,
routing, conventions).
