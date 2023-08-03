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
# gl = git pull
# gp = git push

#### Tmux
alias tml="tmux list-sessions"
alias tmk="tmux kill-session -t"
alias tmka="tmux kill-session -a"
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

#### Shortcuts
alias vi="nvim"
alias getip="ifconfig | grep 'inet'"
alias gkeys="cat > /dev/null" # get keystroke for escape sequense.
alias wifi="sh $hdir/wifi.sh"
alias pn="pnpm"
alias gs="git status"
alias vif="vi \$(fzf)" # open vim through fzf
alias cfzf="fzf | tr -d '\n' | pbcopy" #copy to clipboard through fzf
alias iterm="open -a iTerm ."
alias codei="code-insiders"
alias "$"="" # ignore $ sign

if [ -x "$(command -v exa)" ]; then
    alias ls="exa"
    alias la="exa --long --all --group"
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
  # check if input include 'OAM-'
  if [[ $input =~ ^OAM- ]]; then
    ticket=$input
  else
    ticket="OAM-$input"
  fi
  git fetch
  git checkout -b $ticket origin/staging
}
mkdircd() {
  mkdir -p "$@" && eval cd "\"\$$#\"";
}
openGithubRepo() {
  local remote=$(git remote -v | grep origin | grep fetch | awk '{print $2}')
  open $remote
}

################## End Function ##################


######## Source to config files.
## To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


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

# TODO: correct this
bindkey '^n' history-search-forward
bindkey '^p' history-search-backward
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
