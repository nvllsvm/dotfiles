zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*' list-dirs-first true

# Prevent autocompleting to a different parent directory when
# the child does not exist.
#
# Ex.
# /a1/other
# /a2/file
#
# Without this option, `cd a1/f` would complete to `a2/file`.
# That's annoying.
zstyle ':completion:*' accept-exact-dirs true

autoload -U colors && colors
autoload -U compinit
autoload -U add-zsh-hook

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zhistory

setopt hist_no_store
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history
setopt auto_pushd
setopt null_glob

unsetopt correct_all

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Fixes up+down history completion in certain situations.
# Replicate:
#   1. ssh into a remote machine and launch tmux
#   2. kill the session from the remote machine
#   3. attempt using partial completion (enter `ls ` and press up)
#
# ---
# Notes:
#
# https://espterm.github.io/docs/VT100%20escape%20codes.html
# `setcursor DECCKM      Set cursor key to cursor               ^[[?1l`
#
add-zsh-hook precmd set_cursor_key_to_cursor
set_cursor_key_to_cursor () {
    printf '\e[?1l'
}

alias ls='ls --color=auto --group-directories-first'
alias diff='diff --color=auto'

setopt PROMPT_SUBST

insert_mode_color='magenta'
default_mode_color='green'
vi_mode_color=$default_mode_color

prompt_user='%F{green}%n%f'
prompt_separator='%F{black}.%f'
prompt_current_dir='%F{cyan}%~%f'
if [ -n "$SSH_TTY" ] && [ -z "$TMUX" ]; then
    prompt_host='%m'
else
    prompt_host=''
fi

PROMPT='%F{$vi_mode_color}$prompt_host\$%f '
RPROMPT="$prompt_current_dir"

# hide when start typing
setopt TRANSIENT_RPROMPT

bindkey -v

KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    vi_mode_color="${${KEYMAP/vicmd/$insert_mode_color}/(main|viins)/$default_mode_color}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

fpath=("$DOTFILES/zsh/functions" "$fpath[@]")

host_dir="$DOTFILES/zsh/hosts/$HOST"
if [ -r "$host_dir/.zshrc" ]; then
    . "$host_dir/.zshrc"
fi
if [ -d "$host_dir/functions" ]; then
    fpath=("$host_dir/functions" "$fpath[@]")
fi
unset host_dir

for plugin in "$DOTFILES"/zsh/plugins/*/.zshrc(N); do
    . "$plugin"
done

compinit -C

zsh_reload_comp() {
    rm -f ~/.zcompdump
    zsh -ic "echo -n"
}

all_commands() {
    autoload -Uz bashcompinit
    bashcompinit
    compgen -c | sort -u
}

PROMPT_EOL_MARK=''
