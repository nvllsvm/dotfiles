if command -v termux-info > /dev/null; then
    full-update add 'yes | pkg upgrade && rm -f ~/../usr/etc/motd'
fi
