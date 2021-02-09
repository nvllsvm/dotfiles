typeset -U path
typeset -U manpath

zmodload zsh/stat
export DOTFILES=${$(zstat +link ~/.zshrc)%%/zsh/.zshrc}
export EDITOR=nvim
export LESSHISTFILE=/dev/null
export OPENER=open

for plugin in "$DOTFILES"/zsh/plugins/*/.zshenv(N); do
    . "$plugin"
done

pushd "$DOTFILES/scripts/commands" > /dev/null
for c in *; do
    if command -v "$c" > /dev/null; then
        path=("$DOTFILES/scripts/commands/$c" "$path[@]")
    fi
done

path=(
    "${DOTFILES}/scripts/hosts/${HOST}"
    "${DOTFILES}"/scripts/terminal
    "$path[@]"
)

popd > /dev/null
zshenv_host="$DOTFILES/zsh/hosts/$HOST/.zshenv"
if [[ -r "$zshenv_host" ]]; then
    . "$zshenv_host"
fi
unset zshenv_host

path=(
    ~/.local/bin
    "$path[@]"
)
