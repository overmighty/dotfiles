# Some parts of this file were copied from simoniz0r's .zshrc
# Link: https://github.com/simoniz0r/dotfiles/blob/master/.zshrc

setopt no_nullglob
setopt no_nomatch
setopt PROMPT_SUBST
setopt histignorealldups
setopt sharehistory
setopt menu_complete

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

# Displays the current Git branch and the amount of untracked/uncommitted changes
get_git_info() {
    BRANCH="$(git symbolic-ref --short HEAD 2> /dev/null)"

    if [ -n "$BRANCH" ]; then
        STATUS="$(git status --porcelain | wc -l)"

        if [ "$STATUS" -eq "0" ]; then
            echo -n "%F{green}%B(${BRANCH})%b%f "
        else
            echo -n "%F{yellow}%B(${BRANCH}%b*${STATUS}%B)%b%f "
        fi
    fi
}

# Displays non-zero exit codes
get_exit_code() {
    case "$?" in
        0)
            echo ""
            ;;
        *)
            echo "%F{red}%B$?%b%f "
            ;;
    esac
}

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

PROMPT='$(get_exit_code)%B%F{cyan}%~%f%b $(get_git_info)%B➜%b '

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
