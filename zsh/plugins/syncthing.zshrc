if [ -n "$SYNCTHING_DIR" ]; then
    path=("${DOTFILES_DIR}"/scripts/syncthing  "$path[@]")
    compdef '_files -W "$SYNCTHING_DIR"/Notes' notes
fi
