# Auth + sheets-cli

## Credentials (repo)

From `i18n.config.js`:

| Config | Typical path |
|--------|----------------|
| `CREDENTIAL_PATH` | `./build/lang/credentials.json` |
| `TOKEN_PATH` | `./build/lang/token.json` |

OAuth client shape: `credentials.installed` with `client_id`, `client_secret`, `redirect_uris`.

Existing tokens from `@ggj/build-i18n` usually include Drive scopes. The CLI also requests the Spreadsheets scope when refreshing. If append returns 403, user must delete `token.json` and re-auth via `npm run build:lang:staging` or `sheets-cli.js auth-check --force`.

## CLI

Run from **application repo root** (where `i18n.config.js` lives).

Skill path example: `~/.agents/skills/ggj-i18n-sheet` (also symlinked at `~/.claude/skills/ggj-i18n-sheet`).

```bash
SKILL=~/.agents/skills/ggj-i18n-sheet

node $SKILL/scripts/sheets-cli.js auth-check --config ./i18n.config.js

node $SKILL/scripts/sheets-cli.js resolve \
  --config ./i18n.config.js \
  --url 'https://docs.google.com/spreadsheets/d/ID/edit?gid=123'

node $SKILL/scripts/sheets-cli.js resolve \
  --config ./i18n.config.js \
  --workbook desktop --tab sell-input

node $SKILL/scripts/sheets-cli.js headers \
  --config ./i18n.config.js \
  --spreadsheet-id ID --tab sell-input

node $SKILL/scripts/sheets-cli.js append \
  --config ./i18n.config.js \
  --spreadsheet-id ID \
  --tab sell-input \
  --rows-json ./i18n-append-rows.json
```

### rows-json

```json
[
  {
    "index": "try-again",
    "ja": "再度お試し下さい。",
    "en": "Please try again.",
    "th": "...",
    "zh": "...",
    "tw": "...",
    "vi": "...",
    "hk": "..."
  }
]
```

Append uses `spreadsheets.values.append` with `valueInputOption=USER_ENTERED` and `insertDataOption=INSERT_ROWS`. It never calls update/clear on existing ranges.

### Dependencies

Script requires `googleapis` resolvable from the repo (`node_modules` of the app that already depends on `@ggj/build-i18n`). Run with cwd = repo root so `require('googleapis')` resolves.
