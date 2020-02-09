setopt histignorealldups
setopt interactivecomments
setopt menucomplete
setopt promptsubst
setopt sharehistory
setopt no_nomatch
setopt no_nullglob

export PATH="$PATH:$HOME/.local/bin:$HOME/.yarn/bin"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"
export XDG_CONFIG_HOME="$HOME/.config"
export KEYTIMEOUT=1
export VISUAL=nvim
export EDITOR=nvim

source $HOME/proxy.sh
export_proxy

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'

alias nighton='redshift -P -O 4000'
alias nightoff='redshift -P -O 6500'

# `mkdir` and `cd` combined.
mkcd() {
    mkdir "$1"
    cd "$1"
}

print_prompt_git_info() {
    local branch_or_tag="$(git symbolic-ref --short HEAD 2> /dev/null || \
        git describe --exact-match HEAD 2> /dev/null)"

    if [ -n "$branch_or_tag" ]; then
        # Print working branch or tag
        echo -n "%B%F{magenta}$branch_or_tag%f%b"

        local changes="$(git status --porcelain | wc -l)"

        if [ "$changes" -ne "0" ]; then
            # Indicator for uncommitted changes
            echo -n "%B%F{yellow}*%f%b"
        fi

        echo -n " "
    fi
}

print_prompt_symbol() {
    # Set prompt arrow color based on the exit code returned by the last command
    # that was run in the shell
    if [ "$1" -eq "0" ]; then
        echo -n "%B%F{green}"
    else
        echo -n "%B%F{red}"
    fi

    echo -n "➜ %f%b"
}

print_prompt() {
    # Save last command's exit code
    local exit_code="$?"
    # Print working directory
    echo -n "%B%F{cyan}%~%f%b "
    print_prompt_git_info
    print_prompt_symbol "$exit_code"
}

PROMPT='$(print_prompt)'

precmd() {
    RPROMPT=''
}

# Use the right prompt as an indicator for the Vi normal mode
function zle-line-init zle-keymap-select {
    VI_NORMAL_MODE_PROMPT="%B-- NORMAL --%b"
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
bindkey "^[[1;5C" forward-word                      # Ctrl + Left arrow
bindkey "^[[1;5D" backward-word                     # Ctrl + Right arrow

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

# Enable auto-completions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
