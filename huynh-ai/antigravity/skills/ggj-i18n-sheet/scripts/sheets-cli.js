#!/usr/bin/env node
/**
 * Append-only Google Sheets helper for GGJ i18n.
 * Run from the application repo root so `googleapis` and i18n.config resolve.
 *
 * Commands: auth-check | resolve | headers | append | existing-keys
 */
'use strict'

const fs = require('fs')
const path = require('path')
const readline = require('readline')

function parseArgs(argv) {
  const args = { _: [] }
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i]
    if (a.startsWith('--')) {
      const key = a.slice(2)
      const next = argv[i + 1]
      if (!next || next.startsWith('--')) {
        args[key] = true
      } else {
        args[key] = next
        i++
      }
    } else {
      args._.push(a)
    }
  }
  return args
}

function loadConfig(configPath) {
  const abs = path.resolve(configPath || './i18n.config.js')
  if (!fs.existsSync(abs)) {
    throw new Error(`i18n config not found: ${abs}`)
  }
  // eslint-disable-next-line import/no-dynamic-require, global-require
  return { config: require(abs), configPath: abs, root: path.dirname(abs) }
}

function resolveFromRoot(root, p) {
  return path.isAbsolute(p) ? p : path.resolve(root, p)
}

function loadGoogle() {
  try {
    // Prefer app node_modules
    return require(require.resolve('googleapis', { paths: [process.cwd(), __dirname] }))
  } catch (e) {
    throw new Error(
      'Cannot require googleapis. Run this CLI from the app repo root (npm install / @ggj/build-i18n present).',
    )
  }
}

const SHEETS_SCOPES = [
  'https://www.googleapis.com/auth/drive',
  'https://www.googleapis.com/auth/spreadsheets',
]

async function authorize({ config, root }, { force = false } = {}) {
  const { google } = loadGoogle()
  const credPath = resolveFromRoot(root, config.CREDENTIAL_PATH)
  const tokenPath = resolveFromRoot(root, config.TOKEN_PATH)
  if (!fs.existsSync(credPath)) {
    throw new Error(`Missing credentials: ${credPath}`)
  }
  const credentials = JSON.parse(fs.readFileSync(credPath, 'utf8'))
  const { client_secret, client_id, redirect_uris } = credentials.installed
  const oAuth2Client = new google.auth.OAuth2(
    client_id,
    client_secret,
    redirect_uris[0],
  )

  if (!force && fs.existsSync(tokenPath)) {
    oAuth2Client.setCredentials(JSON.parse(fs.readFileSync(tokenPath, 'utf8')))
    return { auth: oAuth2Client, google, tokenPath }
  }

  const authUrl = oAuth2Client.generateAuthUrl({
    access_type: 'offline',
    scope: SHEETS_SCOPES,
    prompt: 'consent',
  })
  console.error('Authorize this app by visiting this url:\n', authUrl)
  const code = await question('Enter the code from that page here: ')
  const { tokens } = await oAuth2Client.getToken(code)
  oAuth2Client.setCredentials(tokens)
  fs.writeFileSync(tokenPath, JSON.stringify(tokens, null, 2))
  console.error('Token stored to', tokenPath)
  return { auth: oAuth2Client, google, tokenPath }
}

function question(prompt) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stderr })
  return new Promise((resolve) => {
    rl.question(prompt, (answer) => {
      rl.close()
      resolve(answer.trim())
    })
  })
}

function parseSpreadsheetUrl(url) {
  if (!url) return null
  const idMatch = String(url).match(/\/spreadsheets\/d\/([a-zA-Z0-9-_]+)/)
  if (!idMatch) return null
  const gidMatch = String(url).match(/[?&#]gid=(\d+)/)
  return {
    spreadsheetId: idMatch[1],
    gid: gidMatch ? Number(gidMatch[1]) : null,
  }
}

async function getSpreadsheetMeta(sheets, spreadsheetId) {
  const res = await sheets.spreadsheets.get({
    spreadsheetId,
    fields: 'spreadsheetId,properties.title,sheets.properties',
  })
  return res.data
}

function tabFromMeta(meta, { tab, gid }) {
  const list = meta.sheets || []
  if (gid != null && gid !== '') {
    const hit = list.find((s) => s.properties.sheetId === Number(gid))
    if (!hit) throw new Error(`No sheet with gid=${gid}`)
    return hit.properties.title
  }
  if (tab) {
    const hit = list.find((s) => s.properties.title === tab)
    if (!hit) {
      const names = list.map((s) => s.properties.title).join(', ')
      throw new Error(`Tab "${tab}" not found. Available: ${names}`)
    }
    return tab
  }
  throw new Error('Provide --tab or gid in --url')
}

async function findWorkbookInFolder(drive, folderId, workbook) {
  const name = workbook.replace(/\.xlsx$/i, '')
  const res = await drive.files.list({
    q: `'${folderId}' in parents and mimeType = 'application/vnd.google-apps.spreadsheet' and trashed=false`,
    fields: 'files(id, name)',
    pageSize: 100,
  })
  const files = res.data.files || []
  const hit =
    files.find((f) => f.name === name) ||
    files.find((f) => f.name === `${name}.xlsx`) ||
    files.find((f) => f.name.toLowerCase() === name.toLowerCase())
  if (!hit) {
    throw new Error(
      `Workbook "${name}" not found in staging folder ${folderId}. Found: ${files
        .map((f) => f.name)
        .join(', ')}`,
    )
  }
  return hit
}

async function readHeaderRow(sheets, spreadsheetId, tab) {
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId,
    range: `'${tab.replace(/'/g, "''")}'!1:1`,
  })
  const row = (res.data.values && res.data.values[0]) || []
  return row.map((c) => String(c || '').trim())
}

async function readIndexColumn(sheets, spreadsheetId, tab) {
  const res = await sheets.spreadsheets.values.get({
    spreadsheetId,
    range: `'${tab.replace(/'/g, "''")}'!A:A`,
  })
  const values = res.data.values || []
  return values
    .slice(1)
    .map((r) => (r[0] != null ? String(r[0]).trim() : ''))
    .filter(Boolean)
}

function rowObjectToArray(headers, obj) {
  return headers.map((h) => {
    if (!h) return ''
    if (h === 'index') return obj.index != null ? String(obj.index) : ''
    if (Object.prototype.hasOwnProperty.call(obj, h)) {
      return obj[h] == null ? '' : String(obj[h])
    }
    return ''
  })
}

async function cmdAuthCheck(args) {
  const loaded = loadConfig(args.config)
  const { auth, google } = await authorize(loaded, { force: !!args.force })
  const drive = google.drive({ version: 'v3', auth })
  await drive.files.get({
    fileId: loaded.config.STAGING_FOLDER,
    fields: 'id, name',
  })
  console.log(
    JSON.stringify(
      {
        ok: true,
        stagingFolder: loaded.config.STAGING_FOLDER,
        langSupport: loaded.config.LANG_SUPPORT,
        tokenPath: resolveFromRoot(loaded.root, loaded.config.TOKEN_PATH),
      },
      null,
      2,
    ),
  )
}

async function cmdResolve(args) {
  const loaded = loadConfig(args.config)
  const { auth, google } = await authorize(loaded)
  const drive = google.drive({ version: 'v3', auth })
  const sheets = google.sheets({ version: 'v4', auth })

  let spreadsheetId = args['spreadsheet-id']
  let gid = args.gid != null ? Number(args.gid) : null
  let tab = args.tab || null

  const fromUrl = parseSpreadsheetUrl(args.url)
  if (fromUrl) {
    spreadsheetId = fromUrl.spreadsheetId
    if (fromUrl.gid != null) gid = fromUrl.gid
  }

  if (!spreadsheetId) {
    if (!args.workbook) {
      throw new Error('Need --url, --spreadsheet-id, or --workbook')
    }
    const file = await findWorkbookInFolder(
      drive,
      loaded.config.STAGING_FOLDER,
      args.workbook,
    )
    spreadsheetId = file.id
  }

  const meta = await getSpreadsheetMeta(sheets, spreadsheetId)
  if (!tab && gid == null) {
    // list tabs only
    console.log(
      JSON.stringify(
        {
          spreadsheetId,
          title: meta.properties.title,
          tabs: (meta.sheets || []).map((s) => ({
            title: s.properties.title,
            sheetId: s.properties.sheetId,
          })),
        },
        null,
        2,
      ),
    )
    return
  }

  const tabTitle = tabFromMeta(meta, { tab, gid })
  const url = `https://docs.google.com/spreadsheets/d/${spreadsheetId}/edit#gid=${
    (meta.sheets || []).find((s) => s.properties.title === tabTitle).properties
      .sheetId
  }`
  console.log(
    JSON.stringify(
      {
        spreadsheetId,
        workbookTitle: meta.properties.title,
        tab: tabTitle,
        url,
      },
      null,
      2,
    ),
  )
}

async function cmdHeaders(args) {
  const loaded = loadConfig(args.config)
  const { auth, google } = await authorize(loaded)
  const sheets = google.sheets({ version: 'v4', auth })
  if (!args['spreadsheet-id'] || !args.tab) {
    throw new Error('--spreadsheet-id and --tab required')
  }
  const headers = await readHeaderRow(sheets, args['spreadsheet-id'], args.tab)
  const langs = String(loaded.config.LANG_SUPPORT || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean)
  const missing = langs.filter((l) => !headers.includes(l))
  console.log(
    JSON.stringify(
      {
        headers,
        langSupport: langs,
        missingLangColumns: missing,
        indexColumn: headers[0] || null,
      },
      null,
      2,
    ),
  )
}

async function cmdExistingKeys(args) {
  const loaded = loadConfig(args.config)
  const { auth, google } = await authorize(loaded)
  const sheets = google.sheets({ version: 'v4', auth })
  if (!args['spreadsheet-id'] || !args.tab) {
    throw new Error('--spreadsheet-id and --tab required')
  }
  const keys = await readIndexColumn(sheets, args['spreadsheet-id'], args.tab)
  console.log(JSON.stringify({ count: keys.length, keys }, null, 2))
}

async function cmdAppend(args) {
  const loaded = loadConfig(args.config)
  const { auth, google } = await authorize(loaded)
  const sheets = google.sheets({ version: 'v4', auth })
  if (!args['spreadsheet-id'] || !args.tab || !args['rows-json']) {
    throw new Error('--spreadsheet-id, --tab, and --rows-json required')
  }
  if (args['dry-run']) {
    console.log(JSON.stringify({ dryRun: true, skippedWrite: true }, null, 2))
    return
  }

  const rowsPath = path.resolve(args['rows-json'])
  const rows = JSON.parse(fs.readFileSync(rowsPath, 'utf8'))
  if (!Array.isArray(rows) || rows.length === 0) {
    throw new Error('rows-json must be a non-empty array')
  }

  const headers = await readHeaderRow(sheets, args['spreadsheet-id'], args.tab)
  if (!headers.length || headers[0] !== 'index') {
    throw new Error(
      `Unexpected header row (expected first cell "index"): ${JSON.stringify(headers)}`,
    )
  }

  const existing = new Set(
    await readIndexColumn(sheets, args['spreadsheet-id'], args.tab),
  )
  for (const row of rows) {
    const key = String(row.index || '').trim()
    if (!key) throw new Error('Each row needs index')
    if (existing.has(key)) {
      throw new Error(
        `Refusing to append: key already exists: ${key}. Do not update existing rows.`,
      )
    }
  }

  const langs = String(loaded.config.LANG_SUPPORT || '')
    .split(',')
    .map((s) => s.trim())
    .filter(Boolean)
  for (const row of rows) {
    for (const lang of langs) {
      if (row[lang] == null || String(row[lang]).trim() === '') {
        throw new Error(`Missing translation for key=${row.index} lang=${lang}`)
      }
    }
  }

  const values = rows.map((r) => rowObjectToArray(headers, r))
  const range = `'${args.tab.replace(/'/g, "''")}'!A:A`
  const res = await sheets.spreadsheets.values.append({
    spreadsheetId: args['spreadsheet-id'],
    range,
    valueInputOption: 'USER_ENTERED',
    insertDataOption: 'INSERT_ROWS',
    requestBody: { values },
  })

  console.log(
    JSON.stringify(
      {
        ok: true,
        updatedRange: res.data.updates && res.data.updates.updatedRange,
        updatedRows: res.data.updates && res.data.updates.updatedRows,
        keys: rows.map((r) => r.index),
      },
      null,
      2,
    ),
  )
}

async function main() {
  const args = parseArgs(process.argv.slice(2))
  const cmd = args._[0]
  try {
    switch (cmd) {
      case 'auth-check':
        await cmdAuthCheck(args)
        break
      case 'resolve':
        await cmdResolve(args)
        break
      case 'headers':
        await cmdHeaders(args)
        break
      case 'existing-keys':
        await cmdExistingKeys(args)
        break
      case 'append':
        await cmdAppend(args)
        break
      default:
        console.error(`Usage: sheets-cli.js <auth-check|resolve|headers|existing-keys|append> [flags]
  --config ./i18n.config.js
  --url <spreadsheet url>
  --workbook desktop --tab sell-input
  --spreadsheet-id ID --tab NAME
  --rows-json ./rows.json
  --dry-run  (append only: skip write)
  --force    (auth-check: re-oauth)`)
        process.exit(cmd ? 1 : 0)
    }
  } catch (e) {
    console.error(String(e && e.stack ? e.stack : e))
    process.exit(1)
  }
}

main()
