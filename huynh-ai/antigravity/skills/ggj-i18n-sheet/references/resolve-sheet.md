# Resolving spreadsheet + tab

## Pattern A — URL comment in source

Many containers start with:

```js
// https://docs.google.com/spreadsheets/d/1RmxByjWDvLzWrXJu_-hsuS21i2QCM3ey5GWhd_51t0U/edit?gid=1179788553#gid=1179788553
import i18n from '@/i18n/lang/desktop/sell-input.json'
```

Extract:

- `spreadsheetId` = path segment after `/d/`
- `gid` = `gid` query/hash (numeric sheet id)

Resolve `gid` → tab title via Spreadsheets API `spreadsheets.get` → `sheets[].properties.sheetId` / `title`.

## Pattern B — import path

`@/i18n/lang/<workbook>/<tab>.json`

- workbook namespace = folder name (`desktop`, `common`, `components_desktop`)
- tab = file basename without `.json`

Find the Drive file under `STAGING_FOLDER` whose **name** equals the workbook (with or without `.xlsx` — Drive spreadsheet name is usually without extension).

## Pattern C — staging folder listing

```
STAGING_FOLDER from i18n.config.js
→ drive.files.list parents=STAGING_FOLDER mimeType=spreadsheet
→ match name === workbook
```

`SHARED_SHEETS` IDs are extra workbooks not in the folder — match by ID if the tab lives there.

## Pattern D — map-index

Local `localization/<workbook>.xlsx` sheet `map-index` column "Use" maps tab → Vue path. Useful when the user names a Vue file but not the tab.

## Ambiguity

If a file has no comment and no lang import, ask which workbook/tab. Do not guess production sheet IDs from README bank-transfer notes.
