---
name: backlog
description: >
  Interact with GGJungle Backlog (issues, projects, wiki, git PRs) via wiki-mcp
  proxy tools named mcp__wiki-mcp__backlog_*.
---

# Backlog (via wiki-mcp)

Use **only** `mcp__wiki-mcp__backlog_*` tools exposed by the team `wiki-mcp` server.
There is no local Backlog fallback.

## Common tools

| Tool | Use |
|------|-----|
| `mcp__wiki-mcp__backlog_get_myself` | Verify Backlog auth |
| `mcp__wiki-mcp__backlog_get_project_list` | List projects |
| `mcp__wiki-mcp__backlog_get_issue` | Fetch one issue by key |
| `mcp__wiki-mcp__backlog_get_issues` | Search/list issues |
| `mcp__wiki-mcp__backlog_add_issue` | Create issue |
| `mcp__wiki-mcp__backlog_update_issue` | Update issue |
| `mcp__wiki-mcp__backlog_add_issue_comment` | Comment on issue |
| `mcp__wiki-mcp__backlog_get_pull_requests` | List PRs in a repo |
| `mcp__wiki-mcp__backlog_get_wiki` | Read Backlog wiki page |

## Workflow tips

1. Call `backlog_get_myself` first if tools fail — server may be missing API key.
2. Use project key (e.g. `GGJ`) from `backlog_get_project_list` before creating issues.
3. For issue search, prefer `backlog_get_issues` with filters over guessing issue keys.

## Space

- Domain: `gogojungle.backlog.jp`
- Issue URLs: `https://gogojungle.backlog.jp/view/<issue-key>`
