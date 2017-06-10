#!/bin/zsh

dpi=$1
if [[ $dpi == '96' ]]; then
    xrandr --dpi 96
    xrdb ~/Code/GitHub/nvllsvm/dotfiles/xresources/general
    xrdb -merge ~/Code/GitHub/nvllsvm/dotfiles/xresources/mars
else
    xrandr --dpi 192
    xrdb ~/Code/GitHub/nvllsvm/dotfiles/xresources/general
    xrdb -merge ~/Code/GitHub/nvllsvm/dotfiles/xresources/phobos
fi

urxvt --perl-lib /usr/lib/urxvt/perl -pe config-print 2>&1 | grep font > /tmp/urxvt-font
echo "*$(cat /tmp/urxvt-font):dpi=$dpi" > /tmp/urxvt-font
xrdb -merge /tmp/urxvt-font

urxvt-config-reload
i3 restart
