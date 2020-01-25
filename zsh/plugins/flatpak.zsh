if command -v flatpak > /dev/null; then
    full-update add 'flatpak update --user --assumeyes'
    full-update add 'flatpak uninstall --unused --user --assumeyes'
fi
