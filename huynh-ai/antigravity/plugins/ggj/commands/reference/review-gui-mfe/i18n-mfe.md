# i18n — Mypage MFE

> Load when: new copy, namespaces, `I18nProvider`.

## Build

- Config: `modules/i18n/i18n.config.js`
- Tool: `@ggj/build-i18n` → `lang/**/*.json` (`FORMAT_TYPE: 'VUE'`)
- Locales: `ja, en, th, zh, tw, vi`; fallback `ja`
- Run: `yarn build:lang` (prestart)

## Runtime

```tsx
import I18nProvider from '@gogo/share-mfe/components/I18nProvider/i18n'
import * as reviewModal from '../../lang/components/review-modal.json'

export const nsTranReviewModal = 'components@review-modal'

const translationSources = {
  [nsTranReviewModal]: reviewModal,
}

// In mount tree:
<I18nProvider sources={translationSources} store={store} />
```

```tsx
// In component:
const { t } = useTranslation(nsTranReviewModal)
```

## Review checklist

| Tag | Check |
|-----|-------|
| agent | All user strings via `useTranslation` + namespace constant |
| agent | New strings: sheet config + `build:lang` + JSON import in expose |
| agent | Namespace constants exported in `const.ts` alongside feature |
| agent | `store.lang` (rxjs or string) passed to `I18nProvider` |
| human | Copy correct per locale on host language switch |

MFE i18n is **per-app** — not shared with host Vue i18n.
