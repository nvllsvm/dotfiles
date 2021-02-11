if command -v fzf > /dev/null; then
    # CTRL-T - Paste the selected file path(s) into the command line
    __fsel() {
      setopt localoptions pipefail 2> /dev/null
      command fd | FZF_DEFAULT_OPTS="--height 40% --reverse" fzf -m "$@" | while read item; do
        echo -n "${(q)item} "
      done
      local ret=$?
      return $ret
    }

    fzf-file-widget() {
      LBUFFER="${LBUFFER}$(__fsel)"
      local ret=$?
      zle reset-prompt
      return $ret
    }
    zle     -N   fzf-file-widget
    bindkey '^T' fzf-file-widget

    # Ensure precmds are run after cd
    fzf-redraw-prompt() {
      local precmd
      for precmd in $precmd_functions; do
        $precmd
      done
      zle reset-prompt
    }
    zle -N fzf-redraw-prompt

    # ALT-C - cd into the selected directory
    fzf-cd-widget() {
      setopt localoptions pipefail 2> /dev/null
      local dir="$(command fd -t d | FZF_DEFAULT_OPTS="--height 40% --reverse" fzf +m)"
      if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
      fi
      cd "$dir"
      local ret=$?
      zle fzf-redraw-prompt
      return $ret
    }
    zle     -N    fzf-cd-widget
    bindkey '\ec' fzf-cd-widget

    # CTRL-R - Paste the selected command from history into the command line
    fzf-history-widget() {
      local selected num
      setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
      selected=( $(fc -rl 1 | FZF_DEFAULT_OPTS="--height 40% -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort --query=${(qqq)LBUFFER} +m" fzf) )
      local ret=$?
      if [ -n "$selected" ]; then
        num=$selected[1]
        if [ -n "$num" ]; then
          zle vi-fetch-history -n $num
        fi
      fi
      zle reset-prompt
      return $ret
    }
    zle     -N   fzf-history-widget
    bindkey '^R' fzf-history-widget
fi
