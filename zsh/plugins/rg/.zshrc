if command -v rg > /dev/null; then
    alias rg="rg --ignore-case --hidden --glob '!\.git/'"
fi
