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

export PROMPT=$RANGER_PROMPT$'%(?..[%?] )%{\e[0;32m%}%n%{\e[0;30m%}.%{\e[0;32m%}%m%{\e[0m%}  '
export RPROMPT=$'%{\e[0;36m%}%~%f'

bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
# for rxvt
bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End
# for non RH/Debian xterm, can't hurt for RH/Debian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# for guake
bindkey "\eOF" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "\e[3~" delete-char # Del
