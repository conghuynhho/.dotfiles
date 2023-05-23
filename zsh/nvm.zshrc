autoload -U add-zsh-hook

load-nvmrc() {
  local node_version="$(nvm version)"
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
    local nvmrc_node_version=$(nvm version "$node_version_nvmrc")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      echo "Target node version is not installed. Installing $node_version_nvmrc"
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      echo "Switching to node version in nvmrc: $nvmrc_node_version"
      nvm use
    fi
  elif [ "$package_node_version" != null ] && [ "$package_node_version" != "$node_version" ]; then
    echo "Switching to Node.js version specified in package.json: $package_node_version"
    nvm use "$package_node_version"
  # elif [ "$node_version" != "$(nvm version default)" ]; then
  #   echo "Reverting to nvm default version"
  #   nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

