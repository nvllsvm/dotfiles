if command -v rg > /dev/null; then
    alias rg="rg --hidden -g '!\.git/'"
fi
