#!/usr/bin/env zsh

##
# fork of zsh-system-clipboard
# https://github.com/kutsan/zsh-system-clipboard
#
# @author
#	Kutsan Kaplan <me@kutsankaplan.com>
#	Doron Behar <doron.behar@gmail.com>
# @license GPL-3.0
# @version v0.7.0
##

function zsh-system-clipboard-vicmd-vi-yank() {
    zle vi-yank
    if [[ "${KEYS}" == "y" && "${KEYMAP}" == 'viopp' ]]; then # A new line should be added to the end
        printf '%s\n' "$CUTBUFFER" | cbcopy
    else
        printf '%s' "$CUTBUFFER" | cbcopy
    fi
}
zle -N zsh-system-clipboard-vicmd-vi-yank

function zsh-system-clipboard-vicmd-vi-yank-whole-line() {
    zle vi-yank-whole-line
    printf '%s\n' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-yank-whole-line

# Wrapper function for common calculations of both put-after and put-before
function zsh-system-clipboard-vicmd-vi-put() {
    local CLIPBOARD
    local mode="$1"
    CLIPBOARD="$(cbpaste; printf '%s' x)"
    CLIPBOARD="${CLIPBOARD%x}"
    local RBUFFER_UNTIL_LINE_END="${RBUFFER%%$'\n'*}"
    # Checks if the last character is a new line
    if [[ "${CLIPBOARD[${#CLIPBOARD}]}" == $'\n' ]]; then
        # if so, we need to check if we have more lines below the cursor.
        # The following variable gets the contents of the whole RBUFFER up
        # until the next new-line. Therefor, this comparison tells us if we have
        # more new lines or not
        if [[ "${RBUFFER_UNTIL_LINE_END}" == "${RBUFFER}" && "$mode" == "after" ]]; then
            # we don't have any more newlines in RBUFFER.
            # Therefor, we add a new line at the beginning of our original
            # clipboard so it will append the whole BUFFER eventually
            CLIPBOARD=$'\n'"${CLIPBOARD%%$'\n'}"
        fi
        # If we are pasting a whole-line selection we need to put the cursor at
        # the correct position, according to our mode of input
        if [[ "$mode" == "after" ]]; then
            CURSOR="$(( ${CURSOR} + ${#RBUFFER_UNTIL_LINE_END} ))"
        else
            # We use the single % for the smallest match possible
            local LBUFFER_UNTIL_LINE_END="${LBUFFER%$'\n'*}"
            CURSOR="$(( ${#LBUFFER_UNTIL_LINE_END} + 1 ))"
        fi
    fi
    # If our selection is not whole lines, we need to check whether the line
    # our cursor is on an empty line or not and if it is, on the final
    # BUFFER modification, we'll always use the after mode. The length of
    # ${RBUFFER_UNTIL_LINE_END} tells as so - if it's 0
    if [[ "$mode" == "after" && ${#RBUFFER_UNTIL_LINE_END} != "0" ]]; then
        BUFFER="${BUFFER:0:$(( ${CURSOR} + 1 ))}${CLIPBOARD}${BUFFER:$(( ${CURSOR} + 1 ))}"
        CURSOR=$(( $#LBUFFER + $#CLIPBOARD ))
    else
        BUFFER="${BUFFER:0:$(( ${CURSOR} ))}${CLIPBOARD}${BUFFER:$(( ${CURSOR} ))}"
        CURSOR=$(( $#LBUFFER + $#CLIPBOARD - 1 ))
    fi
}

function zsh-system-clipboard-vicmd-vi-put-after() {
    zsh-system-clipboard-vicmd-vi-put after
}
zle -N zsh-system-clipboard-vicmd-vi-put-after

function zsh-system-clipboard-vicmd-vi-put-before() {
    zsh-system-clipboard-vicmd-vi-put before
}
zle -N zsh-system-clipboard-vicmd-vi-put-before

function zsh-system-clipboard-vicmd-vi-delete() {
    local region_was_active=${REGION_ACTIVE}
    zle vi-delete
    if [[ "${KEYS}" == "d" && "${region_was_active}" == 0 ]]; then # A new line should be added to the end
        printf '%s\n' "$CUTBUFFER" | cbcopy
    else
        printf '%s' "$CUTBUFFER" | cbcopy
    fi
}
zle -N zsh-system-clipboard-vicmd-vi-delete

function zsh-system-clipboard-vicmd-vi-delete-char() {
    zle vi-delete-char
    printf '%s' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-delete-char

function zsh-system-clipboard-vicmd-vi-change-eol() {
    zle vi-change-eol
    printf '%s' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-change-eol

function zsh-system-clipboard-vicmd-vi-kill-eol() {
    zle vi-kill-eol
    printf '%s' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-kill-eol

function zsh-system-clipboard-vicmd-vi-change-whole-line() {
    zle vi-change-whole-line
    printf '%s\n' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-change-whole-line

function zsh-system-clipboard-vicmd-vi-change() {
    zle vi-change
    printf '%s' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-change

function zsh-system-clipboard-vicmd-vi-substitue() {
    zle vi-substitue
    printf '%s' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-substitue

function zsh-system-clipboard-vicmd-vi-delete-char() {
    zle vi-delete-char
    printf '%s' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-delete-char

function zsh-system-clipboard-vicmd-vi-backward-delete-char() {
    zle vi-backward-delete-char
    printf '%s' "$CUTBUFFER" | cbcopy
}
zle -N zsh-system-clipboard-vicmd-vi-backward-delete-char

# Bind keys to widgets.
function () {
    if [[ -n "$ZSH_SYSTEM_CLIPBOARD_DISABLE_DEFAULT_MAPS" ]]; then
        return
    fi
    local binded_keys i parts key cmd keymap
    for keymap in vicmd visual emacs; do
        binded_keys=(${(f)"$(bindkey -M $keymap)"})
        for (( i = 1; i < ${#binded_keys[@]}; ++i )); do
            parts=("${(z)binded_keys[$i]}")
            key="${parts[1]}"
            cmd="${parts[2]}"
            if (( $+functions[zsh-system-clipboard-$keymap-$cmd] )); then
                eval bindkey -M $keymap $key zsh-system-clipboard-$keymap-$cmd
            fi
        done
    done
}
