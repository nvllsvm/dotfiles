if command -v pkg > /dev/null; then
    PROMPT='%F{$vi_mode_color}$%f '
    full-update add 'yes | pkg upgrade && rm -f ~/../usr/etc/motd'
fi
