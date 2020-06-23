#!/bin/sh

userresources="${HOME}/.Xresources"

if [ -f "${userresources}" ]; then
    xrdb -merge "${userresources}"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        if [ -x "${f}" ]; then
            . "${f}"
        fi
    done

    unset f
fi

exec bspwm
