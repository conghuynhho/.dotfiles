# Shared wiki slash-command validation and hook message formatting.
# README.md is the single source of truth; this lib converts for Claude vs Cursor.

wiki_resolve_readme() {
  local script_dir="$1"
  local plugin_root="${CLAUDE_PLUGIN_ROOT:-${CURSOR_PLUGIN_ROOT:-}}"
  if [[ -n "$plugin_root" ]]; then
    echo "${plugin_root}/skills/wiki/README.md"
  else
    echo "${script_dir}/../README.md"
  fi
}

wiki_read_readme_section() {
  local readme="$1"
  local heading="$2"
  if [[ ! -f "$readme" ]]; then
    return 1
  fi
  awk -v h="$heading" '
    $0 == h { found = 1; next }
    found && /^## / { exit }
    found { print }
  ' "$readme" | sed -e '/./,$!d'
}

wiki_normalize_args() {
  local args="$1"
  args="${args#/llm }"
  args="${args#llm }"
  args="${args#/llm}"
  args="${args#llm}"
  echo "$args" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

wiki_cmd_for_target() {
  case "${1:-claude}" in
    cursor) echo '/ggj-wiki' ;;
    *) echo '/ggj:wiki' ;;
  esac
}

wiki_section_heading() {
  case "${1:-usage}" in
    fetch) echo '## Fetch usage' ;;
    *) echo '## Usage' ;;
  esac
}

# Claude: markdown from README. Cursor: plain text, blank line between items.
wiki_format_hook_message() {
  local text="$1"
  local cmd="$2"
  local target="${3:-claude}"
  local line out=""

  text="${text//\{wiki-cmd\}/$cmd}"

  if [[ "$target" == "claude" ]]; then
    printf '%s' "$text"
    return
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [[ -z "$line" ]] && continue
    line="$(echo "$line" | tr -d '`')"
    if [[ "$line" == -* ]]; then
      line="• ${line#- }"
    fi
    if [[ -n "$out" ]]; then
      out+=$'\n\n'
    fi
    out+="$line"
  done <<< "$text"

  printf '%s' "$out"
}

wiki_hook_message() {
  local readme="$1"
  local section="$2"
  local target="${3:-claude}"
  local cmd raw

  cmd="$(wiki_cmd_for_target "$target")"
  raw="$(wiki_read_readme_section "$readme" "$(wiki_section_heading "$section")" || true)"
  wiki_format_hook_message "$raw" "$cmd" "$target"
}

wiki_cursor_block_title() {
  local section="$1"
  case "$section" in
    fetch) echo '/ggj-wiki fetch — need notion|github and URL' ;;
    *) echo '/ggj-wiki — missing or invalid arguments' ;;
  esac
}

wiki_cursor_block_message() {
  local body="$1"
  local title="${2:-/ggj-wiki — missing or invalid arguments}"
  if [[ -z "$body" ]]; then
    body="See skills/wiki/README.md"
  fi
  printf '%s\n\n%s' "$title" "$body"
}

# Echoes "usage" or "fetch" when invalid; returns 0. Returns 1 when valid.
wiki_validate_wiki_args() {
  local args="$1"
  local action arg2

  args="$(wiki_normalize_args "$args")"

  if [[ -z "$args" ]]; then
    echo 'usage'
    return 0
  fi

  action="$(echo "$args" | awk '{print $1}')"

  case "$action" in
    query|fetch|ingest|lint|sync|audit|refresh|add)
      ;;
    *)
      echo 'usage'
      return 0
      ;;
  esac

  if [[ "$action" == "fetch" ]]; then
    arg2="$(echo "$args" | awk '{print $2}')"
    if [[ -z "$arg2" ]]; then
      echo 'fetch'
      return 0
    fi
  fi

  return 1
}

wiki_extract_args_from_prompt() {
  local prompt="$1"
  local first_line

  prompt="$(printf '%s' "$prompt" | sed 's/^[[:space:]]*//')"
  first_line="${prompt%%$'\n'*}"

  if [[ "$first_line" =~ ^/?(ggj[:-])?wiki([[:space:]]+(.*))?$ ]]; then
    printf '%s' "${BASH_REMATCH[3]:-}"
    return 0
  fi

  return 1
}
