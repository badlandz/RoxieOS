#!/bin/bash
# BAUX Backup Terminal Launcher
# Reliable terminal with large fonts as fallback

# Set large fonts for accessibility
export XTERM_FONT="-*-fixed-medium-r-normal--20-*-*-*-*-*-*-*"
export XTERM_BOLD_FONT="-*-fixed-bold-r-normal--20-*-*-*-*-*-*-*"

# Launch xterm with accessibility settings
xterm \
    -fn "$XTERM_FONT" \
    -fb "$XTERM_BOLD_FONT" \
    -bg "#000000" \
    -fg "#ffffff" \
    -cr "#00ff00" \
    -geometry 120x40 \
    -title "BAUX Backup Terminal" \
    -e bash --login &

echo "BAUX Backup Terminal launched with large fonts"
echo "Use this if main terminal has font issues"