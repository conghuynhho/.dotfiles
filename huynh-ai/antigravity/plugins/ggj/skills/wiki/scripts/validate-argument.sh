#!/bin/bash

# Validate /ggj:wiki (Claude UserPromptExpansion hook).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=wiki-args-lib.sh
source "${SCRIPT_DIR}/wiki-args-lib.sh"

README="$(wiki_resolve_readme "$SCRIPT_DIR")"
INPUT="$(cat)"
COMMAND_NAME="$(echo "$INPUT" | jq -r '.command_name // empty')"
ARGS="$(echo "$INPUT" | jq -r '.command_args // empty')"

is_wiki_command() {
  [[ "$1" == "wiki" || "$1" == "ggj:wiki" || "$1" == *:wiki ]]
}

block() {
  local reason="$1"
  jq -n --arg reason "$reason" '{decision: "block", reason: $reason, suppressOutput: true}'
  exit 0
}

if ! is_wiki_command "$COMMAND_NAME"; then
  exit 0
fi

if SECTION="$(wiki_validate_wiki_args "$ARGS")"; then
  block "$(wiki_hook_message "$README" "$SECTION" claude)"
fi

exit 0
