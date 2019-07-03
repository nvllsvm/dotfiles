# start a subshell in a temporary directory
# delete the directory when the subshell exists

temp-context() {
    (
        # resolve symlink to be consistent when opening a tmux pane (etc)
        # in the same directory
        CONTEXT_DIR="$(readlink -f "$(mktemp -d)")";

        cleanup() { rm -rf "$CONTEXT_DIR" };
        trap cleanup EXIT;
        cd "$CONTEXT_DIR"
        zsh
    )
}
