#!/bin/sh
# load-keymaps - Manually load BAUX keymaps for immediate testing
# Run this after installation if keymaps aren't working

echo "Loading BAUX keymaps..."

# Load console keymap
if [ -f /usr/local/share/syscons/keymaps/baux.kbd ]; then
    echo "Loading BAUX console keymap..."
    kbdcontrol -l /usr/local/share/syscons/keymaps/baux.kbd
    echo "Console keymap loaded (Caps Lock → Escape)"
else
    echo "BAUX console keymap not found"
fi

# Load X11 keymap
if [ -f /usr/local/share/roxieos/xmodmap.rc ]; then
    echo "Loading X11 keymap..."
    xmodmap /usr/local/share/roxieos/xmodmap.rc 2>/dev/null && echo "X11 keymap loaded" || echo "X11 keymap load failed"
else
    echo "X11 keymap file not found"
fi

echo "Keymap loading complete"