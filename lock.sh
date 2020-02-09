#!/bin/sh

# Background (--color=rrggbb or --image=path)
BACKGROUND="--color=000000"

# Foreground color (rrggbbaa)
COLOR_FG="ffffffff"
# Default ring color (rrggbbaa)
COLOR_RING="4a4a4aff"
# Ring color during password verification (rrggbbaa)
COLOR_VERIF="bcecffff"
# Ring color during incorrect password flash (rrggbbaa)
COLOR_WRONG="ff8787ff"

# Time string format (see `man strftime.3`)
FORMAT_TIME="%H:%M"
# Date string format (see `man strftime.3`)
FORMAT_DATE="%A, %B %e"

# Time font size
SIZE_TIME=144
# Date font size
SIZE_DATE=48

i3lock \
    "$BACKGROUND" \
    --force-clock \
    --insidevercolor=00000000 \
    --insidewrongcolor=00000000 \
    --insidecolor=00000000 \
    --ringvercolor="$COLOR_VERIF" \
    --ringwrongcolor="$COLOR_WRONG" \
    --ringcolor="$COLOR_RING" \
    --linecolor=00000000 \
    --keyhlcolor="$COLOR_FG" \
    --bshlcolor="$COLOR_WRONG" \
    --separatorcolor=00000000 \
    --verifcolor="$COLOR_VERIF" \
    --wrongcolor="$COLOR_WRONG" \
    --indpos="w/2:h/2+r*2.5" \
    --timecolor="$COLOR_FG" \
    --timestr="$FORMAT_TIME" \
    --timepos="ix:iy-r*3.5" \
    --timesize="$SIZE_TIME" \
    --datecolor="$COLOR_FG" \
    --datestr="$FORMAT_DATE" \
    --datepos="tx:ty+96" \
    --datesize="$SIZE_DATE" \
    --veriftext="" \
    --wrongtext="" \
    --noinputtext="" \
    --radius=60 \
    --ring-width=10
