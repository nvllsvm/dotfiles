zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
autoload -U colors && colors
autoload -U compinit
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

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

alias ls='ls --color=auto --group-directories-first'
alias diff='diff --color=auto'

setopt PROMPT_SUBST

insert_mode_color='magenta'
default_mode_color='green'
vi_mode_color=$default_mode_color

prompt_user='%F{green}%n%f'
prompt_separator='%F{black}.%f'
prompt_current_dir='%F{cyan}%~%f'
if ! [ -z $SSH_TTY ] && [ -z $TMUX ]; then
    prompt_host='%F{$vi_mode_color}%m%f '
else
    prompt_host=''
fi

PROMPT='$prompt_host%F{$vi_mode_color}\$%f '
RPROMPT="$prompt_current_dir"

# hide when start typing
setopt TRANSIENT_RPROMPT

typeset -U path

bindkey -v

KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    vi_mode_color="${${KEYMAP/vicmd/$insert_mode_color}/(main|viins)/$default_mode_color}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

add-zsh-hook precmd set_cursor_key_to_cursor
add-zsh-hook precmd exit_status

set_cursor_key_to_cursor () {
    # fixes some misbehaving combinations like dotnet and VTE terminals.
    # application mode remaps arrows to ex. ^[OA and
    # breaks history search.
    printf '\e[?1l'
}


exit_status () {
    exit_status=$?
    if [[ $exit_status -gt 0 ]]; then
        echo -e "${fg[red]}${exit_status}${reset_color}"
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

envfile() {
    set -a; . "$@"; set +a
}

fpath=($DOTFILES/zsh/functions $fpath)
compinit -C

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

full-update() {
    if [[ $1 == "add" ]]; then
        if [ -z $2 ]; then
            echo ERROR: No command specified
        else
            update_commands=("$update_commands[@]" "$2")
        fi
    else
        for command in "${update_commands[@]}"; do
            exec-update $command
        done
    fi
}

exec-update() {
    if [ ! -z $@ ]; then
        echo -e "\033[1;33mNow running $@ \033[0m..."
        eval "$@"
    fi
}

for plugin in $DOTFILES/zsh/plugins/*; do
    . $plugin
done

zshrc_host="$DOTFILES/zsh/hosts/$HOST/.zshrc"
[[ -r "$zshrc_host" ]] && . "$zshrc_host"
unset zshrc_host

path=(~/.bin ~/.local/bin "$path[@]")

full-update add 'find ~/.bin -xtype l -delete'
full-update add 'find ~/.local/bin -xtype l -delete'

full-update add 'rm -f ~/.zcompdump && zsh -ic "echo -n"'
full-update add 'exec zsh'

zreset() {
    reset
    exec zsh
}

temp-context() {
    (
        CONTEXT_DIR="$(mktemp -d)";
        cleanup() { rm -rf "$CONTEXT_DIR" };
        trap cleanup EXIT;
        cd "$CONTEXT_DIR"
        zsh
    )
}
