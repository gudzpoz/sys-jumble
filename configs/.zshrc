# Configurable entries
# Set them in ~/.zprofile

ZNAP_INSTALL_DIR="${ZNAP_INSTALL_DIR:-$HOME/Workspaces/clones}"
LOCAL_PROXY_PORT="${LOCAL_PROXY_PORT:-}"

# Environment Variables
[ -d "$HOME/.luarocks/bin" ] && export PATH="$HOME/.luarocks/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

## Optional conda
[ -f /opt/anaconda/etc/profile.d/conda.sh ] && source /opt/anaconda/etc/profile.d/conda.sh

## Proxy settings
if [ "$LOCAL_PROXY_PORT" != "" ]; then
    hp="http://127.0.0.1:${LOCAL_PROXY_PORT}"
    export http_proxy="$hp"
    export HTTP_PROXY="$hp"
    export https_proxy="$hp"
    export HTTPS_PROXY="$hp"
    export no_proxy='localhost,cn,baidu.com,gitee.com'
    export NO_PROXY="$no_proxy"
    deproxied() {
        env -u http_proxy -u https_proxy -u HTTP_PROXY -u HTTPS_PROXY "$@"
    }
fi

# Oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

## Completion
CASE_SENSITIVE='true'
HYPHEN_INSENSITIVE='true'
COMPLETION_WAITING_DOTS='true'

## Oh-my-zsh updates
zstyle ':omz:update' mode reminder  # just remind me to update when it's time
zstyle ':omz:update' frequency 15
## Oh-my-zsh configs
zstyle ':omz:plugins:nvm' lazy yes

## Theme
ZSH_THEME='robbyrussell'

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY='true'

## Plugins
plugins=(fzf git nvm)

# Enable oh-my-zsh
source "$ZSH/oh-my-zsh.sh"

# Enable znap
mkdir -p "$ZNAP_INSTALL_DIR"
if [ ! -f "$ZNAP_INSTALL_DIR/znap/znap.zsh" ]; then
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git \
        "$ZNAP_INSTALL_DIR/znap"
fi
source "$ZNAP_INSTALL_DIR/znap/znap.zsh"

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    if [ -z "$STY" ] && [ -z "$TMUX" ]; then
        # Automatically attach to existing sessions
        tmux attach || tmux
        # Automatically exit
        exit
    fi
fi
## Completion settings
zstyle ':completion:*' add-space true
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' match-original both
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-ip true
autoload -Uz compinit
compinit

# Zoxide
export _ZO_ECHO=1
eval "$(zoxide init zsh --cmd=j )"

# User configuration

## My own editor preference
## Emacs (daemon) -> vim -> any, never Emacs standalone.
has_bin() {
    if command -v "$1" > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}
open_in_emacs() {
    filename=$(echo -n "$1" | base64)
    emacsclient --eval "(find-file (base64-decode-string \"${filename}\"))"
}
checked_sudo() {
    if [ "$1" == 'vim' ]; then
        open_in_emacs "/sudo::$2"
    else
        \sudo "$@"
    fi
}
if [ "$INSIDE_EMACS" != '' ]; then
    DISABLE_AUTO_TITLE='true'

    # Tracks current directory for helm, etc.
    chpwd() { print -P "\033AnSiTc %d" }
    print -P "\033AnSiTu %n"
    print -P "\033AnSiTc %d"

    # Truecolor~
    export TERM=xterm-direct

    export EDITOR=vim
    alias emacs=open_in_emacs
    alias e=emacs
    alias g='emacsclient --eval "(magit-status)"'
elif has_bin emacsclient; then
    if has_bin vim; then
        export EDITOR='emacsclient -nw -a vim'
    elif has_bin nano; then
        export EDITOR='emacsclient -nw -a nano'
    else
        export EDITOR='emacsclient -nw'
    fi
    alias vim="TERM=tmux-direct $EDITOR"
    alias emacs='emacsclient -c'
    alias e='emacs'
    alias g='vim --eval "(magit-status)"'
    sue() {
        emacsclient -nw "/sudo::$1"
    }
elif has_bin vim; then
    export EDITOR='vim'
fi

## History configuration
### Bash compatibility
HISTFILE="$HOME/.bash_history"
HISTSIZE=1000
SAVEHIST=1000
dehist() {
    unset HISTFILE
}

unsetopt sharehistory
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
unsetopt INC_APPEND_HISTORY

## Enable extended globbing
setopt extendedglob

## Use Emacs shortcuts
bindkey -e

## Aliases
alias cp='cp -i'                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias more=less
alias pacman-Rs='sudo pacman -Rs'

### alias for rm / prevent using rm in interacting command line
alias rm='echo "This is not the command you are looking for."; false'
alias rmi='/bin/rm -irv'
alias tp='trash-put --verbose'

# Syntax highlighting
if [ -f '/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
