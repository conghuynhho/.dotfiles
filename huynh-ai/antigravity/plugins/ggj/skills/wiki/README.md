# Wiki slash command

Hook block messages read **`## Usage`** and **`## Fetch usage`** below.
`{wiki-cmd}` is replaced at runtime (`/ggj:wiki` on Claude, `/ggj-wiki` on Cursor).
Maintainer docs: `packages/ggj-ai/README.md`.

## Usage

`{wiki-cmd} <action> [args...]`

- `query <question>` — e.g. `{wiki-cmd} query deploy pipeline?`
- `fetch <url>` — e.g. `{wiki-cmd} fetch notion https://notion.so/...`
- `ingest` — store pasted content
- `lint` / `sync` — audit or refresh wiki
- `add` — add new material

## Fetch usage

`{wiki-cmd} fetch <notion|github> <url>`
e.g. `{wiki-cmd} fetch github https://github.com/org/repo/blob/main/docs/spec.md`
