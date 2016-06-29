zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U add-zsh-hook

setopt completealiases

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zhistory

setopt HIST_NO_STORE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt APPENDHISTORY

bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

alias ranger='if [ -n "$RANGER_LEVEL" ] ; then echo "Nope - already in a ranger shell" ; else ranger; fi'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -A'

setopt PROMPT_SUBST

insert_mode_color='magenta'
default_mode_color='green'
vi_mode_color=$default_mode_color

prompt_host='%F{$vi_mode_color}%m%f'
prompt_user='%F{green}%n%f'
prompt_separator='%F{black}.%f'
prompt_exit_status='%(?..%K{yellow}%F{red}%?%k%f  )'
prompt_current_dir='%F{cyan}%~%f'

prompt_ranger_active='(ranger)'

if [ -n "$RANGER_LEVEL" ]; then prompt_ranger=$prompt_ranger_active; fi

PROMPT='$prompt_virtualenv'"$prompt_ranger$prompt_user$prompt_separator$prompt_host  $prompt_exit_status"

RPROMPT="$prompt_current_dir"

typeset -U path

if [[ -d ~/.bin/ ]]; then
    for dir in ~/.bin/*; do
        path+=($dir)
    done
fi

if [[ -d ~/.gem/ruby/ ]] && ls ~/.gem/ruby/ >/dev/null 2>&1; then
    for dir in ~/.gem/ruby/*; do
        if [[ -d $dir/bin ]]; then
            path+=($dir/bin)
        fi
    done
fi

if [[ -d ~/.node_modules/bin/ ]]; then
    path+=(~/.node_modules/bin/)
fi

bindkey -v

KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    vi_mode_color="${${KEYMAP/vicmd/$insert_mode_color}/(main|viins)/$default_mode_color}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

export VIRTUAL_ENV_DISABLE_PROMPT=1

PYTHON2_BIN=$(command -v python2 || command -v python2.7)
PYTHON3_BIN=$(command -v python3)

function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]] then
        unset prompt_virtualenv
        unset ORIG_PYTHON2_BIN
        unset ORIG_PYTHON3_BIN
    else
        prompt_virtualenv="($(basename $VIRTUAL_ENV))"

        if [[ -n $PYTHON2_BIN ]] then
            export ORIG_PYTHON2_BIN=$PYTHON2_BIN
        fi
        if [[ -n $PYTHON3_BIN ]] then
            export ORIG_PYTHON3_BIN=$PYTHON3_BIN
        fi
    fi
}

add-zsh-hook precmd virtenv_indicator

up() {
    for i in {1..$1};
    do
        cd ..
    done
}

[[ -r ~/.zsh/local.zshrc ]] && . ~/.zsh/local.zshrc
