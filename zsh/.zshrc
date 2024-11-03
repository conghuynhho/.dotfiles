##### Default zsh oh-my-posh and p10k
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_Plugins
plugins=(git copypath zsh-syntax-highlighting zsh-autosuggestions vi-mode)
source $ZSH/oh-my-zsh.sh
eval "$(zoxide init --cmd cd zsh)"

HISTFILE=~/.zsh_history
######## ZSH configuration
HISTSIZE=100000000
SAVEHIST=100000000
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS


######## Environment variable
export KEYTIMEOUT=1 # Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second 1 = 0.01s)


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi


################## Alias ##################

#### Git (plugin git of oh-my-zsh)
alias gs="git status"
alias go="git checkout"
alias opengh="openGithubRepo"
alias openghb="openGithubBranch"

# gl = git pull
# gp = git push
alias gitFilterRepo="git filter-repo --to-subdirectory-filter"
alias gitroot='cd $(git rev-parse --show-toplevel)'



#### Tmux
alias tml="tmux list-sessions"
alias tmk="tmux kill-session -t"
alias tmka="tmux kill-session -a"
alias tmks="tmux kill-server"
alias tma="tmux attach"
alias tmd="tmux detach"

#### yabai
alias yabs="yabai --start-service"
alias yabr="yabai --restart-service"
alias yabd="yabai --stop-service"
alias yabu="yabai --uninstall-service"
alias yabi="yabai --install-service"

#### Navigation
alias bd="cd .."
alias bd2="cd ../.."
alias bd3="cd ../../.."
alias bd4="cd ../../../.."
alias bd5="cd ../../../../.."
alias hd="cd $hd"
alias dd="cd $dotdirs"

#### Quick edit
alias ec="vi ~/.zshrc"
alias ep="vi ~/.zprofile"
alias gec="vi $WORKDIR/configs.gogojungle.co.jp/packages/.dotfiles/ggj.zshrc"
alias gep="vi $WORKDIR/.ggj-config/.zprofile_ggj"
alias reload="source ~/.zshrc && source ~/.zprofile"

#### Docker
alias drr='docker start "$(docker ps -q -l)"'
alias dar='docker attach "$(docker ps -q -l)"' # reattach the terminal & stdin"

#### Shortcuts
alias vi="nvim"
# alias svi="sudo nvim"
alias getip="ifconfig | grep 'inet'"
alias gkeys="cat > /dev/null" # get keystroke for escape sequense.
alias wifi="sh $hdir/wifi.sh"
alias checksizeLinux="du -h --max-depth=1"
alias checksize="du -hcd 1"
alias checksizeSort="du -hcd 1 | sort -hr"
alias pn="pnpm"
alias gs="git status"
alias vif="vi \$(fzf)" # open vim through fzf
alias cfzf="fzf | tr -d '\n' | pbcopy" #copy to clipboard through fzf
alias iterm="open -a iTerm ."
alias codei="code-insiders"
alias "$"="" # ignore $ sign

if [ -x "$(command -v eza)" ]; then
    alias ls="eza"
    alias la="eza --long --all --group"
fi
# MacOS Settings Alias
alias m-fn="defaults write -g com.apple.keyboard.fnState -bool"
################## End Alias ##################

################## Function ##################
accb() { aws codebuild start-build --project-name ggj-stg-build-$1 --no-cli-pager }
acbb() { aws codebuild start-build --project-name ggj-stg-build-$1 --no-cli-pager }
checkport() {
  sudo lsof -i tcp:"$1"
}
# kp() {kill -9 $(lsof -ti:$1)}
cpyp() {
  # get previous command
  local cmd=$(fc -ln -1 | tail -n 1)
  local output=$(eval "$cmd")
  # copied output to clipboard
  echo "$output" | pbcopy
}
setPath() {
  local path=$1
  (echo; echo 'export PATH="$PATH:'$path'"') >> ~/.zprofile

  echo "Added $path to PATH"
  echo $PATH | /usr/bin/grep $path
}
appendProfile() {
  local content=$1
  (echo; echo $content) >> ~/.zprofile
  echo "Added $content to ~/.zprofile"
}
ggjcps() {
  local input=$1
  local ticket
  # check if input include 'OAM-' and $2 is '--n'
  if [[ $input == OAM-* ]] || [[ $2 == "--n" ]]; then
    ticket=$input
  else
    ticket="OAM-$input"
  fi
  git fetch
  git checkout -b $ticket origin/staging
}
ggjmpre() {
  local branch_name=$(git rev-parse --abbrev-ref HEAD)

  # Check if both user input and the current branch name are empty
  if [ -z "$1" ] && [ -z "$branch_name" ]; then
    echo "Error: No branch name provided, and unable to determine the current branch name."
    return
  fi

  # If user input is empty, use the current branch name
  if [ -z "$1" ]; then
    echo "Merge pre-staging with current branch: $branch_name"
  else
    branch_name=$1
    echo "Merge pre-staging with branch: $branch_name"
  fi

  git ggjmpre "$branch_name"
}
mkdircd() {
  mkdir -p "$@" && eval cd "\"\$$#\"";
}
openGithubRepo() {
  local remote=$(git remote -v | grep origin | grep fetch | awk '{print $2}')
  open $remote
}
openGithubBranch() {
  local branch_name="$(git rev-parse --abbrev-ref HEAD)"
  local remote=$(git remote -v | grep origin | grep fetch | awk '{print $2}')
  echo "$remote/tree/$branch_name"
  open "$remote/tree/$branch_name"
}
nchrome() {
  # /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir=/tmp/foo --ignore-certificate-errors --unsafely-treat-insecure-origin-as-secure=https://localhost:3500
  open -na "Google Chrome" --args --user-data-dir=/tmp/foo --ignore-certificate-errors --unsafely-treat-insecure-origin-as-secure=$1
}

################## End Function ##################


######## Source to config files.
## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#############  Private Alias ##############
source $pdir/private-config/.private.zshrc

#############  GGJ alias ##################
source $WORKDIR/configs.gogojungle.co.jp/packages/.dotfiles/ggj.zshrc
bindkey -s '^[b' 'cd .. \n'

# TODO: Remove this later (conflict with ggj_zshrc)
# function git-commit-current-branch() {
#   local branch_name="$(git rev-parse --abbrev-ref HEAD)"
#   BUFFER="git commit -am '$branch_name '"
#   # move cursor to the end then one char back
#   zle end-of-line
#   zle backward-char
# }
#
# zle -N git-commit-current-branch
bindkey '^[n' git-commit-ps-current-branch

# zle -al to show all key binding (widgets)

bindkey '^n' history-beginning-search-forward
bindkey '^p' history-beginning-search-backward
bindkey '^[l' clear-screen


##### DUPLICATE WITH GGJ CONFIG
## Alias
# alias tx="tmuxifier"
## Key binding
# bindkey '^ ' autosuggest-accept
## The ^M at the end of the command represents the Enter key, so that the command will be executed immediately after it is printed out.
# bindkey -s "^[m" "git commit -am ''^[[D"
## clear the screen and then yarn start
# bindkey -s '^s' "^yarn start^M"

############## End of GGJ alias ##############

cpbranch() {
  local branch_name="$(git rev-parse --abbrev-ref HEAD)"
  echo "$branch_name"
  echo "$branch_name" | tr -d '\n' | pbcopy
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# source $pdir/.dotfiles/zsh/nvm.zsh
source $pdir/.dotfiles/zsh/nvm.zshrc
source $pdir/.dotfiles/zsh/reveal-aliases.zshrc


# pnpm
export PNPM_HOME="/Users/huynh/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

PATH=~/.console-ninja/.bin:$PATH
