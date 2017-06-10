ranger() {
    if [ -n "$RANGER_LEVEL" ]; then
        echo "Nope - already in a ranger shell"
    else
        $(whence -p ranger) $@
    fi
}

prompt_ranger_active='(ranger)'

if [ -n "$RANGER_LEVEL" ]; then prompt_ranger=$prompt_ranger_active; fi

PROMPT="$prompt_ranger$PROMPT"
