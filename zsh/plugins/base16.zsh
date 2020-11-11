export BASE16_SHELL="$HOME/.local/share/base16-shell/"

if [ -d "$BASE16_SHELL" ]; then
    export BASE16_SHELL_HOOKS="$DOTFILES/base16_shell_hooks"

    if [ -z "$SSH_CONNECTION" ] && [ -z "$TMUX" ] && [ -f ~/.base16_theme ]; then
        . ~/.base16_theme
    fi

    path=(
        "$DOTFILES"/scripts/base16
        "$path[@]"
    )
else
    unset BASE16_SHELL
fi
