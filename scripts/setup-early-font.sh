#!/usr/local/bin/bash
# BAUX Early Boot Font Setup
# Sets console fonts before video driver loads
# Run this from /etc/rc.local or early in boot process

echo "BAUX: Setting early boot console font for accessibility..."

# Check what fonts are actually available
echo "BAUX: Checking available console fonts..."
AVAILABLE_FONTS=$(ls -1 /usr/share/syscons/fonts/ 2>/dev/null | grep '\.fnt$' | sort)
echo "BAUX: Available fonts: $AVAILABLE_FONTS"

# This script should be run very early in the boot process
# before the video driver kernel module loads

# Try to set the largest available font (in order of preference)
FONT_SET=false
if echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_16x32.fnt" && \
   /usr/local/bin/vidcontrol -f 16x32 /usr/share/syscons/fonts/TERMINAL_16x32.fnt 2>/dev/null; then
    echo "BAUX: Console font set to 16x32 (maximum readability)"
    FONT_SET=true
elif echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_12x24.fnt" && \
     /usr/local/bin/vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt 2>/dev/null; then
    echo "BAUX: Console font set to 12x24 (very readable)"
    FONT_SET=true
elif echo "$AVAILABLE_FONTS" | grep -q "TERMINAL_8x16.fnt" && \
     /usr/local/bin/vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt 2>/dev/null; then
    echo "BAUX: Console font set to 8x16 (minimum acceptable)"
    FONT_SET=true
fi

if [ "$FONT_SET" = false ]; then
    echo "BAUX: Could not set large console font"
    if [ -z "$AVAILABLE_FONTS" ]; then
        echo "BAUX: No .fnt files found - console fonts may be in base system"
        echo "BAUX: Or install additional fonts: pkg install x11-fonts"
    else
        echo "BAUX: Available fonts: $AVAILABLE_FONTS"
    fi
    echo "BAUX: This may be normal if video driver hasn't loaded yet"
fi