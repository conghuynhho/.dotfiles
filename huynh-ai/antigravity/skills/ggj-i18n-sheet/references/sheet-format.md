# Sheet format (Vue / mypage)

## Workbooks in staging

From `i18n.config.js` `FILE_LIST_BK` / Drive staging folder, typical names:

- `common` → `common.xlsx` / spreadsheet titled `common`
- `desktop` → most mypage container strings
- `components_desktop` → shared components

Generated JSON: `{I18N_PATH}/{workbook}/{tab}.json`  
Example: `resources/assetsv1/i18n/lang/desktop/sell-input.json`

## Tab layout

- First tab is often **`map-index`** (metadata: which Vue file uses which tab). Do not append i18n value rows there.
- Translation tabs start at sheet index 1+ in `@ggj/build-i18n` (xlsx-populate).

### Header row (row 1)

Must include language codes as header cells. Build reads headers dynamically:

```
index | ja | en | th | zh | tw | vi | hk
```

Extra empty columns are fine. Language set comes from `LANG_SUPPORT` in config.

### Data rows (row 2+)

| Col | Meaning |
|-----|---------|
| A (`index`) | Key — numeric or short semantic (`add-currency`) |
| lang cols | Translation text; all langs required for build |
| J2 (`REF_CELL`) | Optional comma-separated common reference keys (row 2 only) |

Build stops at the first empty `index` cell.

### JSON shape (Vue)

```json
{
  "ja": { "1": "…", "add-currency": "…" },
  "en": { "1": "…", "add-currency": "…" }
}
```

Component usage:

```js
import i18n from '@/i18n/lang/desktop/sell-input.json'
export default {
  i18n: { messages: i18n },
  // …
  // this.$t('add-currency')
}
```

## Append safety

- Only append after the last filled `index` row.
- Do not clear ranges, do not rewrite JA for an existing key, do not delete rows.
- If JA text already exists under another key, reuse that key in code instead of appending.
