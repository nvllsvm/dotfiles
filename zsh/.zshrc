zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U add-zsh-hook

setopt completealiases

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zhistory

setopt hist_no_store
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -A'
alias grep='grep --color=auto'
alias today='date +"%Y-%m-%d"'

srch () {
    if [[ -z $2 ]]; then
        find . 2> /dev/null | grep -i $1
        grep -riI $1 . 2> /dev/null
    else
        find ${@:2} 2> /dev/null | grep -i $1
        grep -riI $1 ${@:2} 2> /dev/null
    fi
}

setopt PROMPT_SUBST

insert_mode_color='magenta'
default_mode_color='green'
vi_mode_color=$default_mode_color

prompt_host='%F{$vi_mode_color}%m%f'
prompt_user='%F{green}%n%f'
prompt_separator='%F{black}.%f'
prompt_current_dir='%F{cyan}%~%f'

PROMPT="$prompt_user$prompt_separator$prompt_host  "

RPROMPT="$prompt_current_dir"

typeset -U path

if [[ -d ~/.bin/ ]]; then
    for dir in ~/.bin/*; do
        path=($dir "$path[@]")
    done
fi

bindkey -v

KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    vi_mode_color="${${KEYMAP/vicmd/$insert_mode_color}/(main|viins)/$default_mode_color}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

add-zsh-hook precmd exit_status

exit_status () {
    exit_status=$?
    if [[ $exit_status -gt 0 ]]; then
        RED='\033[0;31m'
        YELLOW_BG='\033[43m'
        RESET_COLOR='\033[0m'
        echo -e "${RED}${YELLOW_BG}$exit_status${RESET_COLOR}"
    fi
}

up() {
    for i in {1..$1};
    do
        if [[ -t 1 ]] then
            cd ..
        else
            echo -n ../
        fi
    done
}

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}

zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey '^r' sudo-command-line
bindkey -M vicmd '^r' sudo-command-line

[[ -r ~/.zsh/local.zshrc ]] && . ~/.zsh/local.zshrc
