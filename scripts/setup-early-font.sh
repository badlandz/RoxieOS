#!/bin/bash
# BAUX Early Boot Font Setup
# Sets console fonts before video driver loads
# Run this from /etc/rc.local or early in boot process

echo "BAUX: Setting early boot console font for accessibility..."

# This script should be run very early in the boot process
# before the video driver kernel module loads

# Try to set the largest available font
if /usr/local/bin/vidcontrol -f 16x32 /usr/share/syscons/fonts/TERMINAL_16x32.fnt 2>/dev/null; then
    echo "BAUX: Console font set to 16x32 (maximum readability)"
elif /usr/local/bin/vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt 2>/dev/null; then
    echo "BAUX: Console font set to 12x24 (very readable)"
else
    echo "BAUX: Could not set large console font (video driver not loaded yet?)"
fi