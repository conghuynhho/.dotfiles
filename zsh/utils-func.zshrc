
function ggob {
  local branch_name="$(git rev-parse --abbrev-ref HEAD)"
  # Extract all ticket patterns, e.g. OAM-XXXXX (A-Z chars, dash, digits)
  local tickets=($(echo "$branch_name" | grep -oE '[A-Z]+-[0-9]+'))

  echo "Backlog URLs:"
  for ticket in "${tickets[@]}"; do
    local url="https://gogojungle.backlog.jp/view/$ticket"
    echo -e "\033[32m$url\033[0m"
    open "$url"
  done
}
