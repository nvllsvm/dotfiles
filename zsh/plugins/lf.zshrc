if command -v lf > /dev/null; then
    lf() {
        if [ -n "$LF_LEVEL" ]; then
            echo "Nope - already in a lf shell"
        else
            $(whence -p lf) $@
        fi
    }

    prompt_lf_active='(lf)'

    if [ -n "$LF_LEVEL" ]; then prompt_lf=$prompt_lf_active; fi

    PROMPT="$prompt_lf$PROMPT"
fi
