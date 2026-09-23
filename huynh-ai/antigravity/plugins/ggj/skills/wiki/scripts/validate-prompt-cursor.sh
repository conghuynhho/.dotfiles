#!/bin/bash

# Validate /ggj-wiki (Cursor beforeSubmitPrompt hook).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=wiki-args-lib.sh
source "${SCRIPT_DIR}/wiki-args-lib.sh"

README="$(wiki_resolve_readme "$SCRIPT_DIR")"
INPUT="$(cat)"
PROMPT="$(echo "$INPUT" | jq -r '.prompt // empty')"

allow() {
  jq -cn '{continue: true}'
  exit 0
}

block() {
  local message="$1"
  jq -cn --arg msg "$message" '{continue: false, user_message: $msg}'
  exit 0
}

if [[ -z "$PROMPT" ]]; then
  allow
fi

if ! ARGS="$(wiki_extract_args_from_prompt "$PROMPT")"; then
  allow
fi

if SECTION="$(wiki_validate_wiki_args "$ARGS")"; then
  BODY="$(wiki_hook_message "$README" "$SECTION" cursor)"
  block "$(wiki_cursor_block_message "$BODY" "$(wiki_cursor_block_title "$SECTION")")"
fi

allow
