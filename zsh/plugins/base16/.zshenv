export BASE16_SHELL="$HOME/.local/share/base16-shell/"

if [ -d "$BASE16_SHELL" ]; then
    export BASE16_SHELL_HOOKS="$DOTFILES/base16_shell_hooks"

    path=(
        "$DOTFILES"/scripts/base16
        "$path[@]"
    )
else
    unset BASE16_SHELL
fi
