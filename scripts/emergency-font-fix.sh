#!/usr/local/bin/bash
# BAUX Emergency Font Fix
# Last resort font setting for when everything else fails

set -euo pipefail

echo "=== BAUX EMERGENCY FONT FIX ==="
echo "This script tries every possible way to set large fonts"
echo ""

# Method 1: Direct vidcontrol with available fonts
echo "Method 1: Checking available console fonts..."
AVAILABLE=$(ls -1 /usr/share/syscons/fonts/ 2>/dev/null | grep '\.fnt$' | sort -V)

if [ -n "$AVAILABLE" ]; then
    echo "Available fonts:"
    echo "$AVAILABLE" | tail -5  # Show largest available

    # Try the largest available font
    LARGEST=$(echo "$AVAILABLE" | grep -E "(16x32|12x24|8x16)" | tail -1)
    if [ -n "$LARGEST" ]; then
        echo "Trying largest font: $LARGEST"
        if doas vidcontrol -f "${LARGEST%.fnt}" "/usr/share/syscons/fonts/$LARGEST" 2>/dev/null; then
            echo "✓ Set console font to $LARGEST"
        else
            echo "✗ Failed to set $LARGEST"
            echo "This may be normal if video driver not loaded"
        fi
    else
        echo "No suitable large fonts found in available fonts"
    fi
else
    echo "No console fonts found in /usr/share/syscons/fonts/"
    echo "Console fonts may be provided by base FreeBSD system"
    echo "BAUX will continue with available system fonts"
fi

# Method 2: Install fonts if missing
echo ""
echo "Method 2: Ensuring fonts are available..."
if ! ls /usr/share/syscons/fonts/*.fnt >/dev/null 2>&1; then
    echo "No console fonts found, attempting to install x11-fonts..."
    if pkg install -y x11-fonts 2>/dev/null; then
        echo "✓ x11-fonts installed"
        # Check again after installation
        if ls /usr/share/syscons/fonts/*.fnt >/dev/null 2>&1; then
            echo "✓ Console fonts now available"
        else
            echo "⚠ x11-fonts installed but no console fonts found"
            echo "Console fonts may be in base FreeBSD system"
        fi
    else
        echo "Failed to install x11-fonts package"
        echo "Console fonts may be provided by base FreeBSD system"
    fi
else
    FONT_COUNT=$(ls /usr/share/syscons/fonts/*.fnt | wc -l)
    echo "✓ $FONT_COUNT console fonts already available"
fi

# Method 3: X11 font emergency
if [ -n "${DISPLAY:-}" ]; then
    echo ""
    echo "Method 3: Setting X11 emergency fonts..."
    cat > ~/.Xresources.emergency << 'EOF'
! BAUX Emergency Font Settings
Xft.dpi: 192
Xft.antialias: true
Xft.hinting: true
Xft.hintstyle: hintfull
*.font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*
xterm*font: -*-fixed-medium-r-normal--20-*-*-*-*-*-*-*
URxvt.font: xft:monospace:size=20
EOF

    if xrdb -merge ~/.Xresources.emergency 2>/dev/null; then
        echo "✓ Applied emergency X11 fonts"
    else
        echo "✗ Failed to apply X11 fonts"
    fi
fi

# Method 4: Launch backup terminal
echo ""
echo "Method 4: Launching backup terminal..."
if command -v xterm >/dev/null 2>&1; then
    echo "Launching xterm with large fonts..."
    nohup xterm \
        -fn -*-fixed-medium-r-normal--20-*-*-*-*-*-*-* \
        -fb -*-fixed-bold-r-normal--20-*-*-*-*-*-*-* \
        -bg black -fg white \
        -geometry 100x30 \
        -title "BAUX Emergency Terminal" \
        -e "echo 'BAUX Emergency Terminal'; echo 'Large fonts active'; bash" >/dev/null 2>&1 &
    echo "✓ Backup terminal launched"
else
    echo "✗ xterm not available"
fi

echo ""
echo "=== EMERGENCY FONT FIX COMPLETE ==="
echo "Check if fonts are now readable"
echo "If not, the backup terminal should have opened with large fonts"
echo ""
echo "For persistent fix, run after reboot:"
echo "  ./scripts/setup-early-font.sh"
echo "  ./scripts/setup-display.sh"