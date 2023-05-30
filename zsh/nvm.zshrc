autoload -U add-zsh-hook

load-nvmrc() {
  local node_version="$(nvm version | sed 's/v//')"
  local nvmrc_path="$(nvm_find_nvmrc)"
  local package_node_version=null
  local package_json_path="./package.json"
  # check package_json_path is exist
  if [ -f "$package_json_path" ]; then
    # get node version from package.json if not has node version jq return null
    package_node_version=$(cat "$package_json_path" | jq -r '.engines.node')
  fi

  # check nvmrc_path is exist
  if [ -n "$nvmrc_path" ]; then
    local node_version_nvmrc=$(cat "${nvmrc_path}")
    local nvmrc_node_version=$(nvm version "$node_version_nvmrc" | sed 's/v//')

    if [ "$nvmrc_node_version" = "N/A" ]; then
      echo "${WARNING}Warning:${NC} Target node version is not installed. Installing ${BLUE}$node_version_nvmrc${NC}...}"
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      echo "${BLUE}Switching${NC} to node version in ${YELLOW}nvmrc${NC}: ${SUCCESS}$nvmrc_node_version${NC}"
      nvm use
    fi
  elif [ "$package_node_version" != null ] && [ "$package_node_version" != "$node_version" ]; then
    # echo "🚀 ~ file: nvm.zshrc:27 ~ package_node_version: $package_node_version"
    # echo "🚀 ~ file: nvm.zshrc:27 ~ node_version: $node_version"
    echo "${BLUE}Switching${NC} to Node.js version specified in ${YELLOW}package.json${NC}: ${SUCCESS}$package_node_version${NC}"
    nvm use "$package_node_version"
  # elif [ "$node_version" != "$(nvm version default)" ]; then
  #   echo "Reverting to nvm default version"
  #   nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

