emulate sh
source ~/.profile
emulate zsh



# Added by Toolbox App
export PATH="$PATH:/Users/huynh/Library/Application Support/JetBrains/Toolbox/scripts"

eval $(/opt/homebrew/bin/brew shellenv)
export PATH="$PATH:/Applications/IntelliJ IDEA.app/Contents/MacOS"
export PATH="$PATH:/Applications/XAMPP/bin"

# Personal variable
export hdir=/Users/huynh/Personal/config.huynh
export pdir=/Users/huynh/Personal
export wd=/Users/huynh/GGJ
export WORKDIR=/Users/huynh/GGJ
export tmp=/Users/huynh/Downloads/temp
export dotdir=/Users/huynh/Personal/.dotfiles
# export TERM=screen-256color
export TERM=xterm-256color
# export tmux_dir=/Users/huynh/Personal/.dotfiles/tmux/

# sqlite3
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/sqlite/lib/pkgconfig"

# fd with fzf
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border --preview "bat --color=always --style=header,grid --line-range :500 {}"'


# Private environment
source $WORKDIR/.ggj-config/.zprofile_ggj
# export OPENAI_API_KEY=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

# editor
export EDITOR=nvim
export CODE=code-insiders


## Colors
export RED='\033[0;31m'
export NC='\033[0m' # No Color
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WARNING='\033[0;93m'
export ERROR='\033[0;91m'
export SUCCESS='\033[0;92m'

##
# Your previous /Users/huynh/.zprofile file was backed up as /Users/huynh/.zprofile.macports-saved_2023-04-25_at_23:34:09
##

# MacPorts Installer addition on 2023-04-25_at_23:34:09: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# MacPorts Installer addition on 2023-04-25_at_23:34:09: adding an appropriate MANPATH variable for use with MacPorts.
export MANPATH="/opt/local/share/man:$MANPATH"
# Finished adapting your MANPATH environment variable for use with MacPorts.

# Tmuxifier
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"
export TMUXIFIER_LAYOUT_PATH="$dotdir/tmuxifier-layouts"

# Flutter
export PATH="$PATH:/Users/huynh/GGJ/flutter/bin"

# NVM
export NVM_NODE_PREFIX=""
# export NODE_OPTIONS=--openssl-legacy-provider

export PATH="$PATH:/usr/local/mongodb/bin"

export PATH="$PATH:/usr/local/bin/code-insiders"

# Setting PATH for Python 2.7
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# Setting PATH for Python 3.11
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
export PATH


# bun completions
[ -s "/Users/huynh/.bun/_bun" ] && source "/Users/huynh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

