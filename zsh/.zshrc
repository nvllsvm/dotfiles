zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
autoload -U compinit
compinit

setopt completealiases

# number of lines kept in history
export HISTSIZE=1000
# number of lines saved in the history after logout
export SAVEHIST=1000
# location of history
export HISTFILE=~/.zhistory
setopt HIST_NO_STORE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY 		# save every command to history before execution
setopt SHARE_HISTORY
setopt APPENDHISTORY

bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

if [ -n "$RANGER_LEVEL" ]; then RANGER_PROMPT='(ranger)'; else RANGER_PROMPT=''; fi
alias ranger='if [ -n "$RANGER_LEVEL" ] ; then echo "Nope - already in a ranger shell" ; else ranger; fi'
alias smount='sudo mount'
alias umount='sudo umount'
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lh'
alias la='ls -A'
alias halt='sudo halt'
alias reboot='sudo reboot'
alias pacman-maid='sudo pacman -Sc --noconfirm && sudo pacman-optimize'
alias yup='yaourt -Syu --noconfirm --aur && pacman-maid'
alias yup-devel='yaourt -Syu --noconfirm --aur --devel && pacman-maid'
alias ymount='sudo mount -o noatime,flush,gid=users,fmask=113,dmask=002'

export BASE_PROMPT=$RANGER_PROMPT$'%(?..[%?] )%{\e[0;32m%}%n%{\e[0;30m%}.%{\e[0;32m%}%m%{\e[0m%}  '
export VI_PROMPT=$RANGER_PROMPT$'%(?..[%?] )%{\e[0;32m%}%n%{\e[0;30m%}.%{\e[0;35m%}%m%{\e[0m%}  '
export PROMPT=$BASE_PROMPT
export RPROMPT=$'%{\e[0;36m%}%~%f'

typeset -U path
path=(~/.bin/* ~/.rvm/bin $path)
if [[ -d ~/.gem/ruby/ ]] && ls ~/.gem/ruby/ >/dev/null 2>&1; then
    for dir in ~/.gem/ruby/*; do
        if [[ -d $dir/bin ]]; then
            path+=($dir/bin)
        fi
    done
fi

bindkey -v

export KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    PROMPT="${${KEYMAP/vicmd/$VI_PROMPT}/(main|viins)/$BASE_PROMPT}"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
