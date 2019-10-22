zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
autoload -U colors && colors
autoload -U compinit
autoload -U add-zsh-hook

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
if [ -n "$SSH_TTY" ] && [ -z "$TMUX" ]; then
    prompt_host='%F{$vi_mode_color}%m%f '
else
    prompt_host=''
fi

PROMPT='$prompt_host%F{$vi_mode_color}\$%f '
RPROMPT="$prompt_current_dir"

# hide when start typing
setopt TRANSIENT_RPROMPT

typeset -U path
typeset -U manpath

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
    # when the previous command exits with a code != 0,
    # show it on a new line
    exit_status=$?
    if [[ $exit_status -gt 0 ]]; then
        echo -e "${fg[red]}${exit_status}${reset_color}"
    fi
}

up() {
    for i in {1.."$1"};
    do
        if [[ -t 1 ]] then
            cd ..
        else
            echo -n ../
        fi
    done
}

full-update() {
    if [ "$1" = "add" ]; then
        if [ -z "$2" ]; then
            echo ERROR: No command specified
        else
            update_commands=("$update_commands[@]" "$2")
        fi
    else
        for command in "${update_commands[@]}"; do
            if [ ! -z "$command" ]; then
                echo "${fg[yellow]}Now running $command ${reset_color}..."
                eval "$command"
            fi
        done
    fi
}

fpath=("$DOTFILES/zsh/functions" "$fpath[@]")

host_dir="$DOTFILES/zsh/hosts/$HOST"
if [ -r "$host_dir/.zshrc" ]; then
    . "$host_dir/.zshrc"
fi
if [ -d "$host_dir/functions" ]; then
    fpath=("$host_dir/functions" "$fpath[@]")
fi
unset host_dir

for plugin in $DOTFILES/zsh/plugins/*; do
    . "$plugin"
done

# set last to make local take precedence
path=(~/.local/bin "$path[@]")

compinit -C

zsh_reload_comp() {
    rm -f ~/.zcompdump
    zsh -ic "echo -n"
}

full-update add 'zsh -ic zsh_reload_comp'

pushd "$DOTFILES/scripts/commands" > /dev/null
for c in *; do
    if command -v "$c" > /dev/null; then
        path=("$DOTFILES/scripts/commands/$c" "$path[@]")
    fi
done
popd > /dev/null

path=(
    "${DOTFILES}"/scripts/terminal
    "$path[@]"
)

host_scripts="${DOTFILES}/scripts/hosts/$HOST"
if [ -d "$host_scripts" ]; then
    path=("$host_scripts" "$path[@]")
fi
unset host_scripts
export PATH="/usr/local/opt/postgresql@9.4/bin:$PATH"
