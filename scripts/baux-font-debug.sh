#!/usr/local/bin/bash
# BAUX Font Debug Script - Comprehensive Logging
# Run this on 192.168.33.101 to debug font issues
# Output saved to ~/baux-font-debug.log

set -euo pipefail

LOG_FILE="$HOME/baux-font-debug.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "========================================"
echo "BAUXBSD FONT DEBUG LOG"
echo "Generated: $(date)"
echo "System: $(uname -a)"
echo "User: $(whoami)"
echo "========================================"

echo ""
echo "=== SYSTEM INFORMATION ==="
echo "Hostname: $(hostname)"
echo "FreeBSD Version: $(freebsd-version)"
echo "Uptime: $(uptime)"
echo "Memory: $(sysctl -n hw.physmem) bytes"

echo ""
echo "=== DISPLAY ENVIRONMENT ==="
echo "DISPLAY: ${DISPLAY:-'Not set (console mode)'}"
echo "TERM: ${TERM:-'Not set'}"
echo "LANG: ${LANG:-'Not set'}"

echo ""
echo "=== CONSOLE FONT CHECK ==="
if command -v vidcontrol >/dev/null 2>&1; then
    echo "vidcontrol available: YES"
    echo "Current console font:"
    doas vidcontrol -i active 2>/dev/null || echo "ERROR: Failed to get console font"
    echo ""

    echo "Available console fonts:"
    ls -la /usr/share/syscons/fonts/ 2>/dev/null || echo "ERROR: Font directory not found"
    echo ""

    echo "Testing font changes:"
    echo "Setting to 8x16..."
    doas vidcontrol -f 8x16 2>&1 || echo "ERROR: Failed to set 8x16"
    doas vidcontrol -i active 2>&1 || echo "ERROR: Failed to read after 8x16"

    echo "Setting to iso-8x16..."
    doas vidcontrol -f iso-8x16 2>&1 || echo "ERROR: Failed to set iso-8x16"
    doas vidcontrol -i active 2>&1 || echo "ERROR: Failed to read after iso-8x16"

    echo "Note: 12x24 and 16x32 fonts not available on FreeBSD console"
    echo "For accessibility, use X11 with Xft.dpi: 192"
else
    echo "vidcontrol available: NO"
    echo "ERROR: vidcontrol not found - not FreeBSD console?"
fi

echo ""
echo "=== X11 CHECK ==="
if [ -n "${DISPLAY:-}" ]; then
    echo "X11 detected: YES ($DISPLAY)"

    if command -v xrdb >/dev/null 2>&1; then
        echo "xrdb available: YES"
        echo "X resources:"
        xrdb -query 2>&1 || echo "ERROR: Failed to query X resources"
        echo ""

        echo "Xft.dpi setting:"
        xrdb -query | grep -i dpi 2>&1 || echo "No DPI setting found"
    else
        echo "xrdb available: NO"
    fi

    if command -v xdpyinfo >/dev/null 2>&1; then
        echo "xdpyinfo available: YES"
        echo "Display info:"
        xdpyinfo | grep -E "(dimensions|resolution)" 2>&1 || echo "ERROR: Failed to get display info"
    else
        echo "xdpyinfo available: NO"
    fi

    if command -v xrandr >/dev/null 2>&1; then
        echo "xrandr available: YES"
        echo "Monitor info:"
        xrandr --current 2>&1 || echo "ERROR: Failed to get xrandr info"
    else
        echo "xrandr available: NO"
    fi
else
    echo "X11 detected: NO (console mode)"
fi

echo ""
echo "=== FONT CONFIGURATION FILES ==="
echo "Xresources file:"
if [ -f "$HOME/.Xresources" ]; then
    echo "Found: $HOME/.Xresources"
    cat "$HOME/.Xresources" 2>&1 || echo "ERROR: Failed to read Xresources"
else
    echo "Not found: $HOME/.Xresources"
fi

echo ""
echo "Xdefaults file:"
if [ -f "$HOME/.Xdefaults" ]; then
    echo "Found: $HOME/.Xdefaults"
    cat "$HOME/.Xdefaults" 2>&1 || echo "ERROR: Failed to read Xdefaults"
else
    echo "Not found: $HOME/.Xdefaults"
fi

echo ""
echo "System font config:"
if [ -f "/etc/rc.conf" ]; then
    echo "rc.conf font settings:"
    grep -i font /etc/rc.conf 2>&1 || echo "No font settings in rc.conf"
else
    echo "rc.conf not found"
fi

if [ -f "/boot/loader.conf" ]; then
    echo "loader.conf font settings:"
    grep -i font /boot/loader.conf 2>&1 || echo "No font settings in loader.conf"
else
    echo "loader.conf not found"
fi

echo ""
echo "=== BAUX VERIFICATION SCRIPT ==="
if [ -d "$HOME/src/RoxieOS" ]; then
    echo "RoxieOS repo found: $HOME/src/RoxieOS"
    cd "$HOME/src/RoxieOS"

    if [ -x "./scripts/verify-display.sh" ]; then
        echo "Running verify-display.sh:"
        ./scripts/verify-display.sh 2>&1 || echo "ERROR: verify-display.sh failed"
    else
        echo "verify-display.sh not found or not executable"
        ls -la scripts/verify-display.sh 2>&1 || echo "Script not found"
    fi
else
    echo "RoxieOS repo not found at $HOME/src/RoxieOS"
    echo "Checking alternative locations:"
    for loc in "/src/roxieos" "$HOME/RoxieOS"; do
        if [ -d "$loc" ]; then
            echo "Found at: $loc"
        fi
    done
fi

echo ""
echo "=== INSTALLED PACKAGES CHECK ==="
if command -v pkg >/dev/null 2>&1; then
    echo "Checking BAUX packages:"
    for pkg in bbase baux bwm bterm bvi; do
        if pkg info $pkg >/dev/null 2>&1; then
            echo "✓ $pkg installed"
        else
            echo "✗ $pkg not installed"
        fi
    done
else
    echo "pkg command not available"
fi

echo ""
echo "=== KERNEL MESSAGES ==="
echo "Font-related dmesg:"
dmesg | grep -i font 2>&1 || echo "No font messages in dmesg"

echo ""
echo "Video-related dmesg:"
dmesg | grep -i video 2>&1 || echo "No video messages in dmesg"

echo ""
echo "=== FINAL STATUS ==="
echo "Log saved to: $LOG_FILE"
echo "Please share this log file for analysis"
echo "========================================"