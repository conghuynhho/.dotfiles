autoload -U add-zsh-hook

load-nvmrc() {
  local current_node="$(nvm current | sed 's/^v//')"
  local dir="$PWD"
  local MAX_DEPTH=5
  local depth=0
  local found_nvmrc=""
  local found_package_json=""
  local package_json_node_version=""
  local nvmrc_node_version=""

  # 1. Traverse up to find closest .nvmrc or package.json with engines.node
  while [ $depth -lt $MAX_DEPTH ]; do
    if [ -z "$found_nvmrc" ] && [ -f "$dir/.nvmrc" ]; then
      found_nvmrc="$dir/.nvmrc"
    fi

    if [ -z "$found_package_json" ] && [ -f "$dir/package.json" ]; then
      package_json_node_version=$(jq -r '.engines.node // empty' "$dir/package.json")
      if [ -n "$package_json_node_version" ]; then
        found_package_json="$dir/package.json"
      fi
    fi

    # Stop early if both are found
    if [ -n "$found_nvmrc" ] && [ -n "$found_package_json" ]; then
      break
    fi

    dir="$(dirname "$dir")"
    ((depth++))
  done

  # 2. Use .nvmrc if found
  if [ -n "$found_nvmrc" ]; then
    nvmrc_node_version="$(<"$found_nvmrc")"
    local resolved_version="$(nvm version "$nvmrc_node_version" | sed 's/^v//')"

    if [ "$resolved_version" = "N/A" ]; then
      echo "🔧 Installing Node.js version from .nvmrc: $nvmrc_node_version"
      nvm install "$nvmrc_node_version"
    elif [ "$resolved_version" != "$current_node" ]; then
      echo "🔄 Switching to Node.js version from .nvmrc: $nvmrc_node_version"
      nvm use "$nvmrc_node_version"
    fi
    return
  fi

  # 3. Use package.json engines.node if found
  if [ -n "$found_package_json" ]; then
    local resolved_version="$(nvm version "$package_json_node_version" | sed 's/^v//')"
    if [ "$resolved_version" = "N/A" ]; then
      echo "📦 Installing Node.js version from package.json: $package_json_node_version"
      nvm install "$package_json_node_version"
    fi

    if [ "$resolved_version" != "$current_node" ]; then
      echo "📦 Switching to Node.js version from package.json: $package_json_node_version"
      nvm use "$package_json_node_version"
    fi
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
