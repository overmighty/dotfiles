#!/bin/sh

# Background (--color=rrggbb or --image=path)
BACKGROUND="--image=${HOME}/wallpaper-lock.jpg"

# Foreground color (rrggbbaa)
COLOR_FG="ffffffff"
# Default ring color (rrggbbaa)
COLOR_RING="4a4a4a80"
# Ring color during password verification (rrggbbaa)
COLOR_VERIF="bcecffff"
# Ring color during incorrect password flash (rrggbbaa)
COLOR_WRONG="ff5370ff"

# Time string format (see `man strftime.3`)
FORMAT_TIME="%H:%M"
# Date string format (see `man strftime.3`)
FORMAT_DATE="%A, %B %-e"

# Main font (for time and greeter)
FONT="sans-serif:light"
# Alternative font (for date)
FONT_ALT="sans-serif:thin"

# Time font size
SIZE_TIME=144
# Date font size
SIZE_DATE=48

i3lock \
    "${BACKGROUND}" \
    --force-clock \
    --insidevercolor=00000000 \
    --insidewrongcolor=00000000 \
    --insidecolor=00000000 \
    --ringvercolor="${COLOR_VERIF}" \
    --ringwrongcolor="${COLOR_WRONG}" \
    --ringcolor="${COLOR_RING}" \
    --linecolor=00000000 \
    --keyhlcolor="${COLOR_FG}" \
    --bshlcolor="${COLOR_WRONG}" \
    --separatorcolor=00000000 \
    --verifcolor="${COLOR_VERIF}" \
    --wrongcolor="${COLOR_WRONG}" \
    --indpos="w/2:h/2+r*2.5" \
    --timecolor="${COLOR_FG}" \
    --timestr="${FORMAT_TIME}" \
    --timepos="ix:iy-r*4" \
    --time-font="${FONT}" \
    --timesize="${SIZE_TIME}" \
    --datecolor="${COLOR_FG}" \
    --datestr="${FORMAT_DATE}" \
    --date-font="${FONT_ALT}" \
    --datepos="tx:ty+96" \
    --datesize="${SIZE_DATE}" \
    --greetertext="Type password of $(whoami) to unlock" \
    --greeter-font="${FONT}" \
    --greetercolor="${COLOR_FG}" \
    --veriftext="" \
    --wrongtext="" \
    --noinputtext="" \
    --radius=60 \
    --ring-width=6
