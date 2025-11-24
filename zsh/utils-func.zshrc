
function ggob {
  local branch_name="$(git rev-parse --abbrev-ref HEAD)"
  local tickets
  tickets=($(echo "$branch_name" | grep -oE '[A-Z]+-[0-9]+'))

  local idx=0
  for ticket in "${tickets[@]}"; do
    local url="https://gogojungle.backlog.jp/view/$ticket"
    if [ $idx -eq 0 ]; then
      echo -e "\033[32mMain Task: $url\033[0m"
    else
      echo -e "\033[32mChild Task: $url\033[0m"
    fi
    open "$url"
    idx=$((idx + 1))
  done
}
