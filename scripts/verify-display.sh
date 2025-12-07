#!/usr/local/bin/bash
# BAUX Display Verification Script
# Verifies display and font configuration

set -euo pipefail

echo "=== BAUX Display Verification ==="

# Check console font
if command -v vidcontrol >/dev/null 2>&1; then
    CONSOLE_FONT=$(doas vidcontrol -i active 2>/dev/null | head -1 || echo "unknown")
    echo "Console font: $CONSOLE_FONT"

    if [[ "$CONSOLE_FONT" == *"16x32"* ]]; then
        echo "✓ Console font is excellent for accessibility (16x32)"
    elif [[ "$CONSOLE_FONT" == *"12x24"* ]]; then
        echo "✓ Console font is very good for accessibility (12x24)"
    elif [[ "$CONSOLE_FONT" == *"8x16"* ]]; then
        echo "⚠ Console font acceptable but could be larger (8x16)"
    else
        echo "✗ Console font may be too small for impaired vision"
    fi
else
    echo "vidcontrol not available (not FreeBSD console?)"
fi

# Check X11 configuration
if [ -n "${DISPLAY:-}" ]; then
    echo "X11 display: $DISPLAY"

    # Check X11 font settings
    if command -v xrdb >/dev/null 2>&1; then
        XFT_DPI=$(xrdb -query | grep "Xft.dpi" | awk '{print $2}' || echo "not set")
        echo "X11 DPI: $XFT_DPI"

        if [ "$XFT_DPI" -ge 192 ]; then
            echo "✓ X11 DPI is excellent for accessibility ($XFT_DPI)"
        elif [ "$XFT_DPI" -ge 120 ]; then
            echo "⚠ X11 DPI is acceptable but could be higher ($XFT_DPI)"
        else
            echo "✗ X11 DPI is too low for impaired vision ($XFT_DPI)"
        fi
    fi

    # Check resolution
    if command -v xdpyinfo >/dev/null 2>&1; then
        RESOLUTION=$(xdpyinfo | grep "dimensions:" | awk '{print $2}' || echo "unknown")
        echo "Display resolution: $RESOLUTION"

        if [[ "$RESOLUTION" =~ ([0-9]+)x([0-9]+) ]]; then
            WIDTH="${BASH_REMATCH[1]}"
            HEIGHT="${BASH_REMATCH[2]}"

            if [ "$WIDTH" -le 1920 ] && [ "$HEIGHT" -le 1280 ]; then
                echo "✓ Resolution is within accessibility limits (1920x1280 max)"
            elif [ "$WIDTH" -le 1920 ] && [ "$HEIGHT" -le 1080 ]; then
                echo "⚠ Resolution acceptable but height could be increased to 1280"
            else
                echo "✗ Resolution too high - fonts will be too small"
                echo "  Recommended: Reduce to 1920x1280 or lower"
            fi
        fi
    fi
else
    echo "Console environment (no X11 display)"
fi

# Check keymap
if command -v kbdcontrol >/dev/null 2>&1; then
    KEYMAP_INFO=$(doas kbdcontrol -d 2>/dev/null | head -1 || echo "unknown")
    echo "Current keymap: $KEYMAP_INFO"

    if [[ "$KEYMAP_INFO" == *"baux"* ]]; then
        echo "✓ BAUX keymap is active"
    else
        echo "⚠ BAUX keymap not active"
    fi
fi

echo ""
echo "=== Verification Complete ==="
echo "If any checks show warnings, run:"
echo "  ./scripts/setup-display.sh"