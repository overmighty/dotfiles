# Options
setopt histignorealldups
setopt interactivecomments
setopt menucomplete
setopt promptsubst
setopt sharehistory
setopt no_nomatch
setopt no_nullglob

# Exports
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/go/bin"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export CCACHE_DIR="${XDG_CACHE_HOME}/ccache"
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
export KEYTIMEOUT=1
export VISUAL=nvim
export EDITOR=nvim

# Aliases
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias nighton='redshift -P -O 4000'
alias nightoff='redshift -P -O 6500'

# More aliases

mkcd() {
    mkdir "$1" && cd "$1"
}

yt() {
    mpv ytdl://"$1"
}

# Prompt

print_prompt_git_info() {
    local branch_or_tag="$(git symbolic-ref --short HEAD 2> /dev/null || \
        git describe --exact-match HEAD 2> /dev/null)"

    if [ -z "${branch_or_tag}" ]; then
        return
    fi

    echo -n "%B%F{magenta}${branch_or_tag}%b%f"

    local change_count="$(git status --porcelain | wc -l)"

    if [ "${change_count}" -gt "0" ]; then
        echo -n "%B%F{yellow}*%b%f"
    fi

    echo -n " "
}

print_prompt_symbol() {
    if [ "$1" -eq "0" ]; then
        echo -n "%B%F{green}"
    else
        echo -n "%B%F{red}"
    fi

    echo -n "➜ %f%b"
}

print_prompt() {
    local exit_code="$?"
    echo -n "%B%F{cyan}%~%f%b "
    print_prompt_git_info
    print_prompt_symbol "${exit_code}"
}

PROMPT='$(print_prompt)'
VI_NORMAL_MODE_PROMPT="%B-- NORMAL --%b"

precmd() {
    RPROMPT=''
}

# Use the right prompt as an indicator for the Vi normal mode
function zle-line-init zle-keymap-select {
    RPROMPT='${${KEYMAP/vicmd/$VI_NORMAL_MODE_PROMPT}/(main|viins)/}'
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Keybindings
bindkey -v # Enable Vi emulation
bindkey "^[[2~"   overwrite-mode                    # Insert
bindkey "^[[H"    beginning-of-line                 # Home
bindkey "^[[5~"   up-line-or-history                # Page Up
bindkey "^[[3~"   delete-char                       # Delete
bindkey "^[[F"    end-of-line                       # End
bindkey "^[[6~"   down-line-or-history              # Page Down
bindkey "^[[A"    history-beginning-search-backward # Up arrow
bindkey "^[[B"    history-beginning-search-forward  # Down arrow
bindkey "^[[1;5C" forward-word                      # Ctrl+Left arrow
bindkey "^[[1;5D" backward-word                     # Ctrl+Right arrow

# Keep 50000 lines of history within the shell and save it to ~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' format '%B%F{blue}Completing %d%b%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' menu select=5
zstyle ':completion:*:descriptions' format "%B%d%b"
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%B%F{blue}At %p: Hit TAB for more, or the character to insert%b%f'
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt '%B%F{blue}Scrolling active: current selection at %p%b%f'
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Enable auto-suggestions based on command history
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
