setopt histignorealldups
setopt menucomplete
setopt promptsubst
setopt sharehistory
setopt no_nomatch
setopt no_nullglob

export KEYTIMEOUT=1
export VISUAL=code
export EDITOR=code

# Add colors to `ls`
alias ls='ls --color=auto'
# `mkdir` and `cd` combined
alias mkcd='_() { mkdir $1; cd $1; }; _'
# Toggles night mode on (add orange-ish tone to screen)
alias nighton='redshift -P -O 4500'
# Toggles night mode off (restore regular color tone)
alias nightoff='redshift -P -O 6500'

print_prompt_git_info() {
    BRANCH_OR_TAG="$(git symbolic-ref --short HEAD 2> /dev/null || \
        git describe --exact-match HEAD 2> /dev/null)"

    if [ -n "$BRANCH_OR_TAG" ]; then
        echo -n "%B%F{magenta}$BRANCH_OR_TAG%f%b" # Print working branch or tag
        CHANGES="$(git status --porcelain | wc -l)"

        if [ "$CHANGES" -ne "0" ]; then
            echo -n "%B%F{yellow}*%f%b" # Indicator for uncommitted changes
        fi

        echo -n " "
    fi
}

print_prompt_symbol() {
    # Set prompt arrow color based on the exit code returned by the last command
    # that was ran in the shell
    if [ "$1" -eq "0" ]; then
        echo -n "%B%F{green}"
    else
        echo -n "%B%F{red}"
    fi

    echo -n "➜ %f%b"
}

print_prompt() {
    EXIT_CODE="$?" # Save last command's exit code
    echo -n "%B%F{cyan}%~%f%b " # Print working directory
    print_prompt_git_info
    print_prompt_symbol "$EXIT_CODE"
}

PROMPT='$(print_prompt)'

precmd() {
    RPROMPT=''
}

# Use the right prompt as an indicator for the Vi normal/command mode
function zle-line-init zle-keymap-select {
    VI_NORMAL_MODE_PROMPT="%B-- NORMAL --%b"
    RPROMPT='${${KEYMAP/vicmd/$VI_NORMAL_MODE_PROMPT}/(main|viins)/}'
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Keybindings
bindkey -v # Enable Vi emulation
bindkey "^[[2~"   overwrite-mode                    # Insert key
bindkey "^[[H"    beginning-of-line                 # Home key
bindkey "^[[5~"   up-line-or-history                # Page Up key
bindkey "^[[3~"   delete-char                       # Delete key
bindkey "^[[F"    end-of-line                       # End key
bindkey "^[[6~"   down-line-or-history              # Page Down key
bindkey "^[[A"    history-beginning-search-backward # Up arrow key
bindkey "^[[B"    history-beginning-search-forward  # Down arrow key
bindkey "^[[1;5C" forward-word                      # Ctrl + left arrow key
bindkey "^[[1;5D" backward-word                     # Ctrl + right arrow key

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
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
zstyle ":completion:*:descriptions" format "%B%d%b"
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
