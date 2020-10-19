zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*:matches'         group 'yes'
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*' list-dirs-first true
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

fpath=("$DOTFILES/zsh/functions" "$fpath[@]")

host_dir="$DOTFILES/zsh/hosts/$HOST"
if [ -r "$host_dir/.zshrc" ]; then
    . "$host_dir/.zshrc"
fi
if [ -d "$host_dir/functions" ]; then
    fpath=("$host_dir/functions" "$fpath[@]")
fi
unset host_dir

path=(
    ~/.local/bin
    "$path[@]"
)

for plugin in $DOTFILES/zsh/plugins/*; do
    . "$plugin"
done

compinit -C

zsh_reload_comp() {
    rm -f ~/.zcompdump
    zsh -ic "echo -n"
}

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
#
# set last to make local take precedence
path=(
    ~/.local/bin
    "$path[@]"
)

unset host_scripts

all_commands() {
    autoload -Uz bashcompinit
    bashcompinit
    compgen -c | sort -u
}

PROMPT_EOL_MARK=''
