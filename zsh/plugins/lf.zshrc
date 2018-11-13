if command -v lf > /dev/null; then
    if [ -n "$LF_LEVEL" ]; then
        lf() {
            echo "Nope - already in a lf shell" >&2
            return 1
        }
        PROMPT="(lf)$PROMPT"
    fi
fi
