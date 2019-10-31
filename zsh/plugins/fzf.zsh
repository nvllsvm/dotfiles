if command -v fzf > /dev/null; then
    export FZF_DEFAULT_COMMAND="fd ."

    # Key bindings
    # ------------
    if [[ $- == *i* ]]; then

    # CTRL-T - Paste the selected file path(s) into the command line
    __fsel() {
      local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type f -print \
        -o -type d -print \
        -o -type l -print 2> /dev/null | cut -b3-"}"
      setopt localoptions pipefail 2> /dev/null
      eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
        echo -n "${(q)item} "
      done
      local ret=$?
      echo
      return $ret
    }

    __fzf_use_tmux__() {
      [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
    }

    __fzfcmd() {
      __fzf_use_tmux__ &&
        echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
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
      local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type d -print 2> /dev/null | cut -b3-"}"
      setopt localoptions pipefail 2> /dev/null
      local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
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
      selected=( $(fc -rl 1 |
        FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
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

    # CTRL-R - Paste the selected command from history into the command line
    __get_parents() {
        local d
        local num=1
        d="$1"
        while [ "$d" != '/' ]; do
            d="$(dirname "$d")"
            echo $num "$d"
            let 'num=num+1'
        done
    }

    fzf-up() {
      local selected num
      setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
      selected="$(__get_parents "$PWD" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
      local ret=$?
      if [ -n "$selected" ]; then
          local target="$(printf '%s' "$selected" | cut -d' ' -f2-)"
          if [ -t 1 ]; then
              cd "$target"
          else
              echo -n "$target"
          fi
      fi
      zle && zle reset-prompt || true
    }

    __up() {
        local back=""
        for i in {1.."$1"}; do
            back+='../'
        done
        if [ -t 1 ]; then
            cd "$back"
        else
            echo -n "$back"
        fi
    }

    up() {
        if [ $# -eq 1 ]; then
            __up $1
        else
            fzf-up
        fi

    }
    zle -N up
    bindkey '^b' up

    fi
fi
