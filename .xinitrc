#!/bin/sh

# From the default xinitrc file located in /etc/X11/xinit
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done

    unset f
fi

# Start i3-gaps
exec i3
