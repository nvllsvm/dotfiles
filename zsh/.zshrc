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
alias pacman-maid='sudo pacman -Sc --noconfirm && sudo pacman-optimize'
alias yup='yaourt -Syu --noconfirm --aur && pacman-maid'
alias yup-devel='yaourt -Syu --noconfirm --aur --devel && pacman-maid'

setopt PROMPT_SUBST

insert_mode_color='magenta'
default_mode_color='green'

prompt_host='%F{$vi_mode_color}%m%f'
prompt_user='%F{green}%n%f'
prompt_separator='%F{black}.%f'
prompt_exit_status='%(?..%K{yellow}%F{red}%?%k%f  )'
prompt_current_dir='%F{cyan}%~%f'

prompt_virtualenv_active='(venv)'
prompt_ranger_active='(ranger)'

if [ -n "$RANGER_LEVEL" ]; then prompt_ranger=$prompt_ranger_active; fi

PROMPT='$prompt_virtualenv$prompt_ranger$prompt_user$prompt_separator$prompt_host  $prompt_exit_status'

RPROMPT='$prompt_current_dir'

typeset -U path

if [[ -d ~/.rvm/bin/ ]]; then
    path+=(~/.rvm/bin)
fi

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

bindkey -v

KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    vi_mode_color="${${KEYMAP/vicmd/$insert_mode_color}/(main|viins)/$default_mode_color}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]] then
        unset prompt_virtualenv
    else
        prompt_virtualenv=$prompt_virtualenv_active
    fi
}

add-zsh-hook precmd virtenv_indicator
