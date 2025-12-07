#!/bin/bash
# BAUX Accessibility Quick Fix
# Fast font and display setup for immediate readability

set -euo pipefail

echo "=== BAUX ACCESSIBILITY QUICK FIX ==="
echo "Setting up readable fonts and display for impaired vision"
echo ""

# Quick console font fix
echo "Setting console font..."
if command -v vidcontrol >/dev/null 2>&1; then
    # Try largest fonts first
    doas vidcontrol -f 16x32 /usr/share/syscons/fonts/TERMINAL_16x32.fnt 2>/dev/null || \
    doas vidcontrol -f 12x24 /usr/share/syscons/fonts/TERMINAL_12x24.fnt 2>/dev/null || \
    doas vidcontrol -f 8x16 /usr/share/syscons/fonts/TERMINAL_8x16.fnt 2>/dev/null || \
    echo "Console font setting failed"
    echo "✓ Console font updated"
else
    echo "vidcontrol not available"
fi

# Quick X11 font fix
if [ -n "${DISPLAY:-}" ]; then
    echo ""
    echo "Setting X11 fonts..."
    cat >> ~/.Xresources << 'EOF'
! BAUX Quick Accessibility Fix
Xft.dpi: 192
Xft.antialias: true
Xft.hinting: true
Xft.hintstyle: hintfull
Xft.rgba: rgb
Xft.lcdfilter: lcddefault
*.font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*
URxvt.font: xft:Monospace:size=20
xterm*font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*
EOF

    xrdb -merge ~/.Xresources 2>/dev/null || echo "X11 config failed"
    echo "✓ X11 fonts updated (restart X11 to apply)"
fi

# Launch backup terminal as immediate fallback
echo ""
echo "Launching backup terminal with guaranteed large fonts..."
./scripts/launch-backup-terminal.sh 2>/dev/null || echo "Backup terminal failed to launch"

echo ""
echo "=== QUICK FIX COMPLETE ==="
echo "If fonts are still unreadable:"
echo "1. Use the backup terminal that just opened"
echo "2. Run: ./scripts/emergency-font-fix.sh"
echo "3. Restart X11 for full font changes"