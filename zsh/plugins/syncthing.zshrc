export SYNCTHING_DIR="${SYNCTHING_DIR:-$HOME/Syncthing}"
if [ -d "$SYNCTHING_DIR" ]; then
    path=("${DOTFILES_DIR}"/scripts/syncthing  "$path[@]")
    compdef '_files -W "$SYNCTHING_DIR"/Notes' notes
fi
